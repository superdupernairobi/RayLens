--!strict

const HttpService = game:GetService("HttpService")
const Workspace = game:GetService("Workspace")

const FOLDER_NAME = HttpService:GenerateGUID(false)
const MAX_IDLE_PER_CLASS = 256

local idle: { [string]: { HandleAdornment } } = {}
local folder: Folder? = nil

const function getFolder(): Folder
	const existing = folder
	if existing ~= nil then
		return existing
	end

	const created = Instance.new("Folder")
	created.Name = FOLDER_NAME
	created.Parent = Workspace.Terrain

	folder = created

	return created
end

const function acquire(className: string): HandleAdornment
	const available: { HandleAdornment }? = idle[className]

	if available ~= nil then
		const pooled = table.remove(available)
		if pooled ~= nil then
			pooled.Visible = true
			return pooled
		end
	end

	const instance = Instance.new(className) :: HandleAdornment
	instance.Adornee = Workspace.Terrain
	instance.Visible = true
	instance.Parent = getFolder()

	return instance
end

const function release(adornment: HandleAdornment)
	adornment.Visible = false

	const className = adornment.ClassName
	const available: { HandleAdornment }? = idle[className]

	if available == nil then
		idle[className] = { adornment }
		return
	end

	if #available >= MAX_IDLE_PER_CLASS then
		adornment:Destroy()
		return
	end

	table.insert(available, adornment)
end

const function destroy()
	const current = folder
	if current ~= nil then
		current:Destroy()
		folder = nil
	end

	table.clear(idle)
end

return {
	acquire = acquire,
	release = release,
	destroy = destroy,
}
