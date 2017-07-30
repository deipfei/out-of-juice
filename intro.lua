module(..., package.seeall)

function new()
  local intro_obj = {}

  function intro_obj:load()
    intro_obj.empty = love.graphics.newImage('resources/sprites/emptytexts.png')
    intro_obj.dead = love.graphics.newImage('resources/sprites/deadbattery.png')
    intro_obj.first = love.graphics.newImage('resources/sprites/firsttext.png')
    intro_obj.second = love.graphics.newImage('resources/sprites/secondtext.png')
    intro_obj.third = love.graphics.newImage('resources/sprites/thirdtext.png')

    intro_obj.state = 0
    intro_obj.phone_x = intro_obj:center_x(intro_obj.empty)
    intro_obj.phone_y = 0
    intro_obj.start_time = love.timer.getTime()

    -- sounds
    intro_obj.hmm = love.audio.newSource('resources/sounds/hmm.wav')
    intro_obj.hmm_played = false
    intro_obj.laugh = love.audio.newSource('resources/sounds/laugh.wav')
    intro_obj.laugh_played = false
    intro_obj.oh_yeah = love.audio.newSource('resources/sounds/ohyeah.wav')
    intro_obj.oh_yeah_played = false
    intro_obj.nooo = love.audio.newSource('resources/sounds/nooo.wav')
    intro_obj.nooo_played = false
  end

  function intro_obj:draw()
    if (intro_obj.state == 0) then
      love.graphics.draw(intro_obj.empty, intro_obj.phone_x, intro_obj.phone_y, 0, 1, 1, 0, 0)
    elseif (intro_obj.state == 1) then
      love.graphics.draw(intro_obj.first, intro_obj.phone_x, intro_obj.phone_y, 0, 1, 1, 0, 0)
    elseif (intro_obj.state == 2) then
      love.graphics.draw(intro_obj.second, intro_obj.phone_x, intro_obj.phone_y, 0, 1, 1, 0, 0)
    elseif (intro_obj.state == 3) then
      love.graphics.draw(intro_obj.third, intro_obj.phone_x, intro_obj.phone_y, 0, 1, 1, 0, 0)
    else
      love.graphics.draw(intro_obj.dead, intro_obj.phone_x, intro_obj.phone_y, 0, 1, 1, 0, 0)
    end
  end

  function intro_obj:update()
    if (intro_obj.state == 1) then
      if (not intro_obj.hmm_played) then
        intro_obj.hmm:play()
        intro_obj.hmm_played = true
      end
    elseif (intro_obj.state == 2) then
      if (not intro_obj.laugh_played) then
        intro_obj.laugh:play()
        intro_obj.laugh_played = true
      end
    elseif (intro_obj.state == 3) then
      if (not intro_obj.oh_yeah_played) then
        intro_obj.oh_yeah:play()
        intro_obj.oh_yeah_played = true
      end
    elseif (intro_obj.state == 4) then
      if (not intro_obj.nooo_played) then
        intro_obj.nooo:play()
        intro_obj.nooo_played = true
      end
    end
    if (love.timer.getTime() - intro_obj.start_time > 3) then
      intro_obj.state = intro_obj.state + 1
      intro_obj.start_time = love.timer.getTime()
    end

    if (intro_obj.state > 4) then
      intro_obj.phone_y = intro_obj.phone_y + 4

      if (intro_obj.phone_y > love.graphics.getHeight()) then
        intro_obj.state = -1
      end
    end
  end

  function intro_obj:click(x, y)
    intro_obj.state = intro_obj.state + 1
    intro_obj.start_time = love.timer.getTime()
  end

  function intro_obj:center_x(img)
    return (love.graphics.getWidth() / 2) - (img:getWidth() / 2)
  end

  function intro_obj:finished()
    return intro_obj.state == -1
  end

  return intro_obj
end