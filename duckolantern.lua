local p = game:GetService("Players").LocalPlayer
local TS = game:GetService("TeleportService")
local RS = game:GetService("ReplicatedStorage")
local BS = game:GetService("BadgeService")
local SG = game:GetService("StarterGui")

local MainId = 91329411318364
local DuckId = 87313531273173
local BadgeId = 4427482880414316

local function N(a,b)
    pcall(function()
        SG:SetCore("SendNotification", {
            Title = b and "Error" or "Status",
            Text = a,
            Duration = 4
        })
    end)
end

local function E(a)
    warn("[DuckQuest] " .. a)
    N(a,true)
end

if game.PlaceId == MainId then
    N("Checking quest...")

    local q = p.PlayerGui:FindFirstChild("HUDGui")
    q = q and q.Quests.List.Quest.CanvasGroup.Content.Description

    if not q then
        E("Quest Description not found")
        return
    end

    local K = RS.Packages._Index["sleitnick_knit@1.7.0"].knit.Services
    local R = K.ProgressionEventService.RF.FireEvent
    local C = K.QuestService.RF.CompleteObjective
    local H = K.HalloweenService.RF.ClaimDuckHead

    if not R then
        E("FireEvent not found")
        return
    end

    if not C then
        E("CompleteObjective not found")
        return
    end

    if not H then
        E("ClaimDuckHead not found")
        return
    end

    task.wait(1)

    if q.Text:find("Claim your Duck O Lantern in the Avatar Shop",1,true) then
        N("Claiming Duck O Lantern...")

        local ok,err = pcall(function()
            H:InvokeServer()
        end)

        if not ok then
            E("ClaimDuckHead failed: " .. tostring(err))
            return
        end

        N("Duck O Lantern claimed!")
        task.wait(2)
        p:Kick("Done")
        return
    end

    N("Selecting Duck Quest...")

    local ok,err = pcall(function()
        R:InvokeServer("HalloweenQuestChoiceMade","quest","intro")
    end)

    if not ok then
        E("Quest selection failed: " .. tostring(err))
        return
    end

    task.wait(1)

    if q.Text == "Visit Duck Duck" then
        N("Going to Duck Duck...")

        local c = p.Character
        local t = workspace.Portals
        t = t and t.DuckDuckPortal
        t = t and t.Portal
        t = t and t.Portal
        t = t and t.Part

        if not c then
            E("Character not found")
            return
        end

        if not t then
            E("DuckDuckPortal.Part not found")
            return
        end

        local ok2,err2 = pcall(function()
            c:PivotTo(t.CFrame)
        end)

        if not ok2 then
            E("Teleport failed: " .. tostring(err2))
            return
        end

        N("Arrived at Duck Duck")
        return
    end

    N("Completing objective...")

    local ok3,err3 = pcall(function()
        C:InvokeServer("halloween_duck_hunt")
    end)

    if not ok3 then
        E("CompleteObjective failed: " .. tostring(err3))
        return
    end

    N("Objective completed!")
    return
end

if game.PlaceId == DuckId then
    N("Entering Duck Duck...")

    if getconnections then
        for _, c in getconnections(p.Idled) do
            pcall(function()
                c:Disable()
            end)
            pcall(function()
                c:Disconnect()
            end)
        end
    end

    p.Idled:Connect(function()
        local V = Instance.new("VirtualInputManager")
        V:SendMouseButtonEvent(0,0,0,true,game,0)
        V:SendMouseButtonEvent(0,0,0,false,game,0)
        V:Destroy()
    end)

    local s = p.PlayerGui:FindFirstChild("ROOT_UI")

    if not s then
        E("ROOT_UI not found")
        return
    end

    s = s.Full.FamilyZonePedestalBillboard.Quest.Status

    if not s then
        E("Quest Status not found")
        return
    end

    local lm
    local lg

    N("Checking progress...")

    while task.wait(1) do
        local ok,err = pcall(function()
            local m = tonumber(s.Text:match(">(%d+)/30"))
            local g = tonumber(s.Text:match(">(%d+)/10"))

            if not m or not g then
                E("Unable to read progress: " .. tostring(s.Text))
                return
            end

            if m ~= lm or g ~= lg then
                lm = m
                lg = g
                N("Progress: " .. m .. "/30 MIN | " .. g .. "/10 GAMES")
            end

            if m >= 30 and g >= 10 then
                N("Progress complete, checking badge...")

                local claimed = false

                local ok2,err2 = pcall(function()
                    claimed = BS:UserHasBadgeAsync(p.UserId,BadgeId)
                end)

                if not ok2 then
                    E("Badge check failed: " .. tostring(err2))
                    return
                end

                if claimed then
                    N("Badge found, returning...")
                    task.wait(1)
                    TS:Teleport(MainId,p)
                    return
                end

                N("Badge not found, waiting for claim...")
            end
        end)

        if not ok then
            E("Loop error: " .. tostring(err))
        end
    end
end
