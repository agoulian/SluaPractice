import "UnityEngine"
--------------------------------------------------------------
local equiArray={}--装备对象数组
--------------------------------------------------------------
PlayerInfo={}--人物信息类
function PlayerInfo:new(hp,mp)--人物信息对象构造函数
	local o={}
	setmetatable(o,self)
	self.__index=self
	o.hp=hp or 100--人物的hp属性
	o.mp=mp or 100--人物的mp属性
	o.hp_text=nil--hp的text组件
	o.mp_text=nil--mp的text组件
	o.equiPlace=nil--装备框
	o.equi=nil--已穿上的装备对象
	return o
end
function PlayerInfo:Bind()--为人物对象绑定UI组件方法
	self.hp_text=GameObject.Find("HP_text"):GetComponent(UI.Text)
	self.mp_text=GameObject.Find("MP_text"):GetComponent(UI.Text)
	self.equiPlace=GameObject.Find("tip_img")
end
function PlayerInfo:UpdateValue(hp,mp)--更新人物属性方法
	self.hp=self.hp+hp
	self.mp=self.mp+mp
	self.hp_text.text="HP : " .. self.hp
	self.mp_text.text="MP : " .. self.mp
end
--------------------------------------------------------------
Equipment={}--装备类
function Equipment:new()--装备对象构造函数
	local o={}
	setmetatable(o,self)
	self.__index=self
	o.hp=10--装备的hp加成
	o.mp=20--装备的mp加成
	o.isInUse=false--装备是否使用中标志
	o.isShowInfo=false--装备是否展示了信息
	o.tf=nil--装备UI的变换组件
	o.panel=nil--信息面板
	o.name=nil--装备名字的text组件
	o.hp_text=nil--hp的text组件
	o.mp_text=nil--mp的text组件
	o.use_btn=nil--使用按钮组件
	o.throw_btn=nil--丢弃按钮组件
	table.insert(equiArray,o)--添加进装备对象数组
	return o
end
function Equipment:Bind(equi,pInfo,cont)--为装备对象绑定UI组件方法
	self.tf=equi:GetComponent(Transform)
	local imgs=equi:GetComponentsInChildren(UI.Image)
	for i=1,#imgs do
		if imgs[i].gameObject.name=="equi_panel" then
			self.panel=imgs[i].gameObject
		end
	end
	local text=equi:GetComponentInChildren(UI.Text)
	self.name=text
	local texts=self.panel:GetComponentsInChildren(UI.Text)
	for i=1,#texts do
		if texts[i].gameObject.name=="equi_hp" then
			self.hp_text=texts[i]
		end
		if texts[i].gameObject.name=="equi_mp" then
			self.mp_text=texts[i]
		end
	end
	local btns=equi:GetComponentsInChildren(UI.Button)
	for i=1,#btns do
		if i==1 then
			btns[i].onClick:AddListener(--为装备UI按钮绑定事件
				function()
					if not self.isInUse then
						if self.isShowInfo then
							self.isShowInfo=false
							self.panel:SetActive(false)
						else
							for i=1,#equiArray do
								if equiArray[i].isShowInfo then
									equiArray[i].panel:SetActive(false)
									equiArray[i].isShowInfo=false
								end
							end
							self.isShowInfo=true
							self.panel:SetActive(true)
						end
					end
				end
			)
		end
		if btns[i].gameObject.name=="equi_use" then
			self.use_btn=btns[i]
			self.use_btn.onClick:AddListener(--为使用按钮绑定事件
				function()
					self.isInUse=true
					if pInfo.equi then
						pInfo.equi.tf:SetParent(cont.transform)
						pInfo:UpdateValue(-pInfo.equi.hp,-pInfo.equi.mp)
						pInfo.equi.isInUse=false
					end
					self.tf:SetParent(pInfo.equiPlace.transform)
					pInfo.equi=self
					pInfo:UpdateValue(pInfo.equi.hp,pInfo.equi.mp)
					self.panel:SetActive(false)
					self.isShowInfo=false
				end
			)
		end
		if btns[i].gameObject.name=="equi_throw" then
			self.throw_btn=btns[i]
			self.throw_btn.onClick:AddListener(--为丢弃按钮绑定事件
				function()
					self.tf.gameObject:SetActive(false)
				end
			)
		end
	end
	self.panel:SetActive(false)
end
function Equipment:SetValue(n,hp,mp)--设置装备属性方法
	self.name.text=n
	self.hp=hp
	self.hp_text.text="HP : " .. hp
	self.mp=mp
	self.mp_text.text="MP : " .. mp
end
--------------------------------------------------------------
function MyInstantiate(path,parent_tf)--实例化方法
	local prefab=Resources.Load(path)
	local ob=GameObject.Instantiate(prefab)
	ob.transform:SetParent(parent_tf)
	ob.transform.localPosition=Vector3(0,0,0)
	return ob
end
--------------------------------------------------------------
function main()
	local package=MyInstantiate("Prefab/Package",GameObject.Find("Canvas").transform)
	local container=GameObject.Find("Container")
	--添加一个人物信息对象
	local pinfo=PlayerInfo:new()
	pinfo:Bind()
	pinfo:UpdateValue(0,0)
	--添加三个装备对象
	local eq1=Equipment:new()
	eq1:Bind(MyInstantiate("Prefab/equi",container.transform),pinfo,container)
	eq1:SetValue("equi_1",20,30)
	local eq2=Equipment:new()
	eq2:Bind(MyInstantiate("Prefab/equi",container.transform),pinfo,container)
	eq2:SetValue("equi_2",30,40)
	local eq3=Equipment:new()
	eq3:Bind(MyInstantiate("Prefab/equi",container.transform),pinfo,container)
	eq3:SetValue("equi_3",50,100)
end
--------------------------------------------------------------
