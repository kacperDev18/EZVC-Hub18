-- EZVC Hub v2.20 | Macro = v12 (continuous round-to-round Auto Play)
local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS  = game:GetService("ReplicatedStorage")
local HS  = game:GetService("HttpService")
local VU  = game:GetService("VirtualUser")
local PLR = game:GetService("Players").LocalPlayer
local PG  = PLR:FindFirstChild("PlayerGui") or PLR:WaitForChild("PlayerGui")

local S = {
    shuttingDown=false, shutdownDone=false,
    playbackActive=false, playbackSession=0,
    autoFishEnabled=false, autoFishSession=0,
    voteActive=false, voteSession=0,
    voteModes={"Easy","Medium","Hard","Insane","Crazy"}, voteIdx=1,
    gsOpts={"1","1.5","2","2.5","3"}, gsIdx=1,
    rec={a={},n=1,t={},k={},l=0,active=false,lastPlaced=nil},
    sel="", C={P=0,U=0,S=0},
    _init=true, _pend=false,
    lbLoop=false, rpL=false, hookHits=0, hookAll=0, lastW=nil,
    knownTowers={}, passiveConns={},
    tRefs={}, pages={}, tabs={}, tabInds={}, cur=nil,
    R={}, HR={PL=nil,UP=nil,SE=nil,SK=nil,SP=nil},
    _loseCache=nil, HOOK_MODE="none", HOOK_OK=false,
    CLIP_FN=nil, CLIP_NAME=nil, afkConn=nil,
    voteEvent=nil, fishEvent=nil,
    macroStatusLabel=nil, macroCountLabel=nil,
    pToggle=nil, rToggle=nil, avToggle=nil,
    _applyAFK=nil, _refreshShareSelect=nil,
    __hookOld=nil,
}
local Cfg = {}

local Conns = {}
local function ac(c) Conns[#Conns+1]=c return c end
local function cleanConns()
    for _,c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
    Conns={}
end

local FO, CF = "tdmacro/", "tdmacro/config.json"
pcall(function()
    if type(isfolder)=="function" and type(makefolder)=="function" and not isfolder(FO) then
        makefolder(FO)
    end
end)
local function wj(p,d)
    if type(writefile)~="function" then return false,"writefile missing" end
    local ok,s = pcall(function() return HS:JSONEncode(d) end)
    if not ok then return false,"JSONEncode error: "..tostring(s) end
    if type(s)~="string" then return false,"JSONEncode non-string" end
    local ok2,err = pcall(writefile,p,s)
    if not ok2 then return false,"writefile error: "..tostring(err) end
    return true,s
end
local function rj(p)
    if type(isfile)~="function" or type(readfile)~="function" then return nil,"no file api" end
    if not isfile(p) then return nil,"file missing: "..tostring(p) end
    local ok,d = pcall(readfile,p)
    if not ok then return nil,"readfile error: "..tostring(d) end
    local ok2,a = pcall(function() return HS:JSONDecode(d) end)
    if not ok2 or type(a)~="table" then return nil,"JSONDecode error: "..tostring(a) end
    return a
end
local function lf()
    if type(listfiles)~="function" then return {} end
    local seen,n = {},{}
    for _,p in ipairs({FO,"tdmacro","./tdmacro/"}) do
        local ok,list = pcall(listfiles,p)
        if ok and type(list)=="table" then
            for _,f in ipairs(list) do
                local x = tostring(f):match("([^/\\]+)%.json$")
                if x and x~="state" and x~="config" and not seen[x] then
                    seen[x]=true n[#n+1]=x
                end
            end
        end
    end
    return n
end

local function sanitizeAction(a)
    if type(a)~="table" then return nil end
    a.Method=nil a.method=nil
    if a.t~="P" and a.t~="U" and a.t~="S" and a.t~="W" and a.t~="G" then return nil end
    if a.t=="P" then
        if type(a.n)~="string" then a.n = tostring(a.n or "") end
        if type(a.p)~="table" then return nil end
        local p1,p2,p3 = tonumber(a.p[1]),tonumber(a.p[2]),tonumber(a.p[3])
        if not (p1 and p2 and p3) then return nil end
        a.p = {p1,p2,p3}
        a.i = tonumber(a.i) or 0
        a.d = tonumber(a.d) or 0
    elseif a.t=="U" or a.t=="S" then
        a.i = tonumber(a.i) or 0
        a.d = tonumber(a.d) or 0
    elseif a.t=="W" then
        a.d = tonumber(a.d) or 0
    elseif a.t=="G" then
        a.v = tonumber(a.v) or 1
        a.d = tonumber(a.d) or 0
    end
    return a
end

local function loadMacro(name)
    if not name or name=="" then return nil,"no name" end
    local data,err = rj(FO..name..".json")
    if type(data)~="table" then return nil,err or "not table" end
    local clean = {}
    local dropped = 0
    for _,a in ipairs(data) do
        local s = sanitizeAction(a)
        if s then clean[#clean+1]=s else dropped=dropped+1 end
    end
    return clean, dropped>0 and ("dropped "..dropped) or nil
end

do
    local c = rj(CF)
    if type(c)=="table" then Cfg = c end
end
for k,v in pairs({gs="1",mn="",sel="",sk=false,rp=false,lb=false,rec=false,pl=false,
    s25=false,s10=false,s1=false,spn=false,afk=false,oc=false,av=false,avm="Easy",
    crate="Free",acr=155,acg=120,acb=255}) do
    if Cfg[k]==nil then Cfg[k]=v end
end
S.sel = Cfg.sel or ""
for i,v in ipairs(S.voteModes) do if v==(Cfg.avm or "Easy") then S.voteIdx=i end end
for i,v in ipairs(S.gsOpts)    do if v==(Cfg.gs or "1")    then S.gsIdx=i  end end

local function save()
    if S.shuttingDown or S._init or S._pend then return end
    S._pend = true
    task.spawn(function()
        task.wait(0.2)
        S._pend = false
        if not S.shuttingDown then pcall(function() wj(CF,Cfg) end) end
    end)
end
local function set(k,v)
    if S.shuttingDown then return end
    Cfg[k]=v
    save()
end

local BG  = Color3.fromRGB(16,16,20)
local SF  = Color3.fromRGB(22,22,27)
local HD  = Color3.fromRGB(26,26,32)
local PN  = Color3.fromRGB(30,30,36)
local EL  = Color3.fromRGB(38,38,45)
local BR  = Color3.fromRGB(52,52,60)
local TX  = Color3.fromRGB(238,238,244)
local SB  = Color3.fromRGB(150,150,162)
local MT  = Color3.fromRGB(98,98,110)
local OFF = Color3.fromRGB(52,52,60)
local AC  = Color3.fromRGB(tonumber(Cfg.acr) or 155, tonumber(Cfg.acg) or 120, tonumber(Cfg.acb) or 255)

local par
pcall(function() if gethui then local ok,h=pcall(gethui) if ok and h then par=h end end end)
par = par or game:GetService("CoreGui")
for _,v in ipairs(par:GetChildren()) do
    if v.Name=="EZVCProto" then pcall(function() v:Destroy() end) end
end
local sg = Instance.new("ScreenGui")
sg.Name="EZVCProto"
sg.IgnoreGuiInset=true
sg.ResetOnSpawn=false
sg.DisplayOrder=999
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.Parent=par

local function mk(c,p,r)
    local o = Instance.new(c)
    for k,v in next,p do o[k]=v end
    if r then o.Parent=r end
    return o
end
local function cr(o,r) mk("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function sk(o,c,t) return mk("UIStroke",{Color=c,Thickness=1,Transparency=t},o) end
local function lb(p,t,x,y,w,h,c,s,b)
    return mk("TextLabel",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),
        BackgroundTransparency=1,Font=b and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize=s or 11,TextColor3=c,TextXAlignment=Enum.TextXAlignment.Left,Text=t},p)
end
local function rT(p,f,prop)
    S.tRefs[#S.tRefs+1]={p=p,f=f,prop=prop or "BackgroundColor3"}
    return p
end
local function setAC(c)
    AC=c
    for i=#S.tRefs,1,-1 do
        local e=S.tRefs[i]
        if not e.p or not e.p.Parent then
            table.remove(S.tRefs,i)
        else
            local v = e.f and e.f() or c
            pcall(function()
                TS:Create(e.p,TweenInfo.new(0.28,Enum.EasingStyle.Quart),{[e.prop]=v}):Play()
            end)
        end
    end
end
local function instantApply()
    for _,e in ipairs(S.tRefs) do
        if e.p and e.p.Parent then
            local v = e.f and e.f() or AC
            pcall(function() e.p[e.prop]=v end)
        end
    end
end

local win = mk("Frame",{Size=UDim2.fromOffset(420,300),AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=BG,BorderSizePixel=0},sg)
cr(win,12)
local wS = sk(win,BR,0.35)
local function fit()
    if S.shuttingDown then return end
    pcall(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        if vp.X<=0 or vp.Y<=0 then return end
        win.Size = UDim2.fromOffset(math.clamp(math.floor(vp.X*0.92),300,460),
                                    math.clamp(math.floor(vp.Y*0.78),260,340))
        win.Position = UDim2.new(0.5,0,0.5,0)
    end)
end
fit()
pcall(function() ac(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)) end)

local xb
do
    local hdr = mk("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=HD,BorderSizePixel=0},win)
    cr(hdr,12)
    mk("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=HD,BorderSizePixel=0},hdr)
    local aDot = mk("Frame",{Size=UDim2.fromOffset(10,10),Position=UDim2.new(0,14,0.5,-5),
        BackgroundColor3=AC,BorderSizePixel=0},hdr)
    cr(aDot,3) rT(aDot)
    lb(hdr,"EZVC Hub",30,0,120,38,TX,13,true)
    lb(hdr,"v2.20",92,0,90,38,MT,9,false)
    xb = mk("TextButton",{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-30,0.5,-12),
        BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=SB,Text="X",AutoButtonColor=false},hdr)
    cr(xb,6)
    ac(xb.MouseEnter:Connect(function() if S.shuttingDown then return end
        TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,90,90),
            TextColor3=Color3.new(1,1,1)}):Play() end))
    ac(xb.MouseLeave:Connect(function() if S.shuttingDown then return end
        TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=EL,TextColor3=SB}):Play() end))
    local d0,d1
    ac(hdr.InputBegan:Connect(function(i)
        if S.shuttingDown then return end
        if i.UserInputType==Enum.UserInputType.MouseButton1 or
           i.UserInputType==Enum.UserInputType.Touch then S.dg=true d0=i.Position d1=win.Position end
    end))
    ac(UIS.InputChanged:Connect(function(i)
        if S.shuttingDown or not S.dg then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or
           i.UserInputType==Enum.UserInputType.Touch then
            local d = i.Position-d0
            win.Position = UDim2.new(d1.X.Scale,d1.X.Offset+d.X,d1.Y.Scale,d1.Y.Offset+d.Y)
        end
    end))
    ac(UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or
           i.UserInputType==Enum.UserInputType.Touch then S.dg=false end
    end))
