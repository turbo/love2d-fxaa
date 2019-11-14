image = love.graphics.newImage('download.png')

class FXAACanvas
  new: (width, height, stages = 1, @sharpen = 0, reduce_min = 1/128, reduce_mul = 1/8, span_max = 8) =>
    @shader_fxaa = love.graphics.newShader('fxaa.glsl')
    with @shader_fxaa
      \send('fxaa_reduce_min', reduce_min)
      \send('fxaa_reduce_mul', reduce_mul)
      \send('fxaa_span_max', span_max)

    @shader_sharpen = love.graphics.newShader('sharpen.glsl')

    @layers = { }
    for stage = 1, stages
      table.insert(@layers, love.graphics.newCanvas(width, height))
    
    if @sharpen > 0
      @sharp_pass = love.graphics.newCanvas(width, height) 
      @shader_sharpen\send('sharpness', @sharpen)

  draw: (dfn) =>
    love.graphics.setCanvas(@layers[1])
    love.graphics.setShader(@shader_fxaa)
    dfn!
    love.graphics.setCanvas!
    love.graphics.setShader!

  render: (x, y, w, h) =>
    if #@layers > 1
      for stage, canvas in ipairs @layers
        continue unless stage > 1
        -- print "doing stage", stage
        love.graphics.setCanvas(canvas)
        love.graphics.setShader(@shader_fxaa)
        love.graphics.draw(@layers[stage - 1], 0, 0)
        love.graphics.setShader()
        love.graphics.setCanvas()

    final = @layers[#@layers]

    if @sharp_pass
      love.graphics.setCanvas(@sharp_pass)
      love.graphics.setShader(@shader_sharpen)
      love.graphics.draw(final, 0, 0)
      love.graphics.setShader()
      love.graphics.setCanvas()
      final = @sharp_pass

    love.graphics.draw(final, x, y, w, h)


love.load = ->
  love.window.setMode(1024, 1024, {
    borderless: true
    -- msaa: 4
    -- highdpi: true
    -- vsync: false
  })

  love.window.setTitle("Mobile FXAA (by NVIDIA/Timothy L. & Meincraft/Armin Ronacher)")


cv = FXAACanvas(512, 512)
cv2 = FXAACanvas(512, 512, 2)
cv4 = FXAACanvas(512, 512, 4, .3)

love.draw = ->
  cv\draw -> love.graphics.draw(image, 0, 0)
  cv2\draw -> love.graphics.draw(image, 0, 0)
  cv4\draw -> love.graphics.draw(image, 0, 0)

  love.graphics.draw(image, 0, 0)
  cv\render(512, 0)
  cv2\render(0, 512)
  cv4\render(512, 512)

  love.graphics.setColor(0, 0, 0, 0.75)

  love.graphics.rectangle("fill", 10, 10, 110, 50)
  love.graphics.rectangle("fill", 522, 10, 110, 50)
  love.graphics.rectangle("fill", 522, 522, 110, 50)
  love.graphics.rectangle("fill", 10, 522, 110, 50)

  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.printf("FXAA: off\nSharpen: off", 20, 20, 110)
  love.graphics.printf("FXAA: 1x\nSharpen: off", 532, 20, 110)
  love.graphics.printf("FXAA: 4x\nSharpen: 30%", 532, 532, 110)
  love.graphics.printf("FXAA: 2x\nSharpen: off", 20, 532, 110)

love.keypressed = (k) ->
  love.event.quit! if k == "escape" 
      

