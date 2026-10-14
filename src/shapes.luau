--!strict

const pool = require("./pool")
const types = require("./types")

const function style(adornment: HandleAdornment, options: types.ResolvedOptions)
	adornment.Color3 = options.color
	adornment.Transparency = options.transparency
	adornment.AlwaysOnTop = options.alwaysOnTop
	adornment.ZIndex = options.zIndex
	adornment.AdornCullingMode = options.adornCullingMode
end

const function line(from: Vector3, to: Vector3, options: types.ResolvedOptions): HandleAdornment
	const adornment = pool.acquire("LineHandleAdornment") :: LineHandleAdornment
	const delta = to - from
	const length = delta.Magnitude

	if length > 0 then
		adornment.CFrame = CFrame.lookAt(from, to)
		adornment.Length = length
	else
		adornment.CFrame = CFrame.new(from)
		adornment.Length = 0
	end

	adornment.Thickness = options.thickness
	style(adornment, options)

	return adornment
end

const function sphere(center: Vector3, radius: number, options: types.ResolvedOptions): HandleAdornment
	const adornment = pool.acquire("SphereHandleAdornment") :: SphereHandleAdornment

	adornment.CFrame = CFrame.new(center)
	adornment.Radius = radius
	adornment.Shading = options.shading
	style(adornment, options)

	return adornment
end

const function box(cframe: CFrame, size: Vector3, options: types.ResolvedOptions): HandleAdornment
	const adornment = pool.acquire("BoxHandleAdornment") :: BoxHandleAdornment

	adornment.CFrame = cframe
	adornment.Size = size
	adornment.Shading = options.shading
	style(adornment, options)

	return adornment
end

const function cone(cframe: CFrame, radius: number, height: number, options: types.ResolvedOptions): HandleAdornment
	const adornment = pool.acquire("ConeHandleAdornment") :: ConeHandleAdornment

	adornment.CFrame = cframe
	adornment.Radius = radius
	adornment.Height = height
	adornment.Shading = options.shading
	style(adornment, options)

	return adornment
end

const function cylinder(cframe: CFrame, radius: number, height: number, options: types.ResolvedOptions): HandleAdornment
	const adornment = pool.acquire("CylinderHandleAdornment") :: CylinderHandleAdornment

	adornment.CFrame = cframe
	adornment.Radius = radius
	adornment.Height = height
	adornment.InnerRadius = 0
	adornment.Angle = 360
	adornment.Shading = options.shading
	style(adornment, options)

	return adornment
end

return {
	line = line,
	sphere = sphere,
	box = box,
	cone = cone,
	cylinder = cylinder,
}
