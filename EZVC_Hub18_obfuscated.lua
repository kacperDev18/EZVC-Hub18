local function __d(...) return string.char(...) end
local TS,UIS,RS,HS,PLR=game:GetService(__d(84,119,101,101,110,83,101,114,118,105,99,101)),game:GetService(__d(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101)),game:GetService(__d(82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101)),game:GetService(__d(72,116,116,112,83,101,114,118,105,99,101)),game:GetService(__d(80,108,97,121,101,114,115)).LocalPlayer
local FS={folder=(type(isfolder)==__d(102,117,110,99,116,105,111,110)and type(makefolder)==__d(102,117,110,99,116,105,111,110)),file=(type(isfile)==__d(102,117,110,99,116,105,111,110)and type(readfile)==__d(102,117,110,99,116,105,111,110)),write=type(writefile)==__d(102,117,110,99,116,105,111,110),list=type(listfiles)==__d(102,117,110,99,116,105,111,110),del=type(delfile)==__d(102,117,110,99,116,105,111,110)}
local FO=__d()
if FS.folder then for _,p in ipairs({__d(109,97,99,114,111,95,110,103,47),__d(116,100,109,97,99,114,111,47),__d(109,97,99,114,111,95,110,103),__d(116,100,109,97,99,114,111),__d(46,47),__d(46)})do pcall(function()makefolder(p)end)local ok,e=pcall(isfolder,p)if ok and e then if p:sub(-1)~=__d(47)and p~=__d(46)then p=p..__d(47)end FO=p break end end end
local CF=FO..__d(99,102,103,46,106,115,111,110)
local function wj(p,d)if not FS.write then return false end local ok,s=pcall(function()return HS:JSONEncode(d)end)if not ok then return false end local ok2=pcall(writefile,p,s)return ok2 end
local function rj(p)if not FS.file then return nil end local ok0,ex=pcall(isfile,p)if not ok0 or not ex then return nil end local ok,d=pcall(readfile,p)if not ok then return nil end local ok2,a=pcall(function()return HS:JSONDecode(d)end)if not ok2 or type(a)~=__d(116,97,98,108,101)then return nil end return a end
local function findConfigFile()if not FS.file then return nil end for _,p in ipairs({CF,__d(109,97,99,114,111,95,110,103,47,99,102,103,46,106,115,111,110),__d(116,100,109,97,99,114,111,47,99,102,103,46,106,115,111,110),__d(99,102,103,46,106,115,111,110)})do local ok,ex=pcall(isfile,p)if ok and ex then return p end end return nil end
local function findMacroPath(name)for _,p in ipairs({__d(109,97,99,114,111,95,110,103,47),__d(116,100,109,97,99,114,111,47),__d(46,47),FO,__d(109,97,99,114,111,95,110,103),__d(116,100,109,97,99,114,111)})do local base=p if base~=__d()and base:sub(-1)~=__d(47)then base=base..__d(47)end local full=base..name..__d(46,106,115,111,110)if FS.file then local ok,ex=pcall(isfile,full)if ok and ex then return full end end end return FO..name..__d(46,106,115,111,110)end
local DEF={sk=false,av=false,vm=__d(78,111,114,109,97,108),ag=false,mn=__d(),sel=__d(),pl=false,acr=155,acg=120,acb=255,gs=__d(49),rp=false,lb=false,rec=false,s10=false,s1=false,spn=false,afk=false,oc=false,crate=__d(70,114,101,101),ast=false,tpp=__d(84,111,105,108,101,116,32,67,105,116,121),elev=__d(84,111,105,108,101,116,32,67,105,116,121),al=false,alm=5,spd=1}
local Cfg={} local loadSource=__d(100,101,102,97,117,108,116,115)
if type(getgenv)==__d(102,117,110,99,116,105,111,110)then local ok,env=pcall(getgenv)if ok and type(env)==__d(116,97,98,108,101)and type(env.EZVC_Cfg)==__d(116,97,98,108,101)then for k,v in pairs(env.EZVC_Cfg)do Cfg[k]=v end loadSource=__d(103,101,116,103,101,110,118)end end
local cfgFile=findConfigFile()if cfgFile then local d=rj(cfgFile)if type(d)==__d(116,97,98,108,101)then for k,v in pairs(d)do Cfg[k]=v end CF=cfgFile loadSource=__d(102,105,108,101)end end
for k,v in pairs(DEF)do if Cfg[k]==nil then Cfg[k]=v end end
print(__d(91,69,90,86,67,93,32,67,111,110,102,105,103,58,32)..loadSource..__d(32,124,32)..CF)
local function sv()if type(getgenv)==__d(102,117,110,99,116,105,111,110)then pcall(function()local e=getgenv()if type(e)==__d(116,97,98,108,101)then e.EZVC_Cfg=Cfg end end)end if not FS.write then return true end local ok=wj(CF,Cfg)if not ok then for _,alt in ipairs({__d(109,97,99,114,111,95,110,103,47,99,102,103,46,106,115,111,110),__d(116,100,109,97,99,114,111,47,99,102,103,46,106,115,111,110),__d(99,102,103,46,106,115,111,110)})do if alt~=CF and wj(alt,Cfg)then CF=alt return true end end return false end return true end
local function set(k,v)Cfg[k]=v sv()end
local sel=Cfg.sel or__d()
local function lf()if not FS.list then return{}end local s,n={},{}for _,p in ipairs({__d(109,97,99,114,111,95,110,103,47),__d(116,100,109,97,99,114,111,47),__d(46,47),__d(109,97,99,114,111,95,110,103),__d(116,100,109,97,99,114,111)})do local ok,l=pcall(listfiles,p)if ok and type(l)==__d(116,97,98,108,101)then for _,f in ipairs(l)do local x=tostring(f):match(__d(40,91,94,47,92,93,43,41,37,46,106,115,111,110,36))if x and x~=__d(99,102,103)and x~=__d(99,111,110,102,105,103)and not s[x]then s[x]=true n[#n+1]=x end end end end return n end

local rec={a={},n=0,t={},k={},l=0,on=false,last=nil}
local pb={on=false,sess=0}
local unHook
local stopAutoSkip,stopAutoVote,stopAutoStart,stopAutoLeave

local function readMoney()
    local ls=PLR.leaderstats
    if not ls then return nil end
    local mv=ls.Money
    if not mv then return nil end
    return tonumber(mv.Value)or 0
end

local function readUnitPrice()
    local pg=PLR:FindFirstChild(__d(80,108,97,121,101,114,71,117,105))
    if not pg then return nil end
    local gui=pg:FindFirstChild(__d(71,97,109,101,85,73))
    if not gui then return nil end
    local tu=gui:FindFirstChild(__d(84,111,119,101,114,85,73))
    if tu then
        local b=tu:FindFirstChild(__d(66,117,116,116,111,110,115))
        if b then
            local pr=b:FindFirstChild(__d(80,114,105,99,101))
            if pr then
                local n=tonumber(tostring(pr.Text):match(__d(37,100,43)))
                if n then return n end
            end
        end
    end
    return nil
end

local moneyLabel,lastMoney=nil,nil
local function updateMoneyLabel()
    if not moneyLabel or not moneyLabel.Parent then return end
    local m=readMoney()
    if m==nil then moneyLabel.Text=__d(77,111,110,101,121,58,32,63)return end
    if m~=lastMoney then lastMoney=m moneyLabel.Text=__d(77,111,110,101,121,58,32,36)..m end
end

local BG,SF,HD,PN,EL,BR,TX,SB,MT,OFF=Color3.fromRGB(16,16,20),Color3.fromRGB(22,22,27),Color3.fromRGB(26,26,32),Color3.fromRGB(30,30,36),Color3.fromRGB(38,38,45),Color3.fromRGB(52,52,60),Color3.fromRGB(238,238,244),Color3.fromRGB(150,150,162),Color3.fromRGB(98,98,110),Color3.fromRGB(52,52,60)
local MONEY_COL=Color3.fromRGB(80,220,120)
local AC=Color3.fromRGB(tonumber(Cfg.acr)or 155,tonumber(Cfg.acg)or 120,tonumber(Cfg.acb)or 255)
local par pcall(function()if gethui then local ok,h=pcall(gethui)if ok and h then par=h end end end)par=par or game:GetService(__d(67,111,114,101,71,117,105))
for _,v in ipairs(par:GetChildren())do if v.Name==__d(69,90,86,67,77,97,99,114,111,65,84,68)or v.Name==__d(69,90,86,67,72,85,66)or v.Name==__d(69,90,86,67,72,85,66,98,101,116,97)then pcall(function()v:Destroy()end)end end
local sg=Instance.new(__d(83,99,114,101,101,110,71,117,105))sg.Name=__d(69,90,86,67,72,85,66)sg.IgnoreGuiInset=true sg.ResetOnSpawn=false sg.DisplayOrder=999 sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling sg.Parent=par

local function mk(c,p,r)local o=Instance.new(c)for k,v in next,p do o[k]=v end if r then o.Parent=r end return o end
local function cr(o,r)mk(__d(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,r)},o)end
local function sk(o,c,t)return mk(__d(85,73,83,116,114,111,107,101),{Color=c,Thickness=1,Transparency=t},o)end
local function lb(p,t,x,y,w,h,c,s,b)return mk(__d(84,101,120,116,76,97,98,101,108),{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundTransparency=1,Font=b and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=s or 11,TextColor3=c,TextXAlignment=Enum.TextXAlignment.Left,Text=t},p)end
local tR={}
local function rT(p,f,prop)tR[#tR+1]={p=p,f=f,prop=prop or__d(66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51)}return p end
local function setAC(c)AC=c for i=#tR,1,-1 do local e=tR[i]if not e.p or not e.p.Parent then table.remove(tR,i)else local v=e.f and e.f()or c pcall(function()TS:Create(e.p,TweenInfo.new(0.28,Enum.EasingStyle.Quart),{[e.prop]=v}):Play()end)end end end
local function iA()for _,e in ipairs(tR)do if e.p and e.p.Parent then local v=e.f and e.f()or AC pcall(function()e.p[e.prop]=v end)end end end

local win=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(420,300),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=BG,BorderSizePixel=0},sg)cr(win,12)
local wS=sk(win,BR,0.35)
pcall(function()local cam=workspace.CurrentCamera if cam then local function fit()local vp=cam.ViewportSize if vp.X>0 and vp.Y>0 then win.Size=UDim2.fromOffset(math.clamp(math.floor(vp.X*0.92),300,460),math.clamp(math.floor(vp.Y*0.78),260,340))win.Position=UDim2.new(0.5,0,0.5,0)end end fit()cam:GetPropertyChangedSignal(__d(86,105,101,119,112,111,114,116,83,105,122,101)):Connect(fit)end end)
local hdr=mk(__d(70,114,97,109,101),{Size=UDim2.new(1,0,0,38),BackgroundColor3=HD,BorderSizePixel=0},win)cr(hdr,12)
mk(__d(70,114,97,109,101),{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=HD,BorderSizePixel=0},hdr)
local aD=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(10,10),Position=UDim2.new(0,14,0.5,-5),BackgroundColor3=AC,BorderSizePixel=0},hdr)cr(aD,3)rT(aD)
lb(hdr,__d(69,90,86,67,32,72,85,66),30,0,140,38,TX,13,true)lb(hdr,__d(118,50,46,51,53),125,0,90,38,MT,9,false)
local xb=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-30,0.5,-12),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=SB,Text=__d(88),AutoButtonColor=false},hdr)cr(xb,6)
xb.MouseEnter:Connect(function()TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,90,90),TextColor3=Color3.new(1,1,1)}):Play()end)
xb.MouseLeave:Connect(function()TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=EL,TextColor3=SB}):Play()end)
do local dg,d0,d1=false,nil,nil
hdr.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true d0=i.Position d1=win.Position end end)
UIS.InputChanged:Connect(function(i)if dg and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-d0 win.Position=UDim2.new(d1.X.Scale,d1.X.Offset+d.X,d1.Y.Scale,d1.Y.Offset+d.Y)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)end