end

local ct, go
do
    local body = mk("Frame",{Size=UDim2.new(1,0,1,-38),Position=UDim2.new(0,0,0,38),BackgroundTransparency=1},win)
    local sideBar = mk("Frame",{Size=UDim2.new(0,118,1,0),BackgroundColor3=SF,BorderSizePixel=0},body)
    mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=BR,BackgroundTransparency=0.4,BorderSizePixel=0},sideBar)
    ct = mk("Frame",{Size=UDim2.new(1,-118,1,0),Position=UDim2.new(0,118,0,0),BackgroundTransparency=1},body)
    local accentLine = mk("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),
        BackgroundColor3=AC,BorderSizePixel=0,ZIndex=10},body)
    rT(accentLine)
    go = function(n)
        if S.shuttingDown or S.cur==n then return end
        for k,p in pairs(S.pages) do
            if k==n then
                p.Visible=true p.Position=UDim2.new(0,5,0,0)
                TS:Create(p,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
                    {Position=UDim2.new(0,0,0,0)}):Play()
            else p.Visible=false end
        end
        for k,b in pairs(S.tabs) do
            if k==n then
                TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=EL,TextColor3=AC}):Play()
                if S.tabInds[k] then TS:Create(S.tabInds[k],TweenInfo.new(0.22),{BackgroundTransparency=0}):Play() end
            else
                TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=SF,TextColor3=MT}):Play()
                if S.tabInds[k] then TS:Create(S.tabInds[k],TweenInfo.new(0.22),{BackgroundTransparency=1}):Play() end
            end
        end
        S.cur=n
    end
    for i,n in ipairs({"Main","Play","Macro","Share","GUI"}) do
        local b = mk("TextButton",{Size=UDim2.new(1,-16,0,28),Position=UDim2.new(0,8,0,10+(i-1)*32),
            BackgroundColor3=SF,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
            TextColor3=MT,Text="  "..n,AutoButtonColor=false,
            TextXAlignment=Enum.TextXAlignment.Left},sideBar)
        cr(b,6)
        local ind = mk("Frame",{Size=UDim2.new(0,3,1,-16),Position=UDim2.new(0,3,0,8),
            BackgroundColor3=AC,BorderSizePixel=0,BackgroundTransparency=1},b)
        cr(ind,2) rT(ind)
        S.tabInds[n]=ind
        ac(b.MouseButton1Click:Connect(function() go(n) end))
        S.tabs[n]=b
        rT(b,function() return (S.cur==n) and AC or MT end,"TextColor3")
    end
    for i,c in ipairs({Color3.fromRGB(155,120,255),Color3.fromRGB(220,96,96),
        Color3.fromRGB(108,142,255),Color3.fromRGB(90,196,140),
        Color3.fromRGB(240,150,60),Color3.fromRGB(230,120,180),
        Color3.fromRGB(0,200,220),Color3.fromRGB(230,200,90)}) do
        local s = mk("TextButton",{Size=UDim2.fromOffset(12,12),
            Position=UDim2.new(0,8+(i-1)*13,1,-20),BackgroundColor3=c,
            BorderSizePixel=0,Text="",AutoButtonColor=false},sideBar)
        cr(s,6)
        ac(s.MouseButton1Click:Connect(function()
            if S.shuttingDown then return end
            setAC(c)
            set("acr",math.floor(c.R*255+0.5))
            set("acg",math.floor(c.G*255+0.5))
            set("acb",math.floor(c.B*255+0.5))
            if _syncThemeUI then _syncThemeUI() end
        end))
    end
end

local function pg(n)
    local s = mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=EL,
        CanvasSize=UDim2.new(0,0,0,900),Visible=false},ct)
    S.pages[n]=s return s
end
local function cd(p,t,y)
    local f = mk("Frame",{Size=UDim2.new(1,-24,0,0),Position=UDim2.new(0,12,0,y),
        BackgroundColor3=PN,BorderSizePixel=0},p)
    cr(f,8) sk(f,BR,0.4)
    if t then
        local d = mk("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,10,0,14),
            BackgroundColor3=AC,BorderSizePixel=0},f)
        cr(d,2) rT(d)
        local tLbl = lb(f,string.upper(t),20,10,200,12,AC,10,true)
        rT(tLbl,nil,"TextColor3")
    end
    return f
end
local function btn(p,t,x,y,w,h,k,cb)
    local o = mk("TextButton",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),
        BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,Text=t,AutoButtonColor=false},p)
    if k=="p" then o.BackgroundColor3=AC o.TextColor3=Color3.new(1,1,1)
    elseif k=="d" then o.BackgroundColor3=Color3.fromRGB(56,34,34) o.TextColor3=Color3.fromRGB(230,150,150)
    else o.BackgroundColor3=EL o.TextColor3=TX end
    cr(o,6)
    if k=="p" then rT(o) end
    ac(o.MouseEnter:Connect(function() if S.shuttingDown then return end
        TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=o.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play() end))
    ac(o.MouseLeave:Connect(function() if S.shuttingDown then return end
        local target=EL
        if k=="p" then target=AC end
        if k=="d" then target=Color3.fromRGB(56,34,34) end
        TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=target}):Play() end))
    if cb then ac(o.MouseButton1Click:Connect(function() if S.shuttingDown then return end cb() end)) end
    return o
end
local function tg(p,nm,ds,x,y,w,h,on,cb)
    local box = mk("Frame",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),
        BackgroundColor3=EL,BorderSizePixel=0},p)
    cr(box,6)
    if ds then
        lb(box,nm,10,5,w-50,14,TX,11,false)
        lb(box,ds,10,20,w-50,11,SB,9,false)
    else lb(box,nm,10,0,w-50,h,TX,11,false) end
    local st = on
    local sw = mk("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-44,0.5,-9),
        BackgroundColor3=on and AC or OFF,BorderSizePixel=0},box)
    cr(sw,9)
    local kn = mk("Frame",{Size=UDim2.fromOffset(12,12),
        Position=on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
        BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw)
    cr(kn,6)
    rT(sw,function() return st and AC or OFF end)
    local function apply(v)
        st=v
        if S.shuttingDown then return end
        pcall(function()
            TS:Create(sw,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{BackgroundColor3=v and AC or OFF}):Play()
            TS:Create(kn,TweenInfo.new(0.22,Enum.EasingStyle.Quart),
                {Position=v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play()
        end)
    end
    local z = mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false},box)
    ac(z.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        local newV = not st
        apply(newV)
        if cb then
            local ok,err = pcall(cb, newV)
            if not ok then
                warn("[EZVC] toggle cb error ("..nm.."): "..tostring(err))
            end
        end
    end))
    return {GetValue=function() return st end,SetValue=function(v) apply(v) end}
