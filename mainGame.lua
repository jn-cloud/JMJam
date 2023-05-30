require("bg")
require("body")
require("evil")
require("burn")
require("path")
require("math_utils")
require("sprites")
require("mainScoreTxt")
require('simple-slider')

-- window_w = 1920
-- window_h = 1080
window_w = 1920
window_h = 1080

setLevel = setLevel
-- levelImg = levelImg

speed = speed
people_count = people_count
people_radius = people_radius
hero_speed = hero_speed
hero_speed_lava = hero_speed_lava
cool_set = cool_set
heat_death = heat_death


-- Screen offset
screen_offset_x = 0
screen_offset_y = 0

mainScoreTxt_x = 300
mainScoreTxt_y = 800
mainScoreTxt_sx = 600
mainScoreTxt_sy = 600
mainScoreTxt_color = {1.0, 0.5, 0, 1}

totalPeople_color = {1.0, 0.9, 0.9, 1}
savedPeople_color = {0.0, 0.0, 1.0, 1}
deadPeople_color = {1.0, 0.2, 0.2, 1}

volumecolor = {1.0, 1.0, 1.0, 1}
slider_length = 200



isDown = love.keyboard.isDown

scoreTextSize = 75

mainGame = {}

function mainGame.load()
    bg:load()
    evil:load()
    burn:load()
    love.physics.setMeter(32)
    
    shaman_sprites = load_sprites("shamanSheet_01.png")
    peon_sprites = load_sprites("peonPossessedSheet_01.png")
    peon_idle_sprites = load_sprites("peonIdleSheet_01.png")
    game_over_image = love.graphics.newImage("gameOver.png")
    youWin_image = love.graphics.newImage("youWin.png")
    vignette = love.graphics.newImage("vignette.png")

    music = love.audio.newSource( "A1-0001_testZic01.mp3", "stream" )
    gogogo = love.audio.newSource( "goGoGo.mp3", "stream" )
    youLoose = love.audio.newSource( "youLoose.mp3", "stream" )
    youWin = love.audio.newSource( "youWin.mp3", "stream" )
end

function mainGame.restart(self)
    love.audio.play( music )
    gogogo:play()
    --create a new slider
    -- volumeSlider = newSlider(window_w-100, window_h-200, slider_length, 0.5, 0, 1, function (v) love.audio.setVolume(v) end)
    score_saved = 0
    world = love.physics.newWorld(0, 0, true)
    evil:restart()
    local start_x = math.sqrt(2)*math.max(window_w, window_h)*0.5
    local start_y = bg.ground:getHeight()/2+200
    hero = body(start_x, start_y, "static", people_radius, "fill", shaman_sprites, shaman_sprites, true)
    hero.path = Path:new()
    hero.path:addPoint(start_x, start_y)

    people = {}
    for i=1,people_count do
        local x, y = 0, 0
        repeat
            x = math.random(0, bg.ground:getWidth())
            y = math.random(0, bg.ground:getHeight())
        until not bg:isLava(x, y)
        local p = body(x, y, "dynamic", people_radius, "line", peon_sprites, peon_idle_sprites, false)
        people[p] = true
    end
    game_over_time = nil
    game_over = false
end

function mainGame.testRestart(self)
    if game_over then
        self:restart()
    end
end

function mainGame.keypressed(self, key, scancode, isrepeat )
    self:testRestart()
end

