local TweenControler = {
	DataTypeIndexs = require(script.Parent.DataTypeIndexs)
}

TweenControler.activeTweens = {}

function TweenControler:Lerp(a: any, b: any, t: number):number
	local typeABasicType = string.lower(type(a))
	local typeBBasicType = string.lower(type(b))
	local typeADataType = typeof(a)
	local typeBDataType = typeof(b)
	if typeABasicType == 'number' and typeBBasicType == 'number' then
		return a + (b - a) * t
	else
		local returnVals = {}
		local startPropertyPair = {a}
		local goalPropertyPair = {b}
		local curValues = string.split(tostring(startPropertyPair[1]), ', ')
		local endValues = string.split(tostring(goalPropertyPair[1]), ', ')
		for i,v in pairs(curValues) do
			local str1_1 = string.gsub(v, "{", "")
			local str2_1 = string.gsub(endValues[i], "{", "")
			local str1_2 = string.gsub(str1_1, "}", "")
			local str2_2 = string.gsub(str2_1, "}", "")
			local curValue = tonumber(string.split(str1_2, " ")[1])
			local endValue = tonumber(string.split(str2_2, " ")[1])
			table.insert(returnVals, i, curValue + (endValue - curValue) * t)
		end
		local finalResult = TweenControler.DataTypeIndexs[typeADataType]
		if TweenControler.DataTypeIndexs["#"..typeADataType] <= -1 then
			return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4],returnVals[5],returnVals[6],returnVals[7],
				returnVals[8],returnVals[9],returnVals[10],returnVals[11],returnVals[12],returnVals[13],returnVals[14])
		else
			if TweenControler.DataTypeIndexs["#"..typeADataType] == 2 then
				return finalResult(returnVals[1],returnVals[2])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 3 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 4 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 5 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4],returnVals[5])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 6 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4],returnVals[5],returnVals[6])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 8 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4],returnVals[5],returnVals[6],returnVals[7],returnVals[8])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 10 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4],returnVals[5],returnVals[6],returnVals[7],returnVals[8],returnVals[9],returnVals[10])
			elseif TweenControler.DataTypeIndexs["#"..typeADataType] == 12 then
				return finalResult(returnVals[1],returnVals[2],returnVals[3],returnVals[4],returnVals[5],returnVals[6],returnVals[7],returnVals[8],returnVals[9],returnVals[10],returnVals[11],returnVals[12])
			end
		end
		return error("TweenStep - Error, DataType "..typeADataType.." could not be tweened")
	end
end

function TweenControler:AddTween(hash, Object, StepInfo, PropertyTable)
	TweenControler.activeTweens[hash] = {["TweenData"] = {Object, StepInfo, PropertyTable}, ["Playing"] = false, ["LastTimeStop"] = 0, ["Stopped"] = false, ["Speed"] = 1, ["DurationDelta"] = 0, ["TweenDelta"] = 0}
end

function TweenControler:Play(hash,easingFormulas)
	local tween = TweenControler.activeTweens[hash]
	local Object = tween["TweenData"][1]
	local StepInfo = tween["TweenData"][2]
	local PropertyTable = tween["TweenData"][3]
	tween["Playing"] = true
	local startTimer = tick()
	for i, v in pairs(PropertyTable) do
		task.spawn(function()
			local start, goal = Object[i], PropertyTable[i]
			local lastStop = tween["LastTimeStop"]
			local durationDelta = 0
			local delta = 0
			repeat
				task.wait()
				if (tick()) - startTimer >= (StepInfo.Duration/tween["Speed"]) or durationDelta >= 1 or tween["Playing"] == false then
				else
					durationDelta = math.abs((startTimer - tick()) / (StepInfo.Duration/tween["Speed"])) + lastStop
					delta = easingFormulas[StepInfo.Easing](durationDelta)

					local val = TweenControler:Lerp(start,goal,delta)

					Object[i] = val
				end
			until (tick()) - startTimer >= (StepInfo.Duration/tween["Speed"]) or durationDelta >= 1 or tween["Playing"] == false
			if tween["Playing"] == false and not tween["Stopped"] then
				local n = durationDelta
				local n2 = n * 100
				local n3 = math.floor(n2) * 0.01
				tween["LastTimeStop"] = n3
			end
		end)
	end
	repeat
		tween["DurationDelta"] = math.abs((startTimer - tick()) / (StepInfo.Duration/tween["Speed"])) + tween["LastTimeStop"]
		tween["TweenDelta"] = easingFormulas[StepInfo.Easing](tween["DurationDelta"])
		task.wait()
	until (tick()) - startTimer >= (StepInfo.Duration/tween["Speed"]) or tween["Playing"] == false
	if tween["Playing"] == true then
		for i, v in pairs(PropertyTable) do
			Object[i] = PropertyTable[i]
		end
		tween["LastTimeStop"] = 0
		tween["Stopped"] = false
	else
	end
	tween["Playing"] = false
end

function TweenControler:Pause(hash)
	local tween = TweenControler.activeTweens[hash]
	tween["Playing"] = false
end

function TweenControler:Stop(hash)
	local tween = TweenControler.activeTweens[hash]
	tween["Playing"] = false
	tween["Stopped"] = true
	tween["LastTimeStop"] = 0
end

return TweenControler
