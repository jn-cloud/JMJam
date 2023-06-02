mainMenu_bg = {}
menuTxtColor = {1, .75, 0, 1}

function mainMenu_bg.load(self)
    mainMenu_bg.image = love.graphics.newImage("title.png")
end
    
--[[ function mainMenu_bg.draw(self,mainMenu_x,mainMenu_y,mainMenu_newWidth,mainMenu_newHeight)
-- function mainMenu_bg.draw(self,mainMenu_x,mainMenu_y)
    currentWidth, currentHeight = self.image:getDimensions()
    newW = mainMenu_newWidth / currentWidth
    newH = mainMenu_newHeight / currentHeight
    r = 0
    love.graphics.draw(self.image, mainMenu_x, mainMenu_y, r, newW, newH)
    -- love.graphics.draw(self.image, 0, 0, r)
end ]]

function mainMenu_bg.draw(self)
        r = 0
        w,h = love.graphics.getDimensions()
        bw = self.image:getWidth()
        bh = self.image:getHeight()
        if bw/bh > w/h then
            scale = w/bw
            x = w/2 - bw/2 * scale
            y = h/2 - bh/2 * scale
        else
            scale = h/bh
            x = w/2 - bw/2 * scale
            y = h/2 - bh/2 * scale
        end
         
        love.graphics.draw(self.image,x,y,r,scale,scale)
  
end

