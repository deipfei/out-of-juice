module(..., package.seeall)

function new()
  local me = {}

  function me:load()
    -- seed and pop some randoms BECAUSE LUA!
    math.randomseed(os.time())
    math.random()
    math.random()
    math.random()

    me.magnifying_glass = love.graphics.newImage('resources/sprites/magnifyingglass.png')
    me.forward_arrow = love.graphics.newImage('resources/sprites/forwardarrow.png')
    me.arrow_cursor = love.mouse.getSystemCursor('arrow')
    me.mag_cursor = love.mouse.newCursor('resources/sprites/magnifyingglass.png', me.magnifying_glass:getWidth() / 2, me.magnifying_glass:getHeight() / 2)
    me.forward_cursor = love.mouse.newCursor('resources/sprites/forwardarrow.png', me.forward_arrow:getWidth() / 2, me.forward_arrow:getHeight() / 2)
    me.room = {}
    me.computer = {}
    me.drawers = {}
    me.painting = {}
    me.plant = {}
    me.rug = {}
    me.usb = {}

    me.room.img = love.graphics.newImage('resources/sprites/room.png')
    me.computer.img = love.graphics.newImage('resources/sprites/computer.png')
    me.drawers.img = love.graphics.newImage('resources/sprites/drawers.png')
    me.painting.img = love.graphics.newImage('resources/sprites/painting.png')
    me.plant.img = love.graphics.newImage('resources/sprites/plant.png')
    me.rug.img = love.graphics.newImage('resources/sprites/rug.png')
    me.usb.img = love.graphics.newImage('resources/sprites/usbcable.png')

    me.room.x = 0
    me.room.y = 0
    me.computer.x = me:center_x(me.computer.img) - 30
    me.computer.y = (love.graphics.getHeight() / 2) - 75
    me.drawers.x = me.computer.x + 250
    me.drawers.y = me.computer.y + 75
    me.drawers.shifted = false
    me.drawers.xsh = me.drawers.x + 100
    me.drawers.ysh = me.drawers.y
    me.painting.x = me.computer.x + 175
    me.painting.y = me.computer.y - 100
    me.painting.shifted = false
    me.painting.xsh = me.painting.x + 150
    me.painting.ysh = me.painting.y
    me.plant.x = me.computer.x - 150
    me.plant.y = me.computer.y + 30
    me.plant.shifted = false
    me.plant.xsh = me.plant.x - 50
    me.plant.ysh = me.plant.y
    me.rug.x = me.computer.x - 50
    me.rug.y = me.computer.y + 200
    me.rug.shifted = false
    me.rug.xsh = me.rug.x + 150
    me.rug.ysh = me.rug.y

    random_location = math.random(1, 4)
    --random_location = 3

    if (random_location == 1) then
      me.usb.x = me:center_x_obj(me.usb, me.drawers)
      me.usb.y = me:center_y_obj(me.usb, me.drawers)
      me.usb.hiding_place = me.drawers
    elseif (random_location == 2) then
      me.usb.x = me:center_x_obj(me.usb, me.painting)
      me.usb.y = me:center_y_obj(me.usb, me.painting)
      me.usb.hiding_place = me.painting
    elseif (random_location == 3) then
      me.usb.x = me:center_x_obj(me.usb, me.plant)
      --get it behind the pot not just behind the branches, where it can be seen
      me.usb.y = me:center_y_obj(me.usb, me.plant) + 40
      me.usb.hiding_place = me.plant
    else
      me.usb.x = me:center_x_obj(me.usb, me.rug)
      me.usb.y = me:center_y_obj(me.usb, me.rug)
      me.usb.hiding_place = me.rug
    end

    me.usb.collected = false

    me.finish = false

    -- sounds
    me.dumbdrawers = love.audio.newSource('resources/sounds/dumbdrawers.wav')
    me.dumbdrawers_played = false
    me.fuckingpainting = love.audio.newSource('resources/sounds/fuckingpainting.wav')
    me.fuckingpainting_played = false
    me.stupidplant = love.audio.newSource('resources/sounds/stupidplant.wav')
    me.stupidplant_played = false
    me.undertherug = love.audio.newSource('resources/sounds/undertherug.wav')
    me.undertherug_played = false
    me.thereyouare = love.audio.newSource('resources/sounds/thereyouare.wav')
    me.thereyouare_played = false
  end

  function me:draw()
    love.graphics.draw(me.room.img, me.room.x, me.room.y, 0, 1, 1, 0, 0)

    if (not me.usb.collected) then
      love.graphics.draw(me.usb.img, me.usb.x, me.usb.y, 0, 1, 1, 0, 0)
    end

    me:draw_obj(me.painting)
    me:draw_obj(me.computer)
    me:draw_obj(me.drawers)
    me:draw_obj(me.plant)
    me:draw_obj(me.rug)
  end

  function me:draw_obj(obj)
    if (obj.shifted) then
      love.graphics.draw(obj.img, obj.xsh, obj.ysh, 0, 1, 1, 0, 0)
    else
      love.graphics.draw(obj.img, obj.x, obj.y, 0, 1, 1, 0, 0)
    end
  end

  function me:update()
    if (not me.usb.collected and (me:cursor_collides(me.drawers) or me:cursor_collides(me.painting) or me:cursor_collides(me.plant) or me:cursor_collides(me.rug))) then
      love.mouse.setCursor(me.mag_cursor)
    elseif (me.usb.collected and (me:cursor_collides(me.computer))) then
      love.mouse.setCursor(me.forward_cursor)
    else
      love.mouse.setCursor(me.arrow_cursor)
    end
  end

  function me:click(x, y)
    if (me.usb.collected and me:cursor_collides(me.computer)) then
      love.mouse.setCursor(me.arrow_cursor)
      me.finish = true
    end

    if (me:cursor_collides(me.usb) and me.usb.hiding_place.shifted) then
      me.usb.collected = true
      if (not me.thereyouare_played) then
        me.thereyouare:play()
        me.thereyouare_played = true
      end
    end

    me:check_click(me.painting, x, y)
    me:check_click(me.drawers, x, y)
    me:check_click(me.plant, x, y)
    me:check_click(me.rug, x, y)
  end

  function me:check_click(obj, x, y)
    if (me:cursor_collides(obj)) then
      obj.shifted = true
      if (obj == me.painting and not me.fuckingpainting_played) then
        me.fuckingpainting:play()
        me.fuckingpainting_played = true
      elseif (obj == me.drawers and not me.dumbdrawers_played) then
        me.dumbdrawers:play()
        me.dumbdrawers_played = true
      elseif (obj == me.plant and not me.stupidplant_played) then
        me.stupidplant:play()
        me.stupidplant_played = true
      elseif (obj == me.rug and not me.undertherug_played) then
        me.undertherug:play()
        me.undertherug_played = true
      end
    end
  end

  function me:center_x_obj(item, obj)
    return (obj.x + (obj.img:getWidth() / 2)) - (item.img:getWidth() / 2)
  end

  function me:center_y_obj(item, obj)
    return (obj.y + (obj.img:getHeight() / 2)) - (item.img:getHeight() / 2)
  end

  function me:cursor_collides(obj)
    if (love.mouse.getX() >= obj.x and love.mouse.getY() >= obj.y and love.mouse.getX() < obj.x + obj.img:getWidth() and love.mouse.getY() < obj.y + obj.img:getHeight()) then
      return true
    else
      return false
    end
  end

  function me:center_x(img)
    return (love.graphics.getWidth() / 2) - (img:getWidth() / 2)
  end

  function me:finished()
    return me.finish
  end

  return me
end