local body=mk(__d(70,114,97,109,101),{Size=UDim2.new(1,0,1,-38),Position=UDim2.new(0,0,0,38),BackgroundTransparency=1},win)
local sB=mk(__d(70,114,97,109,101),{Size=UDim2.new(0,118,1,0),BackgroundColor3=SF,BorderSizePixel=0},body)
mk(__d(70,114,97,109,101),{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=BR,BackgroundTransparency=0.4,BorderSizePixel=0},sB)
local ct=mk(__d(70,114,97,109,101),{Size=UDim2.new(1,-118,1,0),Position=UDim2.new(0,118,0,0),BackgroundTransparency=1},body)
local aL=mk(__d(70,114,97,109,101),{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),BackgroundColor3=AC,BorderSizePixel=0,ZIndex=10},body)rT(aL)
local pages,tabs,tInd,cur={},{},{},nil
local function go(n)if cur==n then return end for k,p in pairs(pages)do if k==n then p.Visible=true p.Position=UDim2.new(0,5,0,0)TS:Create(p,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)}):Play()else p.Visible=false end end for k,b in pairs(tabs)do if k==n then TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=EL,TextColor3=AC}):Play()if tInd[k]then TS:Create(tInd[k],TweenInfo.new(0.22),{BackgroundTransparency=0}):Play()end else TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=SF,TextColor3=MT}):Play()if tInd[k]then TS:Create(tInd[k],TweenInfo.new(0.22),{BackgroundTransparency=1}):Play()end end end cur=n end
do for i,n in ipairs({__d(77,97,105,110),__d(80,108,97,121),__d(77,97,99,114,111),__d(71,85,73)})do local b=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,-16,0,28),Position=UDim2.new(0,8,0,10+(i-1)*32),BackgroundColor3=SF,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=MT,Text=__d(32,32)..n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},sB)cr(b,6)local ind=mk(__d(70,114,97,109,101),{Size=UDim2.new(0,3,1,-16),Position=UDim2.new(0,3,0,8),BackgroundColor3=AC,BorderSizePixel=0,BackgroundTransparency=1},b)cr(ind,2)rT(ind)tInd[n]=ind b.MouseButton1Click:Connect(function()go(n)end)tabs[n]=b rT(b,function()return(cur==n)and AC or MT end,__d(84,101,120,116,67,111,108,111,114,51))end end
do local sc={Color3.fromRGB(155,120,255),Color3.fromRGB(220,96,96),Color3.fromRGB(108,142,255),Color3.fromRGB(90,196,140),Color3.fromRGB(240,150,60),Color3.fromRGB(230,120,180),Color3.fromRGB(0,200,220),Color3.fromRGB(230,200,90)}
for i,c in ipairs(sc)do local s=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.fromOffset(12,12),Position=UDim2.new(0,8+(i-1)*13,1,-20),BackgroundColor3=c,BorderSizePixel=0,Text=__d(),AutoButtonColor=false},sB)cr(s,6)s.MouseButton1Click:Connect(function()setAC(c)Cfg.acr=math.floor(c.R*255+0.5)Cfg.acg=math.floor(c.G*255+0.5)Cfg.acb=math.floor(c.B*255+0.5)sv()if _sT then _sT()end end)end end

local function pg(n)local s=mk(__d(83,99,114,111,108,108,105,110,103,70,114,97,109,101),{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=EL,CanvasSize=UDim2.new(0,0,0,900),Visible=false},ct)pages[n]=s return s end
local function cd(p,t,y)local f=mk(__d(70,114,97,109,101),{Size=UDim2.new(1,-24,0,0),Position=UDim2.new(0,12,0,y),BackgroundColor3=PN,BorderSizePixel=0},p)cr(f,8)sk(f,BR,0.4)if t then local d=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,10,0,14),BackgroundColor3=AC,BorderSizePixel=0},f)cr(d,2)rT(d)local tL=lb(f,string.upper(t),20,10,200,12,AC,10,true)rT(tL,nil,__d(84,101,120,116,67,111,108,111,114,51))end return f end
local function bt(p,t,x,y,w,h,k,cb)local o=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,Text=t,AutoButtonColor=false},p)if k==__d(112)then o.BackgroundColor3=AC o.TextColor3=Color3.new(1,1,1)elseif k==__d(100)then o.BackgroundColor3=Color3.fromRGB(56,34,34)o.TextColor3=Color3.fromRGB(230,150,150)else o.BackgroundColor3=EL o.TextColor3=TX end cr(o,6)if k==__d(112)then rT(o)end o.MouseEnter:Connect(function()TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=o.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play()end)o.MouseLeave:Connect(function()local tg2=EL if k==__d(112)then tg2=AC end if k==__d(100)then tg2=Color3.fromRGB(56,34,34)end TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=tg2}):Play()end)if cb then o.MouseButton1Click:Connect(cb)end return o end
local function tg(p,nm,ds,x,y,w,h,on,cb)local bx=mk(__d(70,114,97,109,101),{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundColor3=EL,BorderSizePixel=0},p)cr(bx,6)if ds then lb(bx,nm,10,5,w-50,14,TX,11,false)lb(bx,ds,10,20,w-50,11,SB,9,false)else lb(bx,nm,10,0,w-50,h,TX,11,false)end local st=on and true or false local sw=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-44,0.5,-9),BackgroundColor3=st and AC or OFF,BorderSizePixel=0},bx)cr(sw,9)local kn=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(12,12),Position=st and UDim2.new(1,-15,0.5,-6)or UDim2.new(0,3,0.5,-6),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw)cr(kn,6)rT(sw,function()return st and AC or OFF end)local function ap(v)st=v and true or false pcall(function()TS:Create(sw,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{BackgroundColor3=st and AC or OFF}):Play()TS:Create(kn,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{Position=st and UDim2.new(1,-15,0.5,-6)or UDim2.new(0,3,0.5,-6)}):Play()end)end local z=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=__d(),AutoButtonColor=false},bx)z.MouseButton1Click:Connect(function()ap(not st)if cb then cb(st)end end)return{GetValue=function()return st end,SetValue=function(v)ap(v)end}end
local function N(t,c)local nf=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(220,50),Position=UDim2.new(1,-230,1,-70),BackgroundColor3=PN,BorderSizePixel=0,ZIndex=50},sg)cr(nf,8)local ns=sk(nf,AC,0.3)local t1=lb(nf,t,12,8,180,16,AC,11,true)t1.ZIndex=51 local t2=lb(nf,c,12,26,196,18,SB,10,false)t2.ZIndex=51 nf.BackgroundTransparency=1 ns.Transparency=1 TS:Create(nf,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()TS:Create(ns,TweenInfo.new(0.2),{Transparency=0.3}):Play()task.delay(3,function()if not nf or not nf.Parent then return end TS:Create(nf,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()TS:Create(ns,TweenInfo.new(0.3),{Transparency=1}):Play()TS:Create(t1,TweenInfo.new(0.3),{TextTransparency=1}):Play()TS:Create(t2,TweenInfo.new(0.3),{TextTransparency=1}):Play()task.delay(0.35,function()pcall(function()nf:Destroy()end)end)end)end

local stB=mk(__d(70,114,97,109,101),{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),BackgroundColor3=SF,BorderSizePixel=0},win)
local stD=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,11,0.5,-2),BackgroundColor3=AC,BorderSizePixel=0},stB)cr(stD,3)rT(stD)
local stL=lb(stB,__d(80,108,97,99,101,32,48,32,124,32,85,112,103,114,97,100,101,32,48,32,124,32,83,101,108,108,32,48),22,0,180,18,MT,9,false)
moneyLabel=lb(stB,__d(77,111,110,101,121,58,32,36,63),200,0,180,18,MONEY_COL,10,true)
game:GetService(__d(82,117,110,83,101,114,118,105,99,101)).Heartbeat:Connect(updateMoneyLabel)