function mainGame.draw()
    bg:draw(screen_offset_x, screen_offset_y)
    hero:draw()
    if debug then hero.path:draw() end
    for p,k in pairs(people) do
        p:draw()
    end
    -- volumeSlider:draw()
    burn:draw()
    evil:draw(screen_offset_x, screen_offset_y)
    bg:draw_overlay(screen_offset_x, screen_offset_y)
    --draw volume label
    -- mainScoreTxt:draw(volumecolor,35,"Volume",800,650,0)

    --draw total people count label
    mainScoreTxt:draw(totalPeople_color,30,"Total People Count",100,600,0)
    mainScoreTxt:draw(totalPeople_color,30,people_count,135,600,0)
    --draw chossen level stats
    mainScoreTxt:draw(totalPeople_color,30,"Game Level",25,600,0)
    mainScoreTxt:draw(totalPeople_color,30,setLevel,65,600,0)

    -- debug draw
    -- mainScoreTxt:draw(totalPeople_color,30,people_radius,200,675,0)
    -- mainScoreTxt:draw(totalPeople_color,30,hero_speed_lava,250,675,0)
    -- mainScoreTxt:draw(totalPeople_color,30,cool_set,300,675,0)

    if not hero.alive then        
        local fade_time = 5
        local wait_time = 2
        local time = love.timer.getTime()
        if not game_over_time then
            game_over_time = time
        end
        if time > game_over_time+wait_time then
            if not game_over then
                music:stop()
                if hero.saved then 
                    youWin:play()
                else
                    youLoose:play()
                end
            end
            game_over = true
            alpha = math.max(0, (time - wait_time - game_over_time) / fade_time)
            love.graphics.setColor(0,0,0,alpha)
            love.graphics.rectangle("fill", 0, 0, window_w, window_h)
            love.graphics.setColor(1,1,1,1)
            local scale = math.min(window_w / game_over_image:getWidth(), window_h / game_over_image:getHeight())
            local x = (window_w-game_over_image:getWidth()*scale)/2
            local y = (window_h-game_over_image:getHeight()*scale)/2

            if hero.saved then
                totalSaved = score_saved
                love.graphics.draw(youWin_image, x, y, 0, scale)

                --draw total people count label
                mainScoreTxt:draw(totalPeople_color,30,"Total People Count",450,0,0)
                --draw total people count 
                mainScoreTxt:draw(totalPeople_color,30,people_count,500,0,0)

                --draw total people count label
                mainScoreTxt:draw(deadPeople_color,40,"Dead People Count",550,0,0)
                mainScoreTxt:draw(deadPeople_color,45,people_count-score_saved,600,0,0)

                --draw saved people count    
                mainScoreTxt:draw(mainScoreTxt_color,55,"Your Score - You Saved",675,0,0)
                mainScoreTxt:draw(mainScoreTxt_color,75,score_saved,750,0,0)


            else
                love.graphics.draw(game_over_image, x, y, 0, scale)
            end
        end
    end

    local scale = math.min(window_w / vignette:getWidth(), window_h / vignette:getHeight())
    local x = (window_w-game_over_image:getWidth()*scale)/2
    local y = (window_h-game_over_image:getHeight()*scale)/2
    love.graphics.draw(vignette, x, y, 0, scale)
end

function mainGame.update(dt)
    world:update(dt)
    evil:update(dt)
    bg:update(dt)
    burn:update(dt)
    -- volumeSlider:update()
    hero_x, hero_y = hero:getPosition()

    walk = false

    local hero_dir_x = 0
    local hero_dir_y = 0

    function move_hero(x, y)
        hero_dir_x = hero_dir_x+x
        hero_dir_y = hero_dir_y+y
        walk = true
    end

    if hero.alive then
        if isDown("right") then
            move_hero(1, 0)
        end
        if isDown("left") then
            move_hero(-1, 0)
        end
        if isDown("up") then
            move_hero(0, -1)
        end
        if isDown("down") then
            move_hero(0, 1)
        end
    end

    local speed = bg:isLava(hero_x, hero_y) and hero_speed_lava or hero_speed
    hero_dir_x, hero_dir_y = normalize(hero_dir_x, hero_dir_y)
    hero_dir_x, hero_dir_y = mul(hero_dir_x, hero_dir_y, speed*dt, speed*dt)

    -- Update the hero position
    local diameter = hero.shape:getRadius()*2
    hero_x = clamp(hero_x+hero_dir_x, 0, bg.ground:getWidth()-diameter)
    hero_y = clamp(hero_y+hero_dir_y, 0, bg.ground:getHeight()-diameter)
    hero_x = hero_x+hero_dir_x
    hero_y = hero_y+hero_dir_y
    hero:setPosition(hero_x, hero_y)
    if walk then
        hero:walk()
    end
    hero:setAngle(angleFromDir(hero_dir_x, hero_dir_y))

    -- Update the view position
    sx, sy = worldToScreen(hero_x, hero_y)
    screen_offset_x = screen_offset_x + sx - window_w/2
    screen_offset_y = screen_offset_y + sy - window_h/2

    function clampScreen(x, y)
        local wx, wy = screenToWorld(x, y)
        if wx < 0 then
            wx = 0
        end
        if wy < 0 then
            wy = 0
        end
        if wx > bg.ground:getWidth() then
            wx = bg.ground:getWidth()
        end
        if wy > bg.ground:getHeight() then
            wy = bg.ground:getHeight()
        end
        local sx, sy = worldToScreen(wx, wy)
        screen_offset_x = screen_offset_x + sx - x
        screen_offset_y = screen_offset_y + sy - y
    end
    clampScreen(0, 0)
    clampScreen(window_w, 0)
    clampScreen(window_w, window_h)
    clampScreen(0, window_h)

    hero:update(dt)
    local lpx, lpy = hero.path:lastPoint()
    if distance(hero_x, hero_y, lpx, lpy) > 100 then
        hero.path:addPoint(hero_x, hero_y)
    end

    for p,v in pairs(people) do
        p:walk()
        p:update(dt)
        p:followPath(hero.path)
        p:updateAcceleration()
    end
end

