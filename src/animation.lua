Animation = {}

Animation.__index = Animation

function Animation.new(name)
    local instance = setmetatable({}, Animation)
    instance.name = name
    instance.frames = {}
    return instance
end

function Animation:addFrame(frame)
    self.frames[#self.frames+1] = frame
end

function Animation:setCustomColour(originalColour, colourCode, monitor)
    peripheral.wrap(monitor).setPaletteColour(originalColour, colourCode)
end

function Animation:setType(animationType)
    self.type = animationType
end

AdvancedAnimation = {}
AdvancedAnimation.__index = AdvancedAnimation
setmetatable(AdvancedAnimation, { __index = Animation })

AdvancedAnimationType = { CHANGE_TEXT = 1 }

function AdvancedAnimation.new(name)
    local self = Animation.new(name)
    setmetatable(self, AdvancedAnimation)

    self.type = AdvancedAnimationType.CHANGE_TEXT
    self.texts = {}
    self.durations = {}
    self.frameBackgroundColours = {}

    return self
end

function AdvancedAnimation:setTexts(texts)
    self.texts = texts
end

function AdvancedAnimation:setDurations(durations)
    self.durations = durations
end

function AdvancedAnimation:setFrameBackgroundColours(colours)
    self.frameBackgroundColours = colours
end

function AdvancedAnimation:setType(type)
    self.type = type
end

Frame = {}

Frame.__index = Frame

function Frame.new()
    local instance = setmetatable({}, Frame)
    instance.duration = 0
    instance.pixels = {}
    instance.backgroundColour = colors.black
    instance.text = {}
    return instance
    ---instance.image
end

function Frame:setDuration(newDuration)
  self.duration = newDuration
end

function Frame:getDuration()
    return self.duration
end

function Frame:setBackgroundColour(newColour)
    self.backgroundColour = newColour
end
function Frame:addPixel(pixel)
    self.pixels[#self.pixels+1] = pixel
end

function Frame:addPixels(pixels)
    for _, pixel in ipairs(pixels) do
        self:addPixel(pixel)
    end
end

function Frame:addText(text, colour, size, x, y, backgroundColour)
    self.text = {text = text, colour = colour, size = size, x = x, y = y, backgroundColour = backgroundColour}
end

Pixel = {}

Pixel.__index = Pixel

function Pixel.new(x, y, colour)
    local instance = setmetatable({}, Pixel)
    instance.x = x
    instance.y = y
    instance.colour = colour
    return instance
end

Text = {}

Text.__index = Text

function Text.new(text, colour, size, x, y, backgroundColour)
    local instance = setmetatable({}, Text)
    instance.text = text
    instance.colour = colour
    instance.size = size
    instance.x = x
    instance.y = y
    instance.backgroundColour = backgroundColour
    return instance
end

function startAdvancedAnimation(animation, monitorName)
    if animation.type == AdvancedAnimationType.CHANGE_TEXT then

        for i, text in ipairs(animation.texts) do
            local frame = Frame.new()
            frame:setDuration(animation.durations[i])
            frame:setBackgroundColour(animation.frameBackgroundColours[i])
            frame:addText(text.text, text.colour, text.size, text.x, text.y, text.backgroundColour)
            animation:addFrame(frame)
        end

        startAnimation(animation, monitorName)

    end
end

function startAnimation(animation, monitorName)
    local frameIdx = 1
    local monitor = peripheral.wrap(monitorName)
    monitor.clear()

    while true do
        local frame = animation.frames[frameIdx]
        setMonitorToFrame(monitor, frame)
        frameIdx = math.max(1, (frameIdx + 1) % (#animation.frames + 1))
        sleep(frame:getDuration())
    end
end

function setMonitorToFrame(monitor, frame)
        term.redirect(monitor)
        monitor.setTextScale(1)
        monitor.clear()
        monitor.setBackgroundColour(frame.backgroundColour)
        monitor.clear()

        for _, pixel in ipairs(frame.pixels) do
            paintutils.drawPixel(pixel.x, pixel.y, pixel.colour)
        end

        if frame.text.text then
            monitor.setTextScale(frame.text.size)
            monitor.setTextColour(frame.text.colour)
            monitor.setBackgroundColour(frame.text.backgroundColour)
            monitor.setCursorPos(frame.text.x, frame.text.y)
            monitor.write(frame.text.text)
        end
end

--- create animation

local zabkaMidAnimation = AdvancedAnimation.new("zabka_mid")
zabkaMidAnimation:setTexts({Text.new("Siema", colors.white, 3, 2, 2, colors.white),
Text.new("Witaj!", colors.white, 3, 1, 5, colors.blue)})
zabkaMidAnimation:setDurations({10, 5})
zabkaMidAnimation:setFrameBackgroundColours({colors.green, colors.blue})

startAdvancedAnimation(zabkaMidAnimation, "monitor_0")
