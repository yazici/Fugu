
module(...,package.seeall)

m = {}
node = {}
function setup()
	bert = fg.turtle()

	m = bert:getMesh()
	node = fg.meshnode(m)
	fgu:add(node)


	m = bert:getMesh()
	fgu:addMesh(m)
end

local t = 0
function update(dt)
	t = t + dt

    local age = smoothstep(0,1,t)

    bert = fg.turtle()
    makePlant(age,bert)
	m = bert:getMesh()
	node:setMesh(m)
end

function makePlant(time,bert)
    local length = 200
    local width = 1
    local blades = 50 
    local age = math.min(time,1)

    bert:pitch(-math.pi*.5)

    local m = math.max(age*blades-1, 1)
    for i = 0, m, 1 do
        bert:pushState()
        local leafage = math.max(age-.01-i/blades,0.)
        --leafage = math.min(leafage*1.0,1)
        makeLeaf(.05,length,width,leafage,bert)
        bert:popState()
        local dist = lerp(0.,5.,min(1,2*leafage))--5.--smoothstep(0.,5.,age-i/blades)
        --print(dist)
        bert:move(dist)
        bert:roll(2.4)
        length = length - 2
    end
end

function makeLeaf(maxarch,maxlength,maxwidth,age,bert)
    local width = maxwidth * (0.1+smoothstep(.0,1.,age))--maxwidth * smoothstep(age,.0,1.)
    local length = maxlength * (smoothstep(.0,1.,age))--maxlength * smoothstep(age,.0,1.)
    local arch = maxarch * (smoothstep(.0,1.,age))--maxlength * smoothstep(age,.0,1.)
    local flat = smoothstep(0.,1.,age)
    local cs = {}
    local countdown = min(age*19,19)
    --print('\n')
    --print(age)
    --print(width)
    --print(length)
    bert:pushState()
    cs[1] = makeCrossSection(.3*width,0*flat,bert)
    bert:popState()
    bert:pushState()
    cs[2] = makeCrossSection(.6*width,0*flat,bert)
    bert:popState()
    bert:pushState()
    cs[3] = makeCrossSection(.8*width,0.2*flat,bert)
    bert:popState()
    bert:pushState()
    cs[4] = makeCrossSection(1*width,.5*flat,bert)
    bert:popState()
    bert:pushState()
    cs[5] = makeCrossSection(2.4*width,.7*flat,bert)
    bert:popState()
    bert:pushState()
    cs[6] = makeCrossSection(1.*width,.9*flat,bert)
    bert:popState()
    bert:pushState()
    cs[7] = makeCrossSection(.5*width,.9*flat,bert)
    bert:popState()
    bert:pushState()
    cs[8] = makeCrossSection(.2*width,.9*flat,bert)
    bert:popState()

    --bert:setCrossSection(1)
    --bert:beginCylinder()
    --bert:move(10)
    bert:setCrossSection(cs[1])
    bert:setCarrierMode(0)
	bert:beginCylinder()
	bert:move(8.)
    bert:addPoint(1)
	bert:move(2.)
    bert:setCrossSection(cs[2])
    bert:addPoint(1)
	bert:move(4.)
    bert:setCrossSection(cs[3])
    bert:addPoint(1)

    for i = 1, 5, 1 do
        bert:pitch(arch)
    	bert:move(length/50)
        bert:pitch(arch)
--        if countdown < 0 then
--            bert:endCylinder(1)
--            return
--        end
        bert:addPoint(1)
        countdown = countdown - 1
    end

    bert:pitch(arch)
	bert:move(length/50)
    bert:pitch(arch)
    bert:setCrossSection(cs[4])
    bert:addPoint(1)

    for i = 1, 5, 1 do
        bert:pitch(arch)
    	bert:move(length/50)
        bert:pitch(arch)
--        if countdown < 0 then
--            bert:endCylinder(1)
--            return
--        end
        bert:addPoint(1)
        countdown = countdown - 1
    end

    bert:pitch(arch)
	bert:move(length/50)
    bert:pitch(arch)
    bert:setCrossSection(cs[5])
    bert:addPoint(1)

    for i = 1, 9, 1 do
        bert:pitch(arch)
    	bert:move(length/30)
        bert:pitch(arch)
--        if countdown < 0 then
--            bert:endCylinder(1)
--            return
--        end
        bert:addPoint(1)
        countdown = countdown - 1
    end
    bert:pitch(arch)
    bert:move(length/30)
    bert:pitch(arch)
    bert:setCrossSection(cs[6])
    bert:addPoint(1)

    bert:pitch(arch)
	bert:move(length/60)
    bert:pitch(arch)
    bert:setCrossSection(cs[6])
    bert:addPoint(1)

    bert:pitch(arch)
	bert:move(length/60)
    bert:pitch(arch)
    bert:setCrossSection(cs[7])
    bert:addPoint(1)

    bert:pitch(arch)
	bert:move(length/100)
    bert:pitch(arch)
    bert:setCrossSection(cs[8])
    bert:endCylinder(1)
