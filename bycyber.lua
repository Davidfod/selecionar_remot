local Player = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Important = {
    Kick=true, Teleport=true, TP=true, Ban=true, Unban=true,
    Kill=true, Damage=true, Reset=true, Explode=true, Bring=true,
    ToServerTeleport=true, ServerKick=true, ServerBan=true,
    DecrementMoney=true, Economy=true, Money=true, Coins=true, Transfer=true
}

local function IsChatRemote(remote)
    local name = string.lower(remote.Name)
    return string.find(name, "chat") ~= nil
end

local function SendChatMessage(msg)
    local ChatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if ChatRemote and ChatRemote:FindFirstChild("SayMessageRequest") then
        ChatRemote.SayMessageRequest:FireServer(msg, "All")
    else
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = msg,
            Color = Color3.new(1,1,1)
        })
    end
end

local function MakeDraggable(frame)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function GetAllRemotes()
    local list = {}
    local services = {ReplicatedStorage, workspace, game:GetService("StarterGui")}
    for _, srv in ipairs(services) do
        for _, obj in ipairs(srv:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(list, obj)
            end
        end
    end
    return list
end

local function Create(cls, props)
    local inst = Instance.new(cls)
    for i,v in pairs(props) do inst[i] = v end
    return inst
end

function ExecuteRemote(remote, val, target)
    pcall(function()
        remote:FireServer(-val, target)
    end)

    if IsChatRemote(remote) then
        SendChatMessage("bycyber")
    end
end

function OpenMainGUI(RemoteList)
    if CoreGui:FindFirstChild("CyberCash_V2") then CoreGui.CyberCash_V2:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name="CyberCash_V2", Parent=CoreGui})

    local Main = Create("Frame", {
        Parent=ScreenGui,
        BackgroundColor3=Color3.fromRGB(40,40,40),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0.5,-125,0.3,0),
        Size=UDim2.new(0,250,0,260)
    })

    MakeDraggable(Main)

    local Title = Create("TextLabel", {
        Parent=Main,
        Text="Cyber",
        BackgroundColor3=Color3.fromRGB(30,30,30),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Size=UDim2.new(1,0,0,28),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=18
    })

    local CloseBtn = Create("TextButton", {
        Parent=Main,
        Text="X",
        BackgroundColor3=Color3.fromRGB(120,30,30),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Size=UDim2.new(0,28,0,28),
        Position=UDim2.new(1,-30,0,0),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=18
    })

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MinBtn = Create("TextButton", {
        Parent=Main,
        Text="-",
        BackgroundColor3=Color3.fromRGB(60,60,60),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Size=UDim2.new(0,28,0,28),
        Position=UDim2.new(1,-60,0,0),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=18
    })

    local minimized = false

    MinBtn.MouseButton1Click:Connect(function()
        if minimized == false then
            Main.Size = UDim2.new(0,250,0,28)
            for _, v in ipairs(Main:GetChildren()) do
                if v ~= Title and v ~= CloseBtn and v ~= MinBtn then
                    v.Visible = false
                end
            end
        else
            Main.Size = UDim2.new(0,250,0,260)
            for _, v in ipairs(Main:GetChildren()) do
                v.Visible = true
            end
        end
        minimized = not minimized
    end)

    local NickInput = Create("TextBox", {
        Parent=Main,
        PlaceholderText="Nick alvo...",
        Text=Player.Name,
        BackgroundColor3=Color3.fromRGB(50,50,50),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,40),
        Size=UDim2.new(1,-20,0,30),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSans,
        TextSize=16
    })

    local AmountInput = Create("TextBox", {
        Parent=Main,
        PlaceholderText="Valor...",
        Text="",
        BackgroundColor3=Color3.fromRGB(50,50,50),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,80),
        Size=UDim2.new(1,-20,0,30),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSans,
        TextSize=16
    })

    local SetBtn = Create("TextButton", {
        Parent=Main,
        Text="Executar no Nick",
        BackgroundColor3=Color3.fromRGB(60,60,60),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,120),
        Size=UDim2.new(1,-20,0,35),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=16
    })

    SetBtn.MouseButton1Click:Connect(function()
        local nick = NickInput.Text
        local val = tonumber(AmountInput.Text)

        if val and nick ~= "" then
            SetBtn.Text = "Enviando..."
            for _, remote in ipairs(RemoteList) do
                ExecuteRemote(remote, val, nick)
            end
            task.wait(1)
            SetBtn.Text = "Executar no Nick"
        else
            SetBtn.Text = "Erro"
            task.wait(1)
            SetBtn.Text = "Executar no Nick"
        end
    end)

    local AllBtn = Create("TextButton", {
        Parent=Main,
        Text="Executar em Todos",
        BackgroundColor3=Color3.fromRGB(80,30,30),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,165),
        Size=UDim2.new(1,-20,0,35),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=16
    })

    AllBtn.MouseButton1Click:Connect(function()
        local val = tonumber(AmountInput.Text)
        if not val then
            AllBtn.Text = "Valor inválido"
            task.wait(1)
            AllBtn.Text = "Executar em Todos"
            return
        end

        AllBtn.Text = "Enviando..."
        for _, plr in ipairs(Players:GetPlayers()) do
            for _, remote in ipairs(RemoteList) do
                ExecuteRemote(remote, val, plr.Name)
            end
        end
        task.wait(1)
        AllBtn.Text = "Executar em Todos"
    end)

    local ChangeBtn = Create("TextButton", {
        Parent=Main,
        Text="Trocar Remote",
        BackgroundColor3=Color3.fromRGB(60,60,60),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,210),
        Size=UDim2.new(1,-20,0,35),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=16
    })

    ChangeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        OpenSelectorGUI()
    end)
