-- OPENSOURCE FREECAM SCRIPT (not mine)
--[[ Services ]]
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local conns: { RBXScriptConnection } = {}

--[[ Variables ]]
local Camera = Workspace.CurrentCamera

local Pitch = 0
local Yaw = 0

--[[ Constants ]]
local CameraSpeed = 100
local LookSens = 0.2

local CameraController = {}

--[[ Initialization ]]
function CameraController:_GetMoveVector(): Vector3
	local MoveX = 0
	local MoveY = 0
	local MoveZ = 0
	
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveX += 1 end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveX -= 1 end
	
	if UserInputService:IsKeyDown(Enum.KeyCode.E) then MoveY += 1 end
	if UserInputService:IsKeyDown(Enum.KeyCode.Q) then MoveY -= 1 end
	
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveZ += 1 end
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveZ -= 1 end
	
	return Vector3.new(MoveX, MoveY, MoveZ)
end

function CameraController:_UpdateLook()
	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		
		local MouseDelta = UserInputService:GetMouseDelta()
		
		Yaw -= MouseDelta.X * LookSens
		Pitch -= MouseDelta.Y * LookSens
		
		Pitch = math.clamp(Pitch, -89, 89)
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

function CameraController:Init()
	Camera.CameraType = Enum.CameraType.Scriptable
end

function CameraController:Start()
	table.insert(conns, RunService.RenderStepped:Connect(function(DeltaTime)
		self:_UpdateLook()
		
		local MoveDirection = self:_GetMoveVector()
		local Rotation = CFrame.Angles(0, math.rad(Yaw), 0) * CFrame.Angles(math.rad(Pitch), 0, 0)
		
		if MoveDirection.Magnitude > 0 then
			MoveDirection = MoveDirection.Unit
		end
		
		local Movement = Rotation * MoveDirection * (CameraSpeed * DeltaTime)
		Camera.CFrame = CFrame.new(Camera.CFrame.Position + Movement) * Rotation
	end))
end

function CameraController:Disconnect()
	for _, conn in conns do
		conn:Disconnect()
	end
end

CameraController:Init()
CameraController:Start()