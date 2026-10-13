--!strict

local types = require(script.Parent.types)

--[=[
    The values every draw falls back to, frozen because resolve() hands this exact table
    back when a caller passes no options at all, so the common per frame case allocates
    nothing

    zIndex 1 is the floor, 0 does not draw above parts. AdornCullingMode.Never stops long
    rays disappearing with dist, and Shading.XRay is what lets a cast volume read
    through geometry
]=]
local DEFAULTS = table.freeze({
	color = Color3.fromRGB(255, 170, 0),
	transparency = 0.2,
	thickness = 0.05,
	radius = 0.15,
	lifetime = 1,
	alwaysOnTop = true,
	zIndex = 1,
	shading = Enum.AdornShading.XRay,
	adornCullingMode = Enum.AdornCullingMode.Never,
}) :: types.ResolvedOptions

local function pick<T>(value: T?, fallback: T): T
	if value ~= nil then
		return value
	end

	return fallback
end

local function validate(options: types.ResolvedOptions)
	const transparency = options.transparency
	if transparency < 0 or transparency > 1 then
		error(`raylens: transparency must be between 0 and 1, got {transparency}`)
	end

	const thickneess = options.thickness
	if thickneess <= 0 then
		error(`raylens: thickness must be greater than 0, got {thickneess}`)
	end

	const radius = options.radius
	if radius <= 0 then
		error(`raylens: radius must be greater than 0, got {radius}`)
	end

	const lifetime = options.lifetime
	if lifetime < 0 then
		error(`raylens: lifetime must be 0 or more, got {lifetime}`)
	end

	const zIndex = options.zIndex
	if zIndex < 1 then
		error(`raylens: zIndex must be atleast 1 to draw above parts, got {zIndex}`)
	end
end

--[=[
    Applies defaults and validates, returns DEFAULTS itself when nothing was passed, so a
    per frame caller that wants default styling allocates nothing
]=]
local function resolve(options: types.Options?): types.ResolvedOptions
	if options == nil then
		return DEFAULTS
	end

	const resolved: types.ResolvedOptions = {
		color = pick(options.color, DEFAULTS.color),
		transparency = pick(options.transparency, DEFAULTS.transparency),
		thickness = pick(options.thickness, DEFAULTS.thickness),
		radius = pick(options.radius, DEFAULTS.radius),
		lifetime = pick(options.lifetime, DEFAULTS.lifetime),
		alwaysOnTop = pick(options.alwaysOnTop, DEFAULTS.alwaysOnTop),
		zIndex = pick(options.zIndex, DEFAULTS.zIndex),
		shading = pick(options.shading, DEFAULTS.shading),
		adornCullingMode = pick(options.adornCullingMode, DEFAULTS.adornCullingMode),
	}

	validate(resolved)

	return resolved
end

return {
	DEFAULTS = DEFAULTS,
	resolve = resolve,
}
