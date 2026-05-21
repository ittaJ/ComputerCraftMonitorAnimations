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


local zabkaMidAnimation = Animation.new("zabka_mid")
local frame1ZabkaMid = Frame.new()
local frame2ZabkaMid = Frame.new()

zabkaMidAnimation:setCustomColour(colors.green, 0x006D42, "monitor_0")

frame1ZabkaMid:setDuration(10)
frame1ZabkaMid:setBackgroundColour(colors.green)
frame1ZabkaMid:addText("Zabka", colors.white, 3.5, 4, 4, colors.green)

frame2ZabkaMid:setDuration(10)
frame2ZabkaMid:setBackgroundColour(colors.green)
frame2ZabkaMid:addText("Wpadaj do nas!", colors.white, 2, 4, 4, colors.green)

zabkaMidAnimation:addFrame(frame1ZabkaMid)
zabkaMidAnimation:addFrame(frame2ZabkaMid)

startAnimation(zabkaMidAnimation, "monitor_0")