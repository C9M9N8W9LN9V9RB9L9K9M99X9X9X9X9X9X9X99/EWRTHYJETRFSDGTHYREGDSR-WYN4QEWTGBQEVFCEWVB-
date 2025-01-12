
local HttpService, UserInputService, InsertService = game:FindService("HttpService"), game:FindService("UserInputService"), game:FindService("InsertService")
local RunService, CoreGui, StarterGui = game:GetService("RunService"), game:FindService("CoreGui"), game:GetService("StarterGui")
local _require, _game, _workspace = require, game, workspace


local Workspace = game:FindService("Workspace") or game.Workspace
local RobloxWorkspace = game:FindService("Workspace") or game.Workspace
local Players = game:FindService("Players") or game.Players
local LocalPlayer = game:FindService("Players").LocalPlayer or game.Players.LocalPlayer
local RobloxPlayers = game:FindService("Players") or game.Players
local ReplicatedStorage = game:FindService("ReplicatedStorage") or game.ReplicatedStorage
local RobloxReplicatedStorage = ReplicatedStorage
local ReplicatedFirst = game:FindService("ReplicatedFirst") or game.ReplicatedFirst
local Lighting = game:FindService("Lighting") or game.Lighting
local RobloxLighting = game:FindService("Lighting") or game.Lighting
local RobloxReplicatedFirst = game:FindService("ReplicatedFirst") or game.ReplicatedFirst
local CoreGui = game:FindService("CoreGui") or game.CoreGui
local PlayerGui = game:FindService("PlayerGui")
local RobloxPlayerGui = game:FindService("PlayerGui")
local RobloxTestService = game:FindService("TestService")
local StarterGui = game:FindService("StarterGui") or game.StarterGui
local InsertService = game:FindService("InsertService")
local CorePackages = game:FindService("CorePackages") or game.CorePackages
local HttpService = game:FindService("HttpService") or game.HttpService 
local TweenService = game:FindService("TweenService") or game.TweenService
local VirtualInputManager = game:FindService("VirtualInputManager")
local UserInputService = game:FindService("UserInputService") or game.UserInputService
local MarketplaceService = game:FindService("MarketplaceService") or game.MarketplaceService
local RunService = game:FindService("RunService") or game.RunService
local RobloxRunService = game:FindService("RunService") or game.RunService
local LogService = game:FindService("LogService") or game.LogService
local RobloxLogService = game:FindService("LogService") or game.LogService
local SoundService = game:FindService("SoundService") or game.SoundService


local RunService = game:GetService("RunService")

local existingIndicator = CoreGui:FindFirstChild("SynBoolValue")
local existingHolder = CoreGui:FindFirstChild("SynHolder")

if existingHolder or existingIndicator then
    warn("Already injected")
    return
end


local indicator

if not existingIndicator then
	indicator = Instance.new("BoolValue")
	indicator.Name = "SynBoolValue"
	indicator.Parent = CoreGui
else
	indicator = CoreGui:FindFirstChild("SynBoolValue")
end

local script_holder

if not existingHolder then
	script_holder = Instance.new("ObjectValue")
	script_holder.Name = "SynHolder"
	script_holder.Parent = CoreGui
else
	script_holder = CoreGui:FindFirstChild("SynHolder")
end



local CoreGui = game:FindService("CoreGui")
local twait = task.wait

local script_idx = 1
local scripts_list = {}

for _, c in next, game:GetService("CoreGui"):GetDescendants() do
	if c:IsA("ModuleScript") then
		local clone = c:Clone()
		clone.Name = ""

		table.insert(scripts_list, clone)
	end
end

script_holder.Value = scripts_list[script_idx]:Clone()




info = {
	name = "syn",
	version = "1.0",
	author = "glosary"
}


table.freeze(info)



function getgenv()
	return getfenv()
end


function getexecutorname()
	return info.name
end
function getexecutorversion()
	return info.version
end

function identifyexecutor()
	return getexecutorname(), getexecutorversion()
end
whatexecutor = identifyexecutor

function gethui()
	return CoreGui
end




debug = table.clone(debug)

