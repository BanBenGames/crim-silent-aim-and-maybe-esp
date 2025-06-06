local Camera = workspace.CurrentCamera
local PlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui") or game:GetService("StarterGui")

-- Function to create the Silent Aim confirmation UI
local function CreateSilentAimUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 0, 50)
    Label.Position = UDim2.new(0.5, -100, 0.1, 0) -- Top-center of the screen
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 0, 0) -- Red text for visibility
    Label.TextScaled = true -- Scales text for readability
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = "Silent Aim Active"
    Label.Parent = ScreenGui
end

CreateSilentAimUI() -- Show confirmation when script executes

-- Function to find the closest target inside the radius
local function GetClosestTargetInRadius()
    local closestTarget = nil
    local closestDistance = math.huge

    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Team ~= game.Players.LocalPlayer.Team then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                
                if onScreen and distanceFromCenter <= 100 then
                    if distanceFromCenter < closestDistance then
                        closestTarget = character.HumanoidRootPart
                        closestDistance = distanceFromCenter
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Function to override the game's raycast logic
local function SilentAimRaycast(origin, direction, params)
    local target = GetClosestTargetInRadius()
    if target then
        print("Silent Aim Activated: Redirecting shot to", target)
        return workspace:Raycast(origin, (target.Position - origin).Unit * 1000, params)
    end
    return workspace:Raycast(origin, direction, params)
end

hookfunction(workspace.Raycast, SilentAimRaycast) -- Override raycast function
