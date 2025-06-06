local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Function to create the radius UI
local function CreateRadiusUI()
    local ScreenGui = Instance.new("ScreenGui")
    task.wait(1) -- Allow time for PlayerGui to load
    ScreenGui.Parent = LocalPlayer:FindFirstChild("PlayerGui") or StarterGui

    local CircleFrame = Instance.new("Frame")
    CircleFrame.Size = UDim2.new(0, 170, 0, 170) -- 85-pixel radius (doubled for full coverage)
    CircleFrame.Position = UDim2.new(0.5, -85, 0.5, -125) -- Adjusted Y offset for crosshair alignment
    CircleFrame.BackgroundTransparency = 1 -- Fully transparent inside
    CircleFrame.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 3 -- Adjust thickness for visibility
    UIStroke.Color = Color3.new(1, 0, 0) -- Red border
    UIStroke.Parent = CircleFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0) -- Make it a perfect circle
    UICorner.Parent = CircleFrame

    -- Ensure the UI updates correctly
    RunService.RenderStepped:Connect(function()
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        CircleFrame.Position = UDim2.new(0, screenCenter.X - 85, 0, screenCenter.Y - 125) -- Adjusted Y offset
    end)
end

-- Execute function to create the UI
CreateRadiusUI()