function debug.getinfo(f, options)
	if type(options) == "string" then
		options = string.lower(options) 
	else
		options = "sflnu"
	end
	local result = {}
	for index = 1, #options do
		local option = string.sub(options, index, index)
		if "s" == option then
			local short_src = debug.info(f, "s")
			result.short_src = short_src
			result.source = "=" .. short_src
			result.what = if short_src == "[C]" then "C" else "Lua"
		elseif "f" == option then
			result.func = debug.info(f, "f")
		elseif "l" == option then
			result.currentline = debug.info(f, "l")
		elseif "n" == option then
			result.name = debug.info(f, "n")
		elseif "u" == option or option == "a" then
			local numparams, is_vararg = debug.info(f, "a")
			result.numparams = numparams
			result.is_vararg = if is_vararg then 1 else 0
			if "u" == option then
				result.nups = 2
			end
		end
	end
	return result
end




local camera = workspace.CurrentCamera
local drawingUI = Instance.new("ScreenGui")
drawingUI.Name = "Drawing"
drawingUI.IgnoreGuiInset = true
drawingUI.DisplayOrder = 0x7fffffff
drawingUI.Parent = CoreGui

local drawingIndex = 0
local drawingFontsEnum = {
[0] = Font.fromEnum(Enum.Font.Roboto),
[1] = Font.fromEnum(Enum.Font.Legacy),
[2] = Font.fromEnum(Enum.Font.SourceSans),
[3] = Font.fromEnum(Enum.Font.RobotoMono)
}

local function getFontFromIndex(fontIndex)
return drawingFontsEnum[fontIndex]
end

local function convertTransparency(transparency)
return math.clamp(1 - transparency, 0, 1)
end

local baseDrawingObj = setmetatable({
Visible = true,
ZIndex = 0,
Transparency = 1,
Color = Color3.new(),
Remove = function(self)
	setmetatable(self, nil)
end,
Destroy = function(self)
	setmetatable(self, nil)
end,
SetProperty = function(self, index, value)
	if self[index] ~= nil then
		self[index] = value
	else
		warn("Attempted to set invalid property: " .. tostring(index))
	end
end,
GetProperty = function(self, index)
	if self[index] ~= nil then
		return self[index]
	else
		warn("Attempted to get invalid property: " .. tostring(index))
		return nil
	end
end,
SetParent = function(self, parent)
	self.Parent = parent
end
}, {
__add = function(t1, t2)
	local result = {}
	for index, value in pairs(t1) do
		result[index] = value
	end
	for index, value in pairs(t2) do
		result[index] = value
	end
	return result
end
})

local DrawingLib = {}
DrawingLib.Fonts = {
["UI"] = 0,
["System"] = 1,
["Plex"] = 2,
["Monospace"] = 3
}

function DrawingLib.createLine()
local lineObj = ({
	From = Vector2.zero,
	To = Vector2.zero,
	Thickness = 1
} + baseDrawingObj)

local lineFrame = Instance.new("Frame")
lineFrame.Name = drawingIndex
lineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
lineFrame.BorderSizePixel = 0

lineFrame.Parent = drawingUI
return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if lineObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "From" or index == "To" then
			local direction = (index == "From" and lineObj.To or value) - (index == "From" and value or lineObj.From)
			local center = (lineObj.To + lineObj.From) / 2
			local distance = direction.Magnitude
			local theta = math.deg(math.atan2(direction.Y, direction.X))

			lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
			lineFrame.Rotation = theta
			lineFrame.Size = UDim2.fromOffset(distance, lineObj.Thickness)
		elseif index == "Thickness" then
			lineFrame.Size = UDim2.fromOffset((lineObj.To - lineObj.From).Magnitude, value)
		elseif index == "Visible" then
			lineFrame.Visible = value
		elseif index == "ZIndex" then
			lineFrame.ZIndex = value
		elseif index == "Transparency" then
			lineFrame.BackgroundTransparency = convertTransparency(value)
		elseif index == "Color" then
			lineFrame.BackgroundColor3 = value
		elseif index == "Parent" then
			lineFrame.Parent = value
		end
		lineObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				lineFrame:Destroy()
				lineObj:Remove()
			end
		end
		return lineObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createText()
