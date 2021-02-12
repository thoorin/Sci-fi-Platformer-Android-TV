local composer = require( "composer" )
local fileHandler = require( "fileHandler" )

local scene = composer.newScene()

local selector

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local creator = require("creator")

function getSceneGroup()
        return sceneGroup
end

local ar = {}
local maxRecords = {0,200,650,1025,1275,300,650,850,1500,2475}

local selectedLevel = 1

local indentOFElement = display.actualContentWidth/5.45
local elementOriginX = display.actualContentWidth/8.67

local indentOFElementEnv0 = display.actualContentWidth/3.8
local elementOriginXEnv0 = display.actualContentWidth*0.38

local arrowY = display.actualContentHeight*0.1+5
local leftArrowX = display.screenOriginX + display.actualContentWidth*0.14
local rightArrowX = display.screenOriginX + display.actualContentWidth*0.84

local wrongSound = audio.loadSound( "wrong.mp3" )

local selectorY = 240

local selectorPosition = "low"

local background

local function cleanMap()
        for i in ipairs(ar) do
                display.remove(ar[i])
        end
        ar = {}
end

function createMap( environment, selectorPosition )
        cleanMap()
        local curLevel = fileHandler.getCurrentLevel()

        print(selectedLevel)
        print("environment "..environment)

        local arrow
        local j

        local planet = display.newEmbossedText(sceneGroup,"",display.screenOriginX + display.actualContentWidth*0.5,50,"PermanentMarker-Regular.ttf",50)
        local color = 
        {
                highlight = { r=0, g=0, b=0 },
                shadow = { r=0, g=0, b=0 }
        }
        planet:setFillColor(0.2,0.8,0.2)
        planet:setEmbossColor( color )
        planet.anchorX = 0.5

        local numberOfElements

        if (environment == 0) then
                planet.text = "Miscellaneous"
                planet:setFillColor(0,0,0.8)
                planet:setEmbossColor( color )

                arrow = creator.createArrowRight(rightArrowX,arrowY) 
                background.fill.effect = "generator.radialGradient"
 
                background.fill.effect.color1 = { 1, 0.5, 1, 1 }
                background.fill.effect.color2 = { 0.5, 0, 0.5, 1 }
                background.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.25, 0.75 }
                background.fill.effect.aspectRatio  = 1
                j = 1

                numberOfElements = 2
        elseif (environment == 1) then
                planet.text = "Grass Planet"
                arrow = creator.createArrowRight(rightArrowX,arrowY) 
                arrow2 = creator.createArrowLeft(leftArrowX,arrowY) 
                background.fill.effect = "generator.radialGradient"
 
                background.fill.effect.color1 = { 0.5, 0.5, 1, 1 }
                background.fill.effect.color2 = { 0.2, 0.2, 0.8, 1 }
                background.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.25, 0.75 }
                background.fill.effect.aspectRatio  = 1
                j = 1

                table.insert(ar,arrow2)

                numberOfElements = 5
        else 
                planet.text = "Desert Planet"
                planet:setFillColor(1,1,0.4)
                planet:setEmbossColor( color )

                arrow = creator.createArrowLeft(leftArrowX,arrowY) 
                background.fill.effect = "generator.radialGradient"
 
                background.fill.effect.color1 = { 1, 0.5, 0, 1 }
                background.fill.effect.color2 = { 0.6, 0.2, 0, 1 }
                background.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.25, 0.75 }
                background.fill.effect.aspectRatio  = 1
                j = 6

                numberOfElements = 5
        end
        table.insert(ar,arrow)

        selector = display.newRect(sceneGroup, display.screenOriginX + indentOFElement*(selectorPosition-1) + elementOriginX, selectorY, 150, 250)
        selector.strokeWidth = 3
        selector:setStrokeColor( 1, 1, 1 )
        selector:setFillColor( 0, 0, 0, 0 )
        table.insert(ar,selector)
        if (environment == 0) then
                selector.x = selector.x - 23
        end

        for i=0,numberOfElements-1 do
                local elementX = display.screenOriginX + elementOriginX + i * indentOFElement
                local recordX = elementX+5
                local levelName
                if (environment == 0) then
                        if (i == 0) then
                                levelName = "Tutorial"
                        else 
                                levelName = "Credits"
                        end
                else
                        levelName = "Level "..i+j
                end
                local levelTitle = display.newText(sceneGroup, levelName, elementX, display.actualContentHeight*0.5-100, "ethnocentric rg.ttf", 20)
                local recordInPercentage 
                local percentage 
                local recordY = display.actualContentHeight*0.5+100
                local tree
                local treeY = display.actualContentHeight*0.5
                local playedColor = environment == 1 and { 0.1,1,0.1 } or { 1,1,0 }
                local availableColor = environment == 1 and { 0.6, 1, 0.6 } or { 1,1,0.6 }
                local state

                if (curLevel > j+i) then
                        if (maxRecords[i+j] == 0) then percentage = 100 else
                                percentage = (fileHandler.getRecord(i+j)/maxRecords[i+j])*100
                        end
                        recordInPercentage = display.newText(sceneGroup, math.round(percentage).." %", recordX, recordY, native.systemFontBold, 20, "right")
                        levelTitle:setTextColor( unpack(playedColor) )
                        state = "played"
                elseif (curLevel == j+i) then

                        if (fileHandler.getRecord(curLevel)==nil) then
                                recordInPercentage = display.newText(sceneGroup, "0 %", recordX, recordY, native.systemFontBold, 20)
                                levelTitle:setTextColor( unpack(availableColor))
                                state = "current"
                        else 
                                if (maxRecords[i+j] == 0) then percentage = 0 else percentage = (fileHandler.getRecord(i+j)/maxRecords[i+j])*100 end
                                recordInPercentage = display.newText(sceneGroup, math.round(percentage).." %", recordX, recordY, native.systemFontBold, 20)
                                levelTitle:setTextColor( unpack(playedColor) )
                                state = "played"
                        end
                else
                        recordInPercentage = display.newText(sceneGroup, "0 %", recordX, recordY, native.systemFontBold, 20)
                        levelTitle:setTextColor( 0.9, 0.9, 0.9 )
                        state = "closed"
                end

                if (environment == 0) then
                        recordInPercentage.text = ""
                        levelTitle:setTextColor( 0,0,1 )
                        elementX = display.screenOriginX + elementOriginXEnv0 + i * indentOFElementEnv0
                        levelTitle.x = elementX
                        if (i == 0) then
                                state = "tutorial"
                        end
                end

                tree = creator.createMapElement(elementX, treeY, state)
                table.insert(tree,i+j)

                table.insert(ar,tree)
                table.insert(ar,recordInPercentage)
                table.insert(ar,levelTitle)

                if display.screenOriginX + display.actualContentWidth/8.67 > 420 then
                        tree:scale(0.8,0.8)
                        levelTitle:scale(0.8,0.8)
                        recordInPercentage:scale(0.8,0.8)
                end
        end
        table.insert(ar,planet)
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    
    -- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup = self.view

    background = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1500,500)

    background.fill.effect = "generator.radialGradient"
 
    background.fill.effect.color1 = { 0.5, 0.5, 1, 1 }
    background.fill.effect.color2 = { 0.2, 0.2, 0.8, 1 }
    background.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.25, 0.75 }
    background.fill.effect.aspectRatio  = 1

    composer.setVariable("env",1)

    createMap(1,1)
