-----------------------------------------------------------------------------------------
--
-- environment.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local mainGroup = display.newGroup()
local playerGroup = display.newGroup()
local backGroup = display.newGroup()

local block, blockTop, blockEndTop, blockStartTop, blockStart, blockEnd, blockBottomEnd, blockBottomEndEdge, blockBottomStart, blockBottomStartEdge, movingBlock, 
    background, stone



M.setEnvironment = function( number )
    if (number == 1) then 
        background = "BG.png"
        block = "5.png"
        blockTop = "2.png"
        blockEndTop = "3.png"
        blockStartTop = "1.png"
        blockStart = "4.png"
        blockEnd = "6.png"
        blockBottomEnd = "7.png"
        blockBottomEndEdge = "8.png"
        blockBottomStart = "11.png"
        blockBottomStartEdge = "10.png"
        movingBlock = "19.png"
        stone = "Stone.png"
    elseif (number == 2) then
        background = "BG_desert.png"
        block = "5_desert.png"
        blockTop = "2_desert.png"
        blockEndTop = "3_desert.png"
        blockStartTop = "1_desert.png"
        blockStart = "4_desert.png"
        blockEnd = "6_desert.png"
        blockBottomEnd = "7_desert.png"
        blockBottomEndEdge = "8_desert.png"
        blockBottomStart = "11_desert.png"
        blockBottomStartEdge = "10_desert.png"
        movingBlock = "19_desert.png"
        stone = "Stone_Desert.png"
    end
end

M.getStone = function()
    return stone
end

M.getBackground = function()
    return background
end

M.getBlock = function()
    return block
end

M.getBlockTop = function()
    return blockTop
end

M.getBlockEndTop = function()
    return blockEndTop
end

M.getBlockStartTop = function()
    return blockStartTop
end

M.getBlockStart = function()
    return blockStart
end

M.getBlockEnd = function()
    return blockEnd
end

M.getBlockBottomEnd = function()
    return blockBottomEnd
end

M.getBlockBottomEndEdge = function()
    return blockBottomEndEdge
end

M.getBlockBottomStart = function()
    return blockBottomStart
end

M.getBlockBottomStartEdge = function()
    return blockBottomStartEdge
end

M.getMovingBlock = function()
    return movingBlock
end


return M