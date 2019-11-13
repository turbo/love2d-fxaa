image = love.graphics.newImage('download.png')
shader = love.graphics.newShader('fxaa.glsl')

canvas = love.graphics.newCanvas( 512, 512 )

love.load = ->
  love.window.setMode(1024, 512, {
    -- msaa: 4
    -- highdpi: true
    -- vsync: false
  })

  love.window.setTitle("Mobile FXAA (by NVIDIA/Timothy L. & Meincraft/Armin Ronacher) - Left: FXAA on, Right: Original")

love.draw = ->
  love.graphics.setCanvas(canvas)
  love.graphics.setShader(shader)
  love.graphics.draw(image, 0, 0)
  love.graphics.setShader()
  love.graphics.setCanvas()

  love.graphics.draw(canvas, 0, 0)

  love.graphics.draw(image, 512, 0)
