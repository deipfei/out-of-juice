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

    me.background = love.graphics.newImage('resources/sprites/outlet.png')
    me.darkbackground = love.graphics.newImage('resources/sprites/outletdark.png')

    me.topplug = {}
    me.bottomplug = {}
    me.usbcable = {}

    me.topplug.img = love.graphics.newImage('resources/sprites/topplug.png')
    me.bottomplug.img = love.graphics.newImage('resources/sprites/bottomplug.png')
    me.usbcable.img = love.graphics.newImage('resources/sprites/usbcableclose.png')

    me.topplug.x = 75
    me.topplug.y = 0
    me.topplug.plugged = true

    me.bottomplug.x = 150
    me.bottomplug.y = love.graphics.getHeight() - me.bottomplug.img:getHeight()
    me.bottomplug.plugged = true

    me.usbcable.startx = 400
    me.usbcable.starty = 400
    me.usbcable.x = 400
    me.usbcable.y = 400

    me.lastcheck = {}

    me.lastcheck.x = love.mouse.getX()
    me.lastcheck.y = love.mouse.getY()

    me.previous = {}

    me.previous.x = love.mouse.getX()
    me.previous.y = love.mouse.getY()

    me.lightsout = false
    me.hovering = false
    me.holding_top = false
    me.holding_bottom = false
    me.holding_usb = false
    me.finish = false

    -- sounds
    me.computerfan = love.audio.newSource('resources/sounds/computerfan.wav')
    me.computerfan:setLooping(true)
    me.computerfan_played = false
    me.damnlights = love.audio.newSource('resources/sounds/damnlights.wav')
    me.damnlights_played = false
    me.getinthere = love.audio.newSource('resources/sounds/getinthere.wav')
    me.getinthere_played = false
    me.noopenoutlets = love.audio.newSource('resources/sounds/noopenoutlets.wav')
    me.noopenoutlets_played = false
    me.stupidcomputer = love.audio.newSource('resources/sounds/stupidcomputer.wav')
    me.stupidcomputer_played = false
  end

  function me:update_last_check()
    me.lastcheck.x = love.mouse.getX()
    me.lastcheck.y = love.mouse.getY()
  end

  function me:draw()
    if (not me.topplug.plugged) then
      love.graphics.draw(me.darkbackground, 0, 0, 0, 1, 1, 0, 0)
    else
      love.graphics.draw(me.background, 0, 0, 0, 1, 1, 0, 0)
    end
    love.graphics.draw(me.topplug.img, me.topplug.x, me.topplug.y, 0, 1, 1, 0, 0)
    love.graphics.draw(me.bottomplug.img, me.bottomplug.x, me.bottomplug.y, 0, 1, 1, 0, 0)
    love.graphics.draw(me.usbcable.img, me.usbcable.x, me.usbcable.y, 0, 1, 1, 0, 0)

  end

  function me:update()
    if (not me.computerfan_played) then
      me.computerfan:play()
      me.computerfan_played = true
    end

    if (not me.noopenoutlets_played) then
      me.noopenoutlets:play()
      me.noopenoutlets_played = true
    end

    if (not (me.holding_top or me.holding_bottom or me.holding_usb)) then
      if (me:cursor_collides(me.topplug) or me:cursor_collides(me.bottomplug) or me:cursor_collides(me.usbcable)) then
        love.mouse.setCursor(me.open_hand_cursor)
        if (me.hovering) then
          if (love.mouse.isDown(1)) then
            love.mouse.setCursor(me.closed_hand_cursor)
            me:update_last_check()
            if (me:cursor_collides(me.topplug)) then
              me.holding_top = true
            elseif (me:cursor_collides(me.bottomplug)) then
              me.holding_bottom = true
            else
              me.holding_usb = true
              me.previous.time = love.timer.getTime()
              me.previous.x = love.mouse.getX()
              me.previous.y = love.mouse.getY()
            end
          end
        end

        if (not love.mouse.isDown(1)) then
          me.hovering = true
        end
      else
        love.mouse.setCursor(me.arrow_cursor)
        me.hovering = false
      end
    else
      if (me.lastcheck.x - love.mouse.getX() > 100) then
        if (me.holding_top and me.topplug.plugged) then
          me.topplug.plugged = false
          me.topplug.x = love.mouse.getX() - 300
          if (not me.damnlights_played) then
            me.damnlights:play()
            me.damnlights_played = true
          end
        elseif (me.holding_bottom and me.bottomplug.plugged) then
          me.bottomplug.plugged = false
          me.bottomplug.x = love.mouse.getX() - 250
          if (not me.stupidcomputer_played) then
            me.computerfan:stop()
            me.stupidcomputer:play()
            me.stupidcomputer_played = true
          end
        end
      end
    end

    if (me.holding_usb) then
      if (not me.getinthere_played) then
        me.getinthere:play()
        me.getinthere_played = true
      end

      movementx = (love.mouse.getX() - me.previous.x) / 8
      movementy = (love.mouse.getY() - me.previous.y) / 8

      love.mouse.setX(me.previous.x + movementx)
      love.mouse.setY(me.previous.y + movementy)

      me.previous.x = love.mouse.getX()
      me.previous.y = love.mouse.getY()

      me.usbcable.x = love.mouse.getX() - (me.usbcable.img:getWidth() / 2)
      me.usbcable.y = love.mouse.getY() - (me.usbcable.img:getHeight() / 6)
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
      if ((love.mouse.getX() > 275 and love.mouse.getX() < 325) and (love.mouse.getY() > 160 and love.mouse.getY() < 185) and not me.topplug.plugged) then
        me.usbcable.plugged = true
        me.computerfan:stop()
      end

      if ((love.mouse.getX() > 275 and love.mouse.getX() < 325) and (love.mouse.getY() > 300 and love.mouse.getY() < 325) and not me.bottomplug.plugged) then
        me.usbcable.plugged = true
        me.computerfan:stop()
      end
    end

    if (not love.mouse.isDown(1)) then
      me.holding_top = false
      me.holding_bottom = false
      me.holding_usb = false
    end

    if (math.abs(me.usbcable.y - me.usbcable.starty) > 5) then
      if (me.usbcable.y > me.usbcable.starty) then
        me.usbcable.y = me.usbcable.y - 2
      elseif (me.usbcable.y < me.usbcable.starty) then
        me.usbcable.y = me.usbcable.y + 2
      end
    end

  end

  function me:cursor_collides(obj)
    if (love.mouse.getX() >= obj.x and love.mouse.getY() >= obj.y and love.mouse.getX() < obj.x + obj.img:getWidth() and love.mouse.getY() < obj.y + obj.img:getHeight()) then
      return true
    else
      return false
    end
  end

  function me:finished()
    return me.usbcable.plugged
  end

  return me
end