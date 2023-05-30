math.randomseed(os.time())

require("mainMenu_bg")
-- require("buttonStart")
require("mainGame")
require('simple-slider')
require('mainScoreTxt')

release = true
debug = false and not release
full_screen = false or release
page = release and "menu" or "mainGame"
-- window_w = 3840
-- window_h = 2160
window_w = 1920
window_h = 1080

-- world coordinate of the upper left corner
screen_offset_x = 0
screen_offset_y = 0

slider_length = 200

-- mainMenu_newWidth = 2
-- mainMenu_newHeight = 2

isDown = love.keyboard.isDown
loadVal = 0
-- sButton  = {
--     image  = buttonStart.image,
--     x      = startButton_x,
--     y      = startButton_y,
--     width  = scaleButton_X,
--     height = scaleButton_Y,
-- }


function love.load()
    mainMenu_bg:load()
    mainGame:load()

    --load slider control for people count and to set game level
    peopleCountSlider = newSlider((love.graphics.getWidth( )/2-slider_length/2)+1160,(love.graphics.getHeight( )+100),
    slider_length, 3000, 3000, 10, function (v) people_count = math.floor(v) end)

    setGameLevelSlider = newSlider((love.graphics.getWidth( )/2-slider_length/2)+1060,(love.graphics.getHeight( )+100),
    slider_length, 1, 1, 3, function (v) setLevel = math.floor(v) end)  
              
    if full_screen then
        love.window.setFullscreen(true)
        window_w, window_h = love.graphics.getDimensions()
    else
        love.window.setMode(window_w, window_h)
    end
    world = love.physics.newWorld(0, 0, true)
end

function love.keypressed(key)
    if page == "menu" then
        if key == "return" then
            page = "mainGame"
            mainGame:restart()
        end
    else
        mainGame:keypressed(key, scancode, isrepeat)
    end
end

function love.draw()
    if page == "menu" then
        -- mainMenu_bg:draw()
        mainMenu_bg:draw(screen_offset_x, screen_offset_y,1600,850)
        --draw people count label
        peopleCountSlider:draw()
        mainScoreTxt:draw(volumecolor,15,"People Count",love.graphics.getHeight( ),700,-45)
        mainScoreTxt:draw(volumecolor,15,math.floor(people_count),love.graphics.getHeight( ),690,-300)
        --draw game level label
        setGameLevelSlider:draw()
        mainScoreTxt:draw(volumecolor,15,"Game Level",love.graphics.getHeight( ),590,-45)
        mainScoreTxt:draw(volumecolor,15,math.floor(setLevel),love.graphics.getHeight( ),590,-300)
                
    else
        mainGame:draw()
    end
end

function love.update(dt)
    if page == "mainGame" then
        mainGame.update(dt)
    else
        peopleCountSlider:update()
        setGameLevelSlider:update()
        if setLevel == 1 then
            people_radius = 8
            hero_speed_lava = 1100
            hero_speed = 400
            speed = 800
            evil.speed = 100
            heat_death = 4
            cool_set = 2.5
        end

        if setLevel == 2 then
            people_radius = 11
            hero_speed_lava = 500
            hero_speed = 500
            speed = 500
            evil.speed = 350
            heat_death = 1.5
            cool_set = 0.6
        end

        if setLevel == 3 then
            people_radius = 15
            hero_speed_lava = 200
            hero_speed = 400
            speed = 400
            evil.speed = 650
            heat_death = 0.5
            cool_set = 0.1
        end
    end
end
