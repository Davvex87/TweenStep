local StepInfo = {
	Duration = 0,
	Easing = 'linear',
	StartDelay = 0,
	Reverse = false,
	RepeatCount = false
}
StepInfo.__index = StepInfo

--CONSTRUCTOR
function StepInfo.new(Duration:number, Easing:string, StartDelay:number, Reverse:boolean, RepeatCount:number)
	local args = {Duration=Duration,Easing=Easing,StartDelay=StartDelay,Reverse=Reverse,RepeatCount=RepeatCount}
	local self = setmetatable({}, StepInfo)
	self.Duration = Duration
	self.Easing = Easing
	self.StartDelay = StartDelay
	self.Reverse = Reverse
	self.RepeatCount = RepeatCount
	--self.__index = self
	
	if self.Duration == nil then
		self.Duration = 1
	end
	if self.Easing == nil then
		self.Easing = "Linear"
	end
	if self.StartDelay == nil then
		self.StartDelay = 0
	end
	if self.Reverse == nil then
		self.Reverse = false
	end
	if self.RepeatCount == nil then
		self.RepeatCount = 0
	end
	
	return self
end

return StepInfo
