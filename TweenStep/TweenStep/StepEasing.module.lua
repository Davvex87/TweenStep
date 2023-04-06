local StepEasing = {}

local pow = math.pow;
local sqrt = math.sqrt;
local sin = math.sin;
local cos = math.cos;
local PI = math.pi;
local c1 = 1.70158;
local c2 = c1 * 1.525;
local c3 = c1 + 1;
local c4 = (2 * PI) / 3;
local c5 = (2 * PI) / 4.5;

local function bounceOut(x)
	local n1 = 7.5625;
	local d1 = 2.75;

	if (x < 1 / d1) then
		return n1 * x * x;
	elseif (x < 2 / d1) then
		return n1 * (x - 1.5 / d1) * x + 0.75;
	elseif (x < 2.5 / d1) then
		return n1 * (x - 2.25 / d1) * x + 0.9375;
	else
		return n1 * (x - 2.625 / d1) * x + 0.984375;
	end
end

StepEasing.lerp = function(start,goal,duration)
	return start + (goal - start) + duration
end

StepEasing.Linear = function(x) --Linear
	return x
end
StepEasing.InQuad = function(x) --InQuad
	return x * x
end
StepEasing.OutQuad = function(x) --OutQuad
	return 1 - (1 - x) * (1 - x);
end
StepEasing.InOutQuad = function(x) --InOutQuad
	if x < 0.5 then
		return 2 * x * x
	end
	return 1 - pow(-2 * x + 2, 2) / 2;
end
StepEasing.InCubic = function(x) --InCubic
	return x * x * x;
end
StepEasing.OutCubic = function(x) --OutCubic
	return 1 - pow(1 - x, 3);
end
StepEasing.InOutCubic = function(x) --InOutCubic
	if x < 0.5 then
		return 4 * x * x * x
	end
	return 1 - pow(-2 * x + 2, 3) / 2;
end
StepEasing.InQuart = function(x) --InQuart
	return x * x * x * x;
end
StepEasing.OutQuart = function(x) --OutQuart
	return 1 - pow(1 - x, 4);
end
StepEasing.InOutQuart = function(x) --InOutQuart
	if x < 0.5 then
		return 8 * x * x * x * x
	end
	return 1 - pow(-2 * x + 2, 4) / 2;
end
StepEasing.InQuint = function(x) --InQuint
	return x * x * x * x * x;
end
StepEasing.OutQuint = function(x) --OutQuint
	return 1 - pow(1 - x, 5);
end
StepEasing.InOutQuint = function(x) --InOutQuint
	if x < 0.5 then
		return 16 * x * x * x * x * x
	end
	return 1 - pow(-2 * x + 2, 5) / 2;
end
StepEasing.InSine = function(x) --InSine
	return 1 - cos((x * PI) / 2);
end
StepEasing.OutSine = function(x) --OutSine
	return sin((x * PI) / 2);
end
StepEasing.InOutSine = function(x) --InOutSine
	return -(cos(PI * x) - 1) / 2;
end
StepEasing.InExpo = function(x) --InExpo
	if x == 0 then
		return 0
	end
	return pow(2, 10 * x - 10);
end
StepEasing.OutExpo = function(x) --OutExpo
	if x == 1 then
		return 1
	end
	return 1 - pow(2, -10 * x);
end
StepEasing.InOutExpo = function(x) --InOutExpo
	if x == 0 then
		return 0
	end
	if x == 1 then
		return 1
	end
	if x < 0.5 then
		return pow(2, 20 * x - 10) / 2
	end
	return (2 - pow(2, -20 * x + 10)) / 2;
end
StepEasing.InCirc = function(x) --InCirc
	return 1 - sqrt(1 - pow(x, 2));
end
StepEasing.OutCirc = function(x) --OutCirc
	return sqrt(1 - pow(x - 1, 2));
end
StepEasing.InOutCirc = function(x) --InOutCirc
	if x < 0.5 then
		return (1 - sqrt(1 - pow(2 * x, 2))) / 2
	end
	return (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2;
end
StepEasing.InBack = function(x) --InBack
	return c3 * x * x * x - c1 * x * x;
end
StepEasing.OutBack = function(x) --OutBack
	return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2);
end
StepEasing.InOutBack = function(x) --InOutBack
	if x < 0.5 then
		return (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
	end
	return (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2;
end
StepEasing.InElastic = function(x) --InElastic
	if x == 0 then
		return 0
	end
	if x == 1 then
		return 1
	end
	return -pow(2, 10 * x - 10) * sin((x * 10 - 10.75) * c4);
end
StepEasing.OutElastic = function(x) --OutElastic
	if x == 0 then
		return 0
	end
	if x == 1 then
		return 1
	end
	return pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
end
StepEasing.InOutElastic = function(x) --InOutElastic
	if x == 0 then
		return 0
	end
	if x == 1 then
		return 1
	end
	if x < 0.5 then
		return -(pow(2, 20 * x - 10) * sin((20 * x - 11.125) * c5)) / 2
	end
	return (pow(2, -20 * x + 10) * sin((20 * x - 11.125) * c5)) / 2 + 1;
end
StepEasing.InBounce = function(x) --InBounce
	return 1 - bounceOut(1 - x);
end
StepEasing.OutBounce = function(x) --OutBounce
	return bounceOut(x)
end
StepEasing.InOutBounce = function(x) --InOutBounce
	if x < 0.5 then
		return (1 - bounceOut(1 - 2 * x)) / 2
	end
	return (1 + bounceOut(2 * x - 1)) / 2;
end

return StepEasing
