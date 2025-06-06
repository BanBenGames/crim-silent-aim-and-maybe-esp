local Camera = workspace.CurrentCamera
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

local function SilentAimRaycast(origin, direction, params)
    local target = GetClosestTargetInRadius()
    if target then
        print("Silent Aim Activated: Redirecting shot to", target)
        return workspace:Raycast(origin, (target.Position - origin).Unit * 1000, params)
    end
    return workspace:Raycast(origin, direction, params)
end

hookfunction(workspace.Raycast, SilentAimRaycast)
