--!strict

const optionsModule = require("./options")
const render = require("./render")
const shapes = require("./shapes")
const typees = require("./types")

const function marker(position: Vector3, options: typees.ResolvedOptions): HandleAdornment
	return shapes.sphere(position, options.radius, options)
end

const function draw(origin: Vector3, direction: Vector3, result: RaycastResult?, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	if result == nil then
		render.add(shapes.line(origin, origin + direction, resolved), resolved.lifetime)
		return
	end

	render.add(shapes.line(origin, result.Position, resolved), resolved.lifetime)
	render.add(marker(result.Position, resolved), resolved.lifetime)
end

const function ray(origin: Vector3, direction: Vector3, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.line(origin, origin + direction, resolved), resolved.lifetime)
end

const function line(from: Vector3, to: Vector3, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.line(from, to, resolved), resolved.lifetime)
end

const function box(cframe: CFrame, size: Vector3, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.box(cframe, size, resolved), resolved.lifetime)
end

const function sphere(center: Vector3, radius: number, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.sphere(center, radius, resolved), resolved.lifetime)
end

const function cone(cframe: CFrame, radius: number, height: number, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.cone(cframe, radius, height, resolved), resolved.lifetime)
end

const function cylinder(cframe: CFrame, radius: number, height: number, options: typees.Options?)
	const resolved = optionsModule.resolve(options)

	render.add(shapes.cylinder(cframe, radius, height, resolved), resolved.lifetime)
end

const function clear()
	render.clear()
end

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
