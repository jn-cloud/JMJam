math.randomseed(os.time())

require("mainMenu_bg")
-- require("buttonStart")
require("mainGame")
require('simple-slider')
require('mainScoreTxt')
require('screenAdapt')

release = true
debug = false and not release
full_screen = false or release
page = release and "menu" or "mainGame"

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
           
    if full_screen then
        love.window.setFullscreen(true)
        window_w, window_h = love.graphics.getDimensions()
    else
        love.window.setMode(window_w, window_h)
    end

    world = love.physics.newWorld(0, 0, true)

    loffset_X,loffset_Y = screeanAdapt:load(0.9,0.8)
    poffset_X,poffset_Y = screeanAdapt:load(0.99,0.8)

    -- print(loffset_X,loffset_Y)
    -- print(poffset_X,poffset_Y)
    -- local start_x_p = math.sqrt(3.13)*math.max(w, h)*0.5
    -- local start_y_p = mainMenu_bg.image:getHeight()/2+200
    -- local start_x_l = math.sqrt(3.6)*math.max(w, h)*0.5
    -- local start_y_l = mainMenu_bg.image:getHeight()/2+200

    --load slider control for people count and to set game level
    
    setGameLevelSlider = newSlider(loffset_X,loffset_Y,slider_length, 1, 1, 3,
                            function (v) setLevel = math.floor(v) end) 

    peopleCountSlider = newSlider(poffset_X,poffset_Y,slider_length, 3000, 3000, 10,
                            function (v) people_count = math.floor(v) end)

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
        mainMenu_bg:draw()
        -- mainMenu_bg:draw(screen_offset_x, screen_offset_y,1600,850)
        --draw people count label
        peopleCountSlider:draw()
        --draw game level label
        setGameLevelSlider:draw()
        mainScoreTxt:draw(volumecolor,15,"Game Level",0.83,1.1)
        mainScoreTxt:draw(volumecolor,15,math.floor(setLevel),0.89,0.5)
        --draw text
        mainScoreTxt:draw(volumecolor,15,"People Count",0.96,1.1)
        mainScoreTxt:draw(volumecolor,15,math.floor(people_count),0.96,0.5)
                
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
