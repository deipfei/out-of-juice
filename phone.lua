module(..., package.seeall)

function new()
  local me = {}

  function me:load()
    -- seed and pop some randoms BECAUSE LUA!

    me.openhand = love.graphics.newImage('resources/sprites/openhandcursor.png')
    me.closedhand = love.graphics.newImage('resources/sprites/closedhandcursor.png')
    me.arrow_cursor = love.mouse.getSystemCursor('arrow')
    me.open_hand_cursor = love.mouse.newCursor('resources/sprites/openhandcursor.png', me.openhand:getWidth() / 2, me.openhand:getHeight() / 2)
    me.closed_hand_cursor = love.mouse.newCursor('resources/sprites/closedhandcursor.png', me.closedhand:getWidth() / 2, me.closedhand:getHeight() / 2)
    me.phonedead = love.graphics.newImage('resources/sprites/phoneoff.PNG')
    me.phoneload1 = love.graphics.newImage('resources/sprites/phoneload1.png')
    me.phoneload2 = love.graphics.newImage('resources/sprites/phoneload2.png')
    me.phoneload3 = love.graphics.newImage('resources/sprites/phoneload3.png')
    me.phoneload4 = love.graphics.newImage('resources/sprites/phoneload4.png')
    me.phonefinal1 = love.graphics.newImage('resources/sprites/phonefinal1.png')
    me.phonefinal2 = love.graphics.newImage('resources/sprites/phonefinal2.png')

    me.phonestate = 0

    me.phonex = (love.graphics.getWidth() / 2) - (me.phonedead:getWidth() / 2)
    me.phoney = -600

    me.usbcable = {}
    me.usbcable.img = love.graphics.newImage('resources/sprites/phonecharger.png')
    me.usbcable.startx = 0
    me.usbcable.starty = 460
    me.usbcable.x = 0
    me.usbcable.y = 460
    me.usbcable.plugged = false

    me.previous = {}

    me.previous.x = love.mouse.getX()
    me.previous.y = love.mouse.getY()

    me.holding_usb = false
    me.hovering = false

    me.has_released_after_end = false

    me.lasttimecheck = love.timer.getTime()

    -- sounds
    me.brandon = love.audio.newSource('resources/sounds/brandon.wav')
    me.brandon_played = false
    me.hurryup = love.audio.newSource('resources/sounds/hurryup.wav')
    me.hurryup_played = false
    me.upsidedown = love.audio.newSource('resources/sounds/upsidedown.wav')
    me.upsidedown_played = false
    me.what = love.audio.newSource('resources/sounds/what.wav')
    me.what_played = false

    me.stop_breathing = false
  end

  function me:draw()
    love.graphics.draw(me.usbcable.img, me.usbcable.x, me.usbcable.y, 0, 1, 1, 0, 0)

    if (me.phonestate == 0) then
      love.graphics.draw(me.phonedead, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    elseif (me.phonestate == 1) then
      love.graphics.draw(me.phoneload1, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    elseif (me.phonestate == 2) then
      love.graphics.draw(me.phoneload2, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    elseif (me.phonestate == 3) then
      love.graphics.draw(me.phoneload3, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    elseif (me.phonestate == 4) then
      love.graphics.draw(me.phoneload4, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    elseif (me.phonestate == 5) then
      love.graphics.draw(me.phonefinal1, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    else
      love.graphics.draw(me.phonefinal2, me.phonex, me.phoney, 0, 1, 1, 0, 0)
    end

  end

  function me:update()
    if (not me.usbcable.plugged) then
      if (not (me.holding_usb)) then
        if (me:cursor_collides(me.usbcable)) then
          love.mouse.setCursor(me.open_hand_cursor)
          if (me.hovering) then
            if (love.mouse.isDown(1)) then
              love.mouse.setCursor(me.closed_hand_cursor)
              me.holding_usb = true
              me.previous.x = love.mouse.getX()
              me.previous.y = love.mouse.getY()
            end
          end

          if (not love.mouse.isDown(1)) then
            me.hovering = true
          end
        else
          love.mouse.setCursor(me.arrow_cursor)
          me.hovering = false
        end
      end

      if (me.holding_usb) then
        if (not me.upsidedown_played) then
          me.upsidedown:play()
          me.upsidedown_played = true
        end

        movementx = (love.mouse.getX() - me.previous.x) / 4
        movementy = (love.mouse.getY() - me.previous.y) / 4

        love.mouse.setX(me.previous.x + movementx)
        love.mouse.setY(me.previous.y + movementy)

        me.previous.x = love.mouse.getX()
        me.previous.y = love.mouse.getY()

        me.usbcable.x = love.mouse.getX() - (me.usbcable.img:getWidth() / 1.7)
        me.usbcable.y = love.mouse.getY() - (me.usbcable.img:getHeight() / 10)
        if me.usbcable.y < 0 then
          me.usbcable.y = 0
        elseif me.usbcable.y > love.graphics.getHeight() then
          me.usbcable.y = love.graphics.getHeight()
        end

        if me.usbcable.x < 0 then
          me.usbcable.x = 0
        elseif me.usbcable.x > love.graphics.getWidth() then
          me.usbcable.x = love.graphics.getWidth()
        end

        -- check if plugged in
        if (((me.usbcable.x + 70) > (love.graphics.getWidth() / 2) - 10 and (me.usbcable.x + 70) < (love.graphics.getWidth() / 2) + 10) and (me.usbcable.y > 25 and me.usbcable.y < 45)) then
          me.usbcable.plugged = true
          me.phonestate = me.phonestate + 1
          me.lasttimecheck = love.timer.getTime()
          love.mouse.setCursor(me.arrow_cursor)
        end
      end

      if (not love.mouse.isDown(1)) then
        me.holding_usb = false
      end

      if (math.abs(me.usbcable.y - me.usbcable.starty) > 5) then
        if (me.usbcable.y > me.usbcable.starty) then
          me.usbcable.y = me.usbcable.y - 2
        elseif (me.usbcable.y < me.usbcable.starty) then
          me.usbcable.y = me.usbcable.y + 2
        end
      end

    else
      if (me.phoney < 0) then
        me.phoney = me.phoney + 2
        me.usbcable.y = me.usbcable.y + 2
      end

      if (me.phonestate == 3) then
        if (not me.hurryup_played) then
          me.hurryup:play()
          me.hurryup_played = true
        end
      end

      if (me.phonestate == 5) then
        if (not me.what_played) then
          me.stop_breathing = true
          me.what:play()
          me.what_played = true
        end
      end

      if (me.phonestate == 6) then
        if (not me.brandon_played) then
          me.brandon:play()
          me.brandon_played = true
        end
      end

      if (love.timer.getTime() - me.lasttimecheck > 3) then
        me.phonestate = me.phonestate + 1
        me.lasttimecheck = love.timer.getTime()
      end
    end

  end

  function me:stopbreathing()
    return me.stop_breathing
  end

  function me:cursor_collides(obj)
    if (love.mouse.getX() >= obj.x and love.mouse.getY() >= obj.y and love.mouse.getX() < obj.x + obj.img:getWidth() and love.mouse.getY() < obj.y + obj.img:getHeight()) then
      return true
    else
      return false
    end
  end

  function me:click(x, y)
    if (me.has_released_after_end) then
      me.phonestate = me.phonestate + 1
      me.lasttimecheck = love.timer.getTime()
    end

    me.has_released_after_end = true
  end

  function me:finished()
    return me.phonestate > 6
  end

  return me
end