local vis=true
local fl=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.fromOffset(78,34),Position=UDim2.new(0,16,0,16),BackgroundColor3=HD,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TX,Text=__d(84,111,103,103,108,101),AutoButtonColor=false,ZIndex=30},sg)cr(fl,17)
local fS=sk(fl,AC,0.4)rT(fS,nil,__d(67,111,108,111,114))
local fd=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,10,0.5,-4),BackgroundColor3=AC,BorderSizePixel=0},fl)cr(fd,4)rT(fd)
do local fDg,fM,f0,f1=false,false,nil,nil
fl.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fDg=true fM=false f0=i.Position f1=fl.Position end end)
UIS.InputChanged:Connect(function(i)if fDg and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-f0 if math.abs(d.X)>4 or math.abs(d.Y)>4 then fM=true end fl.Position=UDim2.new(f1.X.Scale,f1.X.Offset+d.X,f1.Y.Scale,f1.Y.Offset+d.Y)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fDg=false end end)
fl.MouseButton1Click:Connect(function()if fM then return end vis=not vis
if vis then win.Visible=true win.BackgroundTransparency=1 wS.Transparency=1 TS:Create(win,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()TS:Create(wS,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.35}):Play()TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=AC}):Play()
else TS:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()TS:Create(wS,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency=1}):Play()task.delay(0.3,function()if not vis then win.Visible=false end end)TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=MONEY_COL}):Play()end end)end

local _sD,_dlg
local function killD(inst)if not _dlg then return end if inst then pcall(function()_dlg:Destroy()end)pcall(function()_sD:Destroy()end)_dlg=nil _sD=nil return end local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In)local items={_dlg,_sD}for _,c in ipairs(_dlg:GetDescendants())do items[#items+1]=c end for _,el in ipairs(items)do if el and el:IsA(__d(84,101,120,116,76,97,98,101,108))then TS:Create(el,ti,{TextTransparency=1}):Play()elseif el and el:IsA(__d(84,101,120,116,66,117,116,116,111,110))then TS:Create(el,ti,{BackgroundTransparency=1,TextTransparency=1}):Play()elseif el and el:IsA(__d(85,73,83,116,114,111,107,101))then TS:Create(el,ti,{Transparency=1}):Play()elseif el and el:IsA(__d(70,114,97,109,101))then TS:Create(el,ti,{BackgroundTransparency=1}):Play()end end task.delay(0.28,function()pcall(function()_dlg:Destroy()end)pcall(function()_sD:Destroy()end)_dlg=nil _sD=nil end)end
do local function ask()killD(true)_sD=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0,Text=__d(),AutoButtonColor=false,ZIndex=40},sg)_dlg=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(280,130),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=PN,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=41},sg)cr(_dlg,10)local ds=sk(_dlg,BR,1)local dt=lb(_dlg,__d(67,108,111,115,101,32,71,85,73),14,14,250,20,TX,14,true)dt.TextTransparency=1 dt.ZIndex=42 local dm=mk(__d(84,101,120,116,76,97,98,101,108),{Size=UDim2.new(1,-28,0,40),Position=UDim2.new(0,14,0,40),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=SB,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text=__d(67,108,111,115,101,32,71,85,73,63),TextTransparency=1,ZIndex=42},_dlg)local nb=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0,14,1,-46),BackgroundColor3=EL,BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=TX,TextTransparency=1,Text=__d(78,111),AutoButtonColor=false,ZIndex=42},_dlg)cr(nb,6)local yb=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0.5,6,1,-46),BackgroundColor3=Color3.fromRGB(180,70,70),BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.new(1,1,1),TextTransparency=1,Text=__d(89,101,115),AutoButtonColor=false,ZIndex=42},_dlg)cr(yb,6)local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)TS:Create(_sD,ti,{BackgroundTransparency=0.5}):Play()TS:Create(_dlg,ti,{BackgroundTransparency=0}):Play()TS:Create(ds,ti,{Transparency=0.3}):Play()TS:Create(dt,ti,{TextTransparency=0}):Play()TS:Create(dm,ti,{TextTransparency=0}):Play()TS:Create(nb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()TS:Create(yb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()nb.MouseButton1Click:Connect(function()killD(false)end)yb.MouseButton1Click:Connect(function()pcall(function()if rec and rec.on then rec.on=false end end)pcall(function()if unHook then unHook()end end)pcall(function()if pb then pb.on=false end end)pcall(function()if stopAutoSkip then stopAutoSkip()end end)pcall(function()if stopAutoVote then stopAutoVote()end end)pcall(function()if stopAutoStart then stopAutoStart()end end)pcall(function()if stopAutoLeave then stopAutoLeave()end end)pcall(sv)pcall(function()sg:Destroy()end)end)end
xb.MouseButton1Click:Connect(ask)end

local function getRF()local ml=RS:FindFirstChild(__d(77,111,100,117,108,101,76,111,97,100,101,114))if not ml then return nil end local sh=ml:FindFirstChild(__d(83,104,97,114,101,100))if not sh then return nil end local nw=sh:FindFirstChild(__d(78,101,116,119,111,114,107))if not nw then return nil end return nw:FindFirstChild(__d(82,101,109,111,116,101,69,118,101,110,116))end
local REM,UP_REMS,SELL_REMS,PLACE_REMS={},{},{},{}
local function tryPath(...)local cur=RS for _,name in ipairs({...})do cur=cur:FindFirstChild(name)if not cur then return nil end end return cur end
local function findRemotesFor(kind)local list={}local c={}if kind==__d(85)then c={{__d(77,111,100,117,108,101,76,111,97,100,101,114),__d(83,104,97,114,101,100),__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(84,111,119,101,114,85,112,103,114,97,100,101)},{__d(70,117,110,99,116,105,111,110,115),__d(85,112,103,114,97,100,101,84,111,119,101,114)},{__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110,115),__d(85,112,103,114,97,100,101,84,111,119,101,114)},{__d(82,101,109,111,116,101,115),__d(85,112,103,114,97,100,101,84,111,119,101,114)},{__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(84,111,119,101,114,85,112,103,114,97,100,101)}}elseif kind==__d(83)then c={{__d(77,111,100,117,108,101,76,111,97,100,101,114),__d(83,104,97,114,101,100),__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(84,111,119,101,114,83,101,108,108)},{__d(70,117,110,99,116,105,111,110,115),__d(83,101,108,108,84,111,119,101,114)},{__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110,115),__d(83,101,108,108,84,111,119,101,114)},{__d(82,101,109,111,116,101,115),__d(83,101,108,108,84,111,119,101,114)},{__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(84,111,119,101,114,83,101,108,108)}}elseif kind==__d(80)then c={{__d(77,111,100,117,108,101,76,111,97,100,101,114),__d(83,104,97,114,101,100),__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(84,111,119,101,114,65,100,100)},{__d(70,117,110,99,116,105,111,110,115),__d(80,108,97,99,101,84,111,119,101,114)},{__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110,115),__d(80,108,97,99,101,84,111,119,101,114)},{__d(82,101,109,111,116,101,115),__d(80,108,97,99,101,84,111,119,101,114)},{__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(84,111,119,101,114,65,100,100)}}end for _,p in ipairs(c)do local r=tryPath(unpack(p))if r then table.insert(list,r)end end return list end
local function rRem()local f=getRF()if f then REM.Add=f:FindFirstChild(__d(84,111,119,101,114,65,100,100))REM.Up=f:FindFirstChild(__d(84,111,119,101,114,85,112,103,114,97,100,101))REM.Sell=f:FindFirstChild(__d(84,111,119,101,114,83,101,108,108))REM.Skip=f:FindFirstChild(__d(87,97,118,101,83,107,105,112))REM.Vote=f:FindFirstChild(__d(77,111,100,101,86,111,116,101))end UP_REMS=findRemotesFor(__d(85))SELL_REMS=findRemotesFor(__d(83))PLACE_REMS=findRemotesFor(__d(80))return REM.Add and REM.Up and REM.Sell end
rRem()