end

function OpenSelectorGUI()
    local Remotes = GetAllRemotes()
    if #Remotes == 0 then return end

    if CoreGui:FindFirstChild("RemoteSelector") then CoreGui.RemoteSelector:Destroy() end

    local SelectorGui = Create("ScreenGui", {Name="RemoteSelector", Parent=CoreGui})

    local SelFrame = Create("Frame", {
        Parent=SelectorGui,
        BackgroundColor3=Color3.fromRGB(40,40,40),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0.5,-150,0.3,0),
        Size=UDim2.new(0,300,0,330)
    })

    MakeDraggable(SelFrame)

    local Title = Create("TextLabel", {
        Parent=SelFrame,
        Text="Selecionar Remote",
        BackgroundColor3=Color3.fromRGB(30,30,30),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Size=UDim2.new(1,0,0,28),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=18
    })

    local CloseBtn = Create("TextButton", {
        Parent=SelFrame,
        Text="X",
        BackgroundColor3=Color3.fromRGB(120,30,30),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Size=UDim2.new(0,28,0,28),
        Position=UDim2.new(1,-30,0,0),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=18
    })

    CloseBtn.MouseButton1Click:Connect(function()
        SelectorGui:Destroy()
    end)

    local SelectAllBtn = Create("TextButton", {
        Parent=SelFrame,
        Text="Selecionar Todas",
        BackgroundColor3=Color3.fromRGB(60,60,60),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,40),
        Size=UDim2.new(1,-20,0,30),
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.SourceSansBold,
        TextSize=16
    })

    SelectAllBtn.MouseButton1Click:Connect(function()
        SelectorGui:Destroy()
        OpenMainGUI(Remotes)
    end)

    local Scroll = Create("ScrollingFrame", {
        Parent=SelFrame,
        BackgroundColor3=Color3.fromRGB(35,35,35),
        BorderSizePixel=1,
        BorderColor3=Color3.fromRGB(0,0,0),
        Position=UDim2.new(0,10,0,80),
        Size=UDim2.new(1,-20,1,-90),
        CanvasSize=UDim2.new(0,0,0,#Remotes * 32),
        ScrollBarThickness=6
    })

    for i, remote in ipairs(Remotes) do
        local btn = Create("TextButton", {
            Parent=Scroll,
            Text=remote.Name,
            BackgroundColor3=Color3.fromRGB(50,50,50),
            BorderSizePixel=1,
            BorderColor3=Color3.fromRGB(0,0,0),
            Size=UDim2.new(1,-10,0,28),
            Position=UDim2.new(0,5,0,(i-1)*32),
            TextColor3 = Important[remote.Name] and Color3.new(1,0,0) or Color3.new(1,1,1),
            Font=Enum.Font.SourceSansBold,
            TextSize=15
        })

        btn.MouseButton1Click:Connect(function()
            SelectorGui:Destroy()
            OpenMainGUI({remote})
        end)
    end
end

OpenSelectorGUI()
