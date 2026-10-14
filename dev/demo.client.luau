--!strict
-- Demo code

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local rayLens = require(ReplicatedStorage.raylens)

const RAY_COUNT = 12
const RAY_LENGTH = 40
const SPIN = 0.3

rayLens.onDraw(function()
    const t = os.clock()

    for i = 1, RAY_COUNT do
        const angle = (i / RAY_COUNT) * math.pi * 2 + t * SPIN
        const origin = Vector3.new(0, 1 + math.sin(t + i) * 3, 0)
        const direction = Vector3.new(math.cos(angle), math.sin(t * 0.7 + i * 0.5) * 0.4, math.sin(angle)) * RAY_LENGTH

        rayLens.draw(origin, direction, Workspace:Raycast(origin, direction, nil, direction), {
            color = Color3.new(1,1,1),
            thickness = 1,
        })
    end
end)