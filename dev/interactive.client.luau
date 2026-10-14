--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local rayLens = require(ReplicatedStorage.raylens)

const RAY_LENGTH = 500
const CASTS = { "ray", "blockcast" }

local index = 1

UserInputService.InputBegan:Connect(function(input: InputObject)
    const camera = Workspace.CurrentCamera
    if camera == nil then
        return
    end

    if input.KeyCode == Enum.KeyCode.X then
        rayLens.clear()
        return
    end

    if input.KeyCode == Enum.KeyCode.C then
        index = index % #CASTS + 1
        print("cast type:", CASTS[index])
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    const screen = UserInputService:GetMouseLocation()
    const ray = camera:ScreenPointToRay(screen.X, screen.Y)
    const direction = ray.Direction * RAY_LENGTH

    if CASTS[index] == "blockcast" then
        const size = Vector3.new(3,3,3)
        const result = Workspace:Blockcast(CFrame.new(ray.Origin), size, direction, nil)
        rayLens.draw(ray.Origin, direction, result)
        return
    end

    rayLens.draw(ray.Origin, direction, Workspace:Raycast(ray.Origin, direction, nil))
end)