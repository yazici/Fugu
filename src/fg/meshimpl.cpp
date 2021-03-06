/**
 * \file
 * \author ben
 *
 * \cond showlicense
 * \verbatim
 * --------------------------------------------------------------
 *    ___     
 *   |  _|___ 
 *   |  _| . | fg: real-time procedural 
 *   |_| |_  | animation and generation 
 *       |___| of 3D forms
 *
 *   Copyright (c) 2011 Centre for Electronic Media Art (CEMA)
 *   Monash University, Australia. All rights reserved.
 *
 *   Use of this software is governed by the terms outlined in 
 *   the LICENSE file.
 * 
 * --------------------------------------------------------------
 * \endverbatim
 * \endcond
 */

#include "fg/meshimpl.h"

#include <vcg/complex/allocate.h>

#include <vcg/complex/algorithms/update/bounding.h>
#include <vcg/complex/algorithms/update/normal.h>
#include <vcg/complex/algorithms/update/topology.h>
#include <vcg/complex/algorithms/update/flag.h>

namespace fg {
	int VertexImpl::bindBone(BoneWeakRef b, double weight){
		if (mNumBones >= MAX_BONES_PER_VERTEX) throw("VertexImpl: Attempting to bind too many bones!");
		// else
		mBones[mNumBones] = b;
		mBoneWeights[mNumBones] = weight;
		mNumBones++;
		mOriginalPosition = Vec3(P());
		return mNumBones;
	}

	void _copyMeshIntoMesh(MeshImpl& fm, MeshImpl& m){
		vcg::tri::Allocator<MeshImpl>::AddVertices(m,fm.vert.size());
		std::map<VertexImpl*,int> ptrMap;
		for(int i=0;i<fm.vert.size();i++){
			ptrMap[&fm.vert[i]] = i;

			// m.vert[i] = fm.vert[i];

			m.vert[i].P() = fm.vert[i].P();
			m.vert[i].N() = fm.vert[i].N();
			m.vert[i].C() = fm.vert[i].C();

			// texcoords
			m.vert[i].T().U() = fm.vert[i].T().U();
			m.vert[i].T().V() = fm.vert[i].T().V();

			if (fm.vert[i].IsD()) m.vert[i].SetD();
		}

		vcg::tri::Allocator<MeshImpl>::AddFaces(m,fm.face.size());
		for(int i=0;i<fm.face.size();i++){
			FaceImpl* f = &m.face[i];
			//*f = fm.face[i]; // Copy all attribs

			// Then reassign verts
			f->V(0) = &m.vert[ptrMap[fm.face[i].V(0)]];
			f->V(1) = &m.vert[ptrMap[fm.face[i].V(1)]];
			f->V(2) = &m.vert[ptrMap[fm.face[i].V(2)]];

			if (fm.face[i].IsD()) f->SetD();
		}

		vcg::tri::UpdateTopology<MeshImpl>::VertexFace(m);
		vcg::tri::UpdateTopology<MeshImpl>::FaceFace(m);
	}

	void _copyFloatMeshIntoMesh(_FloatMeshImpl& fm, MeshImpl& m){
		vcg::tri::Allocator<MeshImpl>::AddVertices(m,fm.vert.size());
		std::map<_FloatVertexImpl*,int> ptrMap;
		for(int i=0;i<fm.vert.size();i++){
			ptrMap[&fm.vert[i]] = i;
			for(int c=0;c<3;c++){
				m.vert[i].P()[c] = fm.vert[i].P()[c];
				m.vert[i].N()[c] = fm.vert[i].N()[c];
				m.vert[i].C()[c] = fm.vert[i].C()[c];
			}
			// texcoords
			m.vert[i].T().U() = fm.vert[i].T().U();
			m.vert[i].T().V() = fm.vert[i].T().V();
		}

		vcg::tri::Allocator<MeshImpl>::AddFaces(m,fm.face.size());
		for(int i=0;i<fm.face.size();i++){
			FaceImpl* f = &m.face[i];
			f->V(0) = &m.vert[ptrMap[fm.face[i].V(0)]];
			f->V(1) = &m.vert[ptrMap[fm.face[i].V(1)]];
			f->V(2) = &m.vert[ptrMap[fm.face[i].V(2)]];
		}

		vcg::tri::UpdateTopology<MeshImpl>::VertexFace(m);
		vcg::tri::UpdateTopology<MeshImpl>::FaceFace(m);
	}
}
