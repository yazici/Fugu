
module(...,package.seeall)

local m = {}
function setup()
	bert = fg.turtle()

	bert:pushState()

    -- Create a cross section
--	bert:setStiffness(1.,1.)
	bert:pitch(-.5*math.pi)
	bert:yaw(.5)
	bert:beginCrossSection()
	bert:yaw(.5)
	bert:move(.5)
	bert:addPoint()
	bert:yaw(1)
	bert:move(.5)
	bert:addPoint()
	bert:yaw(1)
	bert:move(.5)
	bert:addPoint()
	bert:yaw(1)
	bert:move(.5)
	bert:yaw(.5)
	bert:endCrossSection()

	bert:popState()

    -- Create the cylinder
	bert:setCrossSection(0)
	bert:beginCylinder()
	bert:move(10.)
	bert:addPoint()
	bert:pitch(0.3)
	bert:move(10.)
	bert:setCrossSection(1)
    bert:endCylinder()

	m = bert:getMesh()
	fgu:addMesh(m)
end

local t = 0
function update(dt)
	t = t + dt
end


