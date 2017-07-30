module(..., package.seeall)

function new()
  local me = {}

  function me:load()
    me.title1 = love.graphics.newImage('resources/sprites/title1.png')
    me.title2 = love.graphics.newImage('resources/sprites/title2.png')
    me.title3 = love.graphics.newImage('resources/sprites/title3.png')
    me.title4 = love.graphics.newImage('resources/sprites/title4.png')
    me.title5 = love.graphics.newImage('resources/sprites/title5.png')
    me.title6 = love.graphics.newImage('resources/sprites/title6.png')
    me.title7 = love.graphics.newImage('resources/sprites/title7.png')
    me.title8 = love.graphics.newImage('resources/sprites/title8.png')
    me.title9 = love.graphics.newImage('resources/sprites/title9.png')
    me.title10 = love.graphics.newImage('resources/sprites/title10.png')

    me.start_on = love.graphics.newImage('resources/sprites/start_on.png')
    me.start_off = love.graphics.newImage('resources/sprites/start_off.png')

    me.exit_on = love.graphics.newImage('resources/sprites/exit_on.png')
    me.exit_off = love.graphics.newImage('resources/sprites/exit_off.png')

    me.current_title = 1
    me.last_update = love.timer.getTime()

    me.titlex = (love.graphics.getWidth() / 2) - (me.title1:getWidth() / 2)
    me.titley = 100

    me.startx = (love.graphics.getWidth() / 2) - (me.start_on:getWidth() / 2)
    me.starty = 275

    me.exitx = (love.graphics.getWidth() / 2) - (me.exit_on:getWidth() / 2)
    me.exity = 350

    me.hoverstart = false
    me.hoverexit = false

    me.finish = false
  end

  function me:draw()
    if (me.current_title == 1) then
      love.graphics.draw(me.title1, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 2) then
      love.graphics.draw(me.title2, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 3) then
      love.graphics.draw(me.title3, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 4) then
      love.graphics.draw(me.title4, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 5) then
      love.graphics.draw(me.title5, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 6) then
      love.graphics.draw(me.title6, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 7) then
      love.graphics.draw(me.title7, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 8) then
      love.graphics.draw(me.title8, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 9) then
      love.graphics.draw(me.title9, me.titlex, me.titley, 0, 1, 1, 0, 0)
    elseif (me.current_title == 10) then
      love.graphics.draw(me.title10, me.titlex, me.titley, 0, 1, 1, 0, 0)
    end

    if (me.hoverstart) then
      love.graphics.draw(me.start_on, me.startx, me.starty, 0, 1, 1, 0, 0)
    else
      love.graphics.draw(me.start_off, me.startx, me.starty, 0, 1, 1, 0, 0)
    end

    if (me.hoverexit) then
      love.graphics.draw(me.exit_on, me.exitx, me.exity, 0, 1, 1, 0, 0)
    else
      love.graphics.draw(me.exit_off, me.exitx, me.exity, 0, 1, 1, 0, 0)
    end
  end

  function me:update()
    if (love.timer.getTime() - me.last_update > 1) then
      me.current_title = me.current_title + 1

      if (me.current_title > 10) then
        me.current_title = 1
      end

      me.last_update = love.timer.getTime()
    end

    if (me:cursor_collides(me.startx, me.starty, me.start_on)) then
      me.hoverstart = true
    else
      me.hoverstart = false
    end

    if (me:cursor_collides(me.exitx, me.exity, me.exit_on)) then
      me.hoverexit = true
    else
      me.hoverexit = false
    end
  end

  function me:finished()
    return me.finish
  end

  function me:cursor_collides(x, y, img)
    if (love.mouse.getX() >= x and love.mouse.getY() >= y and love.mouse.getX() < x + img:getWidth() and love.mouse.getY() < y + img:getHeight()) then
      return true
    else
      return false
    end
  end

  function me:click(x, y)
    if (me:cursor_collides(me.startx, me.starty, me.start_on)) then
      me.finish = true
    elseif (me:cursor_collides(me.exitx, me.exity, me.start_off)) then
      love.event.quit()
    end
  end

  return me
end