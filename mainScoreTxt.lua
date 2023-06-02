mainScoreTxt = {}
-- scoreColor = {1, 0.5, 0, 1}

function mainScoreTxt.draw(self,scoreColor,scoreSize,scoreCount,offsetX,offsetY)
    local TitleFont= love.graphics.setNewFont(scoreSize)
    local offset_X = (love.graphics.getWidth( )/2-TitleFont:getWidth(scoreCount)/2) + offsetX
    -- local offset_Y = score_ty + offsetY

    w,h = love.window.getDesktopDimensions()
 
    bw = mainMenu_bg.image:getWidth()
    bh = mainMenu_bg.image:getHeight()
     
    if bw/bh > w/h then
        scale = w/bw
        x = w/2 - bw/2 * scale
        y = h/2 - bh/2 * scale
    else
        scale = h/bh
        x = w/2 - bw/2 * scale
        y = h/2 - bh/2 * scale
    end

    local loffsetX = w/2 * offsetX
    local loffsetY = h/2 * offsetY
    local loffset_X = (window_w/2) - (slider_length/2) + loffsetX
    local loffset_Y = (window_h/2) - (slider_length/2) + loffsetY

    loffset_X = x + loffset_X
    loffset_Y = y + loffset_Y

    love.graphics.print({scoreColor, scoreCount}, loffset_X, loffset_Y)
end

function mainScoreTxt.update(self, dt)
end