-----------------------------------------------------------------------------------------
--
-- interface.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local game
local creator
local record
local collisionHandler
local fileHandler
local level
local elements = {}
local builder 
local mainGroup = display.newGroup()
local composer = require("composer")
local selectorPosition

M.setUp = function(g,c,b,cH,fH)
    game, creator, builder = g, c, b
    M.setCollisionHandler(cH)
    M.setFileHandler(fH)
end

M.setCollisionHandler = function(cH)
    collisionHandler = cH
    level = collisionHandler.getLevel()
end

M.setFileHandler = function(fH)
    fileHandler = fH
    M.setRecord(level)
end

M.setRecord= function()
    record = fileHandler.getRecord(level)
    if (record == nil) then record = 0 end
end

M.screen = function()
    selectorPosition = 0
    game.setGame(false)
    game.setPressed(false)

    local score = collisionHandler.getScore()

    if (level ~= 0) then
        if (record <= score) then 
            record = score
            fileHandler.writeRecord(record)
        end
    else
        fileHandler.generateFiles()
    end

    local win = display.newImageRect(mainGroup, "Window.png", 550, 400)
    win.x = display.contentWidth-display.actualContentWidth*0.5
    win.y = display.contentCenterY
    table.insert( elements, win)
    
    local scoreText = display.newImageRect(mainGroup, "Score.png", 130, 20)
    scoreText.x = display.contentWidth-display.actualContentWidth*0.5 - 150
    scoreText.y = display.contentCenterY - 90
    table.insert( elements, scoreText)

    local table1 = display.newImageRect(mainGroup, "Table.png", 220, 60)
    table1.x = display.contentWidth-display.actualContentWidth*0.5 + 65
    table1.y = display.contentCenterY - 88
    table.insert( elements, table1)

    local scoreValue = display.newText(mainGroup, score, display.contentWidth-display.actualContentWidth*0.5+ 65, display.contentCenterY - 92, "ethnocentric rg.ttf", 30)
    scoreValue:setTextColor( 0.9, 0.9, 0.9 )
    table.insert( elements, scoreValue)

    local recordText = display.newImageRect(mainGroup, "Record.png", 130, 20)
    recordText.x = display.contentWidth-display.actualContentWidth*0.5 - 150
    recordText.y = display.contentCenterY
    table.insert( elements, recordText)

    local table2 = display.newImageRect(mainGroup, "Table.png", 220, 60)
    table2.x = display.contentWidth-display.actualContentWidth*0.5 + 65
    table2.y = display.contentCenterY + 2
    table.insert( elements, table2)

    local recordValue = display.newText(mainGroup, record, display.contentWidth-display.actualContentWidth*0.5 + 65, display.contentCenterY - 2, "ethnocentric rg.ttf", 30)
    recordValue:setTextColor( 0.9, 0.9, 0.9 )
    table.insert( elements, recordValue)

    local closeBtn = display.newImageRect(mainGroup, "Close_BTN.png", 100, 100)
    closeBtn.x = display.contentWidth-display.actualContentWidth*0.5 - 140
    closeBtn.y = display.contentCenterY + 120
    closeBtn.fill.effect = "filter.brightness"
    closeBtn.fill.effect.intensity = 0.4
    table.insert( elements, closeBtn)

    local replayBtn = display.newImageRect(mainGroup, "Replay_BTN.png", 100, 100)
    replayBtn.x = display.contentWidth-display.actualContentWidth*0.5
    replayBtn.y = display.contentCenterY + 120
    table.insert( elements, replayBtn)
    
    return closeBtn, replayBtn
end

local nextLevel = function()
    timer.cancelAll()
    level = level + 1

    M.setRecord()

    for i in ipairs(elements) do 
        display.remove(elements[i])
    end

    composer.removeScene( "level", true )
    if (level > 10) then 
        composer.gotoScene("ending") 
        composer.removeScene("level", true)
    else
        composer.setVariable("lvl", level)
        composer.gotoScene("level")
    end
    audio.play(clickSound)
end

