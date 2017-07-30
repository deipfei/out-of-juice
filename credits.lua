module(..., package.seeall)

function new()
  local me = {}

  function me:load()
    me.background = love.graphics.newImage('resources/sprites/credits.png')
    me.finish = false
  end

  function me:draw()
    love.graphics.draw(me.background, 0, 0, 0, 1, 1, 0, 0)
  end

  function me:update()
  end

  function me:click(x, y)
    me.finish = true
  end

  function me:finished()
    return me.finish
  end

  return me
end