--!strict

const optionsModule = require("./options")
const render = require("./render")
const shapes = require("./shapes")
const typees = require("./types")

const MARKER_HEIGHT_RATIO = 3

--[=[
    Draws the marker at a hit, a cast that starts in contact reports distance 0 and a zero
    normal, so a zero direction into CFrame.lookAt gives a NaN look Vect without raising,
    so the orientation is only applied when the normal actually has length
]=]
const function marker(position: Vector3, normal: Vector3, options: typees.ResolvedOptions): HandleAdornment
	const size = options.radius
	const height = size * MARKER_HEIGHT_RATIO

	if normal.Magnitude > 0 then
		return shapes.pyramid(CFrame.lookAt(position, position + normal), size, height, options)
	end

	return shapes.pyramid(CFrame.new(position), size, height, options)
end

--[=[
    Draws a cast, a NIL result is a miss, drawn at full length with no marker, so the absent
    marker is what tells you the ray missed, anything present is drawn to its hit point with
    a marker on the surface normal
]=]
const function draw(origin: Vector3, direction: Vector3, result: RaycastResult?, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	if result == nil then
		render.add(shapes.line(origin, origin + direction, resolved), resolved.lifetime)
		return
	end

	render.add(shapes.line(origin, result.Position, resolved), resolved.lifetime)
	render.add(marker(result.Position, result.Normal, resolved), resolved.lifetime)
end

--[=[
    Draws a ray before or without casting it, `direction` carries its own length, matching
    worldRoot:raycast(origin, direction), so the same vector can be passed through both
]=]
const function ray(origin: Vector3, direction: Vector3, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.line(origin, origin + direction, resolved), resolved.lifetime)
end

--[=[
    Draws a line between two points
]=]
const function line(from: Vector3, to: Vector3, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.line(from, to, resolved), resolved.lifetime)
end

--[=[
    Draws a box, for visualising a blockcast, make sure to pass the cf and size you gave the cast
]=]
const function box(cframe: CFrame, size: Vector3, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.box(cframe, size, resolved), resolved.lifetime)
end

--[=[
    Draws a sphere, for visualising a spherecast
]=]
const function sphere(center: Vector3, radius: number, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.sphere(center, radius, resolved), resolved.lifetime)
end

--[=[
    Draws a cone
]=]
const function cone(cframe: CFrame, radius: number, height: number, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.cone(cframe, radius, height, resolved), resolved.lifetime)
end

--[=[
    Draws a cylinder
]=]
const function cylinder(cframe: CFrame, radius: number, height: number, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.cylinder(cframe, radius, height, resolved), resolved.lifetime)
end

--[=[
    Removes every drawn adornment and stops the loop
]=]
const function clear()
	render.clear()
end

--[=[
    Registers a per frame callback, so while one is set the previous frame is cleared before
    each call so draws inside the callback produce a fresh picture every frame and never
    rely on lifetime, pass nil to stop
]=]
const function onDraw(callback: typees.DrawCallback?)
	render.setOnDraw(callback)
end

return {
	draw = draw,
	ray = ray,
	line = line,
	box = box,
	sphere = sphere,
	cone = cone,
	cylinder = cylinder,
	clear = clear,
	onDraw = onDraw,
}
