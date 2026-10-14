--!strict

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

export type Entry = {
	adornment: HandleAdornment,
	expiresAt: number,
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
