local re:RemoteEvent = game.ReplicatedStorage:WaitForChild("ClientTween")
if not _G["ClientTweenControler"] then
	_G["ClientTweenControler"] = require(game.ReplicatedStorage:WaitForChild("TweenStep"):WaitForChild("TweenControler"))
end
re.OnClientEvent:Connect(function(hash,func,data)
	if func == "add" then
		_G["ClientTweenControler"]:AddTween(hash,data[1],data[2],data[3])
	elseif func == "play" then
		task.spawn(function()
			_G["ClientTweenControler"]:Play(hash,require(data))
		end)
	elseif func == "pause" then
		_G["ClientTweenControler"]:Pause(hash,data[1],data[2],data[3])
	elseif func == "stop" then
		_G["ClientTweenControler"]:Stop(hash,data[1],data[2],data[3])
	elseif string.split(func, ",")[1] == "setControlerInfo" then
		_G["ClientTweenControler"].activeTweens[hash][string.split(func, ",")[2]] = data
	end
end)
