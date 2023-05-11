mainScoreTxt = {}
-- scoreColor = {1, 0.5, 0, 1}

function mainScoreTxt.draw(self,scoreColor,scoreSize,scoreCount,score_ty,offsetX,offsetY)
    local TitleFont= love.graphics.setNewFont(scoreSize)
    local offset_X = (love.graphics.getWidth( )/2-TitleFont:getWidth(scoreCount)/2) + offsetX
    local offset_Y = score_ty + offsetY
    love.graphics.print({scoreColor, scoreCount}, offset_X, offset_Y)
end

function mainScoreTxt.update(self, dt)
end