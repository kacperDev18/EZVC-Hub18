local lllllIIl=math.floor local llIIIlll=math.abs local lIllllIl=math.clamp
local lIIllIll=tostring local lIlllIll=type local lllIlllI=pcall
local _jnk1=function(x,y) return x*1+y*0 end
local _jnk2=function(t) local r=0 for i=1,0 do r=r+1 end return r end
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("ReplicatedStorage")
local HS=game:GetService("HttpService")
local VU=game:GetService("VirtualUser")
local PLR=game:GetService("Players").LocalPlayer
local PG=PLR:FindFirstChild("PlayerGui") or PLR:WaitForChild("PlayerGui")
local Conns={}
local function lII1I11IlI(c) Conns[#Conns+1]=c return c end
local function llIlI11Il11()
for _,c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
Conns={}
end
local lll1II1l1=false
local ll1Il1Ill=false
local ll11l1ll=false
local lllllI1l=0
local pToggle,rToggle
local rec={a={},n=1,t={},k={},l=0,active=false,lastPlaced=nil}
local sel=""
local C={P=0,U=0,S=0}
local lI11llI,lIIlIIIl
local l1111Il={}
local ll1I11IIll={}
local llII1Il1=false
local lIlI1lll=0
local l11l1lII=Vector3.new(-6222.22802734375, 16, 1338.9178466796875)
local ll11lll11ll=nil
local FO="tdmacro/"
local CF=FO.."config.json"
pcall(function()
if type(isfolder)=="function" and type(makefolder)=="function" and not isfolder(FO) then
makefolder(FO)
end
end)
local function lI1lI11(p,d)
if type(writefile)~="function" then return false end
local ok,s=pcall(function() return HS:JSONEncode(d) end)
if not ok then return false end
return pcall(writefile,p,s)
end
local function lI1I111l(p)
if type(isfile)~="function" or type(readfile)~="function" or not isfile(p) then return nil end
local ok,d=pcall(readfile,p)
if not ok then return nil end
local ok2,a=pcall(function() return HS:JSONDecode(d) end)
if not ok2 or type(a)~="table" then return nil end
return a
end
local function lII11Il11()
if type(listfiles)~="function" then return {} end
local seen,n={},{}
for _,p in ipairs({FO,"tdmacro","./tdmacro/"}) do
local ok,list=pcall(listfiles,p)
if ok and type(list)=="table" then
for _,f in ipairs(list) do
local x=tostring(f):match("([^/\\]+)%.json$")
if x and x~="state" and x~="config" and not seen[x] then
seen[x]=true n[#n+1]=x
end
end
end
end
return n
end
local function l1ll11lII(a)
if type(a)~="table" then return nil end
a.Method=nil a.method=nil
if a.t~="P" and a.t~="U" and a.t~="S" and a.t~="W" and a.t~="G" then return nil end
return a
end
local function l1llI111(name)
if not name or name=="" then return nil end
local data=lI1I111l(FO..name..".json")
if type(data)~="table" then return nil end
local clean={}
for _,a in ipairs(data) do
local s=l1ll11lII(a)
if s then clean[#clean+1]=s end
end
return clean
end
local Cfg={}
do
local c=lI1I111l(CF)
if type(c)=="table" then Cfg=c end
end
for k,v in pairs({gs="1",mn="",sel="",lll1I1ll=false,rp=false,l11Il11=false,rec=false,pl=false,s10=false,s1=false,spn=false,afk=false,oc=false,crate="Free",acr=155,acg=120,acb=255}) do
if Cfg[k]==nil then Cfg[k]=v end
end
Cfg.pl=false
sel=Cfg.sel or ""
local _init=true
local _pend=false
local function l1ll1l1I()
if lll1II1l1 then return end
if _init or _pend then return end
_pend=true
task.spawn(function()
task.wait(0.2)
_pend=false
if not lll1II1l1 then pcall(function() lI1lI11(CF,Cfg) end) end
end)
end
local function llI1lI11(k,v)
if lll1II1l1 then return end
Cfg[k]=v
l1ll1l1I()
end
local BG=Color3.fromRGB(16,16,20)
local SF=Color3.fromRGB(22,22,27)
local HD=Color3.fromRGB(26,26,32)
local PN=Color3.fromRGB(30,30,36)
local EL=Color3.fromRGB(38,38,45)
local BR=Color3.fromRGB(52,52,60)
local TX=Color3.fromRGB(238,238,244)
local SB=Color3.fromRGB(150,150,162)
local MT=Color3.fromRGB(98,98,110)
local OFF=Color3.fromRGB(52,52,60)
local AC=Color3.fromRGB(tonumber(Cfg.acr) or 155, tonumber(Cfg.acg) or 120, tonumber(Cfg.acb) or 255)
local par
pcall(function() if gethui then local ok,h=pcall(gethui) if ok and h then par=h end end end)
par=par or game:GetService("CoreGui")
for _,v in ipairs(par:GetChildren()) do
if v.Name=="EZVCProto" then pcall(function() v:Destroy() end) end
end
local sg=Instance.new("ScreenGui")
sg.Name="EZVCProto"
sg.IgnoreGuiInset=true
sg.ResetOnSpawn=false
sg.DisplayOrder=0x3E7
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.Parent=par
local function llII1lII11(c,p,r)
local o=Instance.new(c)
for k,v in next,p do o[k]=v end
if r then o.Parent=r end
return o
end
local function lllII1Il1(o,r) llII1lII11("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function lll1I1ll(o,c,t) return llII1lII11("UIStroke",{Color=c,Thickness=1,Transparency=t},o) end
local function l11Il11(p,t,x,y,w,h,c,s,b)
return llII1lII11("TextLabel",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundTransparency=1,Font=b and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=s or 11,TextColor3=c,TextXAlignment=Enum.TextXAlignment.Left,Text=t},p)
end
local lI1I1Il1={}
local function llI1l11I(p,f,prop)
lI1I1Il1[#lI1I1Il1+1]={p=p,f=f,prop=prop or "BackgroundColor3"}
return p
end
local function ll1I1IIlII(c)
AC=c
for i=#lI1I1Il1,1,-1 do
local e=lI1I1Il1[i]
if not e.p or not e.p.Parent then
table.remove(lI1I1Il1,i)
else
local v=e.f and e.f() or c
pcall(function()
TS:Create(e.p,TweenInfo.new(0.28,Enum.EasingStyle.Quart),{[e.prop]=v}):Play()
end)
end
end
end
local function ll1I111l()
for _,e in ipairs(lI1I1Il1) do
if e.p and e.p.Parent then
local v=e.f and e.f() or AC
pcall(function() e.p[e.prop]=v end)
end
end
end
local win=llII1lII11("Frame",{Size=UDim2.fromOffset(0x1A4,0x12C),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=BG,BorderSizePixel=0},sg)
lllII1Il1(win,12)
local wS=lll1I1ll(win,BR,0.35)
local function ll1IllI()
if lll1II1l1 then return end
pcall(function()
local cam=workspace.CurrentCamera
if not cam then return end
local vp=cam.ViewportSize
if vp.X<=0 or vp.Y<=0 then return end
win.Size=UDim2.fromOffset(math.clamp(math.floor(vp.X*0.92),300,460),math.clamp(math.floor(vp.Y*0.78),260,340))
win.Position=UDim2.new(0.5,0,0.5,0)
end)
end
ll1IllI()
pcall(function() lII1I11IlI(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ll1IllI)) end)
local hdr=llII1lII11("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=HD,BorderSizePixel=0},win)
lllII1Il1(hdr,12)
llII1lII11("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=HD,BorderSizePixel=0},hdr)
local aDot=llII1lII11("Frame",{Size=UDim2.fromOffset(10,10),Position=UDim2.new(0,14,0.5,-5),BackgroundColor3=AC,BorderSizePixel=0},hdr)
lllII1Il1(aDot,3)
llI1l11I(aDot)
l11Il11(hdr,"EZVC Hub",30,0,120,38,TX,13,true)
l11Il11(hdr,"v2.9",92,0,90,38,MT,9,false)
local xb=llII1lII11("TextButton",{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-30,0.5,-12),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=SB,Text="X",AutoButtonColor=false},hdr)
lllII1Il1(xb,6)
lII1I11IlI(xb.MouseEnter:Connect(function() if lll1II1l1 then return end TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,90,90),TextColor3=Color3.new(1,1,1)}):Play() end))
lII1I11IlI(xb.MouseLeave:Connect(function() if lll1II1l1 then return end TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=EL,TextColor3=SB}):Play() end))
local dg,d0,d1=false,nil,nil
lII1I11IlI(hdr.InputBegan:Connect(function(i)
if lll1II1l1 then return end
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dg=true d0=i.Position d1=win.Position
end
end))
lII1I11IlI(UIS.InputChanged:Connect(function(i)
if lll1II1l1 or not dg then return end
if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
local d=i.Position-d0
win.Position=UDim2.new(d1.X.Scale,d1.X.Offset+d.X,d1.Y.Scale,d1.Y.Offset+d.Y)
end
end))
lII1I11IlI(UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end
end))
local body=llII1lII11("Frame",{Size=UDim2.new(1,0,1,-38),Position=UDim2.new(0,0,0,38),BackgroundTransparency=1},win)
local sideBar=llII1lII11("Frame",{Size=UDim2.new(0,118,1,0),BackgroundColor3=SF,BorderSizePixel=0},body)
llII1lII11("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=BR,BackgroundTransparency=0.4,BorderSizePixel=0},sideBar)
local ct=llII1lII11("Frame",{Size=UDim2.new(1,-118,1,0),Position=UDim2.new(0,118,0,0),BackgroundTransparency=1},body)
local accentLine=llII1lII11("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),BackgroundColor3=AC,BorderSizePixel=0,ZIndex=0xA},body)
llI1l11I(accentLine)
local pages,tabs,tabInds,cur={},{},{},nil
local function lll1lllII(n)
if lll1II1l1 then return end
if cur==n then return end
for k,p in pairs(pages) do
if k==n then
p.Visible=true
p.Position=UDim2.new(0,5,0,0)
TS:Create(p,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)}):Play()
else
p.Visible=false
end
end
for k,b in pairs(tabs) do
if k==n then
TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=EL,TextColor3=AC}):Play()
if tabInds[k] then TS:Create(tabInds[k],TweenInfo.new(0.22),{BackgroundTransparency=0}):Play() end
else
TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=SF,TextColor3=MT}):Play()
if tabInds[k] then TS:Create(tabInds[k],TweenInfo.new(0.22),{BackgroundTransparency=1}):Play() end
end
end
cur=n
end
for i,n in ipairs({"Main","Play","Macro","Share","GUI"}) do
local b=llII1lII11("TextButton",{Size=UDim2.new(1,-16,0,28),Position=UDim2.new(0,8,0,10+(i-1)*32),BackgroundColor3=SF,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=MT,Text=" "..n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},sideBar)
lllII1Il1(b,6)
local ind=llII1lII11("Frame",{Size=UDim2.new(0,3,1,-16),Position=UDim2.new(0,3,0,8),BackgroundColor3=AC,BorderSizePixel=0,BackgroundTransparency=1},b)
lllII1Il1(ind,2)
llI1l11I(ind)
tabInds[n]=ind
lII1I11IlI(b.MouseButton1Click:Connect(function() lll1lllII(n) end))
tabs[n]=b
llI1l11I(b,function() return (cur==n) and AC or MT end,"TextColor3")
end
for i,c in ipairs({Color3.fromRGB(155,120,255),Color3.fromRGB(220,96,96),Color3.fromRGB(108,142,255),Color3.fromRGB(90,196,140),Color3.fromRGB(240,150,60),Color3.fromRGB(230,120,180),Color3.fromRGB(0,200,220),Color3.fromRGB(230,200,90)}) do
local s=llII1lII11("TextButton",{Size=UDim2.fromOffset(12,12),Position=UDim2.new(0,8+(i-1)*13,1,-20),BackgroundColor3=c,BorderSizePixel=0,Text="",AutoButtonColor=false},sideBar)
lllII1Il1(s,6)
lII1I11IlI(s.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
ll1I1IIlII(c)
llI1lI11("acr",math.floor(c.R*255+0.5))
llI1lI11("acg",math.floor(c.G*255+0.5))
llI1lI11("acb",math.floor(c.B*255+0.5))
if _syncThemeUI then _syncThemeUI() end
end))
end
local function lIl11l11(n)
local s=llII1lII11("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=EL,CanvasSize=UDim2.new(0,0,0,900),Visible=false},ct)
pages[n]=s
return s
end
local function lIlI1I11III(p,t,y)
local f=llII1lII11("Frame",{Size=UDim2.new(1,-24,0,0),Position=UDim2.new(0,12,0,y),BackgroundColor3=PN,BorderSizePixel=0},p)
lllII1Il1(f,8)
lll1I1ll(f,BR,0.4)
if t then
local d=llII1lII11("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,10,0,14),BackgroundColor3=AC,BorderSizePixel=0},f)
lllII1Il1(d,2)
llI1l11I(d)
local tLbl=l11Il11(f,string.upper(t),20,10,200,12,AC,10,true)
llI1l11I(tLbl,nil,"TextColor3")
end
return f
end
local function l1lll1lIIl(p,t,x,y,w,h,k,cb)
local o=llII1lII11("TextButton",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,Text=t,AutoButtonColor=false},p)
if k=="p" then o.BackgroundColor3=AC o.TextColor3=Color3.new(1,1,1)
elseif k=="d" then o.BackgroundColor3=Color3.fromRGB(56,34,34) o.TextColor3=Color3.fromRGB(230,150,150)
else o.BackgroundColor3=EL o.TextColor3=TX end
lllII1Il1(o,6)
if k=="p" then llI1l11I(o) end
lII1I11IlI(o.MouseEnter:Connect(function()
if lll1II1l1 then return end
TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=o.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play()
end))
lII1I11IlI(o.MouseLeave:Connect(function()
if lll1II1l1 then return end
local target=EL
if k=="p" then target=AC end
if k=="d" then target=Color3.fromRGB(56,34,34) end
TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=target}):Play()
end))
if cb then lII1I11IlI(o.MouseButton1Click:Connect(function() if lll1II1l1 then return end cb() end)) end
return o
end
local function lIIIIl1l(p,nm,ds,x,y,w,h,on,cb)
local box=llII1lII11("Frame",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundColor3=EL,BorderSizePixel=0},p)
lllII1Il1(box,6)
if ds then
l11Il11(box,nm,10,5,w-50,14,TX,11,false)
l11Il11(box,ds,10,20,w-50,11,SB,9,false)
else
l11Il11(box,nm,10,0,w-50,h,TX,11,false)
end
local st=on
local sw=llII1lII11("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-44,0.5,-9),BackgroundColor3=on and AC or OFF,BorderSizePixel=0},box)
lllII1Il1(sw,9)
local kn=llII1lII11("Frame",{Size=UDim2.fromOffset(12,12),Position=on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw)
lllII1Il1(kn,6)
llI1l11I(sw,function() return st and AC or OFF end)
local function apply(v)
st=v
if lll1II1l1 then return end
pcall(function()
TS:Create(sw,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{BackgroundColor3=v and AC or OFF}):Play()
TS:Create(kn,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{Position=v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play()
end)
end
local z=llII1lII11("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false},box)
lII1I11IlI(z.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
apply(not st)
if cb then cb(st) end
end))
return {GetValue=function() return st end,SetValue=function(v) apply(v) end}
end
local function llI111l1ll1(title,content)
if lll1II1l1 then return end
local nf=llII1lII11("Frame",{Size=UDim2.fromOffset(0xDC,0x32),Position=UDim2.new(1,-230,1,-70),BackgroundColor3=PN,BorderSizePixel=0,ZIndex=0x32},sg)
lllII1Il1(nf,8)
local ns=lll1I1ll(nf,AC,0.3)
local t1=l11Il11(nf,title,12,8,180,16,AC,11,true)
t1.ZIndex=51
local t2=l11Il11(nf,content,12,26,196,18,SB,10,false)
t2.ZIndex=51
nf.BackgroundTransparency=1
ns.Transparency=1
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
local stBar=llII1lII11("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),BackgroundColor3=SF,BorderSizePixel=0},win)
local stDot=llII1lII11("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,11,0.5,-2),BackgroundColor3=AC,BorderSizePixel=0},stBar)
lllII1Il1(stDot,3)
llI1l11I(stDot)
local stLbl=l11Il11(stBar,"Place 0 | Upgrade 0 | Sell 0",22,0,300,18,MT,9,false)
local llI1l1I1I1=true
local fl=llII1lII11("TextButton",{Size=UDim2.fromOffset(78,34),Position=UDim2.new(0,16,0,16),BackgroundColor3=HD,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TX,Text=string.char(84,111,103,103,108,101),AutoButtonColor=false,ZIndex=0x1E},sg)
lllII1Il1(fl,17)
local fS=lll1I1ll(fl,AC,0.4)
llI1l11I(fS,nil,"Color")
local fd=llII1lII11("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,10,0.5,-4),BackgroundColor3=AC,BorderSizePixel=0},fl)
lllII1Il1(fd,4)
llI1l11I(fd)
local fDg,fM,f0,f1=false,false,nil,nil
lII1I11IlI(fl.InputBegan:Connect(function(i)
if lll1II1l1 then return end
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
fDg=true fM=false f0=i.Position f1=fl.Position
end
end))
lII1I11IlI(UIS.InputChanged:Connect(function(i)
if lll1II1l1 or not fDg then return end
if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
local d=i.Position-f0
if math.abs(d.X)>4 or math.abs(d.Y)>4 then fM=true end
fl.Position=UDim2.new(f1.X.Scale,f1.X.Offset+d.X,f1.Y.Scale,f1.Y.Offset+d.Y)
end
end))
lII1I11IlI(UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fDg=false end
end))
local function lllllI1I1I1(v)
if lll1II1l1 then return end
llI1l1I1I1=v
if v then
win.Visible=true
win.BackgroundTransparency=1
wS.Transparency=1
TS:Create(win,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
TS:Create(wS,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.35}):Play()
TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=AC}):Play()
else
TS:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
TS:Create(wS,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency=1}):Play()
task.delay(0.3,function() if not llI1l1I1I1 and not lll1II1l1 then win.Visible=false end end)
TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=Color3.fromRGB(90,196,140)}):Play()
end
end
lII1I11IlI(fl.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
if not fM then lllllI1I1I1(not llI1l1I1I1) end
end))
local function l1llI1II11()
if ll1Il1Ill then return end
ll1Il1Ill=true
lll1II1l1=true
ll11l1ll=false
lllllI1l=lllllI1l+1
llII1Il1=false
lIlI1lll=lIlI1lll+1
rec.active=false
pcall(llIlI11Il11)
pcall(function()
for _,c in ipairs(l1111Il) do pcall(function() c:Disconnect() end) end
l1111Il={}
end)
pcall(function() sg:Destroy() end)
print("[EZVC] shutdown complete")
end
local scrD,dlg
local function ll1ll11Il1I(instant)
if not dlg then return end
if instant then
pcall(function() dlg:Destroy() end)
pcall(function() scrD:Destroy() end)
dlg=nil scrD=nil return
end
local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
local items={dlg,scrD}
for _,c in ipairs(dlg:GetDescendants()) do items[#items+1]=c end
for _,el in ipairs(items) do
if el and el:IsA("TextLabel") then TS:Create(el,ti,{TextTransparency=1}):Play()
elseif el and el:IsA("TextButton") then TS:Create(el,ti,{BackgroundTransparency=1,TextTransparency=1}):Play()
elseif el and el:IsA("UIStroke") then TS:Create(el,ti,{Transparency=1}):Play()
elseif el and el:IsA("Frame") then TS:Create(el,ti,{BackgroundTransparency=1}):Play() end
end
task.delay(0.28,function()
pcall(function() dlg:Destroy() end)
pcall(function() scrD:Destroy() end)
dlg=nil scrD=nil
end)
end
local function l11l11llll1()
if lll1II1l1 then return end
ll1ll11Il1I(true)
scrD=llII1lII11("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=0x28},sg)
dlg=llII1lII11("Frame",{Size=UDim2.fromOffset(0x118,0x82),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=PN,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=0x29},sg)
lllII1Il1(dlg,10)
local ds=lll1I1ll(dlg,BR,1)
local dt=l11Il11(dlg,"Close GUI",14,14,250,20,TX,14,true)
dt.TextTransparency=1 dt.ZIndex=0x2A
local dm=llII1lII11("TextLabel",{Size=UDim2.new(1,-28,0,40),Position=UDim2.new(0,14,0,40),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=SB,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text="Are you sure you want to close this GUI?",TextTransparency=1,ZIndex=0x2A},dlg)
local nb=llII1lII11("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0,14,1,-46),BackgroundColor3=EL,BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=TX,TextTransparency=1,Text=string.char(78,111),AutoButtonColor=false,ZIndex=0x2A},dlg)
lllII1Il1(nb,6)
local yb=llII1lII11("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0.5,6,1,-46),BackgroundColor3=Color3.fromRGB(180,70,70),BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.new(1,1,1),TextTransparency=1,Text=string.char(89,101,115),AutoButtonColor=false,ZIndex=0x2A},dlg)
lllII1Il1(yb,6)
local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
TS:Create(scrD,ti,{BackgroundTransparency=0.5}):Play()
TS:Create(dlg,ti,{BackgroundTransparency=0}):Play()
TS:Create(ds,ti,{Transparency=0.3}):Play()
TS:Create(dt,ti,{TextTransparency=0}):Play()
TS:Create(dm,ti,{TextTransparency=0}):Play()
TS:Create(nb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()
TS:Create(yb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()
lII1I11IlI(nb.MouseButton1Click:Connect(function() if lll1II1l1 then return end ll1ll11Il1I(false) end))
lII1I11IlI(yb.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
lll1II1l1=true
ll11l1ll=false
lllllI1l=lllllI1l+1
llII1Il1=false
lIlI1lll=lIlI1lll+1
rec.active=false
local to=TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
local list={dlg,scrD,win,fl,wS,fS}
for _,c in ipairs(dlg:GetDescendants()) do list[#list+1]=c end
for _,el in ipairs(list) do
if el and el:IsA("TextLabel") then TS:Create(el,to,{TextTransparency=1}):Play()
elseif el and el:IsA("UIStroke") then TS:Create(el,to,{Transparency=1}):Play()
elseif el then TS:Create(el,to,{BackgroundTransparency=1,TextTransparency=1}):Play() end
end
task.delay(0.35,function() l1llI1II11() end)
end))
end
lII1I11IlI(xb.MouseButton1Click:Connect(function() if lll1II1l1 then return end l11l11llll1() end))
local R={}
local function lII1ll1I(k,f,n)
local c=R[k]
if c and c.Parent then return c end
local fo=RS:FindFirstChild(f)
if not fo then return nil end
local r=fo:FindFirstChild(n)
if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
R[k]=r
return r
end
end
local function llIl1l1()
if ll11lll11ll and ll11lll11ll.Parent then return ll11lll11ll end
local fo=RS:FindFirstChild("Fishing")
if not fo then return nil end
local rm=fo:FindFirstChild("Remotes")
if not rm then return nil end
local ev=rm:FindFirstChild("FishingEvent")
if ev and ev:IsA("RemoteEvent") then
ll11lll11ll=ev
return ev
end
return nil
end
local rfC=function()
pcall(function() stLbl.Text=string.format("Place %d | Upgrade %d | Sell %d",C.P,C.U,C.S) end)
end
local function llIllI11(d)
if not d.Visible then return false end
local p=d.Parent
while p do
if p:IsA("GuiObject") and not p.Visible then return false end
p=p.Parent
end
return true
end
local function llI1I1IIl11(tx)
local nd=tx:lower()
local rr={PG}
pcall(function()
if gethui then
local ok,h=pcall(gethui)
if ok and h then rr[#rr+1]=h end
end
end)
for _,root in ipairs(rr) do
if root then
for _,d in ipairs(root:GetDescendants()) do
if (d:IsA("TextButton") or d:IsA("ImageButton")) and llIllI11(d) then
local t=d.Text
if d:IsA("ImageButton") then
local lb2=d:FindFirstChildOfClass("TextLabel")
if lb2 then t=lb2.Text end
end
if tostring(t or ""):lower():find(nd,1,true) then return d end
end
end
end
end
end
local _loseCache=nil
local function l11l1111I()
if _loseCache and _loseCache.Parent and llIllI11(_loseCache) then return true end
_loseCache=llI1I1IIl11("replay")
return _loseCache~=nil
end
local function ll11IIlll()
rec.a={}
rec.n=1
rec.t={}
rec.k={}
rec.l=tick()
C.P=0
C.U=0
C.S=0
rfC()
end
local function lIlIIIIII1I(s)
if not lI11llI or not lI11llI.Parent then return end
local col=MT
if s==string.char(82,101,99,111,114,100,105,110,103) then col=Color3.fromRGB(220,96,96)
elseif s==string.char(80,108,97,121,105,110,103) then col=Color3.fromRGB(90,196,140)
elseif s==string.char(73,100,108,101) then col=SB end
lI11llI.Text="Status: "..s
pcall(function() TS:Create(lI11llI,TweenInfo.new(0.2),{TextColor3=col}):Play() end)
end
local function l1Ill1I(n)
if lIIlIIIl and lIIlIIIl.Parent then lIIlIIIl.Text="Actions: "..tostring(n) end
end
local function lIllI1I1Il()
llII1Il1=false
lIlI1lll=lIlI1lll+1
end
local function llIl1I1I11l()
if lll1II1l1 then return end
if llII1Il1 then return end
llII1Il1=true
lIlI1lll=lIlI1lll+1
local mySession=lIlI1lll
task.spawn(function()
while not lll1II1l1 and llII1Il1 and lIlI1lll==mySession do
local ev=llIl1l1()
if ev then
pcall(function() ev:FireServer("Cast",{Position=l11l1lII}) end)
if not llII1Il1 or lll1II1l1 or lIlI1lll~=mySession then break end
local clickTime=os.time()
pcall(function() ev:FireServer("LuckHold",{ClickTime=clickTime}) end)
pcall(function() ev:FireServer("LuckRelease",{ClickTime=clickTime}) end)
for i=1,10 do
if not llII1Il1 or lll1II1l1 or lIlI1lll~=mySession then break end
pcall(function() ev:FireServer("Hit",{Index=i}) end)
end
end
task.wait()
end
end)
end
local function lII1lIlIlI1()
ll11l1ll=false
lllllI1l=lllllI1l+1
lIlIIIIII1I(string.char(73,100,108,101))
end
local function l1111Illl()
if lll1II1l1 then return end
if ll11l1ll then return end
lllllI1l=lllllI1l+1
local mySession=lllllI1l
ll11l1ll=true
lIlIIIIII1I(string.char(80,108,97,121,105,110,103))
task.spawn(function()
local data=l1llI111(sel)
if not data or #data==0 then
if lllllI1l==mySession then
ll11l1ll=false
lllllI1l=lllllI1l+1
lIlIIIIII1I(string.char(73,100,108,101))
if pToggle then pToggle.SetValue(false) end
end
return
end
C.P=0 C.U=0 C.S=0 rfC()
local P2={t={},k={},i=1}
local function alive()
return ll11l1ll and lllllI1l==mySession and not lll1II1l1
end
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
local PL=lII1ll1I("p","RemoteFunctions","PlaceTower")
if PL then
local cf=CFrame.new(a.p[1],a.p[2],a.p[3])
pcall(function() PL:InvokeServer(a.n,cf) end)
C.P=C.P+1 rfC()
local t0=tick()
while tick()-t0<2 and alive() do
local inst=nf(cf.Position,P2)
if inst then P2.t[a.i]=inst P2.k[inst]=a.i break end
task.wait(0.05)
end
end
elseif a.t=="U" then
local UP=lII1ll1I("u","RemoteFunctions","UpgradeTower")
local inst=P2.t[a.i]
if UP and inst and inst.Parent then
pcall(function() UP:InvokeServer(inst) end)
C.U=C.U+1 rfC()
end
elseif a.t=="S" then
local SE=lII1ll1I("s","RemoteFunctions","SellTower")
local inst=P2.t[a.i]
if SE and inst and inst.Parent then
pcall(function() SE:InvokeServer(inst) end)
C.S=C.S+1 rfC()
P2.t[a.i]=nil
P2.k[inst]=nil
end
elseif a.t=="W" then
local SK=lII1ll1I("w","RemoteEvents","SkipWaveVote")
if SK then pcall(function() SK:FireServer(1) end) end
elseif a.t=="G" then
local SP=lII1ll1I("g","RemoteEvents","SetGameSpeed")
if SP then pcall(function() SP:FireServer(a.v) end) end
end
end
end
P2.i=P2.i+1
end
if lllllI1l==mySession then
ll11l1ll=false
lllllI1l=lllllI1l+1
lIlIIIIII1I(string.char(73,100,108,101))
if pToggle and pToggle.GetValue() then
pToggle.SetValue(false)
end
end
end)
end
local function llIIIlI1I(a)
local fo=RS:FindFirstChild("RemoteFunctions")
local ev=fo and fo:FindFirstChild("SummonUnits")
if not ev or not ev:IsA("RemoteFunction") then return false end
return pcall(function() ev:InvokeServer(a) end)
end
task.spawn(function()
while not lll1II1l1 do
if Cfg.s10 then llIIIlI1I(10) task.wait(1) else task.wait(0.5) end
end
end)
task.spawn(function()
while not lll1II1l1 do
if Cfg.s1 then llIIIlI1I(1) task.wait(1) else task.wait(0.5) end
end
end)
task.spawn(function()
while not lll1II1l1 do
if Cfg.spn then
local fo=RS:FindFirstChild("RemoteFunctions")
local ev=fo and fo:FindFirstChild("SpinWheel")
if ev and ev:IsA("RemoteFunction") then pcall(function() ev:InvokeServer() end) end
task.wait(0.5)
else
task.wait(0.2)
end
end
end)
task.spawn(function()
while not lll1II1l1 do
if Cfg.oc then
local fo=RS:FindFirstChild("RemoteFunctions")
local ev=fo and fo:FindFirstChild("OpenCrate")
if ev and ev:IsA("RemoteFunction") then pcall(function() ev:InvokeServer(Cfg.crate or "Free",1) end) end
task.wait(1)
else
task.wait(0.3)
end
end
end)
local l1II1ll=false
local function lI1II11lI1()
if lll1II1l1 then return end
if l1II1ll then return end
l1II1ll=true
task.spawn(function()
while not lll1II1l1 and Cfg.l11Il11 do
local tl=RS:FindFirstChild("ReturnToLobby")
if tl and tl:IsA("RemoteEvent") then pcall(function() tl:FireServer() end) end
task.wait(1)
end
l1II1ll=false
end)
end
task.spawn(function()
local was=false
while not lll1II1l1 do
local now=l11l1111I()
if now and not was and rec.active then
ll11IIlll()
l1Ill1I(0)
end
was=now
task.wait(1)
end
end)
local lIlIlll=nil
local function lll1l1l()
local ok,b=pcall(function() return PG.MainGameUI.UpSide.InfoDop.AutoSkip end)
return ok and b or nil
end
local function l1l1I1III1(on)
pcall(function()
local b=lll1l1l()
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
while not lll1II1l1 do
if Cfg.lll1I1ll then
local ws=RS:FindFirstChild("WaveState")
if ws then
local w=ws:GetAttribute("CurrentWave")
local c=ws:GetAttribute("CanSkipWave")
local r=ws:GetAttribute("Result")
if c==true and r~="Win" and r~="Lose" and lIlIlll~=w then
lIlIlll=w
local skR=lII1ll1I("w","RemoteEvents","SkipWaveVote")
if skR then pcall(function() skR:FireServer(w) end) end
end
end
end
task.wait(0.5)
end
end)
local l1l1II11ll=false
local function l1I1II1IlI()
if lll1II1l1 then return end
if l1l1II11ll then return end
l1l1II11ll=true
task.spawn(function()
while not lll1II1l1 and Cfg.rp do
local re=RS:FindFirstChild("RemoteEvents")
local rv=re and re:FindFirstChild("ReplayVote")
if rv then pcall(function() rv:FireServer() end) end
task.wait(1)
end
l1l1II11ll=false
end)
end
local HR={PL=nil,UP=nil,SE=nil,SK=nil,SP=nil}
local function lI1I1lII()
HR.PL=lII1ll1I("p","RemoteFunctions","PlaceTower")
HR.UP=lII1ll1I("u","RemoteFunctions","UpgradeTower")
HR.SE=lII1ll1I("s","RemoteFunctions","SellTower")
HR.SK=lII1ll1I("w","RemoteEvents","SkipWaveVote")
HR.SP=lII1ll1I("g","RemoteEvents","SetGameSpeed")
end
lI1I1lII()
task.spawn(function()
while not lll1II1l1 do
if rec.active then lI1I1lII() end
task.wait(5)
end
end)
local lIIIlIl1I1="none"
local l111I1l1=false
do
if type(hookmetamethod)=="function" and type(newcclosure)=="function" then
lIIIlIl1I1="hookmetamethod"
elseif type(getrawmetatable)=="function" and type(setreadonly)=="function" and type(newcclosure)=="function" then
lIIIlIl1I1="getrawmetatable"
end
end
local function llIIII1lIlI(id,cf)
local t0=tick()
while tick()-t0<3 and not lll1II1l1 do
local tw=workspace:FindFirstChild("Towers")
if tw then
local bd,b=20,nil
for _,xx in ipairs(tw:GetChildren()) do
if not rec.k[xx] then
local ok,q=pcall(function() return xx:GetPivot().Position end)
if ok and q then
local dist=(q-cf.Position).Magnitude
if dist<bd then b=xx bd=dist end
end
end
end
if b and not rec.k[b] then
rec.t[id]=b
rec.k[b]=id
rec.lastPlaced=b
return b
end
end
task.wait(0.05)
end
return nil
end
local lIIIIllIl=0
local function lI1l1lI(self,...)
if not rec.active or lll1II1l1 then return end
if self~=HR.PL and self~=HR.UP and self~=HR.SE and self~=HR.SK and self~=HR.SP then return end
local m=getnamecallmethod and getnamecallmethod() or ""
local args={...}
lIIIIllIl=lIIIIllIl+1
if m=="InvokeServer" and self==HR.PL then
local n,cf=args[1],args[2]
if typeof(cf)=="CFrame" then
C.P=C.P+1 rfC()
local id=rec.n rec.n=id+1
local tk=tick()
rec.a[#rec.a+1]={t="P",n=n,p={cf.Position.X,cf.Position.Y,cf.Position.Z},i=id,d=tk-(rec.l or tk)}
rec.l=tk
task.spawn(function() llIIII1lIlI(id,cf) l1Ill1I(#rec.a) end)
end
elseif m=="InvokeServer" and self==HR.UP then
local id=rec.k[args[1]]
if id then
C.U=C.U+1 rfC()
local tk=tick()
rec.a[#rec.a+1]={t="U",i=id,d=tk-(rec.l or tk)}
rec.l=tk l1Ill1I(#rec.a)
end
elseif m=="InvokeServer" and self==HR.SE then
local inst,id=args[1],rec.k[args[1]]
if id then
C.S=C.S+1 rfC()
local tk=tick()
rec.a[#rec.a+1]={t="S",i=id,d=tk-(rec.l or tk)}
rec.l=tk
rec.t[id]=nil rec.k[inst]=nil
l1Ill1I(#rec.a)
end
elseif m=="FireServer" and self==HR.SK then
local tk=tick()
rec.a[#rec.a+1]={t="W",d=tk-(rec.l or tk)}
rec.l=tk l1Ill1I(#rec.a)
elseif m=="FireServer" and self==HR.SP then
local tk=tick()
rec.a[#rec.a+1]={t="G",v=args[1],d=tk-(rec.l or tk)}
rec.l=tk l1Ill1I(#rec.a)
end
end
if lIIIlIl1I1=="hookmetamethod" then
pcall(function()
local old
old=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
local r=old(self,...)
pcall(lI1l1lI,self,...)
return r
end))
l111I1l1=true
end)
elseif lIIIlIl1I1=="getrawmetatable" then
pcall(function()
local mt=getrawmetatable(game)
local old=mt.__namecall
setreadonly(mt,false)
mt.__namecall=newcclosure(function(self,...)
local r=old(self,...)
pcall(lI1l1lI,self,...)
return r
end)
setreadonly(mt,true)
l111I1l1=true
end)
end
if l111I1l1 then
print("[EZVC] Hook mode: "..lIIIlIl1I1)
else
print("[EZVC] No hooking API - using passive mode")
end
local function l11Il1l()
for _,c in ipairs(l1111Il) do pcall(function() c:Disconnect() end) end
l1111Il={}
end
local function lI11I1I(t)
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
local function lIlll1lI1I(tower,id)
local a_=tower.AttributeChanged:Connect(function(attr)
if not rec.active or lll1II1l1 then return end
local l=attr:lower()
if l=="level" or l=="tier" or l=="upgrade" or l=="rank" or l=="upgraded" then
C.U=C.U+1 rfC()
local tk=tick()
rec.a[#rec.a+1]={t="U",i=id,d=tk-(rec.l or tk)}
rec.l=tk l1Ill1I(#rec.a)
end
end)
l1111Il[#l1111Il+1]=a_
local dc=tower.Destroying:Connect(function()
if not rec.active or lll1II1l1 then return end
if rec.k[tower]~=id then return end
if l11l1111I() then return end
C.S=C.S+1 rfC()
local tk=tick()
rec.a[#rec.a+1]={t="S",i=id,d=tk-(rec.l or tk)}
rec.l=tk
rec.t[id]=nil rec.k[tower]=nil
l1Ill1I(#rec.a)
end)
l1111Il[#l1111Il+1]=dc
end
local function llIlI1lI(tower)
if not rec.active or lll1II1l1 then return end
if ll1I11IIll[tower] then return end
ll1I11IIll[tower]=true
local ok,cf=pcall(function() return tower:GetPivot() end)
if not ok or not cf then return end
C.P=C.P+1 rfC()
local id=rec.n rec.n=id+1
local tk=tick()
rec.t[id]=tower rec.k[tower]=id rec.lastPlaced=tower
rec.a[#rec.a+1]={t="P",n=lI11I1I(tower),p={cf.Position.X,cf.Position.Y,cf.Position.Z},i=id,d=tk-(rec.l or tk)}
rec.l=tk l1Ill1I(#rec.a)
lIlll1lI1I(tower,id)
end
local function ll1IllIl()
local tw=workspace:FindFirstChild("Towers")
if tw then
for _,t in ipairs(tw:GetChildren()) do ll1I11IIll[t]=true end
l1111Il[#l1111Il+1]=tw.ChildAdded:Connect(llIlI1lI)
else
local wc
wc=workspace.ChildAdded:Connect(function(child)
if lll1II1l1 then return end
if child.Name=="Towers" then
if wc then wc:Disconnect() end
for _,t in ipairs(child:GetChildren()) do ll1I11IIll[t]=true end
l1111Il[#l1111Il+1]=child.ChildAdded:Connect(llIlI1lI)
end
end)
l1111Il[#l1111Il+1]=wc
end
end
local function l1l11I1l1()
ll1I11IIll={}
l11Il1l()
ll1IllIl()
end
local mP=lIl11l11("Main")
local c1=lIlI1I11III(mP,string.char(83,116,97,116,105,115,116,105,99,115),12)
c1.Size=UDim2.new(1,-24,0,84)
l11Il11(c1,string.char(80,108,97,99,101),12,30,80,12,SB,9,false)
l11Il11(c1,string.char(85,112,103,114,97,100,101),112,30,80,12,SB,9,false)
l11Il11(c1,string.char(83,101,108,108),212,30,80,12,SB,9,false)
local _pL=l11Il11(c1,"0",12,44,80,20,TX,16,true)
local _uL=l11Il11(c1,"0",112,44,80,20,TX,16,true)
local _sL=l11Il11(c1,"0",212,44,80,20,TX,16,true)
local _prevRfC=rfC
rfC=function()
_prevRfC()
pcall(function()
_pL.Text=tostring(C.P)
_uL.Text=tostring(C.U)
_sL.Text=tostring(C.S)
end)
end
local c2=lIlI1I11III(mP,string.char(65,117,116,111,109,97,116,105,111,110),104)
c2.Size=UDim2.new(1,-24,0,290)
local s10T,s1T
s10T=lIIIIl1l(c2,"Auto Summon 10","Summon 10 units/s",12,26,240,38,Cfg.s10,function(on)
llI1lI11("s10",on)
if on and s1T then s1T.SetValue(false) llI1lI11("s1",false) end
end)
s1T=lIIIIl1l(c2,"Auto Summon 1","Summon 1 unit/s",12,70,240,38,Cfg.s1,function(on)
llI1lI11("s1",on)
if on and s10T then s10T.SetValue(false) llI1lI11("s10",false) end
end)
lIIIIl1l(c2,"Auto Spin","Spin wheel automatically",12,114,240,38,Cfg.spn,function(on) llI1lI11("spn",on) end)
lIIIIl1l(c2,"Auto Open Crate","Open selected crate/s",12,158,240,38,Cfg.oc,function(on) llI1lI11("oc",on) end)
lIIIIl1l(c2,"Auto Fish","Automatic fishing cycle",12,202,240,38,false,function(on)
if on then
llIl1I1I11l()
if not llII1Il1 then llI111l1ll1("EZVC","FishingEvent not found") end
else
lIllI1I1Il()
end
end)
local crateOpts={"Free","ScientistCrate","PartyCrate"}
local crateIdx=1
for i,v in ipairs(crateOpts) do if v==Cfg.crate then crateIdx=i end end
local crateLbl=llII1lII11("TextButton",{Size=UDim2.new(1,-24,0,26),Position=UDim2.new(0,12,0,246),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="Crate: "..(Cfg.crate or "Free"),AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},c2)
lllII1Il1(crateLbl,5)
lII1I11IlI(crateLbl.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
crateIdx=crateIdx%#crateOpts+1
Cfg.crate=crateOpts[crateIdx]
llI1lI11("crate",Cfg.crate)
crateLbl.Text="Crate: "..Cfg.crate
llI111l1ll1("EZVC","Crate: "..Cfg.crate)
end))
local pP=lIl11l11("Play")
local pc=lIlI1I11III(pP,"Game Speed",12)
pc.Size=UDim2.new(1,-24,0,60)
l11Il11(pc,string.char(83,112,101,101,100),12,28,60,24,SB,11,false)
local gsOpts={"1","1.50","2"}
local gsCur=Cfg.gs or "1"
local gsIdx=1
for i,v in ipairs(gsOpts) do if v==gsCur then gsIdx=i end end
local gsLbl=llII1lII11("TextButton",{Size=UDim2.new(0,120,0,28),Position=UDim2.new(1,-132,0,22),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=gsCur,AutoButtonColor=false},pc)
lllII1Il1(gsLbl,5)
lII1I11IlI(gsLbl.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
gsIdx=gsIdx%#gsOpts+1
gsCur=gsOpts[gsIdx]
gsLbl.Text=gsCur
llI1lI11("gs",gsCur)
local n=tonumber(gsCur)
if n then
local g=lII1ll1I("g","RemoteEvents","SetGameSpeed")
if g then pcall(function() g:FireServer(n) end) end
end
end))
local pc2=lIlI1I11III(pP,"Toggles",80)
pc2.Size=UDim2.new(1,-24,0,170)
lIIIIl1l(pc2,"Auto Skip Wave","Skip waves automatically",12,26,240,38,Cfg.lll1I1ll,function(on)
llI1lI11("lll1I1ll",on)
if on then lIlIlll=nil l1l1I1III1(true) else l1l1I1III1(false) end
end)
lIIIIl1l(pc2,"Auto Replay","Vote replay on round end",12,70,240,38,Cfg.rp,function(on)
llI1lI11("rp",on)
if on then l1I1II1IlI() else l1l1II11ll=false end
end)
lIIIIl1l(pc2,"Auto Lobby","Return to lobby automatically",12,114,240,38,Cfg.l11Il11,function(on)
llI1lI11("l11Il11",on)
if on then lI1II11lI1() else l1II1ll=false end
end)
local _refreshShareSelect
local mP2=lIl11l11("Macro")
local rc=lIlI1I11III(mP2,"Macro Name",12)
rc.Size=UDim2.new(1,-24,0,56)
l11Il11(rc,string.char(78,97,109,101),12,26,50,24,SB,11,false)
local mnBox=llII1lII11("TextBox",{Size=UDim2.new(1,-80,0,26),Position=UDim2.new(0,64,0,20),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,PlaceholderText="e.g. EasyFarm",PlaceholderColor3=MT,Text=Cfg.mn or "",ClearTextOnFocus=false},rc)
lllII1Il1(mnBox,5)
lII1I11IlI(mnBox.FocusLost:Connect(function() if lll1II1l1 then return end llI1lI11("mn",mnBox.Text or "") end))
local rc2=lIlI1I11III(mP2,"Macro Actions",76)
rc2.Size=UDim2.new(1,-24,0,300)
lI11llI=l11Il11(rc2,"Status: Idle",12,26,110,14,SB,10,true)
lIIlIIIl=l11Il11(rc2,"Actions: 0",124,26,100,14,MT,10,false)
l11Il11(rc2,string.char(83,84,65,84,73,83,84,73,67,83),12,48,120,12,SB,9,true)
local statPlace=l11Il11(rc2,"Place: 0",12,64,90,16,TX,11,true)
local statUpgrade=l11Il11(rc2,"Upgrade: 0",102,64,90,16,TX,11,true)
local statSell=l11Il11(rc2,"Sell: 0",192,64,90,16,TX,11,true)
local _prevRfC2=rfC
rfC=function()
_prevRfC2()
pcall(function()
statPlace.Text="Place: "..tostring(C.P)
statUpgrade.Text="Upgrade: "..tostring(C.U)
statSell.Text="Sell: "..tostring(C.S)
end)
end
local macroList=lII11Il11()
local macroIdx=0
for i,v in ipairs(macroList) do if v==Cfg.sel then macroIdx=i end end
local macroLbl=llII1lII11("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,90),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=Cfg.sel~="" and Cfg.sel or "
lllII1Il1(macroLbl,5)
local function l1Illll1I1()
macroList=lII11Il11()
macroIdx=0
for i,v in ipairs(macroList) do if v==Cfg.sel then macroIdx=i end end
macroLbl.Text=Cfg.sel~="" and Cfg.sel or "
if _refreshShareSelect then _refreshShareSelect() end
end
lII1I11IlI(macroLbl.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
macroList=lII11Il11()
if #macroList==0 then llI111l1ll1("EZVC","No saved macros") return end
macroIdx=macroIdx%#macroList+1
local chosen=macroList[macroIdx]
macroLbl.Text=chosen
sel=chosen
llI1lI11("sel",chosen)
if _refreshShareSelect then _refreshShareSelect() end
end))
l1lll1lIIl(rc2,"Create / Save Macro",12,126,240,28,"p",function()
local n=mnBox.Text or ""
if n=="" then llI111l1ll1("EZVC","Enter a macro name") return end
pcall(function()
if type(isfile)~="function" or not isfile(FO..n..".json") then
lI1lI11(FO..n..".json",{})
end
end)
sel=n
llI1lI11("sel",n)
l1Illll1I1()
llI111l1ll1("EZVC","Macro ready: "..n)
end)
rToggle=lIIIIl1l(rc2,"Record Macro","Start/stop recording",12,162,240,38,false,function(on)
if on then
if rec.active then llI111l1ll1("EZVC","Already recording") rToggle.SetValue(true) return end
if ll11l1ll then llI111l1ll1("EZVC","Stop playback first") rToggle.SetValue(false) return end
if Cfg.sel=="" then llI111l1ll1("EZVC","Select a macro first") rToggle.SetValue(false) return end
llI1lI11("rec",true)
lI1I1lII()
ll11IIlll()
l1Ill1I(0)
lIIIIllIl=0
rec.active=true
lIlIIIIII1I(string.char(82,101,99,111,114,100,105,110,103))
if not l111I1l1 then l1l11I1l1() end
llI111l1ll1("EZVC","Recording -> "..Cfg.sel..(l111I1l1 and "" or " (passive)"))
else
if not rec.active then llI1lI11("rec",false) lIlIIIIII1I(string.char(73,100,108,101)) return end
rec.active=false
llI1lI11("rec",false)
if not l111I1l1 then l11Il1l() end
if #rec.a>0 and Cfg.sel~="" then
if lI1lI11(FO..Cfg.sel..".json",rec.a) then
llI111l1ll1("EZVC","Saved "..#rec.a.." steps")
else
llI111l1ll1("EZVC","Save failed")
end
else
local diag
if l111I1l1 then diag="hook="..lIIIlIl1I1.." hits="..lIIIIllIl
else diag="passive, no towers detected" end
llI111l1ll1("EZVC","Nothing saved ("..diag..")")
warn("[EZVC] "..diag)
end
ll11IIlll()
l1Ill1I(0)
lIlIIIIII1I(string.char(73,100,108,101))
end
end)
pToggle=lIIIIl1l(rc2,"Play Macro","Playback recorded macro",12,206,240,38,false,function(on)
if on then
if rec.active then llI111l1ll1("EZVC","Stop recording first") pToggle.SetValue(false) return end
if Cfg.sel=="" then llI111l1ll1("EZVC","Select a macro first") pToggle.SetValue(false) return end
l1111Illl()
if not ll11l1ll then pToggle.SetValue(false) end
else
lII1lIlIlI1()
end
end)
l1lll1lIIl(rc2,"Delete Macro",12,252,240,28,"d",function()
if Cfg.sel=="" then llI111l1ll1("EZVC","Select a macro") return end
pcall(function()
if type(delfile)=="function" then delfile(FO..Cfg.sel..".json") end
end)
sel=""
llI1lI11("sel","")
l1Illll1I1()
llI111l1ll1("EZVC","Deleted")
end)
local ll1l1lIlI,l1IIlllll
local function l11IlI1l()
if ll1l1lIlI then return ll1l1lIlI,l1IIlllll end
if type(setclipboard)=="function" then ll1l1lIlI,l1IIlllll=setclipboard,"setclipboard" return ll1l1lIlI,l1IIlllll end
if type(toclipboard)=="function" then ll1l1lIlI,l1IIlllll=toclipboard,"toclipboard" return ll1l1lIlI,l1IIlllll end
if type(writeclipboard)=="function" then ll1l1lIlI,l1IIlllll=writeclipboard,"writeclipboard" return ll1l1lIlI,l1IIlllll end
if type(set_clipboard)=="function" then ll1l1lIlI,l1IIlllll=set_clipboard,"set_clipboard" return ll1l1lIlI,l1IIlllll end
if type(getgenv)=="function" then
local ok,env=pcall(getgenv)
if ok and type(env)=="table" then
if type(env.setclipboard)=="function" then ll1l1lIlI,l1IIlllll=env.setclipboard,"getgenv.setclipboard" return ll1l1lIlI,l1IIlllll end
if type(env.toclipboard)=="function" then ll1l1lIlI,l1IIlllll=env.toclipboard,"getgenv.toclipboard" return ll1l1lIlI,l1IIlllll end
if type(env.writeclipboard)=="function" then ll1l1lIlI,l1IIlllll=env.writeclipboard,"getgenv.writeclipboard" return ll1l1lIlI,l1IIlllll end
end
end
if type(syn)=="table" then
if type(syn.setclipboard)=="function" then ll1l1lIlI,l1IIlllll=syn.setclipboard,"syn.setclipboard" return ll1l1lIlI,l1IIlllll end
if type(syn.write_clipboard)=="function" then ll1l1lIlI,l1IIlllll=syn.write_clipboard,"syn.write_clipboard" return ll1l1lIlI,l1IIlllll end
if type(syn.clipboard)=="table" and type(syn.clipboard.llI1lI11)=="function" then
ll1l1lIlI,l1IIlllll=syn.clipboard.llI1lI11,"syn.clipboard.llI1lI11"
return ll1l1lIlI,l1IIlllll
end
end
if type(Clipboard)=="table" and type(Clipboard.llI1lI11)=="function" then
ll1l1lIlI,l1IIlllll=Clipboard.llI1lI11,"Clipboard.llI1lI11"
return ll1l1lIlI,l1IIlllll
end
return nil
end
l11IlI1l()
local sP=lIl11l11("Share")
local sc1=lIlI1I11III(sP,"Export",12)
sc1.Size=UDim2.new(1,-24,0,120)
l11Il11(sc1,"Select Macro to Export",12,26,200,14,SB,10,false)
local exportSelect=llII1lII11("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,42),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=" "..(sel~="" and sel or "
lllII1Il1(exportSelect,5)
lII1I11IlI(exportSelect.MouseEnter:Connect(function() if lll1II1l1 then return end TS:Create(exportSelect,TweenInfo.new(0.14),{BackgroundColor3=BG:Lerp(Color3.new(1,1,1),0.1)}):Play() end))
lII1I11IlI(exportSelect.MouseLeave:Connect(function() if lll1II1l1 then return end TS:Create(exportSelect,TweenInfo.new(0.14),{BackgroundColor3=BG}):Play() end))
lII1I11IlI(exportSelect.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
local list=lII11Il11()
if #list==0 then llI111l1ll1("EZVC","No saved macros") return end
local idx=0
for i,v in ipairs(list) do if v==sel then idx=i end end
idx=idx%#list+1
sel=list[idx]
llI1lI11("sel",sel)
exportSelect.Text=" "..sel
if _refreshShareSelect then _refreshShareSelect() end
end))
local copyBtn=l1lll1lIIl(sc1,"Copy Macro",12,80,240,28,"p")
lII1I11IlI(copyBtn.MouseButton1Click:Connect(function()
if sel=="" then llI111l1ll1("EZVC","Select a macro first") return end
local data=l1llI111(sel)
if not data or #data==0 then llI111l1ll1("EZVC","Macro is empty or invalid") return end
local payload={Name=sel,Actions=data}
local ok,json=pcall(function() return HS:JSONEncode(payload) end)
if not ok or type(json)~="string" or #json<5 then llI111l1ll1("EZVC","Failed to generate macro JSON.") return end
local fn,name=l11IlI1l()
if not fn then llI111l1ll1("EZVC","Clipboard function is not available in this runtime.") return end
local cok,cerr=pcall(fn,json)
if not cok then llI111l1ll1("EZVC","Clipboard error: "..tostring(cerr)) return end
llI111l1ll1("EZVC","Macro copied to clipboard.")
end))
local sc2=lIlI1I11III(sP,"Import",148)
sc2.Size=UDim2.new(1,-24,0,244)
l11Il11(sc2,"Paste macro JSON",12,26,200,14,SB,10,false)
local importBox=llII1lII11("TextBox",{Size=UDim2.new(1,-24,0,60),Position=UDim2.new(0,12,0,44),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=10,TextColor3=TX,Text="",PlaceholderText='Paste JSON here e.g. {string.char(78,97,109,101):"...","Actions":[...]}',PlaceholderColor3=MT,ClearTextOnFocus=false,TextWrapped=true,MultiLine=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},sc2)
lllII1Il1(importBox,5)
l11Il11(sc2,"Macro name (optional override)",12,112,220,14,SB,10,false)
local importName=llII1lII11("TextBox",{Size=UDim2.new(1,-24,0,26),Position=UDim2.new(0,12,0,128),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="",PlaceholderText="Auto-filled from JSON or enter name",PlaceholderColor3=MT,ClearTextOnFocus=false},sc2)
lllII1Il1(importName,5)
local llIllIl1I=nil
local importBtn=l1lll1lIIl(sc2,"Import Macro",12,162,240,28,"p")
local saveImportBtn=l1lll1lIIl(sc2,"Save Imported Macro",12,198,240,28)
lII1I11IlI(importBtn.MouseButton1Click:Connect(function()
local raw=importBox.Text or ""
if #raw<2 then llI111l1ll1("EZVC","Paste macro JSON first") return end
if raw:sub(1,5)=="EZVC:" then raw=raw:sub(6) end
raw=raw:match("^%s*(.-)%s*$") or raw
local ok,decoded=pcall(function() return HS:JSONDecode(raw) end)
if not ok or type(decoded)~="table" then
llIllIl1I=nil
llI111l1ll1("EZVC","Invalid macro JSON.")
return
end
local actions,importedName
if type(decoded.Actions)=="table" then
actions=decoded.Actions
importedName=decoded.Name
elseif decoded[1]~=nil then
actions=decoded
else
llIllIl1I=nil
llI111l1ll1("EZVC","Invalid macro data.")
return
end
local clean={}
for _,a in ipairs(actions) do
local s=l1ll11lII(a)
if s then clean[#clean+1]=s end
end
if #clean==0 then
llIllIl1I=nil
llI111l1ll1("EZVC","Invalid macro data.")
return
end
llIllIl1I=clean
if type(importedName)=="string" and importedName~="" and (importName.Text or "")=="" then
importName.Text=importedName
end
llI111l1ll1("EZVC","Parsed "..#clean.." actions.")
end))
lII1I11IlI(saveImportBtn.MouseButton1Click:Connect(function()
if not llIllIl1I then llI111l1ll1("EZVC","Click Import first") return end
local name=(importName.Text or ""):match("^%s*(.-)%s*$")
if name=="" then llI111l1ll1("EZVC","Enter a macro name") return end
if type(writefile)~="function" then llI111l1ll1("EZVC","writefile not supported") return end
if lI1lI11(FO..name..".json",llIllIl1I) then
sel=name
llI1lI11("sel",name)
l1Illll1I1()
llIllIl1I=nil
importBox.Text=""
importName.Text=""
llI111l1ll1("EZVC","Saved: "..name)
else
llI111l1ll1("EZVC","Save failed")
end
end))
_refreshShareSelect=function()
if exportSelect and exportSelect.Parent then
exportSelect.Text=" "..(sel~="" and sel or "
end
end
_refreshShareSelect()
local gP=lIl11l11("GUI")
local th=lIlI1I11III(gP,string.char(84,104,101,109,101),12)
th.Size=UDim2.new(1,-24,0,180)
local themes={
{n="Purple",c=Color3.fromRGB(155,120,255)},
{n="Red", c=Color3.fromRGB(220,96,96)},
{n="Blue", c=Color3.fromRGB(108,142,255)},
{n="Green", c=Color3.fromRGB(90,196,140)},
{n="Orange",c=Color3.fromRGB(240,150,60)},
{n="Pink", c=Color3.fromRGB(230,120,180)},
{n="Cyan", c=Color3.fromRGB(0,200,220)},
{n="Yellow",c=Color3.fromRGB(230,200,90)},
}
local lII1I11Il={}
local function lIl1ll1(a,b)
return math.abs(a.R-b.R)<0.01 and math.abs(a.G-b.G)<0.01 and math.abs(a.B-b.B)<0.01
end
local function l1l11IllI()
for _,e in ipairs(lII1I11Il) do
if not e.str or not e.str.Parent then break end
local isSel=lIl1ll1(e.c,AC)
TS:Create(e.str,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Transparency=isSel and 0 or 0.85,Color=e.c}):Play()
end
end
_syncThemeUI=l1l11IllI
for i,t in ipairs(themes) do
local col=(i-1)%2
local row=math.floor((i-1)/2)
local px=(col==0) and UDim2.new(0,12,0,30+row*34) or UDim2.new(0.5,6,0,30+row*34)
local b=llII1lII11("TextButton",{Size=UDim2.new(0.5,-18,0,28),Position=px,BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=" "..t.n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},th)
lllII1Il1(b,6)
local str=lll1I1ll(b,t.c,0.85)
local dot=llII1lII11("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-22,0.5,-7),BackgroundColor3=t.c,BorderSizePixel=0},b)
lllII1Il1(dot,7)
lII1I11Il[#lII1I11Il+1]={l1lll1lIIl=b,str=str,c=t.c}
end
for _,e in ipairs(lII1I11Il) do
lII1I11IlI(e.l1lll1lIIl.MouseButton1Click:Connect(function()
if lll1II1l1 then return end
ll1I1IIlII(e.c)
llI1lI11("acr",math.floor(e.c.R*255+0.5))
llI1lI11("acg",math.floor(e.c.G*255+0.5))
llI1lI11("acb",math.floor(e.c.B*255+0.5))
l1l11IllI()
end))
end
l1l11IllI()
local ut=lIlI1I11III(gP,string.char(85,116,105,108,105,116,121),204)
ut.Size=UDim2.new(1,-24,0,70)
local llIllII1l=nil
local function llI11llI(on)
if llIllII1l then pcall(function() llIllII1l:Disconnect() end) llIllII1l=nil end
if on and not lll1II1l1 then
llIllII1l=PLR.Idled:Connect(function()
if lll1II1l1 then return end
pcall(function()
VU:CaptureController()
VU:ClickButton2(Vector2.new())
end)
end)
end
end
lIIIIl1l(ut,"Anti AFK","Prevents idle kick",12,26,240,38,Cfg.afk,function(on)
llI1lI11("afk",on)
llI11llI(on)
end)
_init=false
task.spawn(function()
task.wait(1.5)
if lll1II1l1 then return end
ll1I111l()
l1l11IllI()
local gs=tonumber(Cfg.gs)
if gs then
local g=lII1ll1I("g","RemoteEvents","SetGameSpeed")
if g then pcall(function() g:FireServer(gs) end) end
end
if Cfg.lll1I1ll then lIlIlll=nil l1l1I1III1(true) end
if Cfg.rp then l1I1II1IlI() end
if Cfg.l11Il11 then lI1II11lI1() end
if Cfg.afk then llI11llI(true) end
if Cfg.rec and Cfg.sel~="" then
lI1I1lII()
ll11IIlll()
l1Ill1I(0)
lIIIIllIl=0
rec.active=true
lIlIIIIII1I(string.char(82,101,99,111,114,100,105,110,103))
if not l111I1l1 then l1l11I1l1() end
rToggle.SetValue(true)
elseif Cfg.rec then
Cfg.rec=false
l1ll1l1I()
lIlIIIIII1I(string.char(73,100,108,101))
rToggle.SetValue(false)
end
pToggle.SetValue(false)
if ll1l1lIlI then
print("[EZVC] Clipboard available: "..tostring(l1IIlllll))
else
print("[EZVC] WARNING: no clipboard function found")
end
end)
lll1lllII("Main")
rfC()
llI111l1ll1("EZVC","Ready v2.9")
print("[EZVC] v2.9 loaded | mode="..(l111I1l1 and lIIIlIl1I1 or "passive").." | clipboard="..tostring(l1IIlllll or "none"))