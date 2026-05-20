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
    self.text = {text, colour, size, x, y}
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
    local animationFramesSize = #animation.frames
    local currentFrame = 1
    local firstFrame = animation.frames[1]
    local monitor =  peripheral.wrap(monitorName)
    monitor.clear()
    setMonitorToFrame(monitor, firstFrame)

    if animationFramesSize > 1 then

        sleep(firstFrame:getDuration())

        while true do

            if currentFrame+1 > animationFramesSize then
                setMonitorToFrame(monitor, firstFrame)
                currentFrame = 1
                sleep(firstFrame:getDuration())
            else
                local newFrame = animation.frames[currentFrame+1]
                setMonitorToFrame(monitor, newFrame)
                currentFrame = currentFrame+1
                sleep(newFrame:getDuration())
            end
        end

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

        if #frame.text > 0 then
            monitor.setTextScale(frame.text[3])
            monitor.setTextColour(frame.text[2])
            monitor.setBackgroundColour(frame.text[6])
            monitor.setCursorPos(frame.text[4], frame.text[5])
            monitor.write(frame.text[1])
        end
end


---zabka animation mid
local zabkaAnimation = Animation.new("zabka_mid")
local frame1ZabkaMid = Frame.new()
local frame2ZabkaMid = Frame.new()

frame1ZabkaMid:setDuration(10)
---ymax: 12  xmax: 29
frame1ZabkaMid:addPixels({Pixel.new(1, 1, colors.orange), Pixel.new(1, 3, colors.yellow), Pixel.new(5, 5, colors.green)})
frame1ZabkaMid:setBackgroundColour(colors.blue)
frame1ZabkaMid:addText("Siema", colors.white, 1, 10, 5, colors.blue)
zabkaAnimation:addFrame(frame1ZabkaMid)

frame2ZabkaMid:setDuration(5)
frame2ZabkaMid:setBackgroundColour(colors.black)
zabkaAnimation:addFrame(frame2ZabkaMid)

local zabkaAnimation1 = Animation.new("zabka_mid1")
local frame1ZabkaMid1 = Frame.new()
local frame2ZabkaMid1 = Frame.new()

frame1ZabkaMid1:setDuration(5)
---ymax: 12  xmax: 29
frame1ZabkaMid1:setBackgroundColour(colors.blue)
zabkaAnimation1:addFrame(frame1ZabkaMid1)

frame2ZabkaMid1:setDuration(10)
frame2ZabkaMid1:setBackgroundColour(colors.black)
zabkaAnimation1:addFrame(frame2ZabkaMid1)


local function start_animation_1() startAnimation(zabkaAnimation, "monitor_0") end
local function start_animation_2() startAnimation(zabkaAnimation1, "monitor_1") end

parallel.waitForAll(start_animation_1, start_animation_2)