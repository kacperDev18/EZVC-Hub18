-- ============================================================
-- EZVC Hub - Custom GUI + Full Logic
-- ============================================================

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local PLR = game:GetService("Players").LocalPlayer
local PG = PLR:FindFirstChild("PlayerGui") or PLR:WaitForChild("PlayerGui")

-- ============================================================
-- GUI PARENT (safe gethui)
-- ============================================================
local par
pcall(function()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then par = h end
    end
end)
if not par then par = game:GetService("CoreGui") end

-- destroy old instance if re-running
for _, v in ipairs(par:GetChildren()) do
    if v.Name == "EZVCProto" then pcall(function() v:Destroy() end) end
end

local sg = Instance.new("ScreenGui")
sg.Name = "EZVCProto"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.DisplayOrder = 999
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = par

-- ============================================================
-- HELPERS
-- ============================================================
local function mk(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in next, props do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function cr(o, r) mk("UICorner", {CornerRadius = UDim.new(0, r)}, o) end
local function sk(o, c, t) return mk("UIStroke", {Color = c, Thickness = 1, Transparency = t}, o) end
local function lb(parent, text, x, y, w, h, color, size, bold)
    return mk("TextLabel", {
        Size = UDim2.new(0, w, 0, h),
        Position = UDim2.new(0, x, 0, y),
        BackgroundTransparency = 1,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = size or 11,
        TextColor3 = color,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = text,
    }, parent)
end

-- ============================================================
-- COLORS
-- ============================================================
local BG = Color3.fromRGB(16, 16, 20)
local SF = Color3.fromRGB(22, 22, 27)
local HD = Color3.fromRGB(26, 26, 32)
local PN = Color3.fromRGB(30, 30, 36)
local EL = Color3.fromRGB(38, 38, 45)
local BR = Color3.fromRGB(52, 52, 60)
local TX = Color3.fromRGB(238, 238, 244)
local SB = Color3.fromRGB(150, 150, 162)
local MT = Color3.fromRGB(98, 98, 110)
local AC = Color3.fromRGB(155, 120, 255)

local tRefs = {}
local function rT(p, f) tRefs[#tRefs + 1] = {p = p, f = f} end
local function setAC(c)
    AC = c
    for _, e in ipairs(tRefs) do
        local v = e.f and e.f() or c
        TS:Create(e.p, TweenInfo.new(0.28, Enum.EasingStyle.Quart), {BackgroundColor3 = v}):Play()
    end
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local win = mk("Frame", {
    Size = UDim2.fromOffset(420, 300),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
}, sg)
cr(win, 12)
local wS = sk(win, BR, 0.35)

-- fit to viewport safely
local function fit()
    pcall(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        if vp.X <= 0 or vp.Y <= 0 then return end
        local w = math.clamp(math.floor(vp.X * 0.92), 300, 460)
        local h = math.clamp(math.floor(vp.Y * 0.78), 260, 340)
        win.Size = UDim2.fromOffset(w, h)
        win.Position = UDim2.new(0.5, 0, 0.5, 0)
    end)
end
fit()
pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end)

-- ============================================================
-- HEADER
-- ============================================================
local hdr = mk("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = HD, BorderSizePixel = 0}, win)
cr(hdr, 12)
-- cover bottom corners of header
mk("Frame", {Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12), BackgroundColor3 = HD, BorderSizePixel = 0}, hdr)

local aDot = mk("Frame", {Size = UDim2.fromOffset(10, 10), Position = UDim2.new(0, 14, 0.5, -5), BackgroundColor3 = AC, BorderSizePixel = 0}, hdr)
cr(aDot, 3)
rT(aDot)
lb(hdr, "EZVC Hub", 30, 0, 120, 38, TX, 13, true)
lb(hdr, "v1.0", 92, 0, 90, 38, MT, 9, false)

local xb = mk("TextButton", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, -30, 0.5, -12),
    BackgroundColor3 = EL,
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = SB,
    Text = "X",
    AutoButtonColor = false,
}, hdr)
cr(xb, 6)
xb.MouseEnter:Connect(function() TS:Create(xb, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 90, 90), TextColor3 = Color3.new(1,1,1)}):Play() end)
xb.MouseLeave:Connect(function() TS:Create(xb, TweenInfo.new(0.15), {BackgroundColor3 = EL, TextColor3 = SB}):Play() end)

-- drag window
local dg, d0, d1 = false, nil, nil
hdr.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dg = true; d0 = i.Position; d1 = win.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - d0
        win.Position = UDim2.new(d1.X.Scale, d1.X.Offset + d.X, d1.Y.Scale, d1.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dg = false
    end
end)

