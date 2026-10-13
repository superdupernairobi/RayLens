--!strict

--[=[
    Styling accepted by every draw call. Every field is optional, anything
    omitted falls back to the defaults in options.luau
]=]
export type Options = {
	color: Color3?,
	transparency: number?,
	thickness: number?,
	radius: number?,
	lifetime: number?,
	alwaysOnTop: boolean?,
	zIndex: number?,
	shading: Enum.AdornShading?,
	adornCullingMode: Enum.AdornCullingMode?,
}

--[=[
    Options after defaults are applied and values are validated. Every field
    is present, so nothing downstream needs a second round of nil checks
]=]
export type ResolvedOptions = {
	color: Color3,
	transparency: number,
	thickness: number,
	radius: number,
	lifetime: number,
	alwaysOnTop: boolean,
	zIndex: number,
	shading: Enum.AdornShading,
	adornCullingMode: Enum.AdornCullingMode,
}

export type ShapeKind = "line" | "sphere" | "box" | "cone" | "cylinder" | "pyramid"

--[=[
    One live adornment tracked by the renderer, expiresAt is an os.clock() deadline
]=]
export type Entry = {
	adornment: HandleAdornment,
	expiresAt: number?,
}

export type DrawCallback = (dt: number) -> ()

export type RayLens = {
	draw: (origin: Vector3, direction: Vector3, result: RaycastResult?, options: Options?) -> (),
	ray: (origin: Vector3, direction: Vector3, options: Options?) -> (),
	line: (from: Vector3, to: Vector3, options: Options?) -> (),
	box: (cframe: CFrame, size: Vector3, options: Options?) -> (),
	sphere: (center: Vector3, radius: number, options: Options?) -> (),
	cone: (cframe: CFrame, radius: number, height: number, options: Options?) -> (),
	cylinder: (cframe: CFrame, radius: number, height: number, options: Options?) -> (),
	clear: () -> (),
	onDraw: (callback: DrawCallback?) -> (),
}

return {}