local textObj = ({
	Text = "",
	Font = DrawingLib.Fonts.UI,
	Size = 0,
	Position = Vector2.zero,
	Center = false,
	Outline = false,
	OutlineColor = Color3.new()
} + baseDrawingObj)

local textLabel, uiStroke = Instance.new("TextLabel"), Instance.new("UIStroke")
textLabel.Name = drawingIndex
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.BorderSizePixel = 0
textLabel.BackgroundTransparency = 1

local function updateTextPosition()
	local textBounds = textLabel.TextBounds
	local offset = textBounds / 2
	textLabel.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
	textLabel.Position = UDim2.fromOffset(textObj.Position.X + (not textObj.Center and offset.X or 0), textObj.Position.Y + offset.Y)
end

textLabel:GetPropertyChangedSignal("TextBounds"):Connect(updateTextPosition)

uiStroke.Thickness = 1
uiStroke.Enabled = textObj.Outline
uiStroke.Color = textObj.Color

textLabel.Parent, uiStroke.Parent = drawingUI, textLabel

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if textObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "Text" then
			textLabel.Text = value
		elseif index == "Font" then
			textLabel.FontFace = getFontFromIndex(math.clamp(value, 0, 3))
		elseif index == "Size" then
			textLabel.TextSize = value
		elseif index == "Position" then
			updateTextPosition()
		elseif index == "Center" then
			textLabel.Position = UDim2.fromOffset((value and camera.ViewportSize / 2 or textObj.Position).X, textObj.Position.Y)
		elseif index == "Outline" then
			uiStroke.Enabled = value
		elseif index == "OutlineColor" then
			uiStroke.Color = value
		elseif index == "Visible" then
			textLabel.Visible = value
		elseif index == "ZIndex" then
			textLabel.ZIndex = value
		elseif index == "Transparency" then
			local transparency = convertTransparency(value)
			textLabel.TextTransparency = transparency
			uiStroke.Transparency = transparency
		elseif index == "Color" then
			textLabel.TextColor3 = value
		elseif index == "Parent" then
			textLabel.Parent = value
		end
		textObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				textLabel:Destroy()
				textObj:Remove()
			end
		elseif index == "TextBounds" then
			return textLabel.TextBounds
		end
		return textObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createCircle()
local circleObj = ({
	Radius = 150,
	Position = Vector2.zero,
	Thickness = 0.7,
	Filled = false
} + baseDrawingObj)

local circleFrame, uiCorner, uiStroke = Instance.new("Frame"), Instance.new("UICorner"), Instance.new("UIStroke")
circleFrame.Name = drawingIndex
circleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
circleFrame.BorderSizePixel = 0

uiCorner.CornerRadius = UDim.new(1, 0)
circleFrame.Size = UDim2.fromOffset(circleObj.Radius, circleObj.Radius)
uiStroke.Thickness = circleObj.Thickness
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

circleFrame.Parent, uiCorner.Parent, uiStroke.Parent = drawingUI, circleFrame, circleFrame

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if circleObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "Radius" then
			local radius = value * 2
			circleFrame.Size = UDim2.fromOffset(radius, radius)
		elseif index == "Position" then
			circleFrame.Position = UDim2.fromOffset(value.X, value.Y)
		elseif index == "Thickness" then
			uiStroke.Thickness = math.clamp(value, 0.6, 0x7fffffff)
		elseif index == "Filled" then
			circleFrame.BackgroundTransparency = value and convertTransparency(circleObj.Transparency) or 1
			uiStroke.Enabled = not value
		elseif index == "Visible" then
			circleFrame.Visible = value
		elseif index == "ZIndex" then
			circleFrame.ZIndex = value
		elseif index == "Transparency" then
			local transparency = convertTransparency(value)
			circleFrame.BackgroundTransparency = circleObj.Filled and transparency or 1
			uiStroke.Transparency = transparency
		elseif index == "Color" then
			circleFrame.BackgroundColor3 = value
			uiStroke.Color = value
		elseif index == "Parent" then
			circleFrame.Parent = value
		end
		circleObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				circleFrame:Destroy()
				circleObj:Remove()
			end
		end
		return circleObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createSquare()
local squareObj = ({
	Size = Vector2.zero,
	Position = Vector2.zero,
	Thickness = 0.7,
	Filled = false
} + baseDrawingObj)

