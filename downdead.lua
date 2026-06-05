if game.PlaceId ~= 134137156964623 then
    game:GetService("TeleportService"):Teleport(
        134137156964623,
        game:GetService("Players").LocalPlayer
    )
    return
end

-- CHECK BADGE
if game:GetService("BadgeService"):UserHasBadgeAsync(
    game:GetService("Players").LocalPlayer.UserId,
    2588234614616526
) then

    -- TELEPORT TO GOJO UGC
    if workspace["UGC Event"]
    and workspace["UGC Event"]:FindFirstChild("GojoUGC")
    and workspace["UGC Event"].GojoUGC:FindFirstChild("UGC") then

        game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame =
        workspace["UGC Event"].GojoUGC.UGC:GetPivot()
    end

    -- FIRE BUY PROMPT
    if workspace["UGC Event"].GojoUGC.UGC.Buy
    and workspace["UGC Event"].GojoUGC.UGC.Buy:IsA("ProximityPrompt") then
        fireproximityprompt(workspace["UGC Event"].GojoUGC.UGC.Buy)
    end
end

-- REMOVE COLOR CORRECTION
if game:GetService("Lighting"):FindFirstChild("ColorCorrection") then
    game:GetService("Lighting"):FindFirstChild("ColorCorrection"):Destroy()
end

for _, v in ipairs(game:GetService("Lighting"):GetChildren()) do
    if v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

-- ENEMY TRIGGER
game:GetService("Workspace"):WaitForChild("EnemyController"):WaitForChild("Enemies").ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        game:GetService("MarketplaceService"):SignalPromptProductPurchaseFinished(
            game:GetService("Players").LocalPlayer.UserId,
            2804833237,
            true
        )
    end
end)
