local intro_class = require('intro')
local room_class = require('room')
local outlet_class = require('outlet')
local phone_class = require('phone')
local credits_class = require('credits')
local menu_class = require('menu')

function love.load()
  love.window.setMode(640, 480, {resizable = false})
  love.window.setTitle('Out of Juice')
  menu = menu_class.new()
  menu:load()
  intro = intro_class.new()
  intro:load()
  room = room_class.new()
  room:load()
  outlet = outlet_class.new()
  outlet:load()
  phone = phone_class.new()
  phone:load()
  credits = credits_class.new()
  credits:load()
  state = 'menu'

  breathing = love.audio.newSource('resources/sounds/heavybreathing.wav')
  breathing_started = false
  breathing:setLooping(true)
end

function love.draw()
  if (state == 'menu') then
    menu:draw()
  elseif (state == 'intro') then
    intro:draw()
  elseif (state == 'room') then
    room:draw()
  elseif (state == 'outlet') then
    outlet:draw()
  elseif (state == 'phone') then
    phone:draw()
  elseif (state == 'credits') then
    credits:draw()
  end
end

function love.update(dt)
  if (state == 'menu') then
    menu:update()
  elseif (state == 'intro') then
    intro:update()
  elseif (state == 'room') then
    if (not breathing_started) then
      breathing:play()
      breathing_started = true
    end
    room:update()
  elseif (state == 'outlet') then
    outlet:update()
  elseif (state == 'phone') then
    phone:update()

    if (phone:stopbreathing()) then
      breathing:stop()
    end
  end

  if (menu:finished()) then
    reset_game()
    state = 'intro'
  end

  if (intro:finished()) then
    state = 'room'
  end

  if (room:finished()) then
    state = 'outlet'
  end

  if (outlet:finished()) then
    state = 'phone'
  end

  if (phone:finished()) then
    state = 'credits'
  end

  if (credits:finished()) then
    state = 'menu'
  end
end

function reset_game()
  menu = menu_class.new()
  menu:load()
  intro = intro_class.new()
  intro:load()
  room = room_class.new()
  room:load()
  outlet = outlet_class.new()
  outlet:load()
  phone = phone_class.new()
  phone:load()
  credits = credits_class.new()
  credits:load()
  breathing_started = false
end

function love.mousereleased(x, y, button)
  if button == 1 then
    if (state == 'menu') then
      menu:click(x, y)
    elseif (state == 'intro') then
      intro:click(x, y)
    elseif (state == 'room') then
      room:click(x, y)
    elseif (state == 'phone') then
      phone:click(x, y)
    elseif (state == 'credits') then
      credits:click(x, y)
    end
  end
end

-- maybe for plug pulling, when you click to grab the plug, I should start taking timer readings every half second. And if there's a half second interval where the mouse moved left enough, it will come out. Not otherwise.
-- top plug is lamp, bottom plug is computer
-- plug in phone in a similar manner to unplugging
-- cord -> phone minigame
-- end screen text of 'Ha, fooled you <3'
