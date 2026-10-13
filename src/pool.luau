--!strict

local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local FOLDER_NAME = HttpService:GenerateGUID(false)
local MAX_IDLE_PER_CLASS = 256

local idle: { [string]: { HandleAdornment } } = {}
local folder: Folder? = nil

local function getFolder(): Folder
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

--[=[
    Takes an adornment of `className` from the idle list or creates one, A reused instance
    is made visible again, every other property is left for the caller to set
]=]
local function acquire(className: string): HandleAdornment
	const available: { HandleAdornment }? = idle[className]

	if available ~= nil then
		const pooled = table.remove(available)
		if pooled ~= nil then
			pooled.Visible = true
			return pooled
		end
	end

	const instance = Instance.new(className) :: HandleAdornment
	instance.Parent = getFolder()

	return instance
end

--[=[
    Returns aan adornment to the idle list (hidden), past MAX_IDLE_PER_CLASS it is destroyed
    instead, so one spike of draws does not keep thousands of instances alive for the session
]=]
local function release(adornment: HandleAdornment)
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

--[=[
    Destroys every adornment, idle and live, it does it by deestroying the folder they share
    then drops the idle lists, a no op when nothing has been drawn
]=]
local function destroy()
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
