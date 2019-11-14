local image = love.graphics.newImage('download.png')
local FXAACanvas
do
  local _class_0
  local _base_0 = {
    draw = function(self, dfn)
      love.graphics.setCanvas(self.layers[1])
      love.graphics.setShader(self.shader_fxaa)
      dfn()
      love.graphics.setCanvas()
      return love.graphics.setShader()
    end,
    render = function(self, x, y, w, h)
      if #self.layers > 1 then
        for stage, canvas in ipairs(self.layers) do
          local _continue_0 = false
          repeat
            if not (stage > 1) then
              _continue_0 = true
              break
            end
            love.graphics.setCanvas(canvas)
            love.graphics.setShader(self.shader_fxaa)
            love.graphics.draw(self.layers[stage - 1], 0, 0)
            love.graphics.setShader()
            love.graphics.setCanvas()
            _continue_0 = true
          until true
          if not _continue_0 then
            break
          end
        end
      end
      local final = self.layers[#self.layers]
      if self.sharp_pass then
        love.graphics.setCanvas(self.sharp_pass)
        love.graphics.setShader(self.shader_sharpen)
        love.graphics.draw(final, 0, 0)
        love.graphics.setShader()
        love.graphics.setCanvas()
        final = self.sharp_pass
      end
      return love.graphics.draw(final, x, y, w, h)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, width, height, stages, sharpen)
      if stages == nil then
        stages = 1
      end
      if sharpen == nil then
        sharpen = 0
      end
      self.sharpen = sharpen
      self.shader_fxaa = love.graphics.newShader('fxaa.glsl')
      self.shader_sharpen = love.graphics.newShader('sharpen.glsl')
      self.layers = { }
      for stage = 1, stages do
        table.insert(self.layers, love.graphics.newCanvas(width, height))
      end
      if self.sharpen > 0 then
        self.sharp_pass = love.graphics.newCanvas(width, height)
        return self.shader_sharpen:send('sharpness', self.sharpen)
      end
    end,
    __base = _base_0,
    __name = "FXAACanvas"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  FXAACanvas = _class_0
end
love.load = function()
  love.window.setMode(1024, 1024, {
    borderless = true
  })
  return love.window.setTitle("Mobile FXAA (by NVIDIA/Timothy L. & Meincraft/Armin Ronacher) - Left: FXAA on, Right: Original")
end
local cv = FXAACanvas(512, 512)
local cv2 = FXAACanvas(512, 512, 2)
local cv4 = FXAACanvas(512, 512, 4, .3)
love.draw = function()
  cv:draw(function()
    return love.graphics.draw(image, 0, 0)
  end)
  cv2:draw(function()
    return love.graphics.draw(image, 0, 0)
  end)
  cv4:draw(function()
    return love.graphics.draw(image, 0, 0)
  end)
  love.graphics.draw(image, 0, 0)
  cv:render(512, 0)
  cv2:render(0, 512)
  cv4:render(512, 512)
  love.graphics.setColor(0, 0, 0, 0.75)
  love.graphics.rectangle("fill", 10, 10, 110, 50)
  love.graphics.rectangle("fill", 522, 10, 110, 50)
  love.graphics.rectangle("fill", 522, 522, 110, 50)
  love.graphics.rectangle("fill", 10, 522, 110, 50)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("FXAA: off\nSharpen: off", 20, 20, 110)
  love.graphics.printf("FXAA: 1x\nSharpen: off", 532, 20, 110)
  love.graphics.printf("FXAA: 4x\nSharpen: 30%", 532, 532, 110)
  return love.graphics.printf("FXAA: 2x\nSharpen: off", 20, 532, 110)
end
love.keypressed = function(k)
  if k == "escape" then
    return love.event.quit()
  end
end