M.winScreen = function()
    local closeBtn, replayBtn = M.screen()

    if (fileHandler.getCurrentLevel() == composer.getVariable("lvl")) then 
        fileHandler.updateCurrentLevel()
    end

    local text = level == 0 and "Tutorial finished" or "Level "..level.." finished"
    local finished = display.newText(mainGroup, text, display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY - 170, "ethnocentric rg.ttf", 35)
    finished:setTextColor( 0.9, 0.9, 0.9 )
    table.insert( elements, finished)

    local continueBtn = display.newImageRect(mainGroup, "Play_BTN.png", 100, 100)
    continueBtn.x = display.contentWidth-display.actualContentWidth*0.5 + 140
    continueBtn.y = display.contentCenterY + 120
    table.insert( elements, continueBtn)

    local function onKeyEvent( event )
        if (event.phase == "down") then
            if (event.keyName == "right") then
                if (selectorPosition < 2) then
                    selectorPosition = selectorPosition + 1
                end
            elseif (event.keyName == "left") then
                if (selectorPosition > 0) then
                    selectorPosition = selectorPosition - 1
                end
            elseif (event.keyName == "center") then
                if (selectorPosition == 0) then
                    timer.cancelAll()
                    composer.gotoScene("map")

                    for i in ipairs(elements) do 
                        display.remove(elements[i])
                    end
            
                    composer.removeScene( "level", true )
                    
                    audio.stop(31)
                    audio.play(clickSound)
                elseif (selectorPosition == 1) then
                    game.setCanJump(false)
                    audio.stop(31)
                    game.destroyBlocks()
                    creator.destroyBlocks()
                    collisionHandler.destroyParticles()

                    timer.cancelAll()
                
                    for i in ipairs(elements) do 
                        display.remove(elements[i])
                    end

                    collisionHandler.setBlocksContacted(0)
                    collisionHandler.setScore(0)

                    game.setBlocks(creator.getBlocksArray())

                    game.setGame(true)

                    composer.removeScene("level",true)
                    composer.gotoScene("level")
                    audio.play(clickSound)
                else 
                    nextLevel()
                end
                Runtime:removeEventListener( "key", onKeyEvent )
            end
        end
        if (selectorPosition == 0) then
            closeBtn.fill.effect = "filter.brightness"
            closeBtn.fill.effect.intensity = 0.4
            replayBtn.fill.effect = "filter.brightness"
            replayBtn.fill.effect.intensity = 0
            continueBtn.fill.effect = "filter.brightness"
            continueBtn.fill.effect.intensity = 0
        elseif (selectorPosition == 1) then
            replayBtn.fill.effect = "filter.brightness"
            replayBtn.fill.effect.intensity = 0.4
            closeBtn.fill.effect = "filter.brightness"
            closeBtn.fill.effect.intensity = 0
            continueBtn.fill.effect = "filter.brightness"
            continueBtn.fill.effect.intensity = 0
        else 
            continueBtn.fill.effect = "filter.brightness"
            continueBtn.fill.effect.intensity = 0.4
            closeBtn.fill.effect = "filter.brightness"
            closeBtn.fill.effect.intensity = 0
            replayBtn.fill.effect = "filter.brightness"
            replayBtn.fill.effect.intensity = 0
        end
    end
    Runtime:addEventListener("key", onKeyEvent)
end

M.deathScreen = function()
    local closeBtn, replayBtn = M.screen()

    local youLose = display.newImageRect(mainGroup, "Header.png", 235, 25)
    youLose.x = display.contentWidth-display.actualContentWidth*0.5
    youLose.y = display.contentCenterY - 170
    table.insert( elements, youLose)

    local continueBtn = display.newImageRect(mainGroup, "InactivePlay_BTN.png", 100, 100)
    continueBtn.x = display.contentWidth-display.actualContentWidth*0.5 + 140
    continueBtn.y = display.contentCenterY + 120
    table.insert( elements, continueBtn)

    local function onKeyEvent( event )
        if (event.phase == "down") then
            if (event.keyName == "right") then
                if (selectorPosition == 0) then
                    selectorPosition = selectorPosition + 1
                end
            elseif (event.keyName == "left") then
                if (selectorPosition == 1) then
                    selectorPosition = selectorPosition - 1
                end
            elseif (event.keyName == "center") then
                if (selectorPosition == 0) then
                    timer.cancelAll()
                    composer.gotoScene("map")

                    for i in ipairs(elements) do 
                        display.remove(elements[i])
                    end
            
                    composer.removeScene( "level", true )
                    
                    audio.stop(31)
                    audio.play(clickSound)
                else 
                    game.setCanJump(false)
                    audio.stop(31)
                    game.destroyBlocks()
                    creator.destroyBlocks()
                    collisionHandler.destroyParticles()

                    timer.cancelAll()
                
                    for i in ipairs(elements) do 
                        display.remove(elements[i])
                    end

                    collisionHandler.setBlocksContacted(0)
                    collisionHandler.setScore(0)

                    game.setBlocks(creator.getBlocksArray())

                    game.setGame(true)

                    composer.removeScene("level",true)
                    composer.gotoScene("level")
                    audio.play(clickSound)
                end
                Runtime:removeEventListener( "key", onKeyEvent )
            end
        end
        if (selectorPosition == 0) then
            closeBtn.fill.effect = "filter.brightness"
            closeBtn.fill.effect.intensity = 0.4
            replayBtn.fill.effect = "filter.brightness"
            replayBtn.fill.effect.intensity = 0
        elseif (selectorPosition == 1) then
            replayBtn.fill.effect = "filter.brightness"
            replayBtn.fill.effect.intensity = 0.4
            closeBtn.fill.effect = "filter.brightness"
            closeBtn.fill.effect.intensity = 0
        end
    end
    Runtime:addEventListener("key", onKeyEvent)
end

M.deleteMainGroup = function()
    mainGroup:removeSelf()
    mainGroup = nil
end

M.getMainGroup = function()
    return mainGroup
end

return M