-- ============================================================
-- BODY + SIDEBAR + CONTENT
-- ============================================================
local body = mk("Frame", {Size = UDim2.new(1, 0, 1, -38), Position = UDim2.new(0, 0, 0, 38), BackgroundTransparency = 1}, win)
local sideBar = mk("Frame", {Size = UDim2.new(0, 118, 1, 0), BackgroundColor3 = SF, BorderSizePixel = 0}, body)
mk("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = BR, BackgroundTransparency = 0.4, BorderSizePixel = 0}, sideBar)
local ct = mk("Frame", {Size = UDim2.new(1, -118, 1, 0), Position = UDim2.new(0, 118, 0, 0), BackgroundTransparency = 1}, body)

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local pages, tabs, cur = {}, {}, nil
local function go(n)
    if cur == n then return end
    for k, p in pairs(pages) do
        if k == n then
            p.Visible = true
            p.Position = UDim2.new(0, 5, 0, 0)
            TS:Create(p, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        else
            p.Visible = false
        end
    end
    for k, b in pairs(tabs) do
        if k == n then
            TS:Create(b, TweenInfo.new(0.18), {BackgroundColor3 = EL, TextColor3 = TX}):Play()
        else
            TS:Create(b, TweenInfo.new(0.18), {BackgroundColor3 = SF, TextColor3 = MT}):Play()
        end
    end
    cur = n
end

for i, n in ipairs({"Main", "Play", "Macro"}) do
    local b = mk("TextButton", {
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, 10 + (i-1)*32),
        BackgroundColor3 = SF,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = MT,
        Text = "  " .. n,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, sideBar)
    cr(b, 6)
    b.MouseButton1Click:Connect(function() go(n) end)
    tabs[n] = b
end

-- accent color swatches
for i, c in ipairs({
    Color3.fromRGB(155,120,255), Color3.fromRGB(108,142,255),
    Color3.fromRGB(0,200,220),   Color3.fromRGB(90,196,140),
    Color3.fromRGB(220,96,96),   Color3.fromRGB(240,150,60),
    Color3.fromRGB(230,120,180),
}) do
    local s = mk("TextButton", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.new(0, 8 + (i-1)*15, 1, -20),
        BackgroundColor3 = c,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, sideBar)
    cr(s, 6)
    s.MouseButton1Click:Connect(function() setAC(c) end)
end

-- ============================================================
-- PAGE / CARD / WIDGET BUILDERS
-- ============================================================
local function pg(n)
    local s = mk("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = EL,
        CanvasSize = UDim2.new(0, 0, 0, 700),
        Visible = false,
    }, ct)
    pages[n] = s
    return s
end

local function cd(parent, title, y)
    local f = mk("Frame", {
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, y),
        BackgroundColor3 = PN,
        BorderSizePixel = 0,
    }, parent)
    cr(f, 8)
    sk(f, BR, 0.4)
    if title then lb(f, string.upper(title), 12, 10, 200, 12, SB, 10, true) end
    return f
end

local function btn(parent, text, x, y, w, h, kind, cb)
    local bc, tc = EL, TX
    if kind == "p" then bc = AC; tc = Color3.new(1,1,1) end
    if kind == "d" then bc = Color3.fromRGB(56,34,34); tc = Color3.fromRGB(230,150,150) end
    local o = mk("TextButton", {
        Size = UDim2.new(0, w, 0, h),
        Position = UDim2.new(0, x, 0, y),
        BackgroundColor3 = bc,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = tc,
        Text = text,
        AutoButtonColor = false,
    }, parent)
    cr(o, 6)
    if kind == "p" then rT(o) end
    o.MouseEnter:Connect(function() TS:Create(o, TweenInfo.new(0.14), {BackgroundColor3 = bc:Lerp(Color3.new(1,1,1), 0.15)}):Play() end)
    o.MouseLeave:Connect(function() TS:Create(o, TweenInfo.new(0.14), {BackgroundColor3 = bc}):Play() end)
    if cb then o.MouseButton1Click:Connect(cb) end
    return o
end