local function applySpeed(n)
    n=tonumber(n)or tonumber(Cfg.spd)or 1
    local rf=RS:FindFirstChild(__d(77,111,100,117,108,101,76,111,97,100,101,114))
    if not rf then warn(__d(91,69,90,86,67,93,32,77,111,100,117,108,101,76,111,97,100,101,114,32,109,105,115,115,105,110,103))return false end
    rf=rf:FindFirstChild(__d(83,104,97,114,101,100))
    if not rf then warn(__d(91,69,90,86,67,93,32,83,104,97,114,101,100,32,109,105,115,115,105,110,103))return false end
    rf=rf:FindFirstChild(__d(78,101,116,119,111,114,107))
    if not rf then warn(__d(91,69,90,86,67,93,32,78,101,116,119,111,114,107,32,109,105,115,115,105,110,103))return false end
    rf=rf:FindFirstChild(__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110))
    if not rf then warn(__d(91,69,90,86,67,93,32,82,101,109,111,116,101,70,117,110,99,116,105,111,110,32,109,105,115,115,105,110,103))return false end
    rf=rf:FindFirstChild(__d(67,104,97,110,103,101,83,112,101,101,100))
    if not rf then warn(__d(91,69,90,86,67,93,32,67,104,97,110,103,101,83,112,101,101,100,32,109,105,115,115,105,110,103))return false end
    local ok,err=pcall(function() rf:InvokeServer(n) end)
    if not ok then warn(__d(91,69,90,86,67,93,32,67,104,97,110,103,101,83,112,101,101,100,32,101,114,114,58,32)..tostring(err))return false end
    print(__d(91,69,90,86,67,93,32,83,112,101,101,100,32,61,32)..tostring(n))
    return true
end
local function setSpeed(n)Cfg.spd=n sv()print(__d(91,69,90,86,67,93,32,115,97,118,101,100,32,115,112,100,61)..tostring(n))applySpeed(n)end

local function looksLikeUuid(s)if type(s)~=__d(115,116,114,105,110,103)then return false end if #s<30 or #s>50 then return false end if not s:find(__d(45))then return false end if s:match(__d(94,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,45,37,120,37,120,37,120,37,120,37,45,37,120,37,120,37,120,37,120,37,45,37,120,37,120,37,120,37,120,37,45,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,120,37,120,36))then return true end local hex,other=0,0 for i=1,#s do local c=s:sub(i,i)if c:match(__d(37,120))then hex=hex+1 elseif c==__d(45)then else other=other+1 end end if other>2 then return false end return hex>=#s-4 end
local function extId(o)if not o then return nil end if looksLikeUuid(o.Name)then return o.Name end local KN={__d(73,100),__d(73,68),__d(85,110,105,116,73,100),__d(85,85,73,68),__d(117,105,100),__d(73,110,115,116,97,110,99,101,73,100),__d(71,85,73,68),__d(85,110,105,116,73,68),__d(84,111,119,101,114,73,100),__d(80,108,97,99,101,109,101,110,116,73,100),__d(84,111,119,101,114,73,68),__d(95,105,100),__d(95,95,105,100),__d(95,117,117,105,100),__d(95,73,100)}for _,a in ipairs(KN)do local ok,v=pcall(function()return o:GetAttribute(a)end)if ok and v~=nil then return v end end for _,a in ipairs(o:GetAttributes())do local v=o:GetAttribute(a)if looksLikeUuid(v)then return v end end for _,a in ipairs(KN)do local c=o:FindFirstChild(a)if c and(c:IsA(__d(83,116,114,105,110,103,86,97,108,117,101))or c:IsA(__d(73,110,116,86,97,108,117,101))or c:IsA(__d(78,117,109,98,101,114,86,97,108,117,101)))then return c.Value end end for _,d in ipairs(o:GetDescendants())do if d:IsA(__d(83,116,114,105,110,103,86,97,108,117,101))and looksLikeUuid(d.Value)then return d.Value end end return nil end
local function getTowersFolder()return workspace:FindFirstChild(__d(84,111,119,101,114,115))end
local function findTowerById(id)if id==nil then return nil end local tw=getTowersFolder()if not tw then return nil end local ids=tostring(id)for _,o in ipairs(tw:GetChildren())do local oid=extId(o)if oid~=nil and tostring(oid)==ids then return o end end return nil end
local function findTowerByPosNear(pos,tol)local tw=getTowersFolder()if not tw then return nil end local best,bestD=nil,tol or 5 for _,o in ipairs(tw:GetChildren())do local ok,pv=pcall(function()return o:GetPivot().Position end)if ok and pv then local d=(pv-pos).Magnitude if d<bestD then bestD=d best=o end end end return best end
local function getTowerName(t)if not t then return__d(63)end for _,a in ipairs({__d(85,110,105,116,78,97,109,101),__d(84,111,119,101,114,78,97,109,101),__d(84,121,112,101),__d(85,110,105,116),__d(85,110,105,116,84,121,112,101),__d(84,111,119,101,114)})do local ok,v=pcall(function()return t:GetAttribute(a)end)if ok and type(v)==__d(115,116,114,105,110,103)and v~=__d()then return v end end for _,c in ipairs(t:GetChildren())do if c:IsA(__d(83,116,114,105,110,103,86,97,108,117,101))and(c.Name:lower():find(__d(116,121,112,101))or c.Name:lower():find(__d(110,97,109,101)))then if c.Value~=__d()then return c.Value end end end return t.Name end
local function isModel(o)local ok=pcall(function()return o:IsA(__d(77,111,100,101,108))end)return ok and o:IsA(__d(77,111,100,101,108))end
local function captureNewTower(pos,known,timeout)local deadline=tick()+timeout local found,fid=nil,nil local conn=workspace.DescendantAdded:Connect(function(o)if found then return end if not isModel(o)then return end if known[o]then return end local ok,pv=pcall(function()return o:GetPivot().Position end)if ok and(pv-pos).Magnitude<25 then found=o fid=extId(o)end end)while tick()<deadline and not found do local tw=getTowersFolder()if tw then for _,o in ipairs(tw:GetChildren())do if not known[o]and not found then local ok,pv=pcall(function()return o:GetPivot().Position end)if ok and(pv-pos).Magnitude<25 then found=o fid=extId(o)end end end end if found then break end task.wait(0.01)end pcall(function()conn:Disconnect()end)return found,fid end
local function snapshotTowers()local s={}local tw=getTowersFolder()if tw then for _,o in ipairs(tw:GetChildren())do s[o]=true end end return s end

local hInst,hOld,hookMethodUsed,hits=false,nil,nil,0
local function callR(fn,args)if not fn then return nil end if fn:IsA(__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110))then local ok,res=pcall(function()return fn:InvokeServer(args)end)if ok then return res end else local ok=pcall(function()fn:FireServer(args)end)if ok then return true end end return nil end
local function classifyRemote(self)local ok,nm=pcall(function()return self.Name end)if ok and type(nm)==__d(115,116,114,105,110,103)then if nm==__d(84,111,119,101,114,65,100,100)or nm==__d(80,108,97,99,101,84,111,119,101,114)then return__d(80)end if nm==__d(84,111,119,101,114,85,112,103,114,97,100,101)or nm==__d(85,112,103,114,97,100,101,84,111,119,101,114)then return__d(85)end if nm==__d(84,111,119,101,114,83,101,108,108)or nm==__d(83,101,108,108,84,111,119,101,114)then return__d(83)end end if self==REM.Add then return__d(80)end if self==REM.Up then return__d(85)end if self==REM.Sell then return__d(83)end for _,r in ipairs(UP_REMS)do if self==r then return__d(85)end end for _,r in ipairs(SELL_REMS)do if self==r then return__d(83)end end return nil end
local function tryUpgrade(gid,inst)local gs=gid~=nil and tostring(gid)or nil for _,rem in ipairs(UP_REMS)do if rem and rem.Parent then if rem:IsA(__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110))then if inst then local ok=pcall(function()return rem:InvokeServer(inst)end)if ok then return true end end if gs then local ok=pcall(function()return rem:InvokeServer({Id=gs})end)if ok then return true end end elseif rem:IsA(__d(82,101,109,111,116,101,69,118,101,110,116))then if gs then local ok=pcall(function()rem:FireServer({Id=gs})end)if ok then return true end end if inst then local ok=pcall(function()rem:FireServer(inst)end)if ok then return true end end end end end return false end
local function trySell(gid,inst)local gs=gid~=nil and tostring(gid)or nil for _,rem in ipairs(SELL_REMS)do if rem and rem.Parent then if rem:IsA(__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110))then if inst then local ok=pcall(function()return rem:InvokeServer(inst)end)if ok then return true end end if gs then local ok=pcall(function()return rem:InvokeServer({Id=gs})end)if ok then return true end end elseif rem:IsA(__d(82,101,109,111,116,101,69,118,101,110,116))then if gs then local ok=pcall(function()rem:FireServer({Id=gs})end)if ok then return true end end if inst then local ok=pcall(function()rem:FireServer(inst)end)if ok then return true end end end end end return false end