end

function makeCrossSection2(don)
    local point
    local heading
    local up = vec3(0., 0., 1.)
    local theta
    local width = 1.0
    local flat = 0.

    point = vec3(-width*math.pi*11/12,-1.,0)*width
    heading = vec3(0,-1,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.1,.1)
	don:beginCrossSection()

    point = vec3(-width*math.pi*.5,-1.1,0)*width
    heading = vec3(1,0,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:addPoint()

    point = vec3(0,-1.1,0)*width
    heading = vec3(1,0,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:addPoint()

    point = vec3(width*math.pi*.5,-1.1,0)*width
    heading = vec3(1,0,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:addPoint()

    point = vec3(width*math.pi*11/12,-1.,0)*width
    heading = vec3(0,1,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.1,.1)
	don:addPoint()

    point = vec3(width*math.pi*.5,-.9,0)*width
    heading = vec3(-1,0,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:addPoint()

    point = vec3(0,-.9,0)*width
    heading = vec3(-1,0,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:addPoint()

    point = vec3(-width*math.pi*.5,-.9,0)*width
    heading = vec3(-1,0,0) 
    heading:normalise()

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:addPoint()

    return don:endCrossSection()
end

function makeCrossSection(width,t,don)
    local point1,point2,point
    local heading1,heading2,heading
    local up = vec3(0., 0., 1.)
    local theta

    theta = math.pi*7./12.
    point1 = vec3(math.cos(theta),math.sin(theta),0)*width
    point2 = vec3((-3/2*math.pi+theta)*width,-1,0)
    point = lerp(point1,point2,t)

    heading1 = vec3(math.cos(theta),math.sin(theta),0)*width 
    heading1:normalise()
    heading2 = vec3(0,-1,0)
    heading = lerp(heading1,heading2,t)
    --print('\nPos')
    --print(point)
    --print('Heading')
    --print(heading)

	don:setFrame(point,heading,up)
	don:setStiffness(.4,.4)
	don:beginCrossSection()

    addPoint(math.pi,width,1,.4,1,don,t)
    addPoint(math.pi*3/2.,width,1,.4,1,don,t)
    addPoint(math.pi*2.,width,1,.6,1,don,t)

    addPoint2(math.pi*29/12,width,.4,1,don,t)

    addPoint(math.pi*2.,width,.8,.4,-1,don,t)
    addPoint(math.pi*3/2,width,.8,.4,-1,don,t)

    theta = math.pi
    point1 = vec3(math.cos(theta),math.sin(theta),0)*width*.8
    point2 = vec3((-3/2*math.pi+theta)*width,-.9,0)
    point = lerp(point1,point2,t)

    heading1 = vec3(-math.sin(theta),math.cos(theta),0)*-1
    heading2 = vec3(-1,0,0)
    heading = lerp(heading1,heading2,t)
    --print('\nPos')
    --print(point)
    --print('Heading')
    --print(heading)

    up = vec3(0,0,1)

	don:setStiffness(.4,.4)
	don:setFrame(point,heading,up)
    return don:endCrossSection()
end

function addPoint(theta,width,scale,s,dir,don,t)
    local point1 = vec3(math.cos(theta),math.sin(theta),0)*width
    local tmp = vec3(math.cos(theta),math.sin(theta),0)*width
    tmp:normalise()
    point1 = point1 - tmp*(1-scale)

    local point2 = vec3(width*(-3/2*math.pi+theta),-1-dir*.1,0)
    local point = lerp(point1,point2,t)

    local heading1 = vec3(-math.sin(theta),math.cos(theta),0)*dir
    local heading2 = vec3(dir,0,0)
    local heading = lerp(heading1,heading2,t)
    --print('\nPos')
    --print(point)
    --print('Heading')
    --print(heading)

    local up = vec3(0,0,1)

	don:setStiffness(s,s)
	don:setFrame(point,heading,up)
    don:addPoint()
end

function addPoint2(theta,width,s,dir,don,t)
    local point1 = vec3(math.cos(theta),math.sin(theta),0)*width
    local point2 = vec3(width*(11/12*math.pi),-1,0)
    local point = lerp(point1,point2,t)

    local heading1 = vec3(math.cos(theta),math.sin(theta),0)*width 
    heading1:normalise()
    heading1 = -heading1
    local heading2 = vec3(0,dir,0)
    local heading = lerp(heading1,heading2,t)
    --print('\nPos')
    --print(point)
    --print('Heading')
    --print(heading)

    local up = vec3(0,0,1)

	don:setStiffness(s,s)
	don:setFrame(point,heading,up)
    don:addPoint()
end