local squareFrame, uiStroke = Instance.new("Frame"), Instance.new("UIStroke")
squareFrame.Name = drawingIndex
squareFrame.BorderSizePixel = 0

squareFrame.Parent, uiStroke.Parent = drawingUI, squareFrame

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if squareObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "Size" then
			squareFrame.Size = UDim2.fromOffset(value.X, value.Y)
		elseif index == "Position" then
			squareFrame.Position = UDim2.fromOffset(value.X, value.Y)
		elseif index == "Thickness" then
			uiStroke.Thickness = math.clamp(value, 0.6, 0x7fffffff)
		elseif index == "Filled" then
			squareFrame.BackgroundTransparency = value and convertTransparency(squareObj.Transparency) or 1
			uiStroke.Enabled = not value
		elseif index == "Visible" then
			squareFrame.Visible = value
		elseif index == "ZIndex" then
			squareFrame.ZIndex = value
		elseif index == "Transparency" then
			local transparency = convertTransparency(value)
			squareFrame.BackgroundTransparency = squareObj.Filled and transparency or 1
			uiStroke.Transparency = transparency
		elseif index == "Color" then
			squareFrame.BackgroundColor3 = value
			uiStroke.Color = value
		elseif index == "Parent" then
			squareFrame.Parent = value
		end
		squareObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				squareFrame:Destroy()
				squareObj:Remove()
			end
		end
		return squareObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createImage()
local imageObj = ({
	Data = "",
	DataURL = "rbxassetid://0",
	Size = Vector2.zero,
	Position = Vector2.zero
} + baseDrawingObj)

local imageFrame = Instance.new("ImageLabel")
imageFrame.Name = drawingIndex
imageFrame.BorderSizePixel = 0
imageFrame.ScaleType = Enum.ScaleType.Stretch
imageFrame.BackgroundTransparency = 1

imageFrame.Parent = drawingUI

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if imageObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "Data" then
		elseif index == "DataURL" then
			imageFrame.Image = value
		elseif index == "Size" then
			imageFrame.Size = UDim2.fromOffset(value.X, value.Y)
		elseif index == "Position" then
			imageFrame.Position = UDim2.fromOffset(value.X, value.Y)
		elseif index == "Visible" then
			imageFrame.Visible = value
		elseif index == "ZIndex" then
			imageFrame.ZIndex = value
		elseif index == "Transparency" then
			imageFrame.ImageTransparency = convertTransparency(value)
		elseif index == "Color" then
			imageFrame.ImageColor3 = value
		elseif index == "Parent" then
			imageFrame.Parent = value
		end
		imageObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				imageFrame:Destroy()
				imageObj:Remove()
			end
		elseif index == "Data" then
			return nil 
		end
		return imageObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createQuad()
local quadObj = ({
	PointA = Vector2.zero,
	PointB = Vector2.zero,
	PointC = Vector2.zero,
	PointD = Vector2.zero,
	Thickness = 1,
	Filled = false
} + baseDrawingObj)

local _linePoints = {
	A = DrawingLib.createLine(),
	B = DrawingLib.createLine(),
	C = DrawingLib.createLine(),
	D = DrawingLib.createLine()
}

local fillFrame = Instance.new("Frame")
fillFrame.Name = drawingIndex .. "_Fill"
fillFrame.BorderSizePixel = 0
fillFrame.BackgroundTransparency = quadObj.Transparency
fillFrame.BackgroundColor3 = quadObj.Color
fillFrame.ZIndex = quadObj.ZIndex
fillFrame.Visible = quadObj.Visible and quadObj.Filled

