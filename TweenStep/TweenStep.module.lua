local TweenStep = {
	EasingFormulas = require(script.StepEasing),
}
TweenStep.__index = TweenStep
TweenStep.tweens = {}
TweenStep.StepInfo = require(script.StepInfo)

_G["ClientTween"] = game.ReplicatedStorage:FindFirstChild("ClientTween")
if not _G["ClientTween"] then
	local re = Instance.new("RemoteEvent")
	re.Name = "ClientTween"
	re.Parent = game.ReplicatedStorage
	_G["ClientTween"] = re
end

--[[
for i, plr in pairs(game.Players:GetPlayers()) do
	plr.CharacterAdded:Connect(function()
		local s = script.TweenStepClient:Clone()
		s.Parent = plr.Character
		s.Disabled = false
	end)
end

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		local s = script.TweenStepClient:Clone()
		s.Parent = plr.Character
		s.Disabled = false
	end)
end)]]

if not game:GetService("RunService"):IsClient() then
	local function LoadPlayer(player)
		local clone = script.TweenStepClient:Clone()
		local playerGui = player:WaitForChild("PlayerGui", 20)

		if  playerGui then
			clone.Parent = playerGui
			clone.Disabled = false
			coroutine.resume(coroutine.create(function()
				player.CharacterAdded:Connect(function()
					local find = player.PlayerGui:WaitForChild("TweenClient", 20)
					if find == nil then
						local clone = script.TweenStepClient:Clone()
						clone.Parent = playerGui
						clone.Disabled = false
					end
				end)
			end))
		end
	end

	for i, player in pairs(game.Players:GetPlayers()) do
		coroutine.resume(coroutine.create(function()
			LoadPlayer(player)
		end))
	end
	game.Players.PlayerAdded:Connect(function(player)
		LoadPlayer(player)
	end)
end


function TweenStep:AddCustomEasingStyle(name, formula)
	TweenStep.EasingFormulas[name] = formula
end

--CONSTRUCTOR
function TweenStep.new(Object, StepInfo, PropertyTable, runInClient)
	local args = {Object=Object,StepInfo=StepInfo,PropertyTable=PropertyTable}
	local self = setmetatable({}, TweenStep)
	self.Object = Object
	self.StepInfo = StepInfo
	self.PropertyTable = PropertyTable
	self.runInClient = runInClient
	self.tweenHash = game:GetService("HttpService"):GenerateGUID(false)
	self.TweenSpeed = 1
	
	local tweenUpdate = Instance.new("BindableEvent")
	local complete = Instance.new("BindableEvent")
	
	self.TweenUpdated = tweenUpdate.Event
	self.Completed = complete.Event
	
	TweenStep.tweens[self.tweenHash] = {self.Object,self.StepInfo,self.PropertyTable}
	
	if not _G["ServerTweenControler"] then
		_G["ServerTweenControler"] = require(script.TweenControler)
	end
	if self.runInClient then
		local function addTweenToPlayer(plr)
			_G["ClientTween"]:FireAllClients(self.tweenHash, "add", TweenStep.tweens[self.tweenHash])
		end
		for i, plr in pairs(game.Players:GetPlayers()) do
			addTweenToPlayer(plr)
		end
		game.Players.PlayerAdded:Connect(function(plr)
			plr.CharacterAdded:Connect(function()
				addTweenToPlayer(plr)
			end)
		end)
	else
		_G["ServerTweenControler"]:AddTween(self.tweenHash,self.Object,self.StepInfo,self.PropertyTable)
	end
	
	local function updateControlerInfo()
		if self.runInClient then
			_G["ClientTween"]:FireAllClients(self.tweenHash, "setControlerInfo,Speed", self.TweenSpeed)
		else
			task.spawn(function()
				_G["ServerTweenControler"].activeTweens[self.tweenHash]["Speed"] = self.TweenSpeed
				--_G["ServerTweenControler"]:Play(self.tweenHash,TweenStep.EasingFormulas)
			end)
		end
	end
	
	function self:SetTweenSpeed(Speed:number)
		self.TweenSpeed = Speed
		updateControlerInfo()
	end
	
	function self:Play()
		if self.runInClient then
			_G["ClientTween"]:FireAllClients(self.tweenHash, "play", script.StepEasing)
			task.spawn(function()
				if not StepInfo.Reverse then
					task.wait(StepInfo.Duration + StepInfo.StartDelay)
					for i, v in pairs(PropertyTable) do
						Object[i] = PropertyTable[i]
					end
				end
			end)
		else
			task.spawn(function()
				local tween = _G["ServerTweenControler"].activeTweens[self.tweenHash]
				task.spawn(function()
					repeat
						tweenUpdate:Fire(tween["DurationDelta"], tween["TweenDelta"])
						task.wait()
					until tween["Playing"] == false
					if tween["LastTimeStop"] == 0 and tween["Stopped"] == false then
						complete:Fire(false)
					else
						complete:Fire(true)
					end
				end)
				_G["ServerTweenControler"]:Play(self.tweenHash,TweenStep.EasingFormulas)
			end)
		end
	end
	
	function self:Pause()
		if self.runInClient then
			_G["ClientTween"]:FireAllClients(self.tweenHash, "pause", {})
		else
			_G["ServerTweenControler"]:Pause(self.tweenHash)
		end
	end
	
		function self:Stop()
			if self.runInClient then
				_G["ClientTween"]:FireAllClients(self.tweenHash, "stop", {})
			else
				_G["ServerTweenControler"]:Stop(self.tweenHash)
			end
	end
	
	return self
end

function TweenStep:Tween(Object, StepInfo, PropertyTable, runInClient)
	local tweenHash = game:GetService("HttpService"):GenerateGUID(false)
	TweenStep.tweens[tweenHash] = {Object,StepInfo,PropertyTable}
	if not _G["ServerTweenControler"] then
		_G["ServerTweenControler"] = require(script.TweenControler)
	end
	if runInClient then
		local function addTweenToPlayer(plr)
			_G["ClientTween"]:FireAllClients(tweenHash, "add", TweenStep.tweens[tweenHash])
		end
		for i, plr in pairs(game.Players:GetPlayers()) do
			addTweenToPlayer(plr)
		end
		game.Players.PlayerAdded:Connect(function(plr)
			plr.CharacterAdded:Connect(function()
				addTweenToPlayer(plr)
			end)
		end)
	else
		_G["ServerTweenControler"]:AddTween(tweenHash,Object,StepInfo,PropertyTable)
	end
	
	if runInClient then
		_G["ClientTween"]:FireAllClients(tweenHash, "play", script.StepEasing)
		task.spawn(function()
			if not StepInfo.Reverse then
				task.wait(StepInfo.Duration + StepInfo.StartDelay)
				for i, v in pairs(PropertyTable) do
					Object[i] = PropertyTable[i]
				end
			end
		end)
	else
		task.spawn(function()
			_G["ServerTweenControler"]:Play(tweenHash,TweenStep.EasingFormulas)
		end)
	end
end

return TweenStep
