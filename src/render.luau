--!strict

const RunService = game:GetService("RunService")

const pool = require("./pool")
const types = require("./types")

local entries: { types.Entry } = {}
local connection: RBXScriptConnection? = nil
local drawCallback: types.DrawCallback? = nil

const function stop()
	const current = connection
	if current ~= nil then
		current:Disconnect()
		connection = nil
	end
end

const function releaseAll()
	for i = #entries, 1, -1 do
		pool.release(entries[i].adornment)
	end

	table.clear(entries)
end

const function step(dt: number)
	const callback = drawCallback

	if callback ~= nil then
		releaseAll()
		callback(dt)
	end

	const now = os.clock()
	local i = #entries

	while i >= 1 do
		const entry = entries[i]
		if entry.expiresAt <= now then
			pool.release(entry.adornment)
			table.remove(entries, i)
		end
		i -= 1
	end

	if #entries == 0 and drawCallback == nil then
		stop()
	end
end

const function start()
	if connection ~= nil then
		return
	end

	connection = RunService.Heartbeat:Connect(step)
end

--[=[
    Registers an adornment for drawing, with a lifetime in seconds, starts the loop on
    the first call, so nothing runs until somethingg is drawn
]=]
const function add(adornment: HandleAdornment, lifetime: number)
	entries[#entries + 1] = {
		adornment = adornment,
		expiresAt = os.clock() + lifetime,
	}

	start()
end

--[=[
    Sets or clears the per frame callback, while one is set the frame set is released before
    each call so a per frame caller never relies on a lifetime
]=]
const function setOnDraw(callback: types.DrawCallback?)
	if callback == nil then
		drawCallback = nil

		if #entries == 0 then
			stop()
		end

		return
	end

	drawCallback = callback

	start()
end

--[=[
    Drops every entry and destroys every adornment, idle and live and also clears the onDraw
    callback so a single call stops the renderer completely
]=]
const function clear()
	table.clear(entries)
	drawCallback = nil

	stop()
	pool.destroy()
end

return {
	add = add,
	setOnDraw = setOnDraw,
	clear = clear,
}