fillFrame.Parent = drawingUI

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if quadObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "PointA" then
			_linePoints.A.From = value
			_linePoints.B.To = value
		elseif index == "PointB" then
			_linePoints.B.From = value
			_linePoints.C.To = value
		elseif index == "PointC" then
			_linePoints.C.From = value
			_linePoints.D.To = value
		elseif index == "PointD" then
			_linePoints.D.From = value
			_linePoints.A.To = value
		elseif index == "Thickness" or index == "Visible" or index == "Color" or index == "ZIndex" then
			for _, linePoint in pairs(_linePoints) do
				linePoint[index] = value
			end
			if index == "Visible" then
				fillFrame.Visible = value and quadObj.Filled
			elseif index == "Color" then
				fillFrame.BackgroundColor3 = value
			elseif index == "ZIndex" then
				fillFrame.ZIndex = value
			end
		elseif index == "Filled" then
			for _, linePoint in pairs(_linePoints) do
				linePoint.Transparency = value and 1 or quadObj.Transparency
			end
			fillFrame.Visible = value
		elseif index == "Parent" then
			fillFrame.Parent = value
		end
		quadObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				for _, linePoint in pairs(_linePoints) do
					linePoint:Remove()
				end
				fillFrame:Destroy()
				quadObj:Remove()
			end
		end
		return quadObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createTriangle()
local triangleObj = ({
	PointA = Vector2.zero,
	PointB = Vector2.zero,
	PointC = Vector2.zero,
	Thickness = 1,
	Filled = false
} + baseDrawingObj)

local _linePoints = {
	A = DrawingLib.createLine(),
	B = DrawingLib.createLine(),
	C = DrawingLib.createLine()
}

local fillFrame = Instance.new("Frame")
fillFrame.Name = drawingIndex .. "_Fill"
fillFrame.BorderSizePixel = 0
fillFrame.BackgroundTransparency = triangleObj.Transparency
fillFrame.BackgroundColor3 = triangleObj.Color
fillFrame.ZIndex = triangleObj.ZIndex
fillFrame.Visible = triangleObj.Visible and triangleObj.Filled

fillFrame.Parent = drawingUI

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if triangleObj[index] == nil then 
			warn("Invalid property: " .. tostring(index))
			return 
		end

		if index == "PointA" then
			_linePoints.A.From = value
			_linePoints.B.To = value
		elseif index == "PointB" then
			_linePoints.B.From = value
			_linePoints.C.To = value
		elseif index == "PointC" then
			_linePoints.C.From = value
			_linePoints.A.To = value
		elseif index == "Thickness" or index == "Visible" or index == "Color" or index == "ZIndex" then
			for _, linePoint in pairs(_linePoints) do
				linePoint[index] = value
			end
			if index == "Visible" then
				fillFrame.Visible = value and triangleObj.Filled
			elseif index == "Color" then
				fillFrame.BackgroundColor3 = value
			elseif index == "ZIndex" then
				fillFrame.ZIndex = value
			end
		elseif index == "Filled" then
			for _, linePoint in pairs(_linePoints) do
				linePoint.Transparency = value and 1 or triangleObj.Transparency
			end
			fillFrame.Visible = value
		elseif index == "Parent" then
			fillFrame.Parent = value
		end
		triangleObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				for _, linePoint in pairs(_linePoints) do
					linePoint:Remove()
				end
				fillFrame:Destroy()
				triangleObj:Remove()
			end
		end
		return triangleObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createFrame()
local frameObj = ({
	Size = UDim2.new(0, 100, 0, 100),
	Position = UDim2.new(0, 0, 0, 0),
	Color = Color3.new(1, 1, 1),
	Transparency = 0,
	Visible = true,
	ZIndex = 1
} + baseDrawingObj)

local frame = Instance.new("Frame")
frame.Name = drawingIndex
frame.Size = frameObj.Size
frame.Position = frameObj.Position
frame.BackgroundColor3 = frameObj.Color
frame.BackgroundTransparency = convertTransparency(frameObj.Transparency)
frame.Visible = frameObj.Visible
frame.ZIndex = frameObj.ZIndex
frame.BorderSizePixel = 0

frame.Parent = drawingUI

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if frameObj[index] == nil then
			warn("Invalid property: " .. tostring(index))
			return
		end

		if index == "Size" then
			frame.Size = value
		elseif index == "Position" then
			frame.Position = value
		elseif index == "Color" then
			frame.BackgroundColor3 = value
		elseif index == "Transparency" then
			frame.BackgroundTransparency = convertTransparency(value)
		elseif index == "Visible" then
			frame.Visible = value
		elseif index == "ZIndex" then
			frame.ZIndex = value
		elseif index == "Parent" then
			frame.Parent = value
		end
		frameObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				frame:Destroy()
				frameObj:Remove()
			end
		end
		return frameObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end


