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

    -- Make the notification disappear after 5 seconds
    task.spawn(function()
        wait(5)
        ScreenGui:Destroy()
    end)
end

CreateSilentAimUI() -- Show confirmation when script executes

-- Function to find the closest target inside the adjusted radius
local function GetClosestTargetInRadius()
    local closestTarget = nil
    local closestDistance = math.huge

    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Team ~= game.Players.LocalPlayer.Team then
            local character = player.Character
            if character and character:FindFirstChild("Head") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(character.Head.Position)
                local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 155)).Magnitude
                
                if onScreen and distanceFromCenter <= 155 then -- Adjusted radius for detection
                    if distanceFromCenter < closestDistance then
                        closestTarget = character.Head
                        closestDistance = distanceFromCenter
                    end
                end
            end
        end
    end
    
    print("Silent Aim Target Found:", closestTarget)

    return closestTarget
end

-- Function to adjust projectile direction
local function AdjustBulletDirection(projectile)
    local target = GetClosestTargetInRadius()
    if target then
        print("Redirecting Bullet to:", target)

        -- Modify velocity to send bullet toward target
        projectile.Velocity = (target.Position - projectile.Position).Unit * 500 -- Adjust speed
    end
end

-- Hook projectile creation to modify velocity
local oldInstanceNew = Instance.new
Instance.new = function(class, parent)
    local obj = oldInstanceNew(class, parent)

    if class == "Part" or class == "Projectile" then
        task.wait(0.1) -- Let the projectile spawn
        AdjustBulletDirection(obj)
    end
    
    return obj
end