end


-- show()
function scene:show( event )
    

	local phase = event.phase

        if ( phase == "will" ) then

                local function onKeyEvent( event )
                        if (event.phase == "down") then
                                if (event.keyName == "left" or event.keyName == "right") then
                                        if (selectorPosition == "low") then
                                                local indent = indentOFElement

                                                local levelChange = 1

                                                if (event.keyName == "left") then
                                                        levelChange = -levelChange
                                                end

                                                if ((selectedLevel ~= 10 or levelChange == -1) and (selectedLevel ~=-1 or levelChange == 1)) then
                                                        if (selectedLevel == 1 and levelChange == -1) then
                                                                composer.setVariable("env",0)
                                                                createMap(0,4)
                                                                indent = 0
                                                        elseif (selectedLevel == 5 and levelChange == 1) then
                                                                composer.setVariable("env",2)
                                                                createMap(2,1)
                                                                indent = 0
                                                        elseif (selectedLevel == 6 and levelChange == -1) then
                                                                composer.setVariable("env",1)
                                                                createMap(1,5)
                                                                indent = 0
                                                        elseif (selectedLevel == 0 and levelChange == 1) then
                                                                composer.setVariable("env",1)
                                                                createMap(1,1)
                                                                indent = 0
                                                        elseif (selectedLevel <=0 )then
                                                                indent = indentOFElementEnv0
                                                        end
                                                        selectedLevel = selectedLevel + levelChange
                                                        selector.x = selector.x + indent*levelChange
                                                end
                                        else
                                                if (event.keyName == "right" and selectedLevel < 6) then
                                                        selector.x = rightArrowX
                                                elseif (selectedLevel > 0) then
                                                        selector.x = leftArrowX
                                                end
                                        end
                                elseif (event.keyName == "up") then
                                        selector.y = arrowY
                                        selector.x = selectedLevel <=0 and rightArrowX or leftArrowX
                                        selector.height = 70
                                        selector.width = 70
                                        selectorPosition = "high"
                                elseif (event.keyName == "down") then
                                        selector.height = 250
                                        selector.width = 150
                                        selector.x = selectedLevel <= 0 and display.screenOriginX + indentOFElement*3 + elementOriginX - 23 or display.screenOriginX + elementOriginX
                                        selector.y = selectorY
                                        if (selectedLevel <= 0) then
                                                selectedLevel = 0
                                        elseif (selectedLevel < 6) then
                                                selectedLevel = 1
                                        else
                                                selectedLevel = 6
                                        end
                                        selectorPosition = "low"
                                elseif (event.keyName == "enter") then
                                        if (selectorPosition == "high") then
                                                if (selector.x < 500) then
                                                        if (selectedLevel > 5) then
                                                                composer.setVariable("env",1)
                                                                createMap(1,1)
                                                                selectedLevel = 1
                                                        else
                                                                composer.setVariable("env",0)
                                                                createMap(0,4)
                                                                selectedLevel = 0
                                                        end
                                                else 
                                                        if (selectedLevel < 1) then
                                                                composer.setVariable("env",1)
                                                                createMap(1,1)
                                                                selectedLevel = 1
                                                        else
                                                                composer.setVariable("env",2)
                                                                createMap(2,1)
                                                                selectedLevel = 6
                                                        end
                                                end
                                                selectorPosition = "low"
                                        else
                                                if (selectedLevel == 0) then           
                                                        composer.gotoScene( "credits" )
                                                        composer.removeScene("map", true)
                                                        audio.play(clickSound)

                                                        selectedLevel = 1
                                                elseif (selectedLevel == -1)then
                                                        composer.gotoScene( "level" )
                                                        composer.removeScene("map", true)
                                                        composer.setVariable( "lvl", 0 )
                                                        audio.play(clickSound)
                                                        selectedLevel = 1
                                                else
                                                        local curLevel = fileHandler.getCurrentLevel()
                                                        if (selectedLevel > curLevel) then
                                                                audio.play(wrongSound)
                                                        else
                                                                composer.gotoScene( "level" )
                                                                composer.removeScene("map", true)
                                                                composer.setVariable( "lvl", selectedLevel )
                                                                audio.play(clickSound) 
                                                                Runtime:removeEventListener("key", onKeyEvent)
                                                                selectedLevel = 1
                                                        end
                                                end

                                        end
                                end
                        end
                end
                Runtime:addEventListener( "key", onKeyEvent )

        elseif ( phase == "did" ) then
        end
end


-- hide()
function scene:hide( event )
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
                cleanMap()


        elseif ( phase == "did" ) then

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
        package.loaded["creator"] = nil

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