function DrawingLib.createScreenGui()
local screenGuiObj = ({
	IgnoreGuiInset = true,
	DisplayOrder = 0,
	ResetOnSpawn = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Enabled = true
} + baseDrawingObj)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = drawingIndex
screenGui.IgnoreGuiInset = screenGuiObj.IgnoreGuiInset
screenGui.DisplayOrder = screenGuiObj.DisplayOrder
screenGui.ResetOnSpawn = screenGuiObj.ResetOnSpawn
screenGui.ZIndexBehavior = screenGuiObj.ZIndexBehavior
screenGui.Enabled = screenGuiObj.Enabled

screenGui.Parent = coreGui

return setmetatable({Parent = coreGui}, {
	__newindex = function(_, index, value)
		if screenGuiObj[index] == nil then
			warn("Invalid property: " .. tostring(index))
			return
		end

		if index == "IgnoreGuiInset" then
			screenGui.IgnoreGuiInset = value
		elseif index == "DisplayOrder" then
			screenGui.DisplayOrder = value
		elseif index == "ResetOnSpawn" then
			screenGui.ResetOnSpawn = value
		elseif index == "ZIndexBehavior" then
			screenGui.ZIndexBehavior = value
		elseif index == "Enabled" then
			screenGui.Enabled = value
		elseif index == "Parent" then
			screenGui.Parent = value
		end
		screenGuiObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				screenGui:Destroy()
				screenGuiObj:Remove()
			end
		end
		return screenGuiObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createTextButton()
local buttonObj = ({
	Text = "Button",
	Font = DrawingLib.Fonts.UI,
	Size = 20,
	Position = UDim2.new(0, 0, 0, 0),
	Color = Color3.new(1, 1, 1),
	BackgroundColor = Color3.new(0.2, 0.2, 0.2),
	Transparency = 0,
	Visible = true,
	ZIndex = 1,
	MouseButton1Click = nil
} + baseDrawingObj)

local button = Instance.new("TextButton")
button.Name = drawingIndex
button.Text = buttonObj.Text
button.FontFace = getFontFromIndex(buttonObj.Font)
button.TextSize = buttonObj.Size
button.Position = buttonObj.Position
button.TextColor3 = buttonObj.Color
button.BackgroundColor3 = buttonObj.BackgroundColor
button.BackgroundTransparency = convertTransparency(buttonObj.Transparency)
button.Visible = buttonObj.Visible
button.ZIndex = buttonObj.ZIndex

button.Parent = drawingUI

local buttonEvents = {}

return setmetatable({
	Parent = drawingUI,
	Connect = function(_, eventName, callback)
		if eventName == "MouseButton1Click" then
			if buttonEvents["MouseButton1Click"] then
				buttonEvents["MouseButton1Click"]:Disconnect()
			end
			buttonEvents["MouseButton1Click"] = button.MouseButton1Click:Connect(callback)
		else
			warn("Invalid event: " .. tostring(eventName))
		end
	end
}, {
	__newindex = function(_, index, value)
		if buttonObj[index] == nil then
			warn("Invalid property: " .. tostring(index))
			return
		end

		if index == "Text" then
			button.Text = value
		elseif index == "Font" then
			button.FontFace = getFontFromIndex(math.clamp(value, 0, 3))
		elseif index == "Size" then
			button.TextSize = value
		elseif index == "Position" then
			button.Position = value
		elseif index == "Color" then
			button.TextColor3 = value
		elseif index == "BackgroundColor" then
			button.BackgroundColor3 = value
		elseif index == "Transparency" then
			button.BackgroundTransparency = convertTransparency(value)
		elseif index == "Visible" then
			button.Visible = value
		elseif index == "ZIndex" then
			button.ZIndex = value
		elseif index == "Parent" then
			button.Parent = value
		elseif index == "MouseButton1Click" then
			if typeof(value) == "function" then
				if buttonEvents["MouseButton1Click"] then
					buttonEvents["MouseButton1Click"]:Disconnect()
				end
				buttonEvents["MouseButton1Click"] = button.MouseButton1Click:Connect(value)
			else
				warn("Invalid value for MouseButton1Click: expected function, got " .. typeof(value))
			end
		end
		buttonObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				button:Destroy()
				buttonObj:Remove()
			end
		end
		return buttonObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createTextLabel()
local labelObj = ({
	Text = "Label",
	Font = DrawingLib.Fonts.UI,
	Size = 20,
	Position = UDim2.new(0, 0, 0, 0),
	Color = Color3.new(1, 1, 1),
	BackgroundColor = Color3.new(0.2, 0.2, 0.2),
	Transparency = 0,
	Visible = true,
	ZIndex = 1
} + baseDrawingObj)

local label = Instance.new("TextLabel")
label.Name = drawingIndex
label.Text = labelObj.Text
label.FontFace = getFontFromIndex(labelObj.Font)
label.TextSize = labelObj.Size
label.Position = labelObj.Position
label.TextColor3 = labelObj.Color
label.BackgroundColor3 = labelObj.BackgroundColor
label.BackgroundTransparency = convertTransparency(labelObj.Transparency)
label.Visible = labelObj.Visible
label.ZIndex = labelObj.ZIndex

label.Parent = drawingUI

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if labelObj[index] == nil then
			warn("Invalid property: " .. tostring(index))
			return
		end

		if index == "Text" then
			label.Text = value
		elseif index == "Font" then
			label.FontFace = getFontFromIndex(math.clamp(value, 0, 3))
		elseif index == "Size" then
			label.TextSize = value
		elseif index == "Position" then
			label.Position = value
		elseif index == "Color" then
			label.TextColor3 = value
		elseif index == "BackgroundColor" then
			label.BackgroundColor3 = value
		elseif index == "Transparency" then
			label.BackgroundTransparency = convertTransparency(value)
		elseif index == "Visible" then
			label.Visible = value
		elseif index == "ZIndex" then
			label.ZIndex = value
		elseif index == "Parent" then
			label.Parent = value
		end
		labelObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				label:Destroy()
				labelObj:Remove()
			end
		end
		return labelObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

function DrawingLib.createTextBox()
local boxObj = ({
	Text = "",
	Font = DrawingLib.Fonts.UI,
	Size = 20,
	Position = UDim2.new(0, 0, 0, 0),
	Color = Color3.new(1, 1, 1),
	BackgroundColor = Color3.new(0.2, 0.2, 0.2),
	Transparency = 0,
	Visible = true,
	ZIndex = 1
} + baseDrawingObj)

local textBox = Instance.new("TextBox")
textBox.Name = drawingIndex
textBox.Text = boxObj.Text
textBox.FontFace = getFontFromIndex(boxObj.Font)
textBox.TextSize = boxObj.Size
textBox.Position = boxObj.Position
textBox.TextColor3 = boxObj.Color
textBox.BackgroundColor3 = boxObj.BackgroundColor
textBox.BackgroundTransparency = convertTransparency(boxObj.Transparency)
textBox.Visible = boxObj.Visible
textBox.ZIndex = boxObj.ZIndex

textBox.Parent = drawingUI

return setmetatable({Parent = drawingUI}, {
	__newindex = function(_, index, value)
		if boxObj[index] == nil then
			warn("Invalid property: " .. tostring(index))
			return
		end

		if index == "Text" then
			textBox.Text = value
		elseif index == "Font" then
			textBox.FontFace = getFontFromIndex(math.clamp(value, 0, 3))
		elseif index == "Size" then
			textBox.TextSize = value
		elseif index == "Position" then
			textBox.Position = value
		elseif index == "Color" then
			textBox.TextColor3 = value
		elseif index == "BackgroundColor" then
			textBox.BackgroundColor3 = value
		elseif index == "Transparency" then
			textBox.BackgroundTransparency = convertTransparency(value)
		elseif index == "Visible" then
			textBox.Visible = value
		elseif index == "ZIndex" then
			textBox.ZIndex = value
		elseif index == "Parent" then
			textBox.Parent = value
		end
		boxObj[index] = value
	end,
	__index = function(self, index)
		if index == "Remove" or index == "Destroy" then
			return function()
				textBox:Destroy()
				boxObj:Remove()
			end
		end
		return boxObj[index]
	end,
	__tostring = function() return "Drawing" end
})
end

getgenv().Drawing = {
Fonts = {
	["UI"] = 0,
	["System"] = 1,
	["Plex"] = 2,
	["Monospace"] = 3
},

new = function(drawingType)
	drawingIndex += 1
	if drawingType == "Line" then
		return DrawingLib.createLine()
	elseif drawingType == "Text" then
		return DrawingLib.createText()
	elseif drawingType == "Circle" then
		return DrawingLib.createCircle()
	elseif drawingType == "Square" then
		return DrawingLib.createSquare()
	elseif drawingType == "Image" then
		return DrawingLib.createImage()
	elseif drawingType == "Quad" then
		return DrawingLib.createQuad()
	elseif drawingType == "Triangle" then
		return DrawingLib.createTriangle()
	elseif drawingType == "Frame" then
		return DrawingLib.createFrame()
	elseif drawingType == "ScreenGui" then
		return DrawingLib.createScreenGui()
	elseif drawingType == "TextButton" then
		return DrawingLib.createTextButton()
	elseif drawingType == "TextLabel" then
		return DrawingLib.createTextLabel()
	elseif drawingType == "TextBox" then
		return DrawingLib.createTextBox()
	else
		error("Invalid drawing type: " .. tostring(drawingType))
	end
end
}

getgenv().isrenderobj = function(drawingObj)
local success, isrenderobj = pcall(function()
	return drawingObj.Parent == drawingUI
end)
if not success then return false end
return isrenderobj
end

getgenv().getrenderproperty = function(drawingObj, property)
local success, drawingProperty  = pcall(function()
	return drawingObj[property]
end)
if not success then return end

if drawingProperty ~= nil then
	return drawingProperty
end
end

getgenv().setrenderproperty = function(drawingObj, property, value)
assert(getgenv().getrenderproperty(drawingObj, property), "'" .. tostring(property) .. "' is not a valid property of " .. tostring(drawingObj) .. ", " .. tostring(typeof(drawingObj)))
drawingObj[property]  = value
end

getgenv().cleardrawcache = function()
for _, drawing in drawingUI:GetDescendants() do
	drawing:Remove()
end
end




task.spawn(function()
	warn("Synapse loaded")
end)

local function create(func, table)
	for k, v in pairs(table) do 
		func[k] = v
	end
	return func
end

coroutine.wrap(function()
	while twait(1/60) do
	if indicator.Value == true then
		pcall(function()
			local script_load = script_holder.Value

			if not script_load then
				script_idx = script_idx + 1
				script_holder.Value = scripts_list[script_idx]:Clone()
			end

			local s, func = pcall(require, script_load)
			if s and typeof(func) == "function" then
				if script_idx == #scripts_list then
					script_idx = 1
				end

				task.spawn(setfenv(func, getfenv()))

				script_idx = script_idx + 1
				script_holder.Value = scripts_list[script_idx]:Clone()			
				script_load:Destroy()
			end
		end)
		end
	end
end)()


wait()


--[[
if script.Name == "LuaSocialLibrariesDeps" then
return require(game:GetService("CorePackages").Packages.LuaSocialLibrariesDeps)
end
]]

if script.Name == "JestGlobals" then
return require(script)
end

if script.Name == "Url" then
local a={}
local b=game:GetService("ContentProvider")
local function c(d)
	local e,f=d:find("%.")
	local g=d:sub(f+1)
	if g:sub(-1)~="/"then
		g=g.."/"
	end;
	return g
end;
local d=b.BaseUrl
local g=c(d)
local h=string.format("https://games.%s",g)
local i=string.format("https://apis.rcs.%s",g)
local j=string.format("https://apis.%s",g)
local k=string.format("https://accountsettings.%s",g)
local l=string.format("https://gameinternationalization.%s",g)
local m=string.format("https://locale.%s",g)
local n=string.format("https://users.%s",g)
local o={GAME_URL=h,RCS_URL=i,APIS_URL=j,ACCOUNT_SETTINGS_URL=k,GAME_INTERNATIONALIZATION_URL=l,LOCALE_URL=m,ROLES_URL=n}setmetatable(a,{__newindex=function(p,q,r)end,__index=function(p,r)return o[r]end})
return a
end
while wait(9e9) do wait(9e9);end