local function tg(parent, name, desc, x, y, w, h, initOn, cb)
    local box = mk("Frame", {
        Size = UDim2.new(0, w, 0, h),
        Position = UDim2.new(0, x, 0, y),
        BackgroundColor3 = EL,
        BorderSizePixel = 0,
    }, parent)
    cr(box, 6)
    if desc then
        lb(box, name, 10, 5, w-50, 14, TX, 11, false)
        lb(box, desc, 10, 20, w-50, 11, SB, 9, false)
    else
        lb(box, name, 10, 0, w-50, h, TX, 11, false)
    end
    local st = initOn
    local sw = mk("Frame", {
        Size = UDim2.fromOffset(32, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = initOn and AC or Color3.fromRGB(52,52,60),
        BorderSizePixel = 0,
    }, box)
    cr(sw, 9)
    local kn = mk("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = initOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
    }, sw)
    cr(kn, 6)
    rT(sw, function() return st and AC or Color3.fromRGB(52,52,60) end)

    local function apply(v)
        st = v
        TS:Create(sw, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {BackgroundColor3 = v and AC or Color3.fromRGB(52,52,60)}):Play()
        TS:Create(kn, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {Position = v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play()
    end

    local z = mk("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, box)
    z.MouseButton1Click:Connect(function()
        apply(not st)
        if cb then cb(st) end
    end)
    return {GetValue = function() return st end, SetValue = apply}
end

-- ============================================================
-- NOTIFICATION
-- ============================================================
local function N(title, content)
    pcall(function()
        local nf = mk("Frame", {
            Size = UDim2.fromOffset(220, 50),
            Position = UDim2.new(1, -230, 1, -70),
            BackgroundColor3 = PN,
            BorderSizePixel = 0,
            ZIndex = 50,
        }, sg)
        cr(nf, 8); sk(nf, BR, 0.3)
        local t1 = lb(nf, title, 12, 8, 180, 16, AC, 11, true); t1.ZIndex = 51
        local t2 = lb(nf, content, 12, 26, 196, 18, SB, 10, false); t2.ZIndex = 51
        nf.BackgroundTransparency = 1
        TS:Create(nf, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        task.delay(3, function()
            TS:Create(nf, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.delay(0.35, function() pcall(function() nf:Destroy() end) end)
        end)
    end)
end

-- ============================================================
-- STATUS BAR
-- ============================================================
local stBar = mk("Frame", {Size = UDim2.new(1,0,0,18), Position = UDim2.new(0,0,1,-18), BackgroundColor3 = SF, BorderSizePixel = 0}, win)
local stDot = mk("Frame", {Size = UDim2.fromOffset(5,5), Position = UDim2.new(0,11,0.5,-2), BackgroundColor3 = Color3.fromRGB(90,196,140), BorderSizePixel = 0}, stBar)
cr(stDot, 3)
local stLbl = lb(stBar, "Lobby 0 | Place 0 | Upgrade 0 | Sell 0", 22, 0, 300, 18, MT, 9, false)

-- ============================================================
-- FLOAT TOGGLE BUTTON
-- ============================================================
local visWin = true
local fl = mk("TextButton", {
    Size = UDim2.fromOffset(78, 34),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundColor3 = HD,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = TX,
    Text = "Toggle",
    AutoButtonColor = false,
    ZIndex = 30,
}, sg)
cr(fl, 17)
local fS = sk(fl, BR, 0.4)
local fd = mk("Frame", {Size = UDim2.fromOffset(8,8), Position = UDim2.new(0,10,0.5,-4), BackgroundColor3 = AC, BorderSizePixel = 0}, fl)
cr(fd, 4); rT(fd)

local fDg, fM, f0, f1 = false, false, nil, nil
fl.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        fDg = true; fM = false; f0 = i.Position; f1 = fl.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if fDg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - f0
        if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then fM = true end
        fl.Position = UDim2.new(f1.X.Scale, f1.X.Offset + d.X, f1.Y.Scale, f1.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fDg = false end
end)

local function showWin(v)
    visWin = v
    if v then
        win.Visible = true
        win.BackgroundTransparency = 1
        wS.Transparency = 1
        TS:Create(win, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TS:Create(wS,  TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.35}):Play()
        TS:Create(fd,  TweenInfo.new(0.24), {BackgroundColor3 = AC}):Play()
    else
        TS:Create(win, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TS:Create(wS,  TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
        task.delay(0.3, function() if not visWin then win.Visible = false end end)
        TS:Create(fd, TweenInfo.new(0.24), {BackgroundColor3 = Color3.fromRGB(90,196,140)}):Play()
    end
end
fl.MouseButton1Click:Connect(function() if not fM then showWin(not visWin) end end)

-- ============================================================
-- CLOSE DIALOG
-- ============================================================
local scrD, dlg
local function killD(instant)
    if not dlg then return end
    if instant then
        pcall(function() dlg:Destroy() end)
        pcall(function() scrD:Destroy() end)
        dlg = nil; scrD = nil; return
    end
    local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local items = {dlg, scrD}
    for _, c in ipairs(dlg:GetDescendants()) do items[#items+1] = c end
    for _, el in ipairs(items) do
        if el and el:IsA("TextLabel") then TS:Create(el, ti, {TextTransparency = 1}):Play()
        elseif el and el:IsA("TextButton") then TS:Create(el, ti, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        elseif el and el:IsA("UIStroke") then TS:Create(el, ti, {Transparency = 1}):Play()
        elseif el and el:IsA("Frame") then TS:Create(el, ti, {BackgroundTransparency = 1}):Play() end
    end
    task.delay(0.28, function()
        pcall(function() dlg:Destroy() end)
        pcall(function() scrD:Destroy() end)
        dlg = nil; scrD = nil
    end)
end

local function ask()
    killD(true)
    scrD = mk("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 40}, sg)
    dlg = mk("Frame", {Size = UDim2.fromOffset(280,130), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,0,0.5,0), BackgroundColor3 = PN, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 41}, sg)
    cr(dlg, 10)
    local ds = sk(dlg, BR, 1)
    local dt = lb(dlg, "Close GUI", 14, 14, 250, 20, TX, 14, true); dt.TextTransparency = 1; dt.ZIndex = 42
    local dm = mk("TextLabel", {Size = UDim2.new(1,-28,0,40), Position = UDim2.new(0,14,0,40), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = SB, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Text = "Are you sure you want to close this GUI?", TextTransparency = 1, ZIndex = 42}, dlg)
    local nb = mk("TextButton", {Size = UDim2.new(0.5,-20,0,32), Position = UDim2.new(0,14,1,-46), BackgroundColor3 = EL, BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = TX, TextTransparency = 1, Text = "No", AutoButtonColor = false, ZIndex = 42}, dlg)
    cr(nb, 6)
    local yb = mk("TextButton", {Size = UDim2.new(0.5,-20,0,32), Position = UDim2.new(0.5,6,1,-46), BackgroundColor3 = Color3.fromRGB(180,70,70), BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.new(1,1,1), TextTransparency = 1, Text = "Yes", AutoButtonColor = false, ZIndex = 42}, dlg)
    cr(yb, 6)
    local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TS:Create(scrD, ti, {BackgroundTransparency = 0.5}):Play()
    TS:Create(dlg, ti, {BackgroundTransparency = 0}):Play()
    TS:Create(ds, ti, {Transparency = 0.3}):Play()
    TS:Create(dt, ti, {TextTransparency = 0}):Play()
    TS:Create(dm, ti, {TextTransparency = 0}):Play()
    TS:Create(nb, ti, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TS:Create(yb, ti, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    nb.MouseButton1Click:Connect(function() killD(false) end)
    yb.MouseButton1Click:Connect(function()
        local to = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        local list = {dlg, scrD, win, fl, wS, fS}
        for _, c in ipairs(dlg:GetDescendants()) do list[#list+1] = c end
        for _, el in ipairs(list) do
            if el and el:IsA("TextLabel") then TS:Create(el, to, {TextTransparency = 1}):Play()
            elseif el and el:IsA("UIStroke") then TS:Create(el, to, {Transparency = 1}):Play()
            elseif el then TS:Create(el, to, {BackgroundTransparency = 1, TextTransparency = 1}):Play() end
        end
        task.delay(0.35, function() pcall(function() sg:Destroy() end) end)
    end)
end
xb.MouseButton1Click:Connect(ask)

-- ============================================================
-- LOGIC / CONFIG
-- ============================================================
local FO = "tdmacro/"
local CF = FO .. "config.json"
pcall(function()
    if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(FO) then
        makefolder(FO)
    end
end)

local function wj(p, d)
    if type(writefile) ~= "function" then return false end
    local ok, s = pcall(function() return HS:JSONEncode(d) end)
    if not ok then return false end
    return pcall(writefile, p, s)
end
local function rj(p)
    if type(isfile) ~= "function" or type(readfile) ~= "function" or not isfile(p) then return nil end
    local ok, d = pcall(readfile, p)
    if not ok then return nil end
    local ok2, a = pcall(function() return HS:JSONDecode(d) end)
    if not ok2 or type(a) ~= "table" then return nil end
    return a
end
local function lf()
    if type(listfiles) ~= "function" then return {} end
    local seen, n = {}, {}
    for _, p in ipairs({FO, "tdmacro", "./tdmacro/"}) do
        local ok, list = pcall(listfiles, p)
        if ok and type(list) == "table" then
            for _, f in ipairs(list) do
                local x = tostring(f):match("([^/\\]+)%.json$")
                if x and x ~= "state" and x ~= "config" and not seen[x] then
                    seen[x] = true; n[#n+1] = x
                end
            end
        end
    end
    return n
end

local Cfg = {}
do local c = rj(CF); if c and type(c) == "table" then Cfg = c end end
for k, v in pairs({gs="1",mn="",sel="",sk=false,rp=false,lb=false,rec=false,pl=false,s10=false,s1=false,spn=false}) do
    if Cfg[k] == nil then Cfg[k] = v end
end

local _init = true
local _pend = false
local function save()
    if _init or _pend then return end
    _pend = true
    task.spawn(function()
        task.wait(0.2)
        _pend = false
        pcall(function() wj(CF, Cfg) end)
    end)
end
local function set(k, v) Cfg[k] = v; save() end

local sel = Cfg.sel or ""
local C = {L=0, P=0, U=0, S=0}
local rec = {a={}, n=1, t={}, k={}, l=0, active=false}
local R = {}

local function ens(k, f, n)
    if R[k] and R[k].Parent then return R[k] end
    local fo = RS:FindFirstChild(f)
    if not fo then return nil end
    local r = fo:FindFirstChild(n)
    if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then R[k] = r; return r end
end

-- rfC defined early so loops can call it safely; will be replaced later with label refs
local rfC = function()
    pcall(function()
        stLbl.Text = string.format("Lobby %d | Place %d | Upgrade %d | Sell %d", C.L, C.P, C.U, C.S)
    end)
end

local function visEl(d)
    if not d.Visible then return false end
    local p = d.Parent
    while p do
        if p:IsA("GuiObject") and not p.Visible then return false end
        p = p.Parent
    end
    return true
end
local function fB(tx)
    local nd = tx:lower()
    local rr = {PG}
    pcall(function() if gethui then local ok,h=pcall(gethui) if ok and h then rr[#rr+1]=h end end end)
    for _, root in ipairs(rr) do
        if root then
            for _, d in ipairs(root:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and visEl(d) then
                    local t = d.Text
                    if d:IsA("ImageButton") then
                        local lb2 = d:FindFirstChildOfClass("TextLabel")
                        if lb2 then t = lb2.Text end
                    end
                    if tostring(t or ""):lower():find(nd, 1, true) then return d end
                end
            end
        end
    end
end
local function lose() return fB("replay") ~= nil end
local function resetRec()
    rec.a = {}; rec.n = 1; rec.t = {}; rec.k = {}; rec.l = tick()
    C.P = 0; C.U = 0; C.S = 0; rfC()
end

-- ============================================================
-- AUTO SUMMON
-- ============================================================
local function invokeSummon(a)
    local ev
    pcall(function()
        local fo = RS:FindFirstChild("RemoteFunctions")
        if fo then ev = fo:FindFirstChild("SummonUnits") end
    end)
    if not ev or not ev:IsA("RemoteFunction") then return false end
    return pcall(function() ev:InvokeServer(a) end)
end
task.spawn(function()
    while true do
        if Cfg.s10 then if invokeSummon(10) then C.L=C.L+1; rfC() end task.wait(1)
        else task.wait(0.5) end
    end
end)
task.spawn(function()
    while true do
        if Cfg.s1 then if invokeSummon(1) then C.L=C.L+1; rfC() end task.wait(1)
        else task.wait(0.5) end
    end
end)

-- ============================================================
-- AUTO SPIN
-- ============================================================
task.spawn(function()
    while true do
        if Cfg.spn then
            local ev
            pcall(function()
                local fo = RS:FindFirstChild("RemoteFunctions")
                if fo then ev = fo:FindFirstChild("SpinWheel") end
            end)
            if ev and ev:IsA("RemoteFunction") then pcall(function() ev:InvokeServer() end) end
            task.wait(0.5)
        else task.wait(0.2) end
    end
end)

-- ============================================================
-- AUTO LOBBY
-- ============================================================
local lbLoop = false
local function startLB()
    if lbLoop then return end; lbLoop = true
    task.spawn(function()
        while Cfg.lb do
            local tl = RS:FindFirstChild("ReturnToLobby")
            if tl and tl:IsA("RemoteEvent") then
                if pcall(function() tl:FireServer() end) then C.L=C.L+1; rfC() end
            end
            task.wait(1)
        end
        lbLoop = false
    end)
end

-- ============================================================
-- ROUND WATCHER
-- ============================================================
task.spawn(function()
    local was = false
    while true do
        local now = lose()
        if now and not was and rec.active then resetRec() end
        was = now
        task.wait(0.5)
    end
end)

-- ============================================================
-- AUTO SKIP WAVE
-- ============================================================
local lastW = nil
local function getSkipBtn()
    local ok, b = pcall(function() return PG.MainGameUI.UpSide.InfoDop.AutoSkip end)
    return ok and b or nil
end
local function setVis(on)
    pcall(function()
        local b = getSkipBtn(); if not b then return end
        for _, v in ipairs(b:GetDescendants()) do
            if v:IsA("UIGradient") then
                if v.Name == "AutoOff" then v.Enabled = not on
                elseif v.Name == "AutoOn" then v.Enabled = on end
            end
        end
    end)
end
task.spawn(function()
    while true do
        if Cfg.sk then
            local ws = RS:FindFirstChild("WaveState")
            if ws then
                pcall(function()
                    local w = ws:GetAttribute("CurrentWave")
                    local c = ws:GetAttribute("CanSkipWave")
                    local r = ws:GetAttribute("Result")
                    if c == true and r ~= "Win" and r ~= "Lose" and lastW ~= w then
                        lastW = w
                        local skR = ens("w","RemoteEvents","SkipWaveVote")
                        if skR and pcall(function() skR:FireServer(w) end) then C.L=C.L+1; rfC() end
                    end
                end)
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================================
-- AUTO REPLAY
-- ============================================================
local rpL = false
local function startRP()
    if rpL then return end; rpL = true
    task.spawn(function()
        while Cfg.rp do
            local re = RS:FindFirstChild("RemoteEvents")
            local rv = re and re:FindFirstChild("ReplayVote")
            if rv and pcall(function() rv:FireServer() end) then C.L=C.L+1; rfC() end
            task.wait(1)
        end
        rpL = false
    end)
end

-- ============================================================
-- RECORD HOOK
-- ============================================================
pcall(function()
    if not (getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then return end
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local m, x = getnamecallmethod(), {...}
        local r = old(self, ...)
        if rec.active then
            pcall(function()
                local PL = ens("p","RemoteFunctions","PlaceTower")
                local UP = ens("u","RemoteFunctions","UpgradeTower")
                local SE = ens("s","RemoteFunctions","SellTower")
                local SK = ens("w","RemoteEvents","SkipWaveVote")
                local SP = ens("g","RemoteEvents","SetGameSpeed")
                if m == "InvokeServer" and PL and self == PL then
                    local n, cf = x[1], x[2]
                    if typeof(cf) == "CFrame" then
                        C.P = C.P + 1
                        task.spawn(function()
                            local tw = workspace:FindFirstChild("Towers")
                            local bd, b = 20, nil
                            if tw then
                                for _, xx in ipairs(tw:GetChildren()) do
                                    if not rec.k[xx] then
                                        local ok, q = pcall(function() return xx:GetPivot().Position end)
                                        if ok and q then
                                            local dist = (q - cf.Position).Magnitude
                                            if dist < bd then b = xx; bd = dist end
                                        end
                                    end
                                end
                            end
                            local id = rec.n; rec.n = id + 1
                            if b then rec.t[id] = b; rec.k[b] = id end
                            local tk = tick()
                            rec.a[#rec.a+1] = {t="P", n=n, p={cf.Position.X,cf.Position.Y,cf.Position.Z}, i=id, d=tk-(rec.l or tk)}
                            rec.l = tk; rfC()
                        end)
                    end
                elseif m == "InvokeServer" and UP and self == UP then
                    local id = rec.k[x[1]]
                    if id then C.U=C.U+1; local tk=tick(); rec.a[#rec.a+1]={t="U",i=id,d=tk-(rec.l or tk)}; rec.l=tk; rfC() end
                elseif m == "InvokeServer" and SE and self == SE then
                    local inst, id = x[1], rec.k[x[1]]
                    if id then C.S=C.S+1; local tk=tick(); rec.a[#rec.a+1]={t="S",i=id,d=tk-(rec.l or tk)}; rec.l=tk; rec.t[id]=nil; rec.k[inst]=nil; rfC() end
                elseif m == "FireServer" and SK and self == SK then
                    local tk=tick(); rec.a[#rec.a+1]={t="W",d=tk-(rec.l or tk)}; rec.l=tk
                elseif m == "FireServer" and SP and self == SP then
                    local tk=tick(); rec.a[#rec.a+1]={t="G",v=x[1],d=tk-(rec.l or tk)}; rec.l=tk
                end
            end)
        end
        return r
    end)
    setreadonly(mt, true)
end)

-- ============================================================
-- PLAY LOOP
-- ============================================================
task.spawn(function()
    local function nf(pos, ctx)
        local tw = workspace:FindFirstChild("Towers"); if not tw then return nil end
        local bd, b = 20, nil
        for _, x in ipairs(tw:GetChildren()) do
            if not ctx.k[x] then
                local ok, q = pcall(function() return x:GetPivot().Position end)
                if ok and q then local d = (q-pos).Magnitude; if d < bd then b=x; bd=d end end
            end
        end
        return b
    end
    while true do
        if Cfg.pl and Cfg.sel ~= "" then
            local data = rj(FO .. Cfg.sel .. ".json")
            if data and #data > 0 then
                local P2 = {t={}, k={}, i=1}
                while Cfg.pl and P2.i <= #data do
                    local a = data[P2.i]
                    if a then
                        if (a.d or 0) > 0 then task.wait(a.d) end
                        if not Cfg.pl then break end
                        if a.t == "P" then
                            local PL = ens("p","RemoteFunctions","PlaceTower")
                            if PL then
                                local cf = CFrame.new(a.p[1],a.p[2],a.p[3])
                                pcall(function() PL:InvokeServer(a.n, cf) end)
                                local t0 = tick()
                                while tick()-t0 < 2 do
                                    local inst = nf(cf.Position, P2)
                                    if inst then P2.t[a.i]=inst; P2.k[inst]=a.i; break end
                                    task.wait(0.05)
                                end
                            end
                        elseif a.t == "U" then
                            local UP = ens("u","RemoteFunctions","UpgradeTower"); local inst = P2.t[a.i]
                            if UP and inst and inst.Parent then pcall(function() UP:InvokeServer(inst) end) end
                        elseif a.t == "S" then
                            local SE = ens("s","RemoteFunctions","SellTower"); local inst = P2.t[a.i]
                            if SE and inst and inst.Parent then pcall(function() SE:InvokeServer(inst) end); P2.t[a.i]=nil; P2.k[inst]=nil end
                        elseif a.t == "W" then
                            local SK = ens("w","RemoteEvents","SkipWaveVote")
                            if SK then pcall(function() SK:FireServer(1) end) end
                        elseif a.t == "G" then
                            local SP = ens("g","RemoteEvents","SetGameSpeed")
                            if SP then pcall(function() SP:FireServer(a.v) end) end
                        end
                    end
                    P2.i = P2.i + 1
                end
                if Cfg.pl then task.wait(2) end
            else task.wait(1) end
        else task.wait(0.5) end
    end
end)

-- ============================================================
-- BUILD PAGES
-- ============================================================

-- MAIN PAGE
local mP = pg("Main")
local c1 = cd(mP, "Statistics", 12)
c1.Size = UDim2.new(1, -24, 0, 84)
lb(c1, "Lobby",   12,  30, 60, 12, SB, 9, false)
lb(c1, "Place",   82,  30, 60, 12, SB, 9, false)
lb(c1, "Upgrade", 152, 30, 60, 12, SB, 9, false)
lb(c1, "Sell",    222, 30, 60, 12, SB, 9, false)
-- single set of value labels (no duplicates)
local _lL = lb(c1, "0", 12,  44, 60, 20, TX, 16, true)
local _pL = lb(c1, "0", 82,  44, 60, 20, TX, 16, true)
local _uL = lb(c1, "0", 152, 44, 60, 20, TX, 16, true)
local _sL = lb(c1, "0", 222, 44, 60, 20, TX, 16, true)

-- replace rfC with full version now that labels exist
rfC = function()
    pcall(function()
        _lL.Text = tostring(C.L)
        _pL.Text = tostring(C.P)
        _uL.Text = tostring(C.U)
        _sL.Text = tostring(C.S)
        stLbl.Text = string.format("Lobby %d | Place %d | Upgrade %d | Sell %d", C.L, C.P, C.U, C.S)
    end)
end

local c2 = cd(mP, "Automation", 104)
c2.Size = UDim2.new(1, -24, 0, 166)
tg(c2, "Auto Summon 10", "Summon 10 units/s",      12, 26,  240, 38, Cfg.s10, function(on) set("s10", on) end)
tg(c2, "Auto Summon 1",  "Summon 1 unit/s",         12, 70,  240, 38, Cfg.s1,  function(on) set("s1", on) end)
tg(c2, "Auto Spin",      "Spin wheel automatically", 12, 114, 240, 38, Cfg.spn, function(on) set("spn", on) end)

-- PLAY PAGE
local pP = pg("Play")
local pc = cd(pP, "Game Speed", 12)
pc.Size = UDim2.new(1, -24, 0, 60)
lb(pc, "Speed", 12, 28, 60, 24, SB, 11, false)
local gsOpts = {"1", "1.50", "2"}
local gsCur = Cfg.gs or "1"
local gsIdx = 1
for i, v in ipairs(gsOpts) do if v == gsCur then gsIdx = i end end
local gsLbl = mk("TextButton", {
    Size = UDim2.new(0,120,0,28), Position = UDim2.new(1,-132,0,22),
    BackgroundColor3 = EL, BorderSizePixel = 0,
    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = TX,
    Text = gsCur, AutoButtonColor = false,
}, pc)
cr(gsLbl, 5)
gsLbl.MouseButton1Click:Connect(function()
    gsIdx = gsIdx % #gsOpts + 1
    gsCur = gsOpts[gsIdx]
    gsLbl.Text = gsCur
    set("gs", gsCur)
    local n = tonumber(gsCur)
    if n then local g = ens("g","RemoteEvents","SetGameSpeed"); if g then pcall(function() g:FireServer(n) end) end end
end)

local pc2 = cd(pP, "Toggles", 80)
pc2.Size = UDim2.new(1, -24, 0, 170)
tg(pc2, "Auto Skip Wave", "Skip waves automatically",        12, 26,  240, 38, Cfg.sk, function(on) set("sk", on); if on then lastW=nil; setVis(true) else setVis(false) end end)
tg(pc2, "Auto Replay",    "Vote replay on round end",        12, 70,  240, 38, Cfg.rp, function(on) set("rp", on); if on then startRP() else rpL=false end end)
tg(pc2, "Auto Lobby",     "Return to lobby automatically",   12, 114, 240, 38, Cfg.lb, function(on) set("lb", on); if on then startLB() else lbLoop=false end end)

-- MACRO PAGE
local mP2 = pg("Macro")
local rc = cd(mP2, "Macro Name", 12)
rc.Size = UDim2.new(1, -24, 0, 56)
lb(rc, "Name", 12, 26, 50, 24, SB, 11, false)
local mnBox = mk("TextBox", {
    Size = UDim2.new(1,-80,0,26), Position = UDim2.new(0,64,0,20),
    BackgroundColor3 = BG, BorderSizePixel = 0,
    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = TX,
    PlaceholderText = "np. EasyFarm", PlaceholderColor3 = MT,
    Text = Cfg.mn or "", ClearTextOnFocus = false,
}, rc)
cr(mnBox, 5)
mnBox.FocusLost:Connect(function() set("mn", mnBox.Text or "") end)

local rc2 = cd(mP2, "Macro Actions", 76)
rc2.Size = UDim2.new(1, -24, 0, 240)

local cLbl = lb(rc2, "Lobby 0 | Place 0 | Upgrade 0 | Sell 0", 12, 26, 260, 14, MT, 9, false)
-- extend rfC to also update macro tab label
local _prevRfC = rfC
rfC = function()
    _prevRfC()
    pcall(function()
        cLbl.Text = string.format("Lobby %d | Place %d | Upgrade %d | Sell %d", C.L, C.P, C.U, C.S)
    end)
end

local macroList = lf()
local macroIdx = 0
for i, v in ipairs(macroList) do if v == Cfg.sel then macroIdx = i end end
local macroLbl = mk("TextButton", {
    Size = UDim2.new(1,-24,0,28), Position = UDim2.new(0,12,0,46),
    BackgroundColor3 = EL, BorderSizePixel = 0,
    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = TX,
    Text = Cfg.sel ~= "" and Cfg.sel or "-- select macro --",
    AutoButtonColor = false,
}, rc2)
cr(macroLbl, 5)
local function refreshMacroLbl()
    macroList = lf(); macroIdx = 0
    for i, v in ipairs(macroList) do if v == Cfg.sel then macroIdx = i end end
    macroLbl.Text = Cfg.sel ~= "" and Cfg.sel or "-- select macro --"
end
macroLbl.MouseButton1Click:Connect(function()
    macroList = lf()
    if #macroList == 0 then N("EZVC","Brak zapisanych macro") return end
    macroIdx = macroIdx % #macroList + 1
    local chosen = macroList[macroIdx]
    macroLbl.Text = chosen
    sel = chosen; set("sel", chosen)
end)

btn(rc2, "Create / Save Macro", 12, 82, 240, 28, "p", function()
    local n = mnBox.Text or ""
    if n == "" then N("EZVC","Wpisz nazwe macro") return end
    pcall(function()
        if type(isfile) ~= "function" or not isfile(FO..n..".json") then wj(FO..n..".json",{}) end
    end)
    sel = n; set("sel", n); refreshMacroLbl()
    N("EZVC","Macro gotowe: "..n)
end)

local rToggle
rToggle = tg(rc2, "Record Macro", "Start/stop recording", 12, 118, 240, 38, Cfg.rec, function(on)
    set("rec", on)
    if on then
        if Cfg.sel == "" then N("EZVC","Najpierw wybierz macro"); rToggle.SetValue(false); return end
        resetRec(); rec.active = true
        N("EZVC","Nagrywanie -> "..Cfg.sel)
    else
        rec.active = false
        if #rec.a > 0 and Cfg.sel ~= "" then
            if wj(FO..Cfg.sel..".json", rec.a) then N("EZVC","Zapisano "..#rec.a.." -> "..Cfg.sel) end
        else N("EZVC","Nic do zapisania") end
        resetRec()
    end
end)

local pToggle
pToggle = tg(rc2, "Play Macro", "Playback recorded macro", 12, 162, 240, 38, Cfg.pl, function(on)
    set("pl", on)
    if on and Cfg.sel == "" then N("EZVC","Najpierw wybierz macro"); pToggle.SetValue(false) end
end)

btn(rc2, "Delete Macro", 12, 208, 240, 28, "d", function()
    if Cfg.sel == "" then N("EZVC","Wybierz macro") return end
    pcall(function() if type(delfile) == "function" then delfile(FO..Cfg.sel..".json") end end)
    sel = ""; set("sel", ""); refreshMacroLbl()
    N("EZVC","Usunieto")
end)

-- ============================================================
-- POST-LOAD
-- ============================================================
_init = false
task.spawn(function()
    task.wait(1.5)
    local gs = tonumber(Cfg.gs)
    if gs then local g = ens("g","RemoteEvents","SetGameSpeed"); if g then pcall(function() g:FireServer(gs) end) end end
    if Cfg.sk then lastW = nil; setVis(true) end
    if Cfg.rp then startRP() end
    if Cfg.lb then startLB() end
    if Cfg.rec and Cfg.sel ~= "" then
        resetRec(); rec.active = true
        if rToggle then rToggle.SetValue(true) end
    elseif Cfg.rec then
        Cfg.rec = false; save()
        if rToggle then rToggle.SetValue(false) end
    end
    if Cfg.pl and Cfg.sel == "" then
        Cfg.pl = false; save()
        if pToggle then pToggle.SetValue(false) end
    end
end)

go("Main")
rfC()
N("EZVC", "Ready")
print("[EZVC] DONE")
