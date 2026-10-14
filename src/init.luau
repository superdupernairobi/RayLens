--!strict

const drawModule = require("@self/draw")
const types = require("@self/types")

--[=[
    Styling for a draw call, if you dont add anything it just uses the defaults

    @interface Options
    @within RayLens
    .color Color3? -- Adornment colour, orange by default
    .transparency number? -- 0 is solid, 1 is invis
    .thickness number? -- Line thickness (studs)
    .radius number? -- Marker and sphere radius (studs)
    .lifetime number? -- Seconds a one call draw stays on screen
    .alwaysOnTop boolean? -- Draw through geometry
    .zIndex number? -- 1 or more to draw above parts
    .shading Enum.AdornShading? -- Volume shapes only, lines ignore it
    .adornCullingMode Enum.AdornCullingMode? -- Never stops long rays fading with distance
]=]

--[=[
    Called once per frame while onDraw is running where `dt` is the time in seconds since the previous frame.
    
    @interface DrawCallback 
    @within RayLens
]=]

--[=[
    Draws an already casted ray, put the result you got from worldRoot:Raycast, a nil result is nothing, drawn at full length with no marker, so the absent marker is what tells you it missed, a result is drawn to its hit point with a marker on the surface normal

    @function draw
    @within RayLens
    @param origin Vector3 -- Where the ray started
    @param direction Vector3 -- The vector you cast, its length is the ray length
    @param result RaycastResult? -- The cast result or nil for a miss
    @param options Options? -- Styling, blank fields fall back to the defaults
]=]
const function draw(origin: Vector3, direction: Vector3, result: RaycastResult?, options: types.Options?)
	drawModule.draw(origin, direction, result, options)
end

--[=[
    Draws a ray before or without casting it, direction carries its own length, matches worldRoot:Raycast(o, d), so the same vector can be passed to both

    @function ray
    @within RayLens
    @param origin Vector3 -- Where the ray started
    @param direction Vector3 -- Direction and length
    @param options Options? -- Styling, blank fields just go to the defaults
]=]
const function ray(origin: Vector3, direction: Vector3, options: types.Options?)
	drawModule.ray(origin, direction, options)
end

--[=[
    Draws a line

    @function line
    @within RayLens
    @param from Vector3 -- Start
    @param to Vector3 -- End
    @param options Options? -- Styling, blank fields just go to the defaults
]=]
const function line(from: Vector3, to: Vector3, options: types.Options?)
	drawModule.line(from, to, options)
end

--[=[
    Draws a box

    @function box
    @within RayLens
    @param cframe CFrame -- The cast cframe
    @param size Vector3 -- The cast size
    @param options Options? -- Styling, blank fields just go to the defaults
]=]
const function box(cframe: CFrame, size: Vector3, options: types.Options?)
	drawModule.box(cframe, size, options)
end

--[=[
    Draws a sphere

    @function sphere
    @within RayLens
    @param center Vector3 -- Centre of the sphere
    @param radius number -- Radius in studs
    @param options Options? -- Styling, blank fields just go to the defaults
]=]
const function sphere(center: Vector3, radius: number, options: types.Options?)
	drawModule.sphere(center, radius, options)
end

--[=[
    Draws a cone

    @function cone
    @within RayLens
    @param cframe CFrame -- Position and orientation
    @param radius number -- Radius in studs
    @param height number -- Height in studs
    @param options Options? -- Styling, blank fields just go to the defaults
]=]
const function cone(cframe: CFrame, radius: number, height: number, options: types.Options?)
	drawModule.cone(cframe, radius, height, options)
end

--[=[
    Draws a cylinder

    @function cylinder
    @within RayLens
    @param cframe CFrame -- Position and orientation
    @param radius number -- Radius in studs
    @param height number -- Height in studs
    @param options Options? -- Styling, blank fields just go to the defaults
]=]
const function cylinder(cframe: CFrame, radius: number, height: number, options: types.Options?)
	drawModule.cylinder(cframe, radius, height, options)
end

--[=[
    Removes every drawn adornment and stops the loop

    @function clear
    @within RayLens
]=]
const function clear()
	drawModule.clear()
end

--[=[
    Adds a per frame callback, while the one that's set the previous frame is cleared before each call, so it draws inside the callback to create a new picture every frame and never rely on a lifetime, put nil to stop

    @function onDraw
    @within RayLens
    @param callback DrawCallback? -- Called once per frame with the frame delta, or nil to stop
]=]
const function onDraw(callback: types.DrawCallback?)
	drawModule.onDraw(callback)
end

--[=[
    Raycast and shape cast debugging for Roblox, draws what you already cast, with client side handle adornments that only render inside Studio

    @class RayLens
]=]
const rayLens = table.freeze({
	draw = draw,
	ray = ray,
	line = line,
	box = box,
	sphere = sphere,
	cone = cone,
	cylinder = cylinder,
	clear = clear,
	onDraw = onDraw,
}) :: types.RayLens

return rayLens
