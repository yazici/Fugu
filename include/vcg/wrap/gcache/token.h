#ifndef GCACHE_TOKEN_H
#define GCACHE_TOKEN_H

#include <QAtomicInt>

/* QAtomic int count keep trak of token status:
   >0: locked (possibly multiple times)
   0: data ready in last cache
   -1: not in last cache
   -2: to removed from all caches
   -3: out of caches
   */

/** Holds the resources to be cached.
    The Priority template argument can simply be a floating point number
    or something more complex, (frame and error in pixel); the only
    requirement is the existence of a < comparison operator */

template <typename Priority>
class Token {
 public:
  ///Resource loading status
  /*** - LOCKED: resource in the higher cache and locked
       - READY: resource in the higher cache
       - CACHE: resource in some cache (not the highest)
       - REMOVE: resource in some cache and scheduled for removal
       - OUTSIDE: resource not in the cache system */
  enum Status { LOCKED = 1, READY = 0, CACHE = -1, REMOVE = -2, OUTSIDE = -3 };
  ///Do not access these members directly. Will be moved to private shortly.
  ///used by various cache threads to sort objects [do not use, should be private]
  Priority priority; 
  ///set in the main thread   [do not use, should be private]
  Priority new_priority;     
  ///swap space used in updatePriorities [do not use, should be private]
  Priority tmp_priority;     
  ///reference count of locked items [do not use, should be private]
  QAtomicInt count;          

 public:
  Token(): count(OUTSIDE) {}

  ///the new priority will be effective only after a call to Controller::updatePriorities()
  void setPriority(const Priority &p) {
    new_priority = p;
  }
  Priority getPriority() {
    return new_priority;
  }
  ///return false if resource not in highest query. remember to unlock when done
  bool lock() {
    if(count.fetchAndAddAcquire(1) >= 0) return true;
    count.deref();
    return false;
  }
  ///assumes it was locked first and 1 unlock for each lock.
  bool unlock() {  
    return count.deref();
  }

  ///can't be removed if locked and will return false
  bool remove() {
    count.testAndSetOrdered(READY, REMOVE);
    count.testAndSetOrdered(CACHE, REMOVE);
    return count <= REMOVE;                   //might have become OUSIDE in the meanwhile
  }

  bool isLocked() { return count > 0; }
  bool isInCache() { return count != OUTSIDE; }  //careful, can be used only when provider thread is locked.

  ///copy priority to swap space [do not use, should be private]
  void pushPriority() {
    tmp_priority = new_priority;
  }
  ///copy priority from swap space [do not use, should be private]
  void pullPriority() {
    priority = tmp_priority;
  }

  bool operator<(const Token &a) const {
    if(count == a.count)
      return priority < a.priority;
    return count < a.count;
  }
  bool operator>(const Token &a) const {
    if(count == a.count)
      return priority > a.priority;
    return count > a.count;
  }
};

#endif // GCACHE_H