local function recCall(self,m,args,moneyBefore)
    local kind=classifyRemote(self)
    if not kind then return end
    hits=hits+1
    if kind==__d(80)then
        local d=args[1]
        if type(d)==__d(116,97,98,108,101)and d.CFrame and d.Pos then
            rec.n=rec.n+1
            local sid=rec.n
            local cf=d.CFrame
            local ps=d.Pos
            local tk=tick()
            local delay=tk-(rec.l~=0 and rec.l or tk)
            rec.l=tk
            local idx=#rec.a+1
            local priceGui=readUnitPrice()
            table.insert(rec.a,{t=__d(80),sid=sid,unitId=d.UnitId,name=d.Name,cf={cf:GetComponents()},pos={ps.X,ps.Y,ps.Z},d=delay,cost=priceGui})
            print(__d(91,69,90,86,67,93,32,114,101,99,32,80,76,65,67,69,32,35)..sid..__d(32,103,117,105,67,111,115,116,61)..tostring(priceGui)..__d(32,109,66,61)..tostring(moneyBefore))
            task.spawn(function()
                task.wait(0.8)
                local mA=readMoney()
                if moneyBefore and mA and mA<moneyBefore and rec.a[idx]then
                    local diff=moneyBefore-mA
                    rec.a[idx].cost=diff
                    print(__d(91,69,90,86,67,93,32,114,101,99,32,80,32,99,111,115,116,61)..diff..__d(32,40,109,111,110,101,121,32,100,105,102,102,41))
                end
            end)
            local known=snapshotTowers()
            task.spawn(function()local u,gid=captureNewTower(ps,known,5)if u and gid~=nil then rec.k[__d(105,100,58)..tostring(gid)]=sid end if u then rec.t[sid]=u rec.k[u]=sid rec.last=u end if _cL then _cL()end end)
        end
    elseif kind==__d(85)then
        local d=args[1]
        if type(d)==__d(116,97,98,108,101)and d.Id~=nil then
            local idStr=tostring(d.Id)
            local sid=rec.k[__d(105,100,58)..idStr]
            if not sid then local tw=findTowerById(d.Id)if tw then sid=rec.k[tw]end end
            if not sid then for i=#rec.a,1,-1 do if rec.a[i].t==__d(80)and rec.a[i].sid and not rec.a[i].upgraded then sid=rec.a[i].sid rec.a[i].upgraded=true break end end end
            if sid then
                local nm,ps=nil,nil
                local tw=rec.t[sid]
                if tw and tw.Parent then nm=getTowerName(tw)local ok2,pv=pcall(function()return tw:GetPivot().Position end)if ok2 and pv then ps={pv.X,pv.Y,pv.Z}end end
                local tk=tick()
                local delay=tk-(rec.l~=0 and rec.l or tk)
                rec.l=tk
                local idx=#rec.a+1
                local priceGui=readUnitPrice()
                table.insert(rec.a,{t=__d(85),sid=sid,origId=idStr,name=nm,pos=ps,d=delay,cost=priceGui})
                print(__d(91,69,90,86,67,93,32,114,101,99,32,85,80,71,82,65,68,69,32,115,105,100,61)..sid..__d(32,103,117,105,67,111,115,116,61)..tostring(priceGui)..__d(32,109,66,61)..tostring(moneyBefore))
                task.spawn(function()
                    task.wait(0.8)
                    local mA=readMoney()
                    if moneyBefore and mA and mA<moneyBefore and rec.a[idx]then
                        local diff=moneyBefore-mA
                        rec.a[idx].cost=diff
                        print(__d(91,69,90,86,67,93,32,114,101,99,32,85,32,99,111,115,116,61)..diff..__d(32,40,109,111,110,101,121,32,100,105,102,102,41))
                    end
                end)
            end
        end
    elseif kind==__d(83)then
        local d=args[1]
        if type(d)==__d(116,97,98,108,101)and d.Id~=nil then
            local idStr=tostring(d.Id)
            local sid=rec.k[__d(105,100,58)..idStr]
            if not sid then local tw=findTowerById(d.Id)if tw then sid=rec.k[tw]end end
            if sid then
                local nm,ps=nil,nil
                local tw=rec.t[sid]
                if tw and tw.Parent then nm=getTowerName(tw)local ok2,pv=pcall(function()return tw:GetPivot().Position end)if ok2 and pv then ps={pv.X,pv.Y,pv.Z}end end
                local tk=tick()
                local delay=tk-(rec.l~=0 and rec.l or tk)
                rec.l=tk
                table.insert(rec.a,{t=__d(83),sid=sid,origId=idStr,name=nm,pos=ps,d=delay})
                print(__d(91,69,90,86,67,93,32,114,101,99,32,83,69,76,76,32,115,105,100,61)..sid)
            end
        end
    end
end

local function hBd(self,...)
    if not rec.on then return hOld(self,...)end
    if not REM.Add or not REM.Add.Parent then rRem()end
    local kind=classifyRemote(self)
    if not kind then return hOld(self,...)end
    local m=getnamecallmethod and getnamecallmethod()or__d()
    if m~=__d(70,105,114,101,83,101,114,118,101,114)and m~=__d(73,110,118,111,107,101,83,101,114,118,101,114)then return hOld(self,...)end
    local a={...}
    -- CRITICAL: read money BEFORE FireServer
    local moneyBefore=readMoney()
    local r=hOld(self,...)
    pcall(recCall,self,m,a,moneyBefore)
    return r
end

local function inHook()if hInst then return true end if type(hookmetamethod)==__d(102,117,110,99,116,105,111,110)and type(newcclosure)==__d(102,117,110,99,116,105,111,110)then local ok=pcall(function()hOld=hookmetamethod(game,__d(95,95,110,97,109,101,99,97,108,108),newcclosure(hBd))end)if ok and hOld then hInst=true hookMethodUsed=__d(104,109)return true end end if type(getrawmetatable)==__d(102,117,110,99,116,105,111,110)and type(setreadonly)==__d(102,117,110,99,116,105,111,110)and type(newcclosure)==__d(102,117,110,99,116,105,111,110)then local ok=pcall(function()local mt=getrawmetatable(game)hOld=mt.__namecall setreadonly(mt,false)mt.__namecall=newcclosure(hBd)setreadonly(mt,true)end)if ok and hOld then hInst=true hookMethodUsed=__d(103,114,109)return true end end return false end
unHook=function()if not hInst then return end hInst=false if hookMethodUsed==__d(104,109)and type(hookmetamethod)==__d(102,117,110,99,116,105,111,110)then pcall(function()hookmetamethod(game,__d(95,95,110,97,109,101,99,97,108,108),hOld)end)else pcall(function()local mt=getrawmetatable(game)setreadonly(mt,false)mt.__namecall=hOld setreadonly(mt,true)end)end hOld=nil hookMethodUsed=nil end

local C={P=0,U=0,S=0}
local function play()
    if pb.on then return end
    pb.on=true pb.sess=pb.sess+1 local ms=pb.sess
    local path=findMacroPath(sel)
    local data=rj(path)
    if type(data)~=__d(116,97,98,108,101)or #data==0 then pb.on=false N(__d(77,97,99,114,111),__d(77,97,99,114,111,32,101,109,112,116,121))return end
    print(__d(91,69,90,86,67,93,32,112,108,97,121,32,83,84,65,82,84,32)..#data)
    C.P=0 C.U=0 C.S=0
    if not rRem()then N(__d(77,97,99,114,111),__d(82,101,109,111,116,101,115,32,110,111,116,32,102,111,117,110,100))pb.on=false return end
    local sidToInst={}
    task.spawn(function()
        N(__d(69,90,86,67),__d(80,108,97,121,98,97,99,107,32,115,116,97,114,116,101,100))
        for idx,a in ipairs(data)do
            if not pb.on or pb.sess~=ms then break end
            print(__d(91,69,90,86,67,93,32,112,108,97,121,32)..idx..__d(47)..#data..__d(32,116,121,112,101,61)..tostring(a.t)..__d(32,99,111,115,116,61)..tostring(a.cost))
            if a.t==__d(80)or a.t==__d(85)then
                local cost=tonumber(a.cost)
                if cost and cost>0 then
                    -- WAIT until money >= cost
                    local abort=false
                    while pb.on and pb.sess==ms do
                        local m=readMoney()
                        if m==nil then
                            abort=true
                            break
                        end
                        if m>=cost then break end
                        task.wait(0.1)
                    end
                    if abort then
                        warn(__d(91,69,90,86,67,93,32,99,97,110,110,111,116,32,114,101,97,100,32,109,111,110,101,121,32,45,32,97,98,111,114,116,32,112,108,97,121,98,97,99,107))
                        N(__d(77,97,99,114,111),__d(77,111,110,101,121,32,114,101,97,100,32,102,97,105,108,101,100))
                        break
                    end
                    if not pb.on or pb.sess~=ms then break end
                else
                    -- no cost recorded → fall back to time delay
                    print(__d(91,69,90,86,67,93,32,87,65,82,78,58,32,110,111,32,99,111,115,116,32,102,111,114,32,97,99,116,105,111,110,32)..idx..__d(32,45,32,117,115,105,110,103,32,116,105,109,101))
                    local d=a.d or 0
                    if d>0 then
                        local t0=tick()
                        while tick()-t0<d and pb.on and pb.sess==ms do task.wait()end
                    end
                end
                if not pb.on or pb.sess~=ms then break end
                if a.t==__d(80)then
                    local ps=Vector3.new(unpack(a.pos))
                    local cf=CFrame.new(unpack(a.cf))
                    local res=callR(REM.Add,{UnitId=a.unitId,CFrame=cf,Name=a.name,Pos=ps})
                    C.P=C.P+1
                    local gid=nil
                    if type(res)==__d(116,97,98,108,101)then gid=res.Id or res.ID or res.UnitId or res.UUID
                    elseif type(res)==__d(115,116,114,105,110,103)or type(res)==__d(110,117,109,98,101,114)then gid=res end
                    if gid then sidToInst[a.sid]={gid=gid,inst=nil}
                        task.spawn(function()local known=snapshotTowers()local inst=select(1,captureNewTower(ps,known,1.5))if inst and sidToInst[a.sid]and not sidToInst[a.sid].inst then sidToInst[a.sid].inst=inst end end)
                    else local known=snapshotTowers()local inst,fid=captureNewTower(ps,known,2)if inst or fid then sidToInst[a.sid]={gid=fid or(inst and extId(inst)),inst=inst}end end
                else
                    local entry=sidToInst[a.sid]local gid=entry and entry.gid local inst=entry and entry.inst
                    if inst and inst.Parent and not gid then gid=extId(inst)end
                    if not inst and gid then inst=findTowerById(gid)end
                    if not inst and a.pos then inst=findTowerByPosNear(Vector3.new(unpack(a.pos)),10)if inst then gid=extId(inst)or gid end end
                    if not inst and a.name then local tw=getTowersFolder()if tw then for _,o in ipairs(tw:GetChildren())do if getTowerName(o)==a.name then inst=o gid=extId(o)or gid break end end end end
                    if inst or gid then if tryUpgrade(gid,inst)then C.U=C.U+1 end end
                end
                task.wait(0.3)
            elseif a.t==__d(83)then
                local d=a.d or 0.3
                if d>0 then local t0=tick()while tick()-t0<d and pb.on and pb.sess==ms do task.wait()end end
                if not pb.on or pb.sess~=ms then break end
                local entry=sidToInst[a.sid]local gid=entry and entry.gid local inst=entry and entry.inst
                if inst and inst.Parent and not gid then gid=extId(inst)end
                if not inst and gid then inst=findTowerById(gid)end
                if not inst and a.pos then inst=findTowerByPosNear(Vector3.new(unpack(a.pos)),10)if inst then gid=extId(inst)or gid end end
                if not inst and a.name then local tw=getTowersFolder()if tw then for _,o in ipairs(tw:GetChildren())do if getTowerName(o)==a.name then inst=o gid=extId(o)or gid break end end end end
                if inst or gid then if trySell(gid,inst)then C.S=C.S+1 end end
                task.wait(0.3)
            end
        end
        print(__d(91,69,90,86,67,93,32,112,108,97,121,32,69,78,68,32,80,61)..C.P..__d(32,85,61)..C.U..__d(32,83,61)..C.S)
        if pb.sess==ms then pb.on=false if _pT and _pT.GetValue()then _pT.SetValue(false)end end
    end)
end
local function stopP()pb.on=false pb.sess=pb.sess+1 end

local autoSkipOn=false local autoSkipSess=0
local function startAutoSkip()if autoSkipOn then return end autoSkipOn=true autoSkipSess=autoSkipSess+1 local ms=autoSkipSess task.spawn(function()while autoSkipOn and autoSkipSess==ms and sg and sg.Parent do if not REM.Skip or not REM.Skip.Parent then rRem()end if REM.Skip then pcall(function()REM.Skip:FireServer()end)end task.wait(1)end end)end
stopAutoSkip=function()autoSkipOn=false autoSkipSess=autoSkipSess+1 end

local voteModes={__d(69,97,115,121),__d(78,111,114,109,97,108),__d(72,97,114,100),__d(73,110,115,97,110,101)}local voteIdx=1
for i,v in ipairs(voteModes)do if v==Cfg.vm then voteIdx=i end end
local autoVoteOn=false local autoVoteSess=0 local autoVoteTg=nil
stopAutoVote=function()autoVoteOn=false autoVoteSess=autoVoteSess+1 end
local function startAutoVote()if autoVoteOn then return end autoVoteOn=true autoVoteSess=autoVoteSess+1 local ms=autoVoteSess local mode=voteModes[voteIdx]task.spawn(function()for i=1,10 do if not autoVoteOn or autoVoteSess~=ms or not sg or not sg.Parent then return end if not REM.Vote or not REM.Vote.Parent then rRem()end if REM.Vote then pcall(function()REM.Vote:FireServer(mode)end)end if i<10 then task.wait(1)end end autoVoteOn=false if autoVoteTg then autoVoteTg.SetValue(true)end end)end

local TP_PRESETS={{name=__d(84,111,105,108,101,116,32,67,105,116,121),pos=Vector3.new(743,308,619)},{name=__d(67,97,109,101,114,109,97,110,32,72,81),pos=Vector3.new(743,308,502)},{name=__d(68,101,115,101,114,116),pos=Vector3.new(742,308,725)}}
local tppIdx=1 for i,v in ipairs(TP_PRESETS)do if v.name==Cfg.tpp then tppIdx=i end end
local function getCurrentPos()return TP_PRESETS[tppIdx].pos end
local function teleportToGamePos()local char=PLR.Character if char and char.PrimaryPart then pcall(function()char:PivotTo(CFrame.new(getCurrentPos()))end)return true end return false end

local autoGameOn=false local autoGameSess=0
local function startAutoGame()if autoGameOn then return end autoGameOn=true autoGameSess=autoGameSess+1 local ms=autoGameSess task.spawn(function()if not autoGameOn or autoGameSess~=ms then return end if not teleportToGamePos()then for _=1,50 do task.wait(0.1)if not autoGameOn or autoGameSess~=ms then return end if teleportToGamePos()then break end end end if autoGameSess==ms then autoGameOn=false end end)end
local function stopAutoGame()autoGameOn=false autoGameSess=autoGameSess+1 end

local ELEVATORS={{name=__d(84,111,105,108,101,116,32,67,105,116,121),arg=__d(69,108,101,118,97,116,111,114,49)},{name=__d(68,101,115,101,114,116),arg=__d(69,108,101,118,97,116,111,114,50)},{name=__d(69,108,101,118,97,116,111,114,51),arg=__d(69,108,101,118,97,116,111,114,51)}}
local elevIdx=1 for i,v in ipairs(ELEVATORS)do if v.name==Cfg.elev then elevIdx=i end end
local autoStartOn=false local autoStartSess=0
local function fireElevatorOnce()local arg=ELEVATORS[elevIdx].arg local e=tryPath(__d(77,111,100,117,108,101,76,111,97,100,101,114),__d(83,104,97,114,101,100),__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110),__d(69,108,101,118,97,116,111,114,69,110,116,101,114))local s=tryPath(__d(77,111,100,117,108,101,76,111,97,100,101,114),__d(83,104,97,114,101,100),__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,70,117,110,99,116,105,111,110),__d(69,108,101,118,97,116,111,114,83,116,97,114,116))if e then pcall(function()e:InvokeServer(arg)end)end task.wait(0.5)if s then pcall(function()s:InvokeServer(arg)end)end end
local function startAutoStart()if autoStartOn then return end autoStartOn=true autoStartSess=autoStartSess+1 local ms=autoStartSess task.spawn(function()if not teleportToGamePos()then for _=1,50 do task.wait(0.1)if not autoStartOn or autoStartSess~=ms then return end if teleportToGamePos()then break end end end task.wait(1)if not autoStartOn or autoStartSess~=ms then return end for i=1,4 do if not autoStartOn or autoStartSess~=ms then return end fireElevatorOnce()if i<4 then task.wait(2)end end if autoStartSess==ms then autoStartOn=false end end)end
stopAutoStart=function()autoStartOn=false autoStartSess=autoStartSess+1 end

local function getOnLeaveRemote()return tryPath(__d(77,111,100,117,108,101,76,111,97,100,101,114),__d(83,104,97,114,101,100),__d(78,101,116,119,111,114,107),__d(82,101,109,111,116,101,69,118,101,110,116),__d(79,110,76,101,97,118,101))end
local autoLeaveOn=false local autoLeaveSess=0
stopAutoLeave=function()autoLeaveOn=false autoLeaveSess=autoLeaveSess+1 end
local function startAutoLeave()if autoLeaveOn then return end autoLeaveOn=true autoLeaveSess=autoLeaveSess+1 local ms=autoLeaveSess local mins=math.clamp(math.floor(tonumber(Cfg.alm)or 5),1,30)task.spawn(function()while autoLeaveOn and autoLeaveSess==ms and sg and sg.Parent do local t0=tick()while tick()-t0<mins*60 and autoLeaveOn and autoLeaveSess==ms do task.wait(1)end if not autoLeaveOn or autoLeaveSess~=ms then break end local r=getOnLeaveRemote()if r then pcall(function()r:FireServer()end)end end end)end

