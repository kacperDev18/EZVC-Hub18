-- EZVC HUB v2.25 - Optimized playback (no unnecessary delays)
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("ReplicatedStorage")
local HS=game:GetService("HttpService")
local PLR=game:GetService("Players").LocalPlayer
local FS={folder=(type(isfolder)=="function" and type(makefolder)=="function"),file=(type(isfile)=="function" and type(readfile)=="function"),write=(type(writefile)=="function"),list=(type(listfiles)=="function"),del=(type(delfile)=="function")}
local FO=""
if FS.folder then for _,p in ipairs({"macro_ng/","tdmacro/","macro_ng","tdmacro","./","."}) do pcall(function() makefolder(p) end) local ok,e=pcall(isfolder,p) if ok and e then if p:sub(-1)~="/" and p~="." then p=p.."/" end FO=p break end end end
local CF=FO.."cfg.json"
local function wj(p,d) if not FS.write then return false,"writefile missing" end local ok,s=pcall(function() return HS:JSONEncode(d) end) if not ok then return false,"encode: "..tostring(s) end local ok2,err=pcall(writefile,p,s) if not ok2 then return false,"write: "..tostring(err) end return true,"ok" end
local function rj(p) if not FS.file then return nil,"readfile missing" end local ok0,ex=pcall(isfile,p) if not ok0 or not ex then return nil,"no file" end local ok,d=pcall(readfile,p) if not ok then return nil,"read: "..tostring(d) end local ok2,a=pcall(function() return HS:JSONDecode(d) end) if not ok2 or type(a)~="table" then return nil,"decode" end return a end
local function findConfigFile() if not FS.file then return nil end for _,p in ipairs({CF,"macro_ng/cfg.json","tdmacro/cfg.json","cfg.json"}) do local ok,ex=pcall(isfile,p) if ok and ex then return p end end return nil end
local function findMacroPath(name) for _,p in ipairs({"macro_ng/","tdmacro/","./",FO,"macro_ng","tdmacro"}) do local base=p if base~="" and base:sub(-1)~="/" then base=base.."/" end local full=base..name..".json" if FS.file then local ok,ex=pcall(isfile,full) if ok and ex then return full end end end return FO..name..".json" end
local DEF={sk=false,av=false,vm="Normal",ag=false,mn="",sel="",pl=false,acr=155,acg=120,acb=255,gs="1",rp=false,lb=false,rec=false,s10=false,s1=false,spn=false,afk=false,oc=false,crate="Free",ast=false,tpp="Toilet City",elev="Toilet City",spd="1",apr=false}
local Cfg={}
local loadSource="defaults"
if type(getgenv)=="function" then local ok,env=pcall(getgenv) if ok and type(env)=="table" and type(env.EZVC_Cfg)=="table" then for k,v in pairs(env.EZVC_Cfg) do Cfg[k]=v end loadSource="getgenv" end end
local cfgFile=findConfigFile()
if cfgFile then local d=rj(cfgFile) if type(d)=="table" then for k,v in pairs(d) do Cfg[k]=v end CF=cfgFile loadSource="file:"..cfgFile end end
for k,v in pairs(DEF) do if Cfg[k]==nil then Cfg[k]=v end end
print("[EZVC] Config source: "..loadSource.." | path: "..CF)
print("[EZVC] spd="..tostring(Cfg.spd).." apr="..tostring(Cfg.apr))
local function sv() if type(getgenv)=="function" then pcall(function() local env=getgenv() if type(env)=="table" then env.EZVC_Cfg=Cfg end end) end if not FS.write then return true end local ok,err=wj(CF,Cfg) if not ok then for _,alt in ipairs({"macro_ng/cfg.json","tdmacro/cfg.json","cfg.json"}) do if alt~=CF then local ok2=wj(alt,Cfg) if ok2 then CF=alt return true end end end warn("[EZVC] Save failed: "..tostring(err)) return false end return true end
local function set(k,v) Cfg[k]=v sv() print("[EZVC] saved "..tostring(k).."="..tostring(v)) end
local sel=Cfg.sel or ""
local function lf() if not FS.list then return {} end local s,n={},{} for _,p in ipairs({"macro_ng/","tdmacro/","./","macro_ng","tdmacro"}) do local ok,l=pcall(listfiles,p) if ok and type(l)=="table" then for _,f in ipairs(l) do local x=tostring(f):match("([^/\\]+)%.json$") if x and x~="cfg" and x~="config" and not s[x] then s[x]=true n[#n+1]=x end end end end return n end

-- ============================================================
-- FORWARD DECLARATIONS (fix for callback forward refs)
-- ============================================================
local rec = {a={},n=0,t={},k={},l=0,on=false,last=nil}
local pb  = {on=false,sess=0}
local unHook
local stopAutoSkip, stopAutoVote, stopAutoStart, stopAutoPlayAgain

local BG=Color3.fromRGB(16,16,20) local SF=Color3.fromRGB(22,22,27) local HD=Color3.fromRGB(26,26,32) local PN=Color3.fromRGB(30,30,36) local EL=Color3.fromRGB(38,38,45) local BR=Color3.fromRGB(52,52,60) local TX=Color3.fromRGB(238,238,244) local SB=Color3.fromRGB(150,150,162) local MT=Color3.fromRGB(98,98,110) local OFF=Color3.fromRGB(52,52,60)
local AC=Color3.fromRGB(tonumber(Cfg.acr) or 155,tonumber(Cfg.acg) or 120,tonumber(Cfg.acb) or 255)
local par pcall(function() if gethui then local ok,h=pcall(gethui) if ok and h then par=h end end end) par=par or game:GetService("CoreGui")
for _,v in ipairs(par:GetChildren()) do if v.Name=="EZVCMacroATD" or v.Name=="EZVCHUB" or v.Name=="EZVCHUBbeta" then pcall(function() v:Destroy() end) end end
local sg=Instance.new("ScreenGui") sg.Name="EZVCHUB" sg.IgnoreGuiInset=true sg.ResetOnSpawn=false sg.DisplayOrder=999 sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling sg.Parent=par
local function mk(c,p,r) local o=Instance.new(c) for k,v in next,p do o[k]=v end if r then o.Parent=r end return o end
local function cr(o,r) mk("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function sk(o,c,t) return mk("UIStroke",{Color=c,Thickness=1,Transparency=t},o) end
local function lb(p,t,x,y,w,h,c,s,b) return mk("TextLabel",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundTransparency=1,Font=b and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=s or 11,TextColor3=c,TextXAlignment=Enum.TextXAlignment.Left,Text=t},p) end
local tR={}
local function rT(p,f,prop) tR[#tR+1]={p=p,f=f,prop=prop or "BackgroundColor3"} return p end
local function setAC(c) AC=c for i=#tR,1,-1 do local e=tR[i] if not e.p or not e.p.Parent then table.remove(tR,i) else local v=e.f and e.f() or c pcall(function() TS:Create(e.p,TweenInfo.new(0.28,Enum.EasingStyle.Quart),{[e.prop]=v}):Play() end) end end end
local function iA() for _,e in ipairs(tR) do if e.p and e.p.Parent then local v=e.f and e.f() or AC pcall(function() e.p[e.prop]=v end) end end end
local win=mk("Frame",{Size=UDim2.fromOffset(420,300),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=BG,BorderSizePixel=0},sg) cr(win,12)
local wS=sk(win,BR,0.35)
local function fit() pcall(function() local cam=workspace.CurrentCamera if not cam then return end local vp=cam.ViewportSize if vp.X<=0 or vp.Y<=0 then return end win.Size=UDim2.fromOffset(math.clamp(math.floor(vp.X*0.92),300,460),math.clamp(math.floor(vp.Y*0.78),260,340)) win.Position=UDim2.new(0.5,0,0.5,0) end) end
fit() pcall(function() workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end)
local hdr=mk("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=HD,BorderSizePixel=0},win) cr(hdr,12)
mk("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=HD,BorderSizePixel=0},hdr)
local aD=mk("Frame",{Size=UDim2.fromOffset(10,10),Position=UDim2.new(0,14,0.5,-5),BackgroundColor3=AC,BorderSizePixel=0},hdr) cr(aD,3) rT(aD)
lb(hdr,"EZVC HUB",30,0,140,38,TX,13,true) lb(hdr,"v2.25",125,0,90,38,MT,9,false)
local xb=mk("TextButton",{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-30,0.5,-12),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=SB,Text="X",AutoButtonColor=false},hdr) cr(xb,6)
xb.MouseEnter:Connect(function() TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,90,90),TextColor3=Color3.new(1,1,1)}):Play() end)
xb.MouseLeave:Connect(function() TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=EL,TextColor3=SB}):Play() end)
local dg,d0,d1=false,nil,nil
hdr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true d0=i.Position d1=win.Position end end)
UIS.InputChanged:Connect(function(i) if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-d0 win.Position=UDim2.new(d1.X.Scale,d1.X.Offset+d.X,d1.Y.Scale,d1.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
local body=mk("Frame",{Size=UDim2.new(1,0,1,-38),Position=UDim2.new(0,0,0,38),BackgroundTransparency=1},win)
local sB=mk("Frame",{Size=UDim2.new(0,118,1,0),BackgroundColor3=SF,BorderSizePixel=0},body)
mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=BR,BackgroundTransparency=0.4,BorderSizePixel=0},sB)
local ct=mk("Frame",{Size=UDim2.new(1,-118,1,0),Position=UDim2.new(0,118,0,0),BackgroundTransparency=1},body)
local aL=mk("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),BackgroundColor3=AC,BorderSizePixel=0,ZIndex=10},body) rT(aL)
local pages,tabs,tInd,cur={},{},{},nil
local function go(n) if cur==n then return end for k,p in pairs(pages) do if k==n then p.Visible=true p.Position=UDim2.new(0,5,0,0) TS:Create(p,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)}):Play() else p.Visible=false end end for k,b in pairs(tabs) do if k==n then TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=EL,TextColor3=AC}):Play() if tInd[k] then TS:Create(tInd[k],TweenInfo.new(0.22),{BackgroundTransparency=0}):Play() end else TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=SF,TextColor3=MT}):Play() if tInd[k] then TS:Create(tInd[k],TweenInfo.new(0.22),{BackgroundTransparency=1}):Play() end end end cur=n end
for i,n in ipairs({"Main","Play","Macro","GUI"}) do
local b=mk("TextButton",{Size=UDim2.new(1,-16,0,28),Position=UDim2.new(0,8,0,10+(i-1)*32),BackgroundColor3=SF,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=MT,Text="  "..n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},sB) cr(b,6)
local ind=mk("Frame",{Size=UDim2.new(0,3,1,-16),Position=UDim2.new(0,3,0,8),BackgroundColor3=AC,BorderSizePixel=0,BackgroundTransparency=1},b) cr(ind,2) rT(ind) tInd[n]=ind
b.MouseButton1Click:Connect(function() go(n) end) tabs[n]=b rT(b,function() return (cur==n) and AC or MT end,"TextColor3")
end
local sidebarColors={Color3.fromRGB(155,120,255),Color3.fromRGB(220,96,96),Color3.fromRGB(108,142,255),Color3.fromRGB(90,196,140),Color3.fromRGB(240,150,60),Color3.fromRGB(230,120,180),Color3.fromRGB(0,200,220),Color3.fromRGB(230,200,90)}
for i,c in ipairs(sidebarColors) do local s=mk("TextButton",{Size=UDim2.fromOffset(12,12),Position=UDim2.new(0,8+(i-1)*13,1,-20),BackgroundColor3=c,BorderSizePixel=0,Text="",AutoButtonColor=false},sB) cr(s,6) s.MouseButton1Click:Connect(function() setAC(c) Cfg.acr=math.floor(c.R*255+0.5) Cfg.acg=math.floor(c.G*255+0.5) Cfg.acb=math.floor(c.B*255+0.5) sv() if _sT then _sT() end end) end
local function pg(n) local s=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=EL,CanvasSize=UDim2.new(0,0,0,900),Visible=false},ct) pages[n]=s return s end
local function cd(p,t,y) local f=mk("Frame",{Size=UDim2.new(1,-24,0,0),Position=UDim2.new(0,12,0,y),BackgroundColor3=PN,BorderSizePixel=0},p) cr(f,8) sk(f,BR,0.4) if t then local d=mk("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,10,0,14),BackgroundColor3=AC,BorderSizePixel=0},f) cr(d,2) rT(d) local tL=lb(f,string.upper(t),20,10,200,12,AC,10,true) rT(tL,nil,"TextColor3") end return f end
local function bt(p,t,x,y,w,h,k,cb) local o=mk("TextButton",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,Text=t,AutoButtonColor=false},p) if k=="p" then o.BackgroundColor3=AC o.TextColor3=Color3.new(1,1,1) elseif k=="d" then o.BackgroundColor3=Color3.fromRGB(56,34,34) o.TextColor3=Color3.fromRGB(230,150,150) else o.BackgroundColor3=EL o.TextColor3=TX end cr(o,6) if k=="p" then rT(o) end o.MouseEnter:Connect(function() TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=o.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play() end) o.MouseLeave:Connect(function() local tg2=EL if k=="p" then tg2=AC end if k=="d" then tg2=Color3.fromRGB(56,34,34) end TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=tg2}):Play() end) if cb then o.MouseButton1Click:Connect(cb) end return o end
local function tg(p,nm,ds,x,y,w,h,on,cb) local bx=mk("Frame",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundColor3=EL,BorderSizePixel=0},p) cr(bx,6) if ds then lb(bx,nm,10,5,w-50,14,TX,11,false) lb(bx,ds,10,20,w-50,11,SB,9,false) else lb(bx,nm,10,0,w-50,h,TX,11,false) end local st=on and true or false local sw=mk("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-44,0.5,-9),BackgroundColor3=st and AC or OFF,BorderSizePixel=0},bx) cr(sw,9) local kn=mk("Frame",{Size=UDim2.fromOffset(12,12),Position=st and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw) cr(kn,6) rT(sw,function() return st and AC or OFF end) local function ap(v) st=v and true or false pcall(function() TS:Create(sw,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{BackgroundColor3=st and AC or OFF}):Play() TS:Create(kn,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{Position=st and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play() end) end local z=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false},bx) z.MouseButton1Click:Connect(function() ap(not st) if cb then cb(st) end end) return {GetValue=function() return st end,SetValue=function(v) ap(v) end} end
local function N(t,c) local nf=mk("Frame",{Size=UDim2.fromOffset(220,50),Position=UDim2.new(1,-230,1,-70),BackgroundColor3=PN,BorderSizePixel=0,ZIndex=50},sg) cr(nf,8) local ns=sk(nf,AC,0.3) local t1=lb(nf,t,12,8,180,16,AC,11,true) t1.ZIndex=51 local t2=lb(nf,c,12,26,196,18,SB,10,false) t2.ZIndex=51 nf.BackgroundTransparency=1 ns.Transparency=1 TS:Create(nf,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play() TS:Create(ns,TweenInfo.new(0.2),{Transparency=0.3}):Play() task.delay(3,function() if not nf or not nf.Parent then return end TS:Create(nf,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play() TS:Create(ns,TweenInfo.new(0.3),{Transparency=1}):Play() TS:Create(t1,TweenInfo.new(0.3),{TextTransparency=1}):Play() TS:Create(t2,TweenInfo.new(0.3),{TextTransparency=1}):Play() task.delay(0.35,function() pcall(function() nf:Destroy() end) end) end) end
local stB=mk("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),BackgroundColor3=SF,BorderSizePixel=0},win)
local stD=mk("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,11,0.5,-2),BackgroundColor3=AC,BorderSizePixel=0},stB) cr(stD,3) rT(stD)
local stL=lb(stB,"Place 0 | Upgrade 0 | Sell 0",22,0,300,18,MT,9,false)
local vis=true
local fl=mk("TextButton",{Size=UDim2.fromOffset(78,34),Position=UDim2.new(0,16,0,16),BackgroundColor3=HD,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TX,Text="Toggle",AutoButtonColor=false,ZIndex=30},sg) cr(fl,17)
local fS=sk(fl,AC,0.4) rT(fS,nil,"Color")
local fd=mk("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,10,0.5,-4),BackgroundColor3=AC,BorderSizePixel=0},fl) cr(fd,4) rT(fd)
local fDg,fM,f0,f1=false,false,nil,nil
fl.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fDg=true fM=false f0=i.Position f1=fl.Position end end)
UIS.InputChanged:Connect(function(i) if fDg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-f0 if math.abs(d.X)>4 or math.abs(d.Y)>4 then fM=true end fl.Position=UDim2.new(f1.X.Scale,f1.X.Offset+d.X,f1.Y.Scale,f1.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fDg=false end end)
local function shW(v) vis=v if v then win.Visible=true win.BackgroundTransparency=1 wS.Transparency=1 TS:Create(win,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play() TS:Create(wS,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.35}):Play() TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=AC}):Play() else TS:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play() TS:Create(wS,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency=1}):Play() task.delay(0.3,function() if not vis then win.Visible=false end end) TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=Color3.fromRGB(90,196,140)}):Play() end end
fl.MouseButton1Click:Connect(function() if not fM then shW(not vis) end end)
local _sD,_dlg
local function killD(inst) if not _dlg then return end if inst then pcall(function() _dlg:Destroy() end) pcall(function() _sD:Destroy() end) _dlg=nil _sD=nil return end local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In) local items={_dlg,_sD} for _,c in ipairs(_dlg:GetDescendants()) do items[#items+1]=c end for _,el in ipairs(items) do if el and el:IsA("TextLabel") then TS:Create(el,ti,{TextTransparency=1}):Play() elseif el and el:IsA("TextButton") then TS:Create(el,ti,{BackgroundTransparency=1,TextTransparency=1}):Play() elseif el and el:IsA("UIStroke") then TS:Create(el,ti,{Transparency=1}):Play() elseif el and el:IsA("Frame") then TS:Create(el,ti,{BackgroundTransparency=1}):Play() end end task.delay(0.28,function() pcall(function() _dlg:Destroy() end) pcall(function() _sD:Destroy() end) _dlg=nil _sD=nil end) end
local function ask() killD(true) _sD=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=40},sg) _dlg=mk("Frame",{Size=UDim2.fromOffset(280,130),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=PN,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=41},sg) cr(_dlg,10) local ds=sk(_dlg,BR,1) local dt=lb(_dlg,"Close GUI",14,14,250,20,TX,14,true) dt.TextTransparency=1 dt.ZIndex=42 local dm=mk("TextLabel",{Size=UDim2.new(1,-28,0,40),Position=UDim2.new(0,14,0,40),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=SB,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text="Are you sure you want to close this GUI?",TextTransparency=1,ZIndex=42},_dlg) local nb=mk("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0,14,1,-46),BackgroundColor3=EL,BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=TX,TextTransparency=1,Text="No",AutoButtonColor=false,ZIndex=42},_dlg) cr(nb,6) local yb=mk("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0.5,6,1,-46),BackgroundColor3=Color3.fromRGB(180,70,70),BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.new(1,1,1),TextTransparency=1,Text="Yes",AutoButtonColor=false,ZIndex=42},_dlg) cr(yb,6) local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out) TS:Create(_sD,ti,{BackgroundTransparency=0.5}):Play() TS:Create(_dlg,ti,{BackgroundTransparency=0}):Play() TS:Create(ds,ti,{Transparency=0.3}):Play() TS:Create(dt,ti,{TextTransparency=0}):Play() TS:Create(dm,ti,{TextTransparency=0}):Play() TS:Create(nb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play() TS:Create(yb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play() nb.MouseButton1Click:Connect(function() killD(false) end) yb.MouseButton1Click:Connect(function() if rec.on then rec.on=false pcall(unHook) end pb.on=false pcall(stopAutoSkip) pcall(stopAutoVote) pcall(stopAutoStart) pcall(stopAutoPlayAgain) sv() pcall(function() sg:Destroy() end) end) end
xb.MouseButton1Click:Connect(ask)

-- ============================================================
-- REMOTE DISCOVERY
-- ============================================================
local function getRF() local ml=RS:FindFirstChild("ModuleLoader") if not ml then return nil end local sh=ml:FindFirstChild("Shared") if not sh then return nil end local nw=sh:FindFirstChild("Network") if not nw then return nil end return nw:FindFirstChild("RemoteEvent") end
local REM={} local UP_REMS={} local SELL_REMS={} local PLACE_REMS={}
local function tryPath(...) local cur=RS for _,name in ipairs({...}) do cur=cur:FindFirstChild(name) if not cur then return nil end end return cur end
local function findRemotesFor(kind)
    local list={} local candidates={}
    if kind=="U" then candidates={{"ModuleLoader","Shared","Network","RemoteEvent","TowerUpgrade"},{"Functions","UpgradeTower"},{"RemoteFunctions","UpgradeTower"},{"Remotes","UpgradeTower"},{"Network","RemoteEvent","TowerUpgrade"}}
    elseif kind=="S" then candidates={{"ModuleLoader","Shared","Network","RemoteEvent","TowerSell"},{"Functions","SellTower"},{"RemoteFunctions","SellTower"},{"Remotes","SellTower"},{"Network","RemoteEvent","TowerSell"}}
    elseif kind=="P" then candidates={{"ModuleLoader","Shared","Network","RemoteEvent","TowerAdd"},{"Functions","PlaceTower"},{"RemoteFunctions","PlaceTower"},{"Remotes","PlaceTower"},{"Network","RemoteEvent","TowerAdd"}} end
    for _,p in ipairs(candidates) do local r=tryPath(unpack(p)) if r then table.insert(list,r) print("[EZVC] found "..kind..": "..r:GetFullName()) end end
    return list
end
local function rRem()
    local f=getRF()
    if f then REM.Add=f:FindFirstChild("TowerAdd") REM.Up=f:FindFirstChild("TowerUpgrade") REM.Sell=f:FindFirstChild("TowerSell") REM.Skip=f:FindFirstChild("WaveSkip") REM.Vote=f:FindFirstChild("ModeVote") end
    UP_REMS=findRemotesFor("U") SELL_REMS=findRemotesFor("S") PLACE_REMS=findRemotesFor("P")
    return REM.Add and REM.Up and REM.Sell
end
rRem()

-- ============================================================
-- UUID EXTRACTION
-- ============================================================
local function looksLikeUuid(s)
    if type(s)~="string" then return false end
    if #s<30 or #s>50 then return false end
    if not s:find("-") then return false end
    if s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then return true end
    local hex,other=0,0
    for i=1,#s do local c=s:sub(i,i) if c:match("%x") then hex=hex+1 elseif c=="-" then else other=other+1 end end
    if other>2 then return false end return hex>=#s-4
end
local DIAG_DUMPED=false
local function dumpTowerDiag(t) if DIAG_DUMPED then return end DIAG_DUMPED=true print("=== TOWER DIAG ===") print("Name: "..tostring(t.Name)) end
local function extId(o)
    if not o then return nil end
    if looksLikeUuid(o.Name) then return o.Name end
    local KNOWN={"Id","ID","UnitId","UUID","uid","InstanceId","GUID","UnitID","TowerId","PlacementId","TowerID","_id","__id","_uuid","_Id"}
    for _,a in ipairs(KNOWN) do local ok,v=pcall(function() return o:GetAttribute(a) end) if ok and v~=nil then return v end end
    for _,a in ipairs(o:GetAttributes()) do local v=o:GetAttribute(a) if looksLikeUuid(v) then return v end end
    for _,a in ipairs(KNOWN) do local c=o:FindFirstChild(a) if c and (c:IsA("StringValue") or c:IsA("IntValue") or c:IsA("NumberValue")) then return c.Value end end
    for _,d in ipairs(o:GetDescendants()) do if d:IsA("StringValue") and looksLikeUuid(d.Value) then return d.Value end end
    for _,d in ipairs(o:GetDescendants()) do if looksLikeUuid(d.Name) then return d.Name end end
    return nil
end
local function getTowersFolder() return workspace:FindFirstChild("Towers") end
local function findTowerById(id) if id==nil then return nil end local tw=getTowersFolder() if not tw then return nil end local ids=tostring(id) for _,o in ipairs(tw:GetChildren()) do local oid=extId(o) if oid~=nil and tostring(oid)==ids then return o end end return nil end
local function findTowerByPosNear(pos,tol) local tw=getTowersFolder() if not tw then return nil end local best,bestD=nil,tol or 5 for _,o in ipairs(tw:GetChildren()) do local ok,pv=pcall(function() return o:GetPivot().Position end) if ok and pv then local d=(pv-pos).Magnitude if d<bestD then bestD=d best=o end end end return best end
local function getTowerName(t) if not t then return "?" end for _,a in ipairs({"UnitName","TowerName","Type","Unit","UnitType","Tower"}) do local ok,v=pcall(function() return t:GetAttribute(a) end) if ok and type(v)=="string" and v~="" then return v end end for _,c in ipairs(t:GetChildren()) do if c:IsA("StringValue") and (c.Name:lower():find("type") or c.Name:lower():find("name")) then if c.Value~="" then return c.Value end end end return t.Name end
local function isModel(o) local ok=pcall(function() return o:IsA("Model") end) return ok and o:IsA("Model") end
local function captureNewTower(pos,known,timeout)
    local deadline=tick()+timeout local found,fid=nil,nil
    local conn=workspace.DescendantAdded:Connect(function(o) if found then return end if not isModel(o) then return end if known[o] then return end local ok,pv=pcall(function() return o:GetPivot().Position end) if ok and (pv-pos).Magnitude<25 then found=o fid=extId(o) end end)
    while tick()<deadline and not found do
        local tw=getTowersFolder()
        if tw then for _,o in ipairs(tw:GetChildren()) do if not known[o] and not found then local ok,pv=pcall(function() return o:GetPivot().Position end) if ok and (pv-pos).Magnitude<25 then found=o fid=extId(o) end end end end
        if found then break end task.wait(0.01)
    end
    pcall(function() conn:Disconnect() end)
    return found,fid
end
local function snapshotTowers() local s={} local tw=getTowersFolder() if tw then for _,o in ipairs(tw:GetChildren()) do s[o]=true end end return s end

-- ============================================================
-- MACRO STATE (uses forward-declared rec/pb/unHook)
-- ============================================================
local hInst=false local hOld=nil local hookMethodUsed=nil local hits=0
local function callR(fn,args) if not fn then return nil end if fn:IsA("RemoteFunction") then local ok,res=pcall(function() return fn:InvokeServer(args) end) if ok then return res end else local ok=pcall(function() fn:FireServer(args) end) if ok then return true end end return nil end
local function classifyRemote(self)
    local ok,nm=pcall(function() return self.Name end)
    if ok and type(nm)=="string" then
        if nm=="TowerAdd" or nm=="PlaceTower" then return "P" end
        if nm=="TowerUpgrade" or nm=="UpgradeTower" then return "U" end
        if nm=="TowerSell" or nm=="SellTower" then return "S" end
    end
    if self==REM.Add then return "P" end
    if self==REM.Up then return "U" end
    if self==REM.Sell then return "S" end
    for _,r in ipairs(UP_REMS) do if self==r then return "U" end end
    for _,r in ipairs(SELL_REMS) do if self==r then return "S" end end
    return nil
end
local function tryUpgrade(gid,inst)
    local gidStr = gid~=nil and tostring(gid) or nil
    for _,rem in ipairs(UP_REMS) do if rem and rem.Parent then
        if rem:IsA("RemoteFunction") then
            if inst then local ok=pcall(function() return rem:InvokeServer(inst) end) if ok then return true end end
            if gidStr then local ok=pcall(function() return rem:InvokeServer({Id=gidStr}) end) if ok then return true end end
        elseif rem:IsA("RemoteEvent") then
            if gidStr then local ok=pcall(function() rem:FireServer({Id=gidStr}) end) if ok then return true end end
            if inst then local ok=pcall(function() rem:FireServer(inst) end) if ok then return true end end
        end
    end end
    return false
end
local function trySell(gid,inst)
    local gidStr = gid~=nil and tostring(gid) or nil
    for _,rem in ipairs(SELL_REMS) do if rem and rem.Parent then
        if rem:IsA("RemoteFunction") then
            if inst then local ok=pcall(function() return rem:InvokeServer(inst) end) if ok then return true end end
            if gidStr then local ok=pcall(function() return rem:InvokeServer({Id=gidStr}) end) if ok then return true end end
        elseif rem:IsA("RemoteEvent") then
            if gidStr then local ok=pcall(function() rem:FireServer({Id=gidStr}) end) if ok then return true end end
            if inst then local ok=pcall(function() rem:FireServer(inst) end) if ok then return true end end
        end
    end end
    return false
end
local function recCall(self,m,args)
    local kind=classifyRemote(self)
    if not kind then return end
    hits=hits+1
    if kind=="P" then
        local d=args[1]
        if type(d)=="table" and d.CFrame and d.Pos then
            rec.n=rec.n+1 local sid=rec.n local cf=d.CFrame local ps=d.Pos local tk=tick() local delay=tk-(rec.l~=0 and rec.l or tk) rec.l=tk
            table.insert(rec.a,{t="P",sid=sid,unitId=d.UnitId,name=d.Name,cf={cf:GetComponents()},pos={ps.X,ps.Y,ps.Z},d=delay})
            local known=snapshotTowers()
            task.spawn(function()
                local u,gid=captureNewTower(ps,known,5)
                if u and gid~=nil then rec.k["id:"..tostring(gid)]=sid end
                if u then rec.t[sid]=u rec.k[u]=sid rec.last=u end
                if _cL then _cL() end
            end)
        end
    elseif kind=="U" then
        local d=args[1]
        if type(d)=="table" and d.Id~=nil then
            local idStr=tostring(d.Id) local sid=rec.k["id:"..idStr]
            if not sid then local tw=findTowerById(d.Id) if tw then sid=rec.k[tw] end end
            if not sid then for i=#rec.a,1,-1 do if rec.a[i].t=="P" and rec.a[i].sid and not rec.a[i].upgraded then sid=rec.a[i].sid rec.a[i].upgraded=true break end end end
            if sid then
                local nm,ps=nil,nil local tw=rec.t[sid]
                if tw and tw.Parent then nm=getTowerName(tw) local ok2,pv=pcall(function() return tw:GetPivot().Position end) if ok2 and pv then ps={pv.X,pv.Y,pv.Z} end end
                local tk=tick() local delay=tk-(rec.l~=0 and rec.l or tk) rec.l=tk
                table.insert(rec.a,{t="U",sid=sid,origId=idStr,name=nm,pos=ps,d=delay})
                if _cL then _cL() end
            end
        end
    elseif kind=="S" then
        local d=args[1]
        if type(d)=="table" and d.Id~=nil then
            local idStr=tostring(d.Id) local sid=rec.k["id:"..idStr]
            if not sid then local tw=findTowerById(d.Id) if tw then sid=rec.k[tw] end end
            if sid then
                local nm,ps=nil,nil local tw=rec.t[sid]
                if tw and tw.Parent then nm=getTowerName(tw) local ok2,pv=pcall(function() return tw:GetPivot().Position end) if ok2 and pv then ps={pv.X,pv.Y,pv.Z} end end
                local tk=tick() local delay=tk-(rec.l~=0 and rec.l or tk) rec.l=tk
                table.insert(rec.a,{t="S",sid=sid,origId=idStr,name=nm,pos=ps,d=delay})
                if _cL then _cL() end
            end
        end
    end
end
local function hBd(self,...)
    if not rec.on then return hOld(self,...) end
    if not REM.Add or not REM.Add.Parent then rRem() end
    local kind=classifyRemote(self) if not kind then return hOld(self,...) end
    local m=getnamecallmethod and getnamecallmethod() or ""
    if m~="FireServer" and m~="InvokeServer" then return hOld(self,...) end
    local a={...} local r=hOld(self,...)
    pcall(recCall,self,m,a)
    return r
end
local function inHook()
    if hInst then return true end
    if type(hookmetamethod)=="function" and type(newcclosure)=="function" then
        local ok=pcall(function() hOld=hookmetamethod(game,"__namecall",newcclosure(hBd)) end)
        if ok and hOld then hInst=true hookMethodUsed="hm" return true end
    end
    if type(getrawmetatable)=="function" and type(setreadonly)=="function" and type(newcclosure)=="function" then
        local ok=pcall(function() local mt=getrawmetatable(game) hOld=mt.__namecall setreadonly(mt,false) mt.__namecall=newcclosure(hBd) setreadonly(mt,true) end)
        if ok and hOld then hInst=true hookMethodUsed="grm" return true end
    end
    return false
end
unHook = function()
    if not hInst then return end
    hInst=false
    if hookMethodUsed=="hm" and type(hookmetamethod)=="function" then pcall(function() hookmetamethod(game,"__namecall",hOld) end)
    else pcall(function() local mt=getrawmetatable(game) setreadonly(mt,false) mt.__namecall=hOld setreadonly(mt,true) end) end
    hOld=nil hookMethodUsed=nil
end

-- ============================================================
-- PLAYBACK
-- ============================================================
local C={P=0,U=0,S=0}
local function play()
    if pb.on then return end
    pb.on=true pb.sess=pb.sess+1 local ms=pb.sess
    local path=findMacroPath(sel) local data=rj(path)
    if type(data)~="table" or #data==0 then pb.on=false return end
    C.P=0 C.U=0 C.S=0
    if not rRem() then N("Macro","Remotes not found") pb.on=false return end
    local sidToInst={}
    task.spawn(function()
        for cd=7,1,-1 do if not pb.on or pb.sess~=ms then return end N("EZVC","Starting in "..cd.."...") task.wait(1) end
        for idx,a in ipairs(data) do
            if not pb.on or pb.sess~=ms then break end
            local d=a.d or 0
            if d>0 then local t0=tick() while tick()-t0<d and pb.on and pb.sess==ms do task.wait() end end
            if not pb.on or pb.sess~=ms then break end
            if a.t=="P" then
                local ps=Vector3.new(unpack(a.pos)) local cf=CFrame.new(unpack(a.cf))
                local res=callR(REM.Add,{UnitId=a.unitId,CFrame=cf,Name=a.name,Pos=ps})
                C.P=C.P+1
                local gid=nil
                if type(res)=="table" then gid=res.Id or res.ID or res.UnitId or res.UUID
                elseif type(res)=="string" or type(res)=="number" then gid=res end
                if gid then
                    sidToInst[a.sid]={gid=gid,inst=nil}
                    task.spawn(function() local known=snapshotTowers() local inst=select(1,captureNewTower(ps,known,1.5)) if inst and sidToInst[a.sid] and not sidToInst[a.sid].inst then sidToInst[a.sid].inst=inst end end)
                else
                    local known=snapshotTowers() local inst,fid=captureNewTower(ps,known,2)
                    if inst or fid then sidToInst[a.sid]={gid=fid or (inst and extId(inst)),inst=inst} end
                end
            elseif a.t=="U" then
                local entry=sidToInst[a.sid] local gid=entry and entry.gid local inst=entry and entry.inst
                if inst and inst.Parent and not gid then gid=extId(inst) end
                if not inst and gid then inst=findTowerById(gid) end
                if not inst and a.pos then inst=findTowerByPosNear(Vector3.new(unpack(a.pos)),10) if inst then gid=extId(inst) or gid end end
                if inst or gid then if tryUpgrade(gid,inst) then C.U=C.U+1 end end
            elseif a.t=="S" then
                local entry=sidToInst[a.sid] local gid=entry and entry.gid local inst=entry and entry.inst
                if inst and inst.Parent and not gid then gid=extId(inst) end
                if not inst and gid then inst=findTowerById(gid) end
                if not inst and a.pos then inst=findTowerByPosNear(Vector3.new(unpack(a.pos)),10) if inst then gid=extId(inst) or gid end end
                if inst or gid then if trySell(gid,inst) then C.S=C.S+1 end end
            end
        end
        if pb.sess==ms then pb.on=false if _pT and _pT.GetValue() then _pT.SetValue(false) end end
    end)
end
local function stopP() pb.on=false pb.sess=pb.sess+1 end

-- ============================================================
-- AUTO SKIP
-- ============================================================
local autoSkipOn=false local autoSkipSess=0
local function startAutoSkip()
    if autoSkipOn then return end
    autoSkipOn=true autoSkipSess=autoSkipSess+1 local ms=autoSkipSess
    task.spawn(function() while autoSkipOn and autoSkipSess==ms and sg and sg.Parent do if not REM.Skip or not REM.Skip.Parent then rRem() end if REM.Skip then pcall(function() REM.Skip:FireServer() end) end task.wait(1) end end)
end
stopAutoSkip = function() autoSkipOn=false autoSkipSess=autoSkipSess+1 end

-- ============================================================
-- AUTO VOTE
-- ============================================================
local voteModes={"Easy","Normal","Hard","Insane"} local voteIdx=1
for i,v in ipairs(voteModes) do if v==Cfg.vm then voteIdx=i end end
local autoVoteOn=false local autoVoteSess=0 local autoVoteTg=nil
stopAutoVote = function() autoVoteOn=false autoVoteSess=autoVoteSess+1 end
local function startAutoVote()
    if autoVoteOn then return end
    autoVoteOn=true autoVoteSess=autoVoteSess+1 local ms=autoVoteSess local mode=voteModes[voteIdx]
    task.spawn(function()
        for i=1,10 do
            if not autoVoteOn or autoVoteSess~=ms or not sg or not sg.Parent then return end
            if not REM.Vote or not REM.Vote.Parent then rRem() end
            if REM.Vote then pcall(function() REM.Vote:FireServer(mode) end) end
            if i<10 then task.wait(1) end
        end
        autoVoteOn=false
        if autoVoteTg then autoVoteTg.SetValue(true) end
    end)
end

-- ============================================================
-- TP_PRESETS
-- ============================================================
local TP_PRESETS={
    {name="Toilet City", pos=Vector3.new(743,308,619)},
    {name="Camerman HQ", pos=Vector3.new(743,308,502)},
    {name="Desert",      pos=Vector3.new(742,308,725)},
}
local tppIdx=1
for i,v in ipairs(TP_PRESETS) do if v.name==Cfg.tpp then tppIdx=i end end
local function getCurrentPos() return TP_PRESETS[tppIdx].pos end
local function teleportToGamePos()
    local char=PLR.Character
    if char and char.PrimaryPart then pcall(function() char:PivotTo(CFrame.new(getCurrentPos())) end) return true end
    return false
end

-- ============================================================
-- SPEED (ChangeSpeed)
-- ============================================================
local function getChangeSpeedRemote() return tryPath("ModuleLoader","Shared","Network","RemoteFunction","ChangeSpeed") end
local function applySpeed(s)
    s = s or Cfg.spd or "1"
    local r = getChangeSpeedRemote()
    if not r then warn("[EZVC] ChangeSpeed remote not found - skip") return false end
    local ok, err = pcall(function() r:InvokeServer(s) end)
    if not ok then warn("[EZVC] ChangeSpeed failed: "..tostring(err)) return false end
    print("[EZVC] Speed set to "..tostring(s))
    return true
end
local function setSpeed(s) Cfg.spd=s sv() print("[EZVC] saved spd="..tostring(s)) applySpeed(s) end

-- ============================================================
-- AUTO GAME (TP only)
-- ============================================================
local autoGameOn=false local autoGameSess=0
local function startAutoGame()
    if autoGameOn then return end
    autoGameOn=true autoGameSess=autoGameSess+1 local ms=autoGameSess
    task.spawn(function()
        if not autoGameOn or autoGameSess~=ms then return end
        if not teleportToGamePos() then for _=1,50 do task.wait(0.1) if not autoGameOn or autoGameSess~=ms then return end if teleportToGamePos() then break end end end
        if autoGameSess==ms then autoGameOn=false end
    end)
end
local function stopAutoGame() autoGameOn=false autoGameSess=autoGameSess+1 end

-- ============================================================
-- AUTO START
-- ============================================================
local ELEVATORS={
    {name="Toilet City", arg="Elevator1"},
    {name="Desert",      arg="Elevator2"},
    {name="Elevator3",   arg="Elevator3"},
}
local elevIdx=1
for i,v in ipairs(ELEVATORS) do if v.name==Cfg.elev then elevIdx=i end end
local autoStartOn=false local autoStartSess=0
local function fireElevatorOnce()
    local arg=ELEVATORS[elevIdx].arg
    local e=tryPath("ModuleLoader","Shared","Network","RemoteFunction","ElevatorEnter")
    local s=tryPath("ModuleLoader","Shared","Network","RemoteFunction","ElevatorStart")
    if e then pcall(function() e:InvokeServer(arg) end) end
    task.wait(0.5)
    if s then pcall(function() s:InvokeServer(arg) end) end
end
local function startAutoStart()
    if autoStartOn then return end
    autoStartOn=true autoStartSess=autoStartSess+1 local ms=autoStartSess
    task.spawn(function()
        if not teleportToGamePos() then for _=1,50 do task.wait(0.1) if not autoStartOn or autoStartSess~=ms then return end if teleportToGamePos() then break end end end
        task.wait(1)
        if not autoStartOn or autoStartSess~=ms then return end
        for i=1,4 do
            if not autoStartOn or autoStartSess~=ms then return end
            fireElevatorOnce()
            if i<4 then task.wait(2) end
        end
        if autoStartSess==ms then autoStartOn=false end
    end)
end
stopAutoStart = function() autoStartOn=false autoStartSess=autoStartSess+1 end

-- ============================================================
-- PLAY AGAIN
-- ============================================================
local function getPlayAgainRemote() return tryPath("ModuleLoader","Shared","Network","RemoteEvent","PlayAgain") end
local function visEl(d)
    if not d.Visible then return false end
    local p=d.Parent
    while p do if p:IsA("GuiObject") and not p.Visible then return false end p=p.Parent end
    return true
end
local function findBtn(tx)
    local nd=tx:lower() local rr={PLR:FindFirstChild("PlayerGui")}
    pcall(function() if gethui then local ok,h=pcall(gethui) if ok and h then rr[#rr+1]=h end end end)
    for _,root in ipairs(rr) do if root then for _,d in ipairs(root:GetDescendants()) do if (d:IsA("TextButton") or d:IsA("ImageButton")) and visEl(d) then local t=d.Text if d:IsA("ImageButton") then local l2=d:FindFirstChildOfClass("TextLabel") if l2 then t=l2.Text end end if tostring(t or ""):lower():find(nd,1,true) then return d end end end end end
end
local _loseCache=nil
local function lose() if _loseCache and _loseCache.Parent and visEl(_loseCache) then return true end _loseCache=findBtn("replay") return _loseCache~=nil end
local function playAgainNow()
    local r=getPlayAgainRemote()
    if not r then warn("[EZVC] PlayAgain remote not found") return false end
    local ok,err=pcall(function() r:FireServer() end)
    if not ok then warn("[EZVC] PlayAgain failed: "..tostring(err)) return false end
    return true
end
local autoPlayAgainOn=false local autoPlayAgainSess=0
local function startAutoPlayAgain()
    if autoPlayAgainOn then return end
    autoPlayAgainOn=true autoPlayAgainSess=autoPlayAgainSess+1 local ms=autoPlayAgainSess
    task.spawn(function()
        local prevLose=lose()
        while autoPlayAgainOn and autoPlayAgainSess==ms and sg and sg.Parent do
            task.wait(0.5)
            local cur=lose()
            if (not prevLose) and cur then
                task.wait(1)
                if not autoPlayAgainOn or autoPlayAgainSess~=ms then return end
                playAgainNow()
                prevLose=true
                task.wait(0.5)
                cur=lose()
            end
            prevLose=cur
        end
    end)
end
stopAutoPlayAgain = function() autoPlayAgainOn=false autoPlayAgainSess=autoPlayAgainSess+1 end

-- ============================================================
-- PAGES
-- ============================================================
local mP=pg("Main")
local c1=cd(mP,"Statistics",12) c1.Size=UDim2.new(1,-24,0,84)
lb(c1,"Place",12,30,80,12,SB,9,false) lb(c1,"Upgrade",112,30,80,12,SB,9,false) lb(c1,"Sell",212,30,80,12,SB,9,false)
local _pL=lb(c1,"0",12,44,80,20,TX,16,true) local _uL=lb(c1,"0",112,44,80,20,TX,16,true) local _sL=lb(c1,"0",212,44,80,20,TX,16,true)
local function rC() pcall(function() stL.Text=string.format("Place %d | Upgrade %d | Sell %d",C.P,C.U,C.S) end) pcall(function() _pL.Text=tostring(C.P) _uL.Text=tostring(C.U) _sL.Text=tostring(C.S) end) end

local pP=pg("Play")
local cp=cd(pP,"Automation",12) cp.Size=UDim2.new(1,-24,0,240)
tg(cp,"Auto Skip",nil,12,26,240,38,Cfg.sk,function(on) set("sk",on) if on then startAutoSkip() else stopAutoSkip() end end)
lb(cp,"AUTO VOTE",12,74,120,12,SB,9,true)
autoVoteTg=tg(cp,"Auto Vote",nil,12,90,240,38,Cfg.av,function(on) set("av",on) if on then startAutoVote() else stopAutoVote() end end)
local vmLbl=mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,134),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="  Mode: "..voteModes[voteIdx],AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},cp) cr(vmLbl,5)
vmLbl.MouseButton1Click:Connect(function() voteIdx=voteIdx%#voteModes+1 vmLbl.Text="  Mode: "..voteModes[voteIdx] set("vm",voteModes[voteIdx]) end)
bt(cp,"Send Vote Now",12,168,240,28,"p",function() if not REM.Vote or not REM.Vote.Parent then rRem() end if REM.Vote then pcall(function() REM.Vote:FireServer(voteModes[voteIdx]) end) end N("Macro","Voted: "..voteModes[voteIdx]) end)

local cs=cd(pP,"Speed",272) cs.Size=UDim2.new(1,-24,0,90)
local spdVals={"1","1.5","2"} local spdLabels={"1x","1.5x","2x"} local spdBtns={}
local function refreshSpdBtns()
    for i,b in ipairs(spdBtns) do if b and b.Parent then local on=(Cfg.spd==spdVals[i]) pcall(function() TS:Create(b,TweenInfo.new(0.15),{BackgroundColor3=on and AC or EL}):Play() end) end end
end
for i,lbl in ipairs(spdLabels) do
    local b=mk("TextButton",{Size=UDim2.fromOffset(74,36),Position=UDim2.new(0,12+(i-1)*78,0,32),BackgroundColor3=(Cfg.spd==spdVals[i]) and AC or EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=lbl,AutoButtonColor=false},cs)
    cr(b,6)
    b.MouseButton1Click:Connect(function() setSpeed(spdVals[i]) refreshSpdBtns() end)
    b.MouseEnter:Connect(function() pcall(function() TS:Create(b,TweenInfo.new(0.14),{BackgroundColor3=b.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play() end) end)
    b.MouseLeave:Connect(function() refreshSpdBtns() end)
    spdBtns[i]=b
end
rT(spdBtns[1]) rT(spdBtns[2]) rT(spdBtns[3])
refreshSpdBtns()

local cg=cd(pP,"Auto Game",382) cg.Size=UDim2.new(1,-24,0,110)
tg(cg,"Auto Game","TP -> selected preset only",12,26,240,38,Cfg.ag,function(on) set("ag",on) if on then startAutoGame() else stopAutoGame() end end)
lb(cg,"TP PRESET",12,70,120,12,SB,9,true)
local tpLbl=mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,84),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="  "..TP_PRESETS[tppIdx].name,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},cg) cr(tpLbl,5)
tpLbl.MouseButton1Click:Connect(function() tppIdx=tppIdx%#TP_PRESETS+1 local p=TP_PRESETS[tppIdx] tpLbl.Text="  "..p.name set("tpp",p.name) end)

local ca=cd(pP,"Auto Start",502) ca.Size=UDim2.new(1,-24,0,110)
tg(ca,"Auto Start","TP -> 1s -> Elevator x4 (every 2s)",12,26,240,38,Cfg.ast,function(on) set("ast",on) if on then startAutoStart() else stopAutoStart() end end)
lb(ca,"ELEVATOR",12,70,120,12,SB,9,true)
local elevLbl=mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,84),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="  "..ELEVATORS[elevIdx].name,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},ca) cr(elevLbl,5)
elevLbl.MouseButton1Click:Connect(function() elevIdx=elevIdx%#ELEVATORS+1 elevLbl.Text="  "..ELEVATORS[elevIdx].name set("elev",ELEVATORS[elevIdx].name) end)

local cpa=cd(pP,"Play Again",622) cpa.Size=UDim2.new(1,-24,0,140)
tg(cpa,"Auto Play Again","Auto-fire on round end",12,26,240,38,Cfg.apr,function(on) set("apr",on) if on then startAutoPlayAgain() else stopAutoPlayAgain() end end)
bt(cpa,"Play Again Now",12,76,240,34,"p",function() local ok=playAgainNow() if ok then N("Play Again","Round restarted") else N("Play Again","RemoteEvent missing") end end)

local mP2=pg("Macro")
local rc=cd(mP2,"Macro Name",12) rc.Size=UDim2.new(1,-24,0,56)
lb(rc,"Name",12,26,50,24,SB,11,false)
local mnBox=mk("TextBox",{Size=UDim2.new(1,-80,0,26),Position=UDim2.new(0,64,0,20),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,PlaceholderText="e.g. Farm",PlaceholderColor3=MT,Text=Cfg.mn or "",ClearTextOnFocus=false},rc) cr(mnBox,5)
mnBox.FocusLost:Connect(function() set("mn",mnBox.Text or "") end)
local rc2=cd(mP2,"Macro Actions",76) rc2.Size=UDim2.new(1,-24,0,300)
local mStat=lb(rc2,"Status: Idle",12,26,110,14,SB,10,true)
local mCnt=lb(rc2,"Actions: 0",124,26,100,14,MT,10,false)
lb(rc2,"STATISTICS",12,48,120,12,SB,9,true)
local sPl=lb(rc2,"Place: 0",12,64,90,16,TX,11,true)
local sUp=lb(rc2,"Upgrade: 0",102,64,90,16,TX,11,true)
local sSl=lb(rc2,"Sell: 0",192,64,90,16,TX,11,true)
local function sSt(s) if not mStat or not mStat.Parent then return end local col=MT if s=="Recording" then col=Color3.fromRGB(220,96,96) elseif s=="Playing" then col=Color3.fromRGB(90,196,140) elseif s=="Idle" then col=SB end mStat.Text="Status: "..s pcall(function() TS:Create(mStat,TweenInfo.new(0.2),{TextColor3=col}):Play() end) end
local function sCn(n) if mCnt and mCnt.Parent then mCnt.Text="Actions: "..tostring(n) end end
local mList=lf() local mIdx=0
for i,v in ipairs(mList) do if v==sel then mIdx=i end end
local mSel=mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,90),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=sel~="" and sel or "-- select macro --",AutoButtonColor=false},rc2) cr(mSel,5)
local function rML() mList=lf() mIdx=0 for i,v in ipairs(mList) do if v==sel then mIdx=i end end mSel.Text=sel~="" and sel or "-- select macro --" end
mSel.MouseButton1Click:Connect(function() mList=lf() if #mList==0 then N("Macro","No saved macros") return end mIdx=mIdx%#mList+1 local ch=mList[mIdx] mSel.Text=ch sel=ch set("sel",ch) end)
bt(rc2,"Create / Save Macro",12,126,240,28,"p",function() local n=mnBox.Text or "" if n=="" then N("Macro","Enter a name") return end if FS.write then pcall(writefile,FO..n..".json","[]") end sel=n set("sel",n) rML() N("Macro","Ready: "..n) end)
local rToggle
rToggle=tg(rc2,"Record Macro","Start/stop recording",12,162,240,38,false,function(on)
    if on then
        if rec.on then N("Macro","Already recording") rToggle.SetValue(true) return end
        if pb.on then N("Macro","Stop playback first") rToggle.SetValue(false) return end
        if sel=="" then N("Macro","Select a macro first") rToggle.SetValue(false) return end
        rec.a={} rec.n=0 rec.t={} rec.k={} rec.l=0 rec.last=nil
        C.P=0 C.U=0 C.S=0 rC() sCn(0) hits=0 DIAG_DUMPED=false
        rRem()
        local ok=inHook()
        if not ok then N("Macro","Hook unavailable") rToggle.SetValue(false) return end
        rec.on=true sSt("Recording") N("Macro","Recording -> "..sel)
    else
        if not rec.on then sSt("Idle") return end
        rec.on=false unHook()
        if #rec.a>0 and sel~="" then
            local path=FO..sel..".json" local ok,err=wj(path,rec.a)
            if ok then N("Macro","Saved "..#rec.a.." steps") else N("Macro","Save failed: "..tostring(err)) end
        else N("Macro","Nothing saved (hits="..hits..")") end
        rec.a={} rec.n=0 rec.t={} rec.k={} rec.l=0 rec.last=nil
        C.P=0 C.U=0 C.S=0 rC() sCn(0) sSt("Idle")
    end
end)
local _pT
_pT=tg(rc2,"Play Macro","Playback recorded macro",12,206,240,38,Cfg.pl,function(on)
    if on then
        if rec.on then N("Macro","Stop recording first") _pT.SetValue(false) return end
        if sel=="" then N("Macro","Select a macro first") _pT.SetValue(false) return end
        local path=findMacroPath(sel) local d=rj(path)
        if type(d)~="table" or #d==0 then N("Macro","Macro empty") _pT.SetValue(false) return end
        set("pl",true) sSt("Playing") play()
    else stopP() set("pl",false) sSt("Idle") end
end)
bt(rc2,"Delete Macro",12,252,240,28,"d",function() if sel=="" then N("Macro","Select a macro") return end local path=findMacroPath(sel) pcall(function() if FS.del then delfile(path) end end) sel="" set("sel","") rML() N("Macro","Deleted") end)

local gP=pg("GUI")
local th=cd(gP,"Theme",12) th.Size=UDim2.new(1,-24,0,180)
local themes={{n="Purple",c=Color3.fromRGB(155,120,255)},{n="Red",c=Color3.fromRGB(220,96,96)},{n="Blue",c=Color3.fromRGB(108,142,255)},{n="Green",c=Color3.fromRGB(90,196,140)},{n="Orange",c=Color3.fromRGB(240,150,60)},{n="Pink",c=Color3.fromRGB(230,120,180)},{n="Cyan",c=Color3.fromRGB(0,200,220)},{n="Yellow",c=Color3.fromRGB(230,200,90)}}
local tEnt={}
local function isSm(a,b) return math.abs(a.R-b.R)<0.01 and math.abs(a.G-b.G)<0.01 and math.abs(a.B-b.B)<0.01 end
local function sTS() for _,e in ipairs(tEnt) do if not e.str or not e.str.Parent then break end local isS=isSm(e.c,AC) TS:Create(e.str,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Transparency=isS and 0 or 0.85,Color=e.c}):Play() end end
_sT=sTS
for i,t in ipairs(themes) do
    local col=(i-1)%2 local row=math.floor((i-1)/2)
    local px=(col==0) and UDim2.new(0,12,0,30+row*34) or UDim2.new(0.5,6,0,30+row*34)
    local b=mk("TextButton",{Size=UDim2.new(0.5,-18,0,28),Position=px,BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="  "..t.n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},th) cr(b,6)
    local str=sk(b,t.c,0.85)
    local dot=mk("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-22,0.5,-7),BackgroundColor3=t.c,BorderSizePixel=0},b) cr(dot,7)
    tEnt[#tEnt+1]={btn=b,str=str,c=t.c}
end
for _,e in ipairs(tEnt) do e.btn.MouseButton1Click:Connect(function() setAC(e.c) Cfg.acr=math.floor(e.c.R*255+0.5) Cfg.acg=math.floor(e.c.G*255+0.5) Cfg.acb=math.floor(e.c.B*255+0.5) sv() sTS() end) end
sTS()
local function updateCnt() local p,u,s=0,0,0 for _,a in ipairs(rec.a) do if a.t=="P" then p=p+1 elseif a.t=="U" then u=u+1 elseif a.t=="S" then s=s+1 end end C.P=p C.U=u C.S=s rC() sCn(#rec.a) pcall(function() sPl.Text="Place: "..tostring(p) sUp.Text="Upgrade: "..tostring(u) sSl.Text="Sell: "..tostring(s) end) end
_cL=updateCnt

task.spawn(function()
    task.wait(1.5)
    iA() sTS()
    if Cfg.sk then startAutoSkip() end
    if Cfg.ag then startAutoGame() end
    if Cfg.ast then startAutoStart() end
    if Cfg.apr then startAutoPlayAgain() end
    applySpeed(Cfg.spd or "1")
    if Cfg.av then
        if autoVoteTg then autoVoteTg.SetValue(true) end
        startAutoVote()
    end
    if Cfg.pl and Cfg.sel~="" then
        local path=findMacroPath(Cfg.sel) local d=rj(path)
        if type(d)=="table" and #d>0 then
            if _pT then _pT.SetValue(true) end
            sSt("Playing") play()
        else Cfg.pl=false sv() if _pT then _pT.SetValue(false) end end
    end
end)
go("Main") rC() N("EZVC HUB","Ready")
print("[EZVC HUB] v2.25 loaded | AutoGame=TP | AutoStart=TP+1s+Elevator x4 | Speed=ChangeSpeed | PlayAgain | AutoVote | Play=7s")