end
local function N(title,content)
    if S.shuttingDown then return end
    local nf = mk("Frame",{Size=UDim2.fromOffset(220,50),Position=UDim2.new(1,-230,1,-70),
        BackgroundColor3=PN,BorderSizePixel=0,ZIndex=50},sg)
    cr(nf,8)
    local ns = sk(nf,AC,0.3)
    local t1 = lb(nf,title,12,8,180,16,AC,11,true) t1.ZIndex=51
    local t2 = lb(nf,content,12,26,196,18,SB,10,false) t2.ZIndex=51
    nf.BackgroundTransparency=1 ns.Transparency=1
    TS:Create(nf,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
    TS:Create(ns,TweenInfo.new(0.2),{Transparency=0.3}):Play()
    task.delay(3,function()
        if not nf or not nf.Parent then return end
        TS:Create(nf,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        TS:Create(ns,TweenInfo.new(0.3),{Transparency=1}):Play()
        TS:Create(t1,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        TS:Create(t2,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        task.delay(0.35,function() pcall(function() nf:Destroy() end) end)
    end)
end

local stBar = mk("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),
    BackgroundColor3=SF,BorderSizePixel=0},win)
local stDot = mk("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,11,0.5,-2),
    BackgroundColor3=AC,BorderSizePixel=0},stBar)
cr(stDot,3) rT(stDot)
local stLbl = lb(stBar,"Place 0 | Upgrade 0 | Sell 0",22,0,300,18,MT,9,false)

local fl = mk("TextButton",{Size=UDim2.fromOffset(78,34),Position=UDim2.new(0,16,0,16),
    BackgroundColor3=HD,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=TX,Text="Toggle",AutoButtonColor=false,ZIndex=30},sg)
cr(fl,17)
local fS = sk(fl,AC,0.4) rT(fS,nil,"Color")
local fd = mk("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,10,0.5,-4),
    BackgroundColor3=AC,BorderSizePixel=0},fl)
cr(fd,4) rT(fd)

do
    local f0,f1
    ac(fl.InputBegan:Connect(function(i)
        if S.shuttingDown then return end
        if i.UserInputType==Enum.UserInputType.MouseButton1 or
           i.UserInputType==Enum.UserInputType.Touch then S.fDg=true S.fM=false f0=i.Position f1=fl.Position end
    end))
    ac(UIS.InputChanged:Connect(function(i)
        if S.shuttingDown or not S.fDg then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or
           i.UserInputType==Enum.UserInputType.Touch then
            local d = i.Position-f0
            if math.abs(d.X)>4 or math.abs(d.Y)>4 then S.fM=true end
            fl.Position = UDim2.new(f1.X.Scale,f1.X.Offset+d.X,f1.Y.Scale,f1.Y.Offset+d.Y)
        end
    end))
    ac(UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or
           i.UserInputType==Enum.UserInputType.Touch then S.fDg=false end
    end))
end

local visWin = true
local function showWin(v)
    if S.shuttingDown then return end
    visWin = v
    if v then
        win.Visible=true win.BackgroundTransparency=1 wS.Transparency=1
        TS:Create(win,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
        TS:Create(wS,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.35}):Play()
        TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=AC}):Play()
    else
        TS:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
        TS:Create(wS,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency=1}):Play()
        task.delay(0.3,function() if not visWin and not S.shuttingDown then win.Visible=false end end)
        TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=Color3.fromRGB(90,196,140)}):Play()
    end
end
ac(fl.MouseButton1Click:Connect(function()
    if S.shuttingDown then return end
    if not S.fM then showWin(not visWin) end
end))

local function shutdownScript()
    if S.shutdownDone then return end
    S.shutdownDone=true S.shuttingDown=true
    S.playbackActive=false S.playbackSession=S.playbackSession+1
    S.autoFishEnabled=false S.autoFishSession=S.autoFishSession+1
    S.voteActive=false S.voteSession=S.voteSession+1
    S.rec.active=false
    pcall(cleanConns)
    pcall(function()
        for _,c in ipairs(S.passiveConns) do pcall(function() c:Disconnect() end) end
        S.passiveConns={}
    end)
    pcall(function() sg:Destroy() end)
    print("[EZVC] shutdown complete")
