---
sidebar_position: 2
---
# Examples
## A line of sight check
```lua
local rayLens = require(game.ReplicatedStorage.raylens)

local function has_line_of_sight(from: Vector3, to: Vector3, target: BasePart): boolean
    local direction = to - from
    local result = workspace:Raycast(from, direction, nil)

    rayLens.draw(from, direction, result)

    return result ~= nil and result.Instance == target
end
```
Draw every check while you are testing, but wrap the `rayLens.draw` line in a flag so it costs nothing when you switch it off.
## Draw only the misses
Usually the bug you are chasing is the cast that nothing was able to find, drawing only those keeps the screen easy to read.
```lua
local result = workspace:Raycast(origin, direction, nil)

if result == nil then
    rayLens.draw(origin, direction, result)
end
```
## A cone that has vision
Six rays fanned across the cone, redrawn every frame. This needs `onDraw` because the origin moves.
```lua
local rayLens = require(game.ReplicatedStorage.raylens)

local RAYS = 6
local RANGE = 60
local HALF_ANGLE = math.rad(30)

rayLens.onDraw(function()
    local character = game.Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root == nil then
        return
    end

    local origin = root.Position + Vector3.new(0, 2, 0)
    local forward = root.CFrame.LookVector

    for i = 0, RAYS - 1 do
        local step = i / (RAYS - 1) * 2 - 1
        local direction = (CFrame.Angles(0, step * HALF_ANGLE, 0) * forward) * RANGE

        rayLens.draw(origin, direction, workspace:Raycast(origin, direction, nil))
    end
end)
```
## Visualising a shape cast
`Blockcast` takes a cframe & a size, so draw the volume at its starting position and then the path it travelled.
```lua
local rayLens = require(game.ReplicatedStorage.raylens)

local start = CFrame.new(0, 20, 0)
local size = Vector3.new(4, 4, 4)
local direction = Vector3.new(0, -40, 0)

local result = workspace:Blockcast(start, size, direction, nil)

rayLens.box(start, size)
rayLens.draw(start.Position, direction, result)
```
The box shows the shape you cast, the ray shows where it ended up and between the two, a shape cast that hits the wrong thing usually explains itself.
## Cleaning up
```lua
rayLens.clear()
```
Everything RayLens created goes away, and the frame loop stops.