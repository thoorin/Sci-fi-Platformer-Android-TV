local composer = require( "composer" )

local scene = composer.newScene()

local sheetOptionsFireworks ={ width = 256, height = 256, numFrames = 30}
local fireworksSheet = graphics.newImageSheet( "Firework.png", sheetOptionsFireworks )

local fireworksSequences = {
    {
        name = "fireworks",
        start = 1,
        count = 30,
        time = 1200,
        loopCount = 0
    }
}

local delayTime = 0

local function createFireworks( x, y, delay)
    local fireworks = display.newSprite(sceneGroup, fireworksSheet, fireworksSequences )
    fireworks.x = x
    fireworks.y = y
    fireworks.alpha = 0

    timer.performWithDelay(delay,function()         
        fireworks.alpha = 1
        fireworks:play()
    end)

end

local function tapEvent()
    composer.gotoScene("map")
    Runtime:removeEventListener( "touch", tapEvent)
    composer.removeScene( "credits", true )
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    
    -- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup = self.view

    display.setDefault( "background", 1, 1, 1 )

    local background = display.newImageRect( sceneGroup, "menu.png", 1080, 500)
    background.myName = "background"
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local congratulations = display.newText(sceneGroup, "       Congratulations \nfor completing this game!", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY - 150, "akaDylan Collage.ttf",50)   
    congratulations:setTextColor( 0.3, 0.3, 1)
    congratulations.alpha = 0
    scaleFactor = display.actualContentWidth/display.actualContentHeight/1.94
    congratulations:scale(scaleFactor,scaleFactor)

    local author = display.newText(sceneGroup, "Created by Marek Škreko", display.contentWidth-display.actualContentWidth*0.5, display.actualContentHeight - 70, "PermanentMarker-Regular.ttf",30)   
    author:setTextColor( 1, 1, 1)
    author.alpha = 0

    transition.fadeIn(congratulations,{time = 1400})
    transition.fadeIn(author,{time = 1400})

    createFireworks(display.contentWidth-display.actualContentWidth*0.5,200,1000)
    createFireworks(display.contentWidth-display.actualContentWidth*0.92,120,720)
    createFireworks(display.contentWidth*0.9,100,1300)
end

-- show()
function scene:show( event )
	local phase = event.phase

        if ( phase == "will" ) then
            Runtime:addEventListener( "touch", tapEvent)

        elseif ( phase == "did" ) then
        end
end


-- hide()
function scene:hide( event )
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        --[[
        for i in ipairs(sceneGroup) do
            display.remove(sceneGroup[i])
        end
        sceneGroup = {}]]--

        Runtime:removeEventListener( "touch", tapEvent)
        
        elseif ( phase == "did" ) then
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view

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