end
local scrD,dlg
local function killD(instant)
    if not dlg then return end
    if instant then
        pcall(function() dlg:Destroy() end) pcall(function() scrD:Destroy() end)
        dlg=nil scrD=nil return
    end
    local ti = TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
    local items = {dlg,scrD}
    for _,c in ipairs(dlg:GetDescendants()) do items[#items+1]=c end
    for _,el in ipairs(items) do
        if el and el:IsA("TextLabel") then TS:Create(el,ti,{TextTransparency=1}):Play()
        elseif el and el:IsA("TextButton") then TS:Create(el,ti,{BackgroundTransparency=1,TextTransparency=1}):Play()
        elseif el and el:IsA("UIStroke") then TS:Create(el,ti,{Transparency=1}):Play()
        elseif el and el:IsA("Frame") then TS:Create(el,ti,{BackgroundTransparency=1}):Play() end
    end
    task.delay(0.28,function()
        pcall(function() dlg:Destroy() end) pcall(function() scrD:Destroy() end)
        dlg=nil scrD=nil
    end)
end
local function ask()
    if S.shuttingDown then return end
    killD(true)
    scrD = mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=40},sg)
    dlg = mk("Frame",{Size=UDim2.fromOffset(280,130),AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=PN,BackgroundTransparency=1,
        BorderSizePixel=0,ZIndex=41},sg)
    cr(dlg,10)
    local ds = sk(dlg,BR,1)
    local dt = lb(dlg,"Close GUI",14,14,250,20,TX,14,true) dt.TextTransparency=1 dt.ZIndex=42
    local dm = mk("TextLabel",{Size=UDim2.new(1,-28,0,40),Position=UDim2.new(0,14,0,40),
        BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=SB,
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=true,Text="Are you sure you want to close this GUI?",TextTransparency=1,ZIndex=42},dlg)
    local nb = mk("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0,14,1,-46),
        BackgroundColor3=EL,BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,
        TextSize=12,TextColor3=TX,TextTransparency=1,Text="No",AutoButtonColor=false,ZIndex=42},dlg)
    cr(nb,6)
    local yb = mk("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0.5,6,1,-46),
        BackgroundColor3=Color3.fromRGB(180,70,70),BackgroundTransparency=1,BorderSizePixel=0,
        Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.new(1,1,1),TextTransparency=1,
        Text="Yes",AutoButtonColor=false,ZIndex=42},dlg)
    cr(yb,6)
    local ti = TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    TS:Create(scrD,ti,{BackgroundTransparency=0.5}):Play()
    TS:Create(dlg,ti,{BackgroundTransparency=0}):Play()
    TS:Create(ds,ti,{Transparency=0.3}):Play()
    TS:Create(dt,ti,{TextTransparency=0}):Play()
    TS:Create(dm,ti,{TextTransparency=0}):Play()
    TS:Create(nb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()
    TS:Create(yb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()
    ac(nb.MouseButton1Click:Connect(function() if S.shuttingDown then return end killD(false) end))
    ac(yb.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        S.shuttingDown=true
        S.playbackActive=false S.playbackSession=S.playbackSession+1
        S.autoFishEnabled=false S.autoFishSession=S.autoFishSession+1
        S.voteActive=false S.voteSession=S.voteSession+1
        S.rec.active=false
        local to = TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        local list = {dlg,scrD,win,fl,wS,fS}
        for _,c in ipairs(dlg:GetDescendants()) do list[#list+1]=c end
        for _,el in ipairs(list) do
            if el and el:IsA("TextLabel") then TS:Create(el,to,{TextTransparency=1}):Play()
            elseif el and el:IsA("UIStroke") then TS:Create(el,to,{Transparency=1}):Play()
            elseif el then TS:Create(el,to,{BackgroundTransparency=1,TextTransparency=1}):Play() end
        end
        task.delay(0.35,function() shutdownScript() end)
    end))
end
ac(xb.MouseButton1Click:Connect(function() if S.shuttingDown then return end ask() end))

local function ens(k,f,n)
    local c = S.R[k]
    if c and c.Parent then return c end
    local fo = RS:FindFirstChild(f)
    if not fo then return nil end
    local r = fo:FindFirstChild(n)
    if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
        S.R[k]=r return r
    end
end
local function getFishingEvent()
    if S.fishEvent and S.fishEvent.Parent then return S.fishEvent end
    local fo = RS:FindFirstChild("Fishing")
    if not fo then return nil end
    local rm = fo:FindFirstChild("Remotes")
    if not rm then return nil end
    local ev = rm:FindFirstChild("FishingEvent")
    if ev and ev:IsA("RemoteEvent") then S.fishEvent=ev return ev end
    return nil
end
local rfC = function()
    pcall(function() stLbl.Text=string.format("Place %d | Upgrade %d | Sell %d",S.C.P,S.C.U,S.C.S) end)
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
    pcall(function()
        if gethui then local ok,h=pcall(gethui) if ok and h then rr[#rr+1]=h end end
    end)
    for _,root in ipairs(rr) do
        if root then
            for _,d in ipairs(root:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and visEl(d) then
                    local t = d.Text
                    if d:IsA("ImageButton") then
                        local lb2 = d:FindFirstChildOfClass("TextLabel")
                        if lb2 then t = lb2.Text end
                    end
                    if tostring(t or ""):lower():find(nd,1,true) then return d end
                end
            end
        end
    end
end
local function lose()
    if S._loseCache and S._loseCache.Parent and visEl(S._loseCache) then return true end
    S._loseCache = fB("replay")
    return S._loseCache ~= nil
end
local function resetRec()
    S.rec.a={} S.rec.n=1 S.rec.t={} S.rec.k={} S.rec.l=tick()
    S.C.P=0 S.C.U=0 S.C.S=0 rfC()
end
local function setStatus(s)
    if not S.macroStatusLabel or not S.macroStatusLabel.Parent then return end
    local col = MT
    if s=="Recording" then col=Color3.fromRGB(220,96,96)
    elseif s=="Playing" then col=Color3.fromRGB(90,196,140)
    elseif s=="Idle" then col=SB end
    S.macroStatusLabel.Text = "Status: "..s
    pcall(function() TS:Create(S.macroStatusLabel,TweenInfo.new(0.2),{TextColor3=col}):Play() end)
end
local function setCount(n)
    if S.macroCountLabel and S.macroCountLabel.Parent then
        S.macroCountLabel.Text = "Actions: "..tostring(n)
    end
end

local function stopAutoFish()
    S.autoFishEnabled=false S.autoFishSession=S.autoFishSession+1
end
local function startAutoFish()
    if S.shuttingDown or S.autoFishEnabled then return end
    S.autoFishEnabled=true S.autoFishSession=S.autoFishSession+1
    local my = S.autoFishSession
    task.spawn(function()
        while not S.shuttingDown and S.autoFishEnabled and S.autoFishSession==my do
            local ev = getFishingEvent()
            if ev then
                pcall(function() ev:FireServer("Cast",{Position=Vector3.new(-6222.22802734375,16,1338.9178466796875)}) end)
                if not S.autoFishEnabled or S.shuttingDown or S.autoFishSession~=my then break end
                local ct2 = os.time()
                pcall(function() ev:FireServer("LuckHold",{ClickTime=ct2}) end)
                pcall(function() ev:FireServer("LuckRelease",{ClickTime=ct2}) end)
                for i=1,10 do
                    if not S.autoFishEnabled or S.shuttingDown or S.autoFishSession~=my then break end
                    pcall(function() ev:FireServer("Hit",{Index=i}) end)
                end
            end
            task.wait()
        end
    end)
end

local function getVoteEvent()
    if S.voteEvent and S.voteEvent.Parent then return S.voteEvent end
    local ok, direct = pcall(function()
        return game:GetService("ReplicatedStorage").ModeVote.Vote
    end)
    if ok and direct and direct:IsA("RemoteEvent") then
        S.voteEvent = direct
        return direct
    end
    local mv = RS:FindFirstChild("ModeVote")
    if not mv then return nil end
    local ev = mv:FindFirstChild("Vote")
    if ev and ev:IsA("RemoteEvent") then S.voteEvent=ev return ev end
    return nil
end
local function AutoVote(mode)
    local Event = getVoteEvent()
    if not Event then return false end
    return pcall(function() Event:FireServer(mode) end)
end
local function startAutoVote()
    if S.shuttingDown or S.voteActive then return end
    S.voteActive=true S.voteSession=S.voteSession+1
    local my = S.voteSession
    task.spawn(function()
        while not S.shuttingDown and S.voteActive and S.voteSession==my do
            AutoVote(S.voteModes[S.voteIdx])
            task.wait(3)
        end
    end)
end
local function stopAutoVote()
    S.voteActive=false S.voteSession=S.voteSession+1
end

local function applyGameSpeed(valStr)
    local n = tonumber(valStr)
    if not n then return false end
    local ev = ens("g","RemoteEvents","SetGameSpeed")
    if not ev then return false end
    pcall(function() ev:FireServer(n) end)
    return true
end

-- ====== MACRO: stopPlayback (v12) ======
local function stopPlayback()
    S.playbackActive=false
    S.playbackSession=S.playbackSession+1
    setStatus("Idle")
    set("pl",false)
    stopAutoVote()
end

-- ====== MACRO: startPlayback — v12 CONTINUOUS ROUND-TO-ROUND LOOP ======
local function startPlayback()
    if S.shuttingDown then return end
    if S.playbackActive then return end
    S.playbackSession=S.playbackSession+1
    local mySession=S.playbackSession
    S.playbackActive=true
    setStatus("Playing")
    if Cfg.av then startAutoVote() end

    task.spawn(function()
        local function alive()
            return S.playbackActive and S.playbackSession==mySession and not S.shuttingDown
        end

        -- Czy aktualnie trwa runda (nie jesteśmy na ekranie wyniku / replay)?
        local function roundActive()
            local ws=RS:FindFirstChild("WaveState")
            local result=ws and ws:GetAttribute("Result")
            if result=="Win" or result=="Lose" then return false end
            if lose() then return false end
            return true
        end

        -- Czekaj aż obecna runda się skończy, a potem aż zacznie się następna.
        local function waitForNextRound()
            local t0=tick()
            while alive() and roundActive() and tick()-t0<180 do
                task.wait(0.5)
            end
            local t1=tick()
            while alive() and not roundActive() and tick()-t1<180 do
                task.wait(0.5)
            end
            if alive() then task.wait(1) end
        end

        -- Pętla ciągła: runda -> runda -> runda ... dopóki toggle ON
        while alive() do
            local data=loadMacro(S.sel)
            if not data or #data==0 then break end

            S.C.P=0 S.C.U=0 S.C.S=0 rfC()
            local P2={t={},k={},i=1}
            local function nf(pos,ctx)
                local tw=workspace:FindFirstChild("Towers")
                if not tw then return nil end
                local bd,b=20,nil
                for _,x in ipairs(tw:GetChildren()) do
                    if not ctx.k[x] then
                        local ok,q=pcall(function() return x:GetPivot().Position end)
                        if ok and q then
                            local d=(q-pos).Magnitude
                            if d<bd then b=x bd=d end
                        end
                    end
                end
                return b
            end

            while alive() and P2.i<=#data do
                local a=data[P2.i]
                if a then
                    if (a.d or 0)>0 then
                        local t0=tick()
                        while tick()-t0<a.d and alive() do task.wait(0.05) end
                    end
                    if alive() then
                        if a.t=="P" then
                            local PL=ens("p","RemoteFunctions","PlaceTower")
                            if PL then
                                local cf=CFrame.new(a.p[1],a.p[2],a.p[3])
                                pcall(function() PL:InvokeServer(a.n,cf) end)
                                S.C.P=S.C.P+1 rfC()
                                local t0=tick()
                                while tick()-t0<2 and alive() do
                                    local inst=nf(cf.Position,P2)
                                    if inst then P2.t[a.i]=inst P2.k[inst]=a.i break end
                                    task.wait(0.05)
                                end
                            end
                        elseif a.t=="U" then
                            local UP=ens("u","RemoteFunctions","UpgradeTower")
                            local inst=P2.t[a.i]
                            if UP and inst and inst.Parent then
                                pcall(function() UP:InvokeServer(inst) end)
                                S.C.U=S.C.U+1 rfC()
                            end
                        elseif a.t=="S" then
                            local SE=ens("s","RemoteFunctions","SellTower")
                            local inst=P2.t[a.i]
                            if SE and inst and inst.Parent then
                                pcall(function() SE:InvokeServer(inst) end)
                                S.C.S=S.C.S+1 rfC()
                                P2.t[a.i]=nil
                                P2.k[inst]=nil
                            end
                        elseif a.t=="W" then
                            local SK=ens("w","RemoteEvents","SkipWaveVote")
                            if SK then pcall(function() SK:FireServer(1) end) end
                        elseif a.t=="G" then
                            applyGameSpeed(a.v)
                        end
                    end
                end
                P2.i=P2.i+1
            end

            if not alive() then break end

            -- Zamiasт wyłączać toggle: poczekaj na kolejną rundę i powtórz.
            waitForNextRound()
        end

        -- Tu trafiamy TYLKO gdy pętla zakończyła się naturalnie (brak macro / shutdown).
        if S.playbackSession==mySession then
            S.playbackActive=false
            S.playbackSession=S.playbackSession+1
            setStatus("Idle")
            set("pl",false)
            if S.pToggle and S.pToggle.GetValue() then
                S.pToggle.SetValue(false)
            end
        end
    end)
end

local function invokeSummon(a)
    local fo = RS:FindFirstChild("RemoteFunctions")
    local ev = fo and fo:FindFirstChild("SummonUnits")
    if not ev or not ev:IsA("RemoteFunction") then return false end
    return pcall(function() ev:InvokeServer(a) end)
end
task.spawn(function()
    while not S.shuttingDown do
        if Cfg.s25 then invokeSummon(25) task.wait(1) else task.wait(0.5) end
    end
end)
task.spawn(function()
    while not S.shuttingDown do
        if Cfg.s10 then invokeSummon(10) task.wait(1) else task.wait(0.5) end
    end
end)
task.spawn(function()
    while not S.shuttingDown do
        if Cfg.s1 then invokeSummon(1) task.wait(1) else task.wait(0.5) end
    end
end)
task.spawn(function()
    while not S.shuttingDown do
        if Cfg.spn then
            local fo = RS:FindFirstChild("RemoteFunctions")
            local ev = fo and fo:FindFirstChild("SpinWheel")
            if ev and ev:IsA("RemoteFunction") then pcall(function() ev:InvokeServer() end) end
            task.wait(0.5)
        else task.wait(0.2) end
    end
end)
task.spawn(function()
    while not S.shuttingDown do
        if Cfg.oc then
            local fo = RS:FindFirstChild("RemoteFunctions")
            local ev = fo and fo:FindFirstChild("OpenCrate")
            if ev and ev:IsA("RemoteFunction") then
                pcall(function() ev:InvokeServer(Cfg.crate or "Free",1) end)
            end
            task.wait(1)
        else task.wait(0.3) end
    end
end)
local function startLB()
    if S.shuttingDown or S.lbLoop then return end
    S.lbLoop=true
    task.spawn(function()
        while not S.shuttingDown and Cfg.lb do
            local tl = RS:FindFirstChild("ReturnToLobby")
            if tl and tl:IsA("RemoteEvent") then pcall(function() tl:FireServer() end) end
            task.wait(1)
        end
        S.lbLoop=false
    end)
end
task.spawn(function()
    local was = false
    while not S.shuttingDown do
        local now = lose()
        if now and not was and S.rec.active then resetRec() setCount(0) end
        was = now
        task.wait(1)
    end
end)
local function getSkipBtn()
    local ok,b = pcall(function() return PG.MainGameUI.UpSide.InfoDop.AutoSkip end)
    return ok and b or nil
end
local function setVis(on)
    pcall(function()
        local b = getSkipBtn()
        if not b then return end
        for _,v in ipairs(b:GetDescendants()) do
            if v:IsA("UIGradient") then
                if v.Name=="AutoOff" then v.Enabled=not on
                elseif v.Name=="AutoOn" then v.Enabled=on end
            end
        end
    end)
end
task.spawn(function()
    while not S.shuttingDown do
        if Cfg.sk then
            local ws = RS:FindFirstChild("WaveState")
            if ws then
                local w = ws:GetAttribute("CurrentWave")
                local c = ws:GetAttribute("CanSkipWave")
                local r = ws:GetAttribute("Result")
                if c==true and r~="Win" and r~="Lose" and S.lastW~=w then
                    S.lastW=w
                    local skR = ens("w","RemoteEvents","SkipWaveVote")
                    if skR then pcall(function() skR:FireServer(w) end) end
                end
            end
        end
        task.wait(0.5)
    end
end)
local function startRP()
    if S.shuttingDown or S.rpL then return end
    S.rpL=true
    task.spawn(function()
        while not S.shuttingDown and Cfg.rp do
            local re = RS:FindFirstChild("RemoteEvents")
            local rv = re and re:FindFirstChild("ReplayVote")
            if rv then pcall(function() rv:FireServer() end) end
            task.wait(1)
        end
        S.rpL=false
    end)
end

local function refreshHR()
    S.HR.PL = ens("p","RemoteFunctions","PlaceTower")
    S.HR.UP = ens("u","RemoteFunctions","UpgradeTower")
    S.HR.SE = ens("s","RemoteFunctions","SellTower")
    S.HR.SK = ens("w","RemoteEvents","SkipWaveVote")
    S.HR.SP = ens("g","RemoteEvents","SetGameSpeed")
    return S.HR.PL, S.HR.UP, S.HR.SE, S.HR.SK, S.HR.SP
end
refreshHR()
task.spawn(function()
    while not S.shuttingDown do
        if S.rec.active then refreshHR() end
        task.wait(5)
    end
end)

do
    if type(hookmetamethod)=="function" and type(newcclosure)=="function" then
        S.HOOK_MODE="hookmetamethod"
    elseif type(getrawmetatable)=="function" and type(setreadonly)=="function" and type(newcclosure)=="function" then
        S.HOOK_MODE="getrawmetatable"
    end
end
local function findAndClaim(id,cf)
    local t0 = tick()
    while tick()-t0<3 and not S.shuttingDown do
        local tw=workspace:FindFirstChild("Towers")
        if tw then
            local bd,b=20,nil
            for _,xx in ipairs(tw:GetChildren()) do
                if not S.rec.k[xx] then
                    local ok,q=pcall(function() return xx:GetPivot().Position end)
                    if ok and q then
                        local dist=(q-cf.Position).Magnitude
                        if dist<bd then b=xx bd=dist end
                    end
                end
            end
            if b and not S.rec.k[b] then
                S.rec.t[id]=b S.rec.k[b]=id S.rec.lastPlaced=b
                return b
            end
        end
        task.wait(0.05)
    end
end
local function hookBody(self,old,m,args)
    local r = old(self,table.unpack(args))
    S.hookHits=S.hookHits+1
    if m=="InvokeServer" and self==S.HR.PL then
        local n,cf=args[1],args[2]
        if typeof(cf)=="CFrame" then
            S.C.P=S.C.P+1 rfC()
            local id=S.rec.n S.rec.n=id+1
            local tk=tick()
            S.rec.a[#S.rec.a+1]={t="P",n=tostring(n or ""),
                p={cf.Position.X,cf.Position.Y,cf.Position.Z},
                i=id,d=tk-(S.rec.l or tk)}
            S.rec.l=tk
            task.spawn(function() findAndClaim(id,cf) setCount(#S.rec.a) end)
        end
    elseif m=="InvokeServer" and self==S.HR.UP then
        local id=S.rec.k[args[1]]
        if id then
            S.C.U=S.C.U+1 rfC()
            local tk=tick()
            S.rec.a[#S.rec.a+1]={t="U",i=id,d=tk-(S.rec.l or tk)}
            S.rec.l=tk setCount(#S.rec.a)
        end
    elseif m=="InvokeServer" and self==S.HR.SE then
        local inst,id=args[1],S.rec.k[args[1]]
        if id then
            S.C.S=S.C.S+1 rfC()
            local tk=tick()
            S.rec.a[#S.rec.a+1]={t="S",i=id,d=tk-(S.rec.l or tk)}
            S.rec.l=tk S.rec.t[id]=nil S.rec.k[inst]=nil
            setCount(#S.rec.a)
        end
    elseif m=="FireServer" and self==S.HR.SK then
        local tk=tick()
        S.rec.a[#S.rec.a+1]={t="W",d=tk-(S.rec.l or tk)}
        S.rec.l=tk setCount(#S.rec.a)
    elseif m=="FireServer" and self==S.HR.SP then
        local v=tonumber(args[1]) or 1
        local tk=tick()
        S.rec.a[#S.rec.a+1]={t="G",v=v,d=tk-(S.rec.l or tk)}
        S.rec.l=tk setCount(#S.rec.a)
    end
    return r
end
if S.HOOK_MODE=="hookmetamethod" then
    pcall(function()
        local old
        old=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
            if not S.rec.active or S.shuttingDown then return old(self,...) end
            S.hookAll=S.hookAll+1
            if self~=S.HR.PL and self~=S.HR.UP and self~=S.HR.SE and self~=S.HR.SK and self~=S.HR.SP then
                return old(self,...)
            end
            local m=getnamecallmethod and getnamecallmethod() or ""
            return hookBody(self,old,m,{...})
        end))
        S.HOOK_OK=true
    end)
elseif S.HOOK_MODE=="getrawmetatable" then
    pcall(function()
        local mt=getrawmetatable(game)
        local old=mt.__namecall
        S.__hookOld=old
        setreadonly(mt,false)
        mt.__namecall=newcclosure(function(self,...)
            if not S.rec.active or S.shuttingDown then return old(self,...) end
            S.hookAll=S.hookAll+1
            if self~=S.HR.PL and self~=S.HR.UP and self~=S.HR.SE and self~=S.HR.SK and self~=S.HR.SP then
                return old(self,...)
            end
            local m=getnamecallmethod and getnamecallmethod() or ""
            return hookBody(self,old,m,{...})
        end)
        setreadonly(mt,true)
        S.HOOK_OK=true
    end)
end
if S.HOOK_OK then print("[EZVC] Hook mode: "..S.HOOK_MODE)
else print("[EZVC] No hooking API - passive mode") end
print("[EZVC] Remotes: PL="..tostring(S.HR.PL~=nil).." UP="..tostring(S.HR.UP~=nil)..
      " SE="..tostring(S.HR.SE~=nil).." SK="..tostring(S.HR.SK~=nil).." SP="..tostring(S.HR.SP~=nil))

local function clearPassive()
    for _,c in ipairs(S.passiveConns) do pcall(function() c:Disconnect() end) end
    S.passiveConns={}
end
local function getTowerName(t)
    for _,a in ipairs({"UnitName","TowerName","Type","Unit","UnitType","Tower"}) do
        local v=t:GetAttribute(a)
        if type(v)=="string" and v~="" then return v end
    end
    for _,c in ipairs(t:GetChildren()) do
        if c:IsA("StringValue") and (c.Name:lower():find("type") or c.Name:lower():find("name")) then
            if c.Value~="" then return c.Value end
        end
    end
    return t.Name
end
local function watchTower(tower,id)
    local a_=tower.AttributeChanged:Connect(function(attr)
        if not S.rec.active or S.shuttingDown then return end
        local l=attr:lower()
        if l=="level" or l=="tier" or l=="upgrade" or l=="rank" or l=="upgraded" then
            S.C.U=S.C.U+1 rfC()
            local tk=tick()
            S.rec.a[#S.rec.a+1]={t="U",i=id,d=tk-(S.rec.l or tk)}
            S.rec.l=tk setCount(#S.rec.a)
        end
    end)
    S.passiveConns[#S.passiveConns+1]=a_
    local dc=tower.Destroying:Connect(function()
        if not S.rec.active or S.shuttingDown then return end
        if S.rec.k[tower]~=id then return end
        if lose() then return end
        S.C.S=S.C.S+1 rfC()
        local tk=tick()
        S.rec.a[#S.rec.a+1]={t="S",i=id,d=tk-(S.rec.l or tk)}
        S.rec.l=tk S.rec.t[id]=nil S.rec.k[tower]=nil
        setCount(#S.rec.a)
    end)
    S.passiveConns[#S.passiveConns+1]=dc
end
local function onTowerAdded(tower)
    if not S.rec.active or S.shuttingDown then return end
    if S.knownTowers[tower] then return end
    S.knownTowers[tower]=true
    local ok,cf=pcall(function() return tower:GetPivot() end)
    if not ok or not cf then return end
    S.C.P=S.C.P+1 rfC()
    local id=S.rec.n S.rec.n=id+1
    local tk=tick()
    S.rec.t[id]=tower S.rec.k[tower]=id S.rec.lastPlaced=tower
    S.rec.a[#S.rec.a+1]={t="P",n=getTowerName(tower),
        p={cf.Position.X,cf.Position.Y,cf.Position.Z},i=id,d=tk-(S.rec.l or tk)}
    S.rec.l=tk setCount(#S.rec.a)
    watchTower(tower,id)
end
local function attachPassive()
    local tw=workspace:FindFirstChild("Towers")
    if tw then
        for _,t in ipairs(tw:GetChildren()) do S.knownTowers[t]=true end
        S.passiveConns[#S.passiveConns+1]=tw.ChildAdded:Connect(onTowerAdded)
    else
        local wc
        wc=workspace.ChildAdded:Connect(function(child)
            if S.shuttingDown then return end
            if child.Name=="Towers" then
                if wc then wc:Disconnect() end
                for _,t in ipairs(child:GetChildren()) do S.knownTowers[t]=true end
                S.passiveConns[#S.passiveConns+1]=child.ChildAdded:Connect(onTowerAdded)
            end
        end)
        S.passiveConns[#S.passiveConns+1]=wc
    end
end
local function startPassive()
    S.knownTowers={}
    clearPassive()
    attachPassive()
end

local function buildPages()
    -- MAIN
    local mP = pg("Main")
    local c1 = cd(mP,"Statistics",12) c1.Size=UDim2.new(1,-24,0,84)
    lb(c1,"Place",12,30,80,12,SB,9,false)
    lb(c1,"Upgrade",112,30,80,12,SB,9,false)
    lb(c1,"Sell",212,30,80,12,SB,9,false)
    local _pL = lb(c1,"0",12,44,80,20,TX,16,true)
    local _uL = lb(c1,"0",112,44,80,20,TX,16,true)
    local _sL = lb(c1,"0",212,44,80,20,TX,16,true)
    local prev = rfC
    rfC = function()
        prev()
        pcall(function()
            _pL.Text=tostring(S.C.P) _uL.Text=tostring(S.C.U) _sL.Text=tostring(S.C.S)
        end)
    end

    local c2 = cd(mP,"Automation",104) c2.Size=UDim2.new(1,-24,0,340)
    local s25T, s10T, s1T
    s25T = tg(c2,"Auto Summon 25","Summon 25 units/s",12,26,240,38,Cfg.s25,function(on)
        set("s25",on)
        if on then
            if s10T then s10T.SetValue(false) set("s10",false) end
            if s1T  then s1T.SetValue(false)  set("s1",false)  end
        end
    end)
    s10T = tg(c2,"Auto Summon 10","Summon 10 units/s",12,70,240,38,Cfg.s10,function(on)
        set("s10",on)
        if on then
            if s25T then s25T.SetValue(false) set("s25",false) end
            if s1T  then s1T.SetValue(false)  set("s1",false)  end
        end
    end)
    s1T  = tg(c2,"Auto Summon 1","Summon 1 unit/s",12,114,240,38,Cfg.s1,function(on)
        set("s1",on)
        if on then
            if s25T then s25T.SetValue(false) set("s25",false) end
            if s10T then s10T.SetValue(false) set("s10",false) end
        end
    end)
    tg(c2,"Auto Spin","Spin wheel automatically",12,158,240,38,Cfg.spn,function(on) set("spn",on) end)
    tg(c2,"Auto Open Crate","Open selected crate/s",12,202,240,38,Cfg.oc,function(on) set("oc",on) end)
    tg(c2,"Auto Fish","Automatic fishing cycle",12,246,240,38,false,function(on)
        if on then startAutoFish() if not S.autoFishEnabled then N("EZVC","FishingEvent not found") end
        else stopAutoFish() end
    end)
    local crateOpts = {"Free","ScientistCrate","PartyCrate"}
    local crateIdx = 1
    for i,v in ipairs(crateOpts) do if v==Cfg.crate then crateIdx=i end end
    local crateLbl = mk("TextButton",{Size=UDim2.new(1,-24,0,26),Position=UDim2.new(0,12,0,290),
        BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=TX,Text="Crate: "..(Cfg.crate or "Free"),AutoButtonColor=false,
        TextXAlignment=Enum.TextXAlignment.Left},c2)
    cr(crateLbl,5)
    ac(crateLbl.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        crateIdx = crateIdx%#crateOpts+1
        Cfg.crate = crateOpts[crateIdx]
        set("crate",Cfg.crate)
        crateLbl.Text = "Crate: "..Cfg.crate
        N("EZVC","Crate: "..Cfg.crate)
    end))

    -- PLAY
    local pP = pg("Play")
    local avc = cd(pP,"Auto Vote",12) avc.Size=UDim2.new(1,-24,0,116)
    lb(avc,"Vote mode (applies while Auto Vote is ON)",12,26,240,12,SB,9,false)
    S.avToggle = tg(avc,"Auto Vote","Vote every 3s",12,42,240,38,Cfg.av,function(on)
        set("av",on)
        if on then startAutoVote() else stopAutoVote() end
    end)
    local voteLbl = mk("TextButton",{Size=UDim2.new(1,-24,0,26),Position=UDim2.new(0,12,0,86),
        BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=TX,Text="Mode: "..S.voteModes[S.voteIdx],AutoButtonColor=false,
        TextXAlignment=Enum.TextXAlignment.Left},avc)
    cr(voteLbl,5)
    ac(voteLbl.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        S.voteIdx = S.voteIdx%#S.voteModes+1
        Cfg.avm = S.voteModes[S.voteIdx]
        set("avm",Cfg.avm)
        voteLbl.Text = "Mode: "..Cfg.avm
        N("EZVC","Vote mode: "..Cfg.avm)
    end))

    local pc = cd(pP,"Game Speed",136) pc.Size=UDim2.new(1,-24,0,60)
    lb(pc,"Speed (1 / 1.5 / 2 / 2.5 / 3)",12,20,200,16,SB,10,false)
    local gsLbl = mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,38),
        BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,
        TextColor3=TX,Text="x"..S.gsOpts[S.gsIdx],AutoButtonColor=false},pc)
    cr(gsLbl,5)
    ac(gsLbl.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        S.gsIdx = S.gsIdx%#S.gsOpts+1
        Cfg.gs = S.gsOpts[S.gsIdx]
        set("gs",Cfg.gs)
        gsLbl.Text = "x"..Cfg.gs
        local ok = applyGameSpeed(Cfg.gs)
        if ok then N("EZVC","Game Speed: x"..Cfg.gs)
        else N("EZVC","SetGameSpeed not found") end
    end))

    local pc2 = cd(pP,"Toggles",204) pc2.Size=UDim2.new(1,-24,0,170)
    tg(pc2,"Auto Skip Wave","Skip waves automatically",12,26,240,38,Cfg.sk,function(on)
        set("sk",on)
        if on then S.lastW=nil setVis(true) else setVis(false) end
    end)
    tg(pc2,"Auto Replay","Vote replay on round end",12,70,240,38,Cfg.rp,function(on)
        set("rp",on) if on then startRP() else S.rpL=false end
    end)
    tg(pc2,"Auto Lobby","Return to lobby automatically",12,114,240,38,Cfg.lb,function(on)
        set("lb",on) if on then startLB() else S.lbLoop=false end
    end)

    -- MACRO
    local mP2 = pg("Macro")
    local rc = cd(mP2,"Macro Name",12) rc.Size=UDim2.new(1,-24,0,56)
    lb(rc,"Name",12,26,50,24,SB,11,false)
    local mnBox = mk("TextBox",{Size=UDim2.new(1,-80,0,26),Position=UDim2.new(0,64,0,20),
        BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=TX,PlaceholderText="e.g. EasyFarm",PlaceholderColor3=MT,
        Text=Cfg.mn or "",ClearTextOnFocus=false},rc)
    cr(mnBox,5)
    ac(mnBox.FocusLost:Connect(function() if S.shuttingDown then return end set("mn",mnBox.Text or "") end))
    local rc2 = cd(mP2,"Macro Actions",76) rc2.Size=UDim2.new(1,-24,0,300)
    S.macroStatusLabel = lb(rc2,"Status: Idle",12,26,110,14,SB,10,true)
    S.macroCountLabel  = lb(rc2,"Actions: 0",124,26,100,14,MT,10,false)
    lb(rc2,"STATISTICS",12,48,120,12,SB,9,true)
    local statPlace   = lb(rc2,"Place: 0",12,64,90,16,TX,11,true)
    local statUpgrade = lb(rc2,"Upgrade: 0",102,64,90,16,TX,11,true)
    local statSell    = lb(rc2,"Sell: 0",192,64,90,16,TX,11,true)
    local prev2 = rfC
    rfC = function()
        prev2()
        pcall(function()
            statPlace.Text="Place: "..tostring(S.C.P)
            statUpgrade.Text="Upgrade: "..tostring(S.C.U)
            statSell.Text="Sell: "..tostring(S.C.S)
        end)
    end
    local macroList = lf()
    local macroIdx = 0
    for i,v in ipairs(macroList) do if v==Cfg.sel then macroIdx=i end end
    local macroLbl = mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,90),
        BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=TX,Text=Cfg.sel~="" and Cfg.sel or "-- select macro --",AutoButtonColor=false},rc2)
    cr(macroLbl,5)
    local function refreshMacroLbl()
        macroList = lf() macroIdx = 0
        for i,v in ipairs(macroList) do if v==Cfg.sel then macroIdx=i end end
        macroLbl.Text = Cfg.sel~="" and Cfg.sel or "-- select macro --"
        if S._refreshShareSelect then S._refreshShareSelect() end
    end
    ac(macroLbl.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        macroList = lf()
        if #macroList==0 then N("EZVC","No saved macros") return end
        macroIdx = macroIdx%#macroList+1
        local chosen = macroList[macroIdx]
        macroLbl.Text = chosen S.sel = chosen set("sel",chosen)
        print("[EZVC] Selected macro: "..chosen)
        if S._refreshShareSelect then S._refreshShareSelect() end
    end))
    btn(rc2,"Create / Save Macro",12,126,240,28,"p",function()
        local n = mnBox.Text or ""
        if n=="" then N("EZVC","Enter a macro name") return end
        pcall(function()
            if type(isfile)~="function" or not isfile(FO..n..".json") then wj(FO..n..".json",{}) end
        end)
        S.sel=n Cfg.sel=n set("sel",n) refreshMacroLbl()
        print("[EZVC] Macro created/selected: "..n)
        N("EZVC","Macro ready: "..n.." (record now)")
    end)
    S.rToggle = tg(rc2,"Record Macro","Start/stop recording",12,162,240,38,false,function(on)
        if on then
            if S.rec.active then N("EZVC","Already recording") S.rToggle.SetValue(true) return end
            if S.playbackActive then N("EZVC","Stop playback first") S.rToggle.SetValue(false) return end
            if Cfg.sel=="" then N("EZVC","Select a macro first") S.rToggle.SetValue(false) return end
            set("rec",true) refreshHR() resetRec() setCount(0)
            S.hookHits=0 S.hookAll=0 S.rec.active=true setStatus("Recording")
            if not S.HOOK_OK then startPassive() end
            print("[EZVC] Recording started -> "..Cfg.sel.." mode="..S.HOOK_MODE)
            N("EZVC","Recording -> "..Cfg.sel..(S.HOOK_OK and "" or " (passive)"))
        else
            if not S.rec.active then set("rec",false) setStatus("Idle") return end
            S.rec.active=false set("rec",false)
            if not S.HOOK_OK then clearPassive() end
            print("[EZVC] Recording stop | actions="..#S.rec.a.." hooks="..S.hookHits.." all="..S.hookAll)
            if #S.rec.a>0 and Cfg.sel~="" then
                local ok,err = wj(FO..Cfg.sel..".json",S.rec.a)
                if ok then
                    print("[EZVC] Recording saved: "..#S.rec.a.." actions")
                    N("EZVC","Saved "..#S.rec.a.." steps")
                else
                    warn("[EZVC] Save failed: "..tostring(err))
                    N("EZVC","Save failed")
                end
            else
                local diag
                if S.HOOK_OK then diag="hook="..S.HOOK_MODE.." hits="..S.hookHits.." all="..S.hookAll
                else diag="passive, no towers detected" end
                N("EZVC","Nothing saved ("..diag..")")
                warn("[EZVC] "..diag)
            end
            resetRec() setCount(0) setStatus("Idle")
        end
    end)
    -- v12 Play callback (continuous loop)
    S.pToggle = tg(rc2,"Play Macro","Playback recorded macro",12,206,240,38,Cfg.pl,function(on)
        if on then
            if S.rec.active then
                N("EZVC","Stop recording first")
                S.pToggle.SetValue(false)
                return
            end
            if Cfg.sel=="" then
                N("EZVC","Select a macro first")
                S.pToggle.SetValue(false)
                return
            end
            set("pl",true)
            startPlayback()
            if not S.playbackActive then
                set("pl",false)
                S.pToggle.SetValue(false)
            end
        else
            stopPlayback()
        end
    end)
    btn(rc2,"Delete Macro",12,252,240,28,"d",function()
        if Cfg.sel=="" then N("EZVC","Select a macro") return end
        pcall(function()
            if type(delfile)=="function" then delfile(FO..Cfg.sel..".json") end
        end)
        S.sel="" set("sel","") refreshMacroLbl()
        N("EZVC","Deleted")
    end)

    -- SHARE
    local sP = pg("Share")
    local sc1 = cd(sP,"Export",12) sc1.Size=UDim2.new(1,-24,0,120)
    lb(sc1,"Select Macro to Export",12,26,200,14,SB,10,false)
    local exportSelect = mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,42),
        BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=TX,Text="  "..(S.sel~="" and S.sel or "-- select --"),
        AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},sc1)
    cr(exportSelect,5)
    ac(exportSelect.MouseEnter:Connect(function() if S.shuttingDown then return end
        TS:Create(exportSelect,TweenInfo.new(0.14),{BackgroundColor3=BG:Lerp(Color3.new(1,1,1),0.1)}):Play() end))
    ac(exportSelect.MouseLeave:Connect(function() if S.shuttingDown then return end
        TS:Create(exportSelect,TweenInfo.new(0.14),{BackgroundColor3=BG}):Play() end))
    ac(exportSelect.MouseButton1Click:Connect(function()
        if S.shuttingDown then return end
        local list = lf()
        if #list==0 then N("EZVC","No saved macros") return end
        local idx = 0
        for i,v in ipairs(list) do if v==S.sel then idx=i end end
        idx = idx%#list+1 S.sel = list[idx] set("sel",S.sel)
        exportSelect.Text = "  "..S.sel
        if S._refreshShareSelect then S._refreshShareSelect() end
    end))
    local copyBtn = btn(sc1,"Copy Macro",12,80,240,28,"p")
    ac(copyBtn.MouseButton1Click:Connect(function()
        if S.sel=="" then N("EZVC","Select a macro first") return end
        local data = loadMacro(S.sel)
        if not data or #data==0 then N("EZVC","Macro is empty or invalid") return end
        local payload = {Name=S.sel,Actions=data}
        local ok,json = pcall(function() return HS:JSONEncode(payload) end)
        if not ok or type(json)~="string" or #json<5 then N("EZVC","Failed to generate macro JSON.") return end
        local fn = S.CLIP_FN
        if not fn then N("EZVC","Clipboard function is not available in this runtime.") return end
        local cok,cerr = pcall(fn,json)
        if not cok then N("EZVC","Clipboard error: "..tostring(cerr)) return end
        N("EZVC","Macro copied to clipboard.")
    end))
    local sc2 = cd(sP,"Import",148) sc2.Size=UDim2.new(1,-24,0,244)
    lb(sc2,"Paste macro JSON",12,26,200,14,SB,10,false)
    local importBox = mk("TextBox",{Size=UDim2.new(1,-24,0,60),Position=UDim2.new(0,12,0,44),
        BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=10,
        TextColor3=TX,Text="",PlaceholderText='Paste JSON here e.g. {"Name":"...","Actions":[...]}',
        PlaceholderColor3=MT,ClearTextOnFocus=false,TextWrapped=true,MultiLine=true,
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},sc2)
    cr(importBox,5)
    lb(sc2,"Macro name (optional override)",12,112,220,14,SB,10,false)
    local importName = mk("TextBox",{Size=UDim2.new(1,-24,0,26),Position=UDim2.new(0,12,0,128),
        BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=TX,Text="",PlaceholderText="Auto-filled from JSON or enter name",
        PlaceholderColor3=MT,ClearTextOnFocus=false},sc2)
    cr(importName,5)
    local pendingImport = nil
    local importBtn = btn(sc2,"Import Macro",12,162,240,28,"p")
    local saveImportBtn = btn(sc2,"Save Imported Macro",12,198,240,28)
    ac(importBtn.MouseButton1Click:Connect(function()
        local raw = importBox.Text or ""
        if #raw<2 then N("EZVC","Paste macro JSON first") return end
        if raw:sub(1,5)=="EZVC:" then raw=raw:sub(6) end
        raw = raw:match("^%s*(.-)%s*$") or raw
        local ok,decoded = pcall(function() return HS:JSONDecode(raw) end)
        if not ok or type(decoded)~="table" then
            pendingImport=nil N("EZVC","Invalid macro JSON.") return
        end
        local actions,importedName
        if type(decoded.Actions)=="table" then
            actions = decoded.Actions importedName = decoded.Name
        elseif decoded[1]~=nil then actions = decoded
        else pendingImport=nil N("EZVC","Invalid macro data.") return end
        local clean = {}
        for _,a in ipairs(actions) do
            local s = sanitizeAction(a)
            if s then clean[#clean+1]=s end
        end
        if #clean==0 then pendingImport=nil N("EZVC","Invalid macro data.") return end
        pendingImport = clean
        if type(importedName)=="string" and importedName~="" and (importName.Text or "")=="" then
            importName.Text = importedName
        end
        N("EZVC","Parsed "..#clean.." actions.")
    end))
    ac(saveImportBtn.MouseButton1Click:Connect(function()
        if not pendingImport then N("EZVC","Click Import first") return end
        local name = (importName.Text or ""):match("^%s*(.-)%s*$")
        if name=="" then N("EZVC","Enter a macro name") return end
        if type(writefile)~="function" then N("EZVC","writefile not supported") return end
        local ok,err = wj(FO..name..".json",pendingImport)
        if ok then
            S.sel=name set("sel",name) refreshMacroLbl()
            pendingImport=nil importBox.Text="" importName.Text=""
            N("EZVC","Saved: "..name)
        else N("EZVC","Save failed: "..tostring(err)) end
    end))
    S._refreshShareSelect = function()
        if exportSelect and exportSelect.Parent then
            exportSelect.Text = "  "..(S.sel~="" and S.sel or "-- select --")
        end
    end
    S._refreshShareSelect()

    -- GUI / THEME
    local gP = pg("GUI")
    local th = cd(gP,"Theme",12) th.Size=UDim2.new(1,-24,0,180)
    local themes = {
        {n="Purple",c=Color3.fromRGB(155,120,255)},
        {n="Red",   c=Color3.fromRGB(220,96,96)},
        {n="Blue",  c=Color3.fromRGB(108,142,255)},
        {n="Green", c=Color3.fromRGB(90,196,140)},
        {n="Orange",c=Color3.fromRGB(240,150,60)},
        {n="Pink",  c=Color3.fromRGB(230,120,180)},
        {n="Cyan",  c=Color3.fromRGB(0,200,220)},
        {n="Yellow",c=Color3.fromRGB(230,200,90)},
    }
    local themeEntries = {}
    local function isSame(a,b)
        return math.abs(a.R-b.R)<0.01 and math.abs(a.G-b.G)<0.01 and math.abs(a.B-b.B)<0.01
    end
    local function syncThemeSel()
        for _,e in ipairs(themeEntries) do
            if not e.str or not e.str.Parent then break end
            local isSel = isSame(e.c,AC)
            TS:Create(e.str,TweenInfo.new(0.25,Enum.EasingStyle.Quart),
                {Transparency=isSel and 0 or 0.85,Color=e.c}):Play()
        end
    end
    _syncThemeUI = syncThemeSel
    for i,t in ipairs(themes) do
        local col = (i-1)%2
        local row = math.floor((i-1)/2)
        local px = (col==0) and UDim2.new(0,12,0,30+row*34) or UDim2.new(0.5,6,0,30+row*34)
        local b = mk("TextButton",{Size=UDim2.new(0.5,-18,0,28),Position=px,
            BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,
            TextColor3=TX,Text="  "..t.n,AutoButtonColor=false,
            TextXAlignment=Enum.TextXAlignment.Left},th)
        cr(b,6)
        local str = sk(b,t.c,0.85)
        local dot = mk("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-22,0.5,-7),
            BackgroundColor3=t.c,BorderSizePixel=0},b)
        cr(dot,7)
        themeEntries[#themeEntries+1]={btn=b,str=str,c=t.c}
    end
    for _,e in ipairs(themeEntries) do
        ac(e.btn.MouseButton1Click:Connect(function()
            if S.shuttingDown then return end
            setAC(e.c)
            set("acr",math.floor(e.c.R*255+0.5))
            set("acg",math.floor(e.c.G*255+0.5))
            set("acb",math.floor(e.c.B*255+0.5))
            syncThemeSel()
        end))
    end
    syncThemeSel()

    local ut = cd(gP,"Utility",204) ut.Size=UDim2.new(1,-24,0,70)
    local function applyAFK(on)
        if S.afkConn then pcall(function() S.afkConn:Disconnect() end) S.afkConn=nil end
        if on and not S.shuttingDown then
            S.afkConn = PLR.Idled:Connect(function()
                if S.shuttingDown then return end
                pcall(function()
                    VU:CaptureController()
                    VU:ClickButton2(Vector2.new())
                end)
            end)
        end
    end
    tg(ut,"Anti AFK","Prevents idle kick",12,26,240,38,Cfg.afk,function(on)
        set("afk",on) applyAFK(on)
    end)
    S._applyAFK = applyAFK
end

do
    if type(setclipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=setclipboard,"setclipboard"
    elseif type(toclipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=toclipboard,"toclipboard"
    elseif type(writeclipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=writeclipboard,"writeclipboard"
    elseif type(set_clipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=set_clipboard,"set_clipboard"
    elseif type(getgenv)=="function" then
        local ok,env = pcall(getgenv)
        if ok and type(env)=="table" then
            if type(env.setclipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=env.setclipboard,"getgenv.setclipboard"
            elseif type(env.toclipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=env.toclipboard,"getgenv.toclipboard"
            elseif type(env.writeclipboard)=="function" then S.CLIP_FN,S.CLIP_NAME=env.writeclipboard,"getgenv.writeclipboard" end
        end
    end
end

buildPages()
go("Main")
rfC()

S._init = false
task.spawn(function()
    task.wait(1.5)
    if S.shuttingDown then return end
    instantApply()
    if Cfg.gs then
        local ok = applyGameSpeed(Cfg.gs)
        if not ok then warn("[EZVC] SetGameSpeed remote not found") end
    end
    if Cfg.sk then S.lastW=nil setVis(true) end
    if Cfg.rp then startRP() end
    if Cfg.lb then startLB() end
    if Cfg.afk and S._applyAFK then S._applyAFK(true) end
    if S.avToggle then S.avToggle.SetValue(Cfg.av and true or false) end
    if Cfg.av then startAutoVote() end
    if Cfg.rec and Cfg.sel~="" then
        refreshHR() resetRec() setCount(0) S.hookHits=0 S.hookAll=0 S.rec.active=true
        setStatus("Recording")
        if not S.HOOK_OK then startPassive() end
        if S.rToggle then S.rToggle.SetValue(true) end
    elseif Cfg.rec then
        Cfg.rec=false save() setStatus("Idle")
        if S.rToggle then S.rToggle.SetValue(false) end
    end
    if Cfg.pl and Cfg.sel~="" then
        local checkData = loadMacro(Cfg.sel)
        if checkData and #checkData>0 then
            if S.pToggle then S.pToggle.SetValue(true) end
            startPlayback()
            print("[EZVC] Auto-resumed Play (continuous) -> "..Cfg.sel)
            N("EZVC","Resumed Play -> "..Cfg.sel)
        else
            Cfg.pl=false save()
            if S.pToggle then S.pToggle.SetValue(false) end
        end
    else
        Cfg.pl=false save()
        if S.pToggle then S.pToggle.SetValue(false) end
    end
    if S.CLIP_FN then
        print("[EZVC] Clipboard available: "..tostring(S.CLIP_NAME))
    else
        print("[EZVC] WARNING: no clipboard function found")
    end
end)

N("EZVC","Ready v2.20")
print("[EZVC] v2.20 loaded | mode="..(S.HOOK_OK and S.HOOK_MODE or "passive")..
      " | clipboard="..tostring(S.CLIP_NAME or "none"))