local rC,sSt,sCn,refreshSpdBtns,updateCnt
do
    local mP=pg(__d(77,97,105,110))
    local c1=cd(mP,__d(83,116,97,116,105,115,116,105,99,115),12)c1.Size=UDim2.new(1,-24,0,84)
    lb(c1,__d(80,108,97,99,101),12,30,80,12,SB,9,false)lb(c1,__d(85,112,103,114,97,100,101),112,30,80,12,SB,9,false)lb(c1,__d(83,101,108,108),212,30,80,12,SB,9,false)
    local pL=lb(c1,__d(48),12,44,80,20,TX,16,true)local uL=lb(c1,__d(48),112,44,80,20,TX,16,true)local sL=lb(c1,__d(48),212,44,80,20,TX,16,true)
    rC=function()pcall(function()stL.Text=string.format(__d(80,108,97,99,101,32,37,100,32,124,32,85,112,103,114,97,100,101,32,37,100,32,124,32,83,101,108,108,32,37,100),C.P,C.U,C.S)end)pcall(function()pL.Text=tostring(C.P)uL.Text=tostring(C.U)sL.Text=tostring(C.S)end)end
end

do
    local pP=pg(__d(80,108,97,121))
    local cp=cd(pP,__d(65,117,116,111,109,97,116,105,111,110),12)cp.Size=UDim2.new(1,-24,0,240)
    tg(cp,__d(65,117,116,111,32,83,107,105,112),nil,12,26,240,38,Cfg.sk,function(on)set(__d(115,107),on)if on then startAutoSkip()else stopAutoSkip()end end)
    lb(cp,__d(65,85,84,79,32,86,79,84,69),12,74,120,12,SB,9,true)
    autoVoteTg=tg(cp,__d(65,117,116,111,32,86,111,116,101),nil,12,90,240,38,Cfg.av,function(on)set(__d(97,118),on)if on then startAutoVote()else stopAutoVote()end end)
    local vmLbl=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,134),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=__d(32,32,77,111,100,101,58,32)..voteModes[voteIdx],AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},cp)cr(vmLbl,5)
    vmLbl.MouseButton1Click:Connect(function()voteIdx=voteIdx%#voteModes+1 vmLbl.Text=__d(32,32,77,111,100,101,58,32)..voteModes[voteIdx]set(__d(118,109),voteModes[voteIdx])end)
    bt(cp,__d(83,101,110,100,32,86,111,116,101,32,78,111,119),12,168,240,28,__d(112),function()if not REM.Vote or not REM.Vote.Parent then rRem()end if REM.Vote then pcall(function()REM.Vote:FireServer(voteModes[voteIdx])end)end N(__d(77,97,99,114,111),__d(86,111,116,101,100,58,32)..voteModes[voteIdx])end)
    local cg=cd(pP,__d(65,117,116,111,32,71,97,109,101),272)cg.Size=UDim2.new(1,-24,0,110)
    tg(cg,__d(65,117,116,111,32,71,97,109,101),__d(84,80,32,45,62,32,115,101,108,101,99,116,101,100,32,112,114,101,115,101,116),12,26,240,38,Cfg.ag,function(on)set(__d(97,103),on)if on then startAutoGame()else stopAutoGame()end end)
    lb(cg,__d(84,80,32,80,82,69,83,69,84),12,70,120,12,SB,9,true)
    local tpLbl=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,84),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=__d(32,32)..TP_PRESETS[tppIdx].name,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},cg)cr(tpLbl,5)
    tpLbl.MouseButton1Click:Connect(function()tppIdx=tppIdx%#TP_PRESETS+1 local p=TP_PRESETS[tppIdx]tpLbl.Text=__d(32,32)..p.name set(__d(116,112,112),p.name)end)
    local ca=cd(pP,__d(65,117,116,111,32,83,116,97,114,116),392)ca.Size=UDim2.new(1,-24,0,110)
    tg(ca,__d(65,117,116,111,32,83,116,97,114,116),__d(84,80,32,45,62,32,49,115,32,45,62,32,69,108,101,118,97,116,111,114,32,120,52),12,26,240,38,Cfg.ast,function(on)set(__d(97,115,116),on)if on then startAutoStart()else stopAutoStart()end end)
    lb(ca,__d(69,76,69,86,65,84,79,82),12,70,120,12,SB,9,true)
    local elevLbl=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,84),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=__d(32,32)..ELEVATORS[elevIdx].name,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},ca)cr(elevLbl,5)
    elevLbl.MouseButton1Click:Connect(function()elevIdx=elevIdx%#ELEVATORS+1 elevLbl.Text=__d(32,32)..ELEVATORS[elevIdx].name set(__d(101,108,101,118),ELEVATORS[elevIdx].name)end)
    local cl=cd(pP,__d(65,117,116,111,32,76,101,97,118,101),512)cl.Size=UDim2.new(1,-24,0,110)
    tg(cl,__d(65,117,116,111,32,76,101,97,118,101),__d(70,105,114,101,32,79,110,76,101,97,118,101,32,101,118,101,114,121,32,78,32,109,105,110,117,116,101,115),12,26,240,38,Cfg.al,function(on)set(__d(97,108),on)if on then startAutoLeave()else stopAutoLeave()end end)
    lb(cl,__d(77,105,110,117,116,101,115,32,40,49,45,51,48,41,58),12,74,90,12,SB,9,true)
    local almBox=mk(__d(84,101,120,116,66,111,120),{Size=UDim2.fromOffset(60,22),Position=UDim2.new(0,110,0,70),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=tostring(Cfg.alm or 5),ClearTextOnFocus=false},cl)cr(almBox,5)
    almBox.FocusLost:Connect(function()local n=tonumber(almBox.Text)if not n then n=5 end n=math.clamp(math.floor(n),1,30)almBox.Text=tostring(n)set(__d(97,108,109),n)if autoLeaveOn then stopAutoLeave()startAutoLeave()end end)
    local cs=cd(pP,__d(83,112,101,101,100),642)cs.Size=UDim2.new(1,-24,0,90)
    local spdV={1,1.5,2}
    local spdL={__d(49,120),__d(49,46,53,120),__d(50,120)}
    local spdB={}
    refreshSpdBtns=function()for i,b in ipairs(spdB)do if b and b.Parent then local on=tonumber(Cfg.spd)==spdV[i]pcall(function()TS:Create(b,TweenInfo.new(0.15),{BackgroundColor3=on and AC or EL}):Play()end)end end end
    for i,lbl in ipairs(spdL)do
        local b=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.fromOffset(74,36),Position=UDim2.new(0,12+(i-1)*78,0,32),BackgroundColor3=(tonumber(Cfg.spd)==spdV[i])and AC or EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=lbl,AutoButtonColor=false},cs)
        cr(b,6)
        b.MouseButton1Click:Connect(function()setSpeed(spdV[i])refreshSpdBtns()end)
        b.MouseEnter:Connect(function()pcall(function()TS:Create(b,TweenInfo.new(0.14),{BackgroundColor3=b.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play()end)end)
        b.MouseLeave:Connect(function()refreshSpdBtns()end)
        spdB[i]=b
    end
    rT(spdB[1])rT(spdB[2])rT(spdB[3])
    refreshSpdBtns()
end

local _pT
do
    local mP2=pg(__d(77,97,99,114,111))
    local rc=cd(mP2,__d(77,97,99,114,111,32,78,97,109,101),12)rc.Size=UDim2.new(1,-24,0,56)
    lb(rc,__d(78,97,109,101),12,26,50,24,SB,11,false)
    local mnBox=mk(__d(84,101,120,116,66,111,120),{Size=UDim2.new(1,-80,0,26),Position=UDim2.new(0,64,0,20),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,PlaceholderText=__d(101,46,103,46,32,70,97,114,109),PlaceholderColor3=MT,Text=Cfg.mn or__d(),ClearTextOnFocus=false},rc)cr(mnBox,5)
    mnBox.FocusLost:Connect(function()set(__d(109,110),mnBox.Text or__d())end)
    local rc2=cd(mP2,__d(77,97,99,114,111,32,65,99,116,105,111,110,115),76)rc2.Size=UDim2.new(1,-24,0,300)
    local mStat=lb(rc2,__d(83,116,97,116,117,115,58,32,73,100,108,101),12,26,110,14,SB,10,true)
    local mCnt=lb(rc2,__d(65,99,116,105,111,110,115,58,32,48),124,26,100,14,MT,10,false)
    lb(rc2,__d(83,84,65,84,73,83,84,73,67,83),12,48,120,12,SB,9,true)
    local sPl=lb(rc2,__d(80,108,97,99,101,58,32,48),12,64,90,16,TX,11,true)
    local sUp=lb(rc2,__d(85,112,103,114,97,100,101,58,32,48),102,64,90,16,TX,11,true)
    local sSl=lb(rc2,__d(83,101,108,108,58,32,48),192,64,90,16,TX,11,true)
    sSt=function(s)if not mStat or not mStat.Parent then return end local col=MT if s==__d(82,101,99,111,114,100,105,110,103)then col=Color3.fromRGB(220,96,96)elseif s==__d(80,108,97,121,105,110,103)then col=MONEY_COL elseif s==__d(73,100,108,101)then col=SB end mStat.Text=__d(83,116,97,116,117,115,58,32)..s pcall(function()TS:Create(mStat,TweenInfo.new(0.2),{TextColor3=col}):Play()end)end
    sCn=function(n)if mCnt and mCnt.Parent then mCnt.Text=__d(65,99,116,105,111,110,115,58,32)..tostring(n)end end
    local mList=lf()local mIdx=0 for i,v in ipairs(mList)do if v==sel then mIdx=i end end
    local mSel=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,90),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=sel~=__d()and sel or__d(45,45,32,115,101,108,101,99,116,32,109,97,99,114,111,32,45,45),AutoButtonColor=false},rc2)cr(mSel,5)
    local function rML()mList=lf()mIdx=0 for i,v in ipairs(mList)do if v==sel then mIdx=i end end mSel.Text=sel~=__d()and sel or__d(45,45,32,115,101,108,101,99,116,32,109,97,99,114,111,32,45,45)end
    mSel.MouseButton1Click:Connect(function()mList=lf()if #mList==0 then N(__d(77,97,99,114,111),__d(78,111,32,115,97,118,101,100,32,109,97,99,114,111,115))return end mIdx=mIdx%#mList+1 local ch=mList[mIdx]mSel.Text=ch sel=ch set(__d(115,101,108),ch)end)
    bt(rc2,__d(67,114,101,97,116,101,32,47,32,83,97,118,101,32,77,97,99,114,111),12,126,240,28,__d(112),function()local n=mnBox.Text or__d()if n==__d()then N(__d(77,97,99,114,111),__d(69,110,116,101,114,32,97,32,110,97,109,101))return end if FS.write then pcall(writefile,FO..n..__d(46,106,115,111,110),__d(91,93))end sel=n set(__d(115,101,108),n)rML()N(__d(77,97,99,114,111),__d(82,101,97,100,121,58,32)..n)end)
    local rToggle
    rToggle=tg(rc2,__d(82,101,99,111,114,100,32,77,97,99,114,111),__d(83,116,97,114,116,47,115,116,111,112,32,114,101,99,111,114,100,105,110,103),12,162,240,38,false,function(on)if on then if rec.on then N(__d(77,97,99,114,111),__d(65,108,114,101,97,100,121,32,114,101,99,111,114,100,105,110,103))rToggle.SetValue(true)return end if pb.on then N(__d(77,97,99,114,111),__d(83,116,111,112,32,112,108,97,121,98,97,99,107,32,102,105,114,115,116))rToggle.SetValue(false)return end if sel==__d()then N(__d(77,97,99,114,111),__d(83,101,108,101,99,116,32,97,32,109,97,99,114,111,32,102,105,114,115,116))rToggle.SetValue(false)return end rec.a={}rec.n=0 rec.t={}rec.k={}rec.l=0 rec.last=nil C.P=0 C.U=0 C.S=0 rC()sCn(0)hits=0 rRem()local ok=inHook()if not ok then N(__d(77,97,99,114,111),__d(72,111,111,107,32,117,110,97,118,97,105,108,97,98,108,101))rToggle.SetValue(false)return end rec.on=true sSt(__d(82,101,99,111,114,100,105,110,103))N(__d(77,97,99,114,111),__d(82,101,99,111,114,100,105,110,103,32,45,62,32)..sel)print(__d(91,69,90,86,67,93,32,82,69,67,79,82,68,32,83,84,65,82,84))else if not rec.on then sSt(__d(73,100,108,101))return end rec.on=false unHook()task.wait(1)if #rec.a>0 and sel~=__d()then local ok,err=wj(FO..sel..__d(46,106,115,111,110),rec.a)if ok then N(__d(77,97,99,114,111),__d(83,97,118,101,100,32)..#rec.a..__d(32,115,116,101,112,115))else N(__d(77,97,99,114,111),__d(83,97,118,101,32,102,97,105,108,101,100,58,32)..tostring(err))end else N(__d(77,97,99,114,111),__d(78,111,116,104,105,110,103,32,115,97,118,101,100,32,40,104,105,116,115,61)..hits..__d(41))end rec.a={}rec.n=0 rec.t={}rec.k={}rec.l=0 rec.last=nil C.P=0 C.U=0 C.S=0 rC()sCn(0)sSt(__d(73,100,108,101))end end)
    _pT=tg(rc2,__d(80,108,97,121,32,77,97,99,114,111),__d(80,108,97,121,98,97,99,107,32,114,101,99,111,114,100,101,100,32,109,97,99,114,111),12,206,240,38,Cfg.pl,function(on)if on then if rec.on then N(__d(77,97,99,114,111),__d(83,116,111,112,32,114,101,99,111,114,100,105,110,103,32,102,105,114,115,116))_pT.SetValue(false)return end if sel==__d()then N(__d(77,97,99,114,111),__d(83,101,108,101,99,116,32,97,32,109,97,99,114,111,32,102,105,114,115,116))_pT.SetValue(false)return end local d=rj(findMacroPath(sel))if type(d)~=__d(116,97,98,108,101)or #d==0 then N(__d(77,97,99,114,111),__d(77,97,99,114,111,32,101,109,112,116,121))_pT.SetValue(false)return end set(__d(112,108),true)sSt(__d(80,108,97,121,105,110,103))play()else stopP()set(__d(112,108),false)sSt(__d(73,100,108,101))end end)
    bt(rc2,__d(68,101,108,101,116,101,32,77,97,99,114,111),12,252,240,28,__d(100),function()if sel==__d()then N(__d(77,97,99,114,111),__d(83,101,108,101,99,116,32,97,32,109,97,99,114,111))return end pcall(function()if FS.del then delfile(findMacroPath(sel))end end)sel=__d()set(__d(115,101,108),__d())rML()N(__d(77,97,99,114,111),__d(68,101,108,101,116,101,100))end)
    updateCnt=function()local p,u,s=0,0,0 for _,a in ipairs(rec.a)do if a.t==__d(80)then p=p+1 elseif a.t==__d(85)then u=u+1 elseif a.t==__d(83)then s=s+1 end end C.P=p C.U=u C.S=s rC()sCn(#rec.a)pcall(function()sPl.Text=__d(80,108,97,99,101,58,32)..p sUp.Text=__d(85,112,103,114,97,100,101,58,32)..u sSl.Text=__d(83,101,108,108,58,32)..s end)end
    _cL=updateCnt
end

do
    local gP=pg(__d(71,85,73))
    local th=cd(gP,__d(84,104,101,109,101),12)th.Size=UDim2.new(1,-24,0,180)
    local themes={{n=__d(80,117,114,112,108,101),c=Color3.fromRGB(155,120,255)},{n=__d(82,101,100),c=Color3.fromRGB(220,96,96)},{n=__d(66,108,117,101),c=Color3.fromRGB(108,142,255)},{n=__d(71,114,101,101,110),c=Color3.fromRGB(90,196,140)},{n=__d(79,114,97,110,103,101),c=Color3.fromRGB(240,150,60)},{n=__d(80,105,110,107),c=Color3.fromRGB(230,120,180)},{n=__d(67,121,97,110),c=Color3.fromRGB(0,200,220)},{n=__d(89,101,108,108,111,119),c=Color3.fromRGB(230,200,90)}}
    local tEnt={}
    local function isSm(a,b)return math.abs(a.R-b.R)<0.01 and math.abs(a.G-b.G)<0.01 and math.abs(a.B-b.B)<0.01 end
    local function sTS()for _,e in ipairs(tEnt)do if not e.str or not e.str.Parent then break end local isS=isSm(e.c,AC)TS:Create(e.str,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Transparency=isS and 0 or 0.85,Color=e.c}):Play()end end
    _sT=sTS
    for i,t in ipairs(themes)do
        local col=(i-1)%2 local row=math.floor((i-1)/2)
        local px=(col==0)and UDim2.new(0,12,0,30+row*34)or UDim2.new(0.5,6,0,30+row*34)
        local b=mk(__d(84,101,120,116,66,117,116,116,111,110),{Size=UDim2.new(0.5,-18,0,28),Position=px,BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=__d(32,32)..t.n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},th)cr(b,6)
        local str=sk(b,t.c,0.85)
        local dot=mk(__d(70,114,97,109,101),{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-22,0.5,-7),BackgroundColor3=t.c,BorderSizePixel=0},b)cr(dot,7)
        tEnt[#tEnt+1]={btn=b,str=str,c=t.c}
    end
    for _,e in ipairs(tEnt)do e.btn.MouseButton1Click:Connect(function()setAC(e.c)Cfg.acr=math.floor(e.c.R*255+0.5)Cfg.acg=math.floor(e.c.G*255+0.5)Cfg.acb=math.floor(e.c.B*255+0.5)sv()sTS()end)end
    sTS()
end

task.spawn(function()
    task.wait(1.5)
    iA()
    updateMoneyLabel()
    applySpeed(Cfg.spd or 1)
    if Cfg.sk then startAutoSkip()end
    if Cfg.ag then startAutoGame()end
    if Cfg.ast then startAutoStart()end
    if Cfg.al then startAutoLeave()end
    if Cfg.av then if autoVoteTg then autoVoteTg.SetValue(true)end startAutoVote()end
    if Cfg.pl and Cfg.sel~=__d()then local d=rj(findMacroPath(Cfg.sel))if type(d)==__d(116,97,98,108,101)and #d>0 then if _pT then _pT.SetValue(true)end sSt(__d(80,108,97,121,105,110,103))play()else Cfg.pl=false sv()if _pT then _pT.SetValue(false)end end end
end)
go(__d(77,97,105,110))rC()N(__d(69,90,86,67,32,72,85,66),__d(82,101,97,100,121))
print(__d(91,69,90,86,67,32,72,85,66,93,32,118,50,46,51,53,32,108,111,97,100,101,100))