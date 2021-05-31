 local composer = require( "composer" )
local fileHandler = require( "fileHandler" )

local scene = composer.newScene()
clickSound = audio.loadSound( "click.ogg" )

local function textChangeSize(text,increase)
        local increaseNext = 1
        if (increase == 1) then
                transition.to(text, { time = 700, size = 60})
                increaseNext = 0
        else
                transition.to(text, { time = 700, size = 50})
        end
        timer.performWithDelay(700, function() textChangeSize(text,increaseNext) end)
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

    local function onKeyEvent( event )
        local path = system.pathForFile( "currentLevel.txt", system.DocumentsDirectory )
        local file = io.open( path )

        if not file then
            composer.gotoScene("level")
            composer.setVariable("lvl",0)
        else 
            composer.gotoScene("map")
        end

        audio.play(clickSound) 
        Runtime:removeEventListener( "key", onKeyEvent )

        return false
    end
     
    Runtime:addEventListener( "key", onKeyEvent )

    local title = display.newRect( sceneGroup,600, 0, 1080, 180 )
    title:setFillColor(0.35,0.35,0.8)

        local background = display.newImageRect( sceneGroup, "menu.png", 1080, 500)
        background.myName = "background"
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        local tapStartText = display.newEmbossedText(sceneGroup, "press any key", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY + 170, "PermanentMarker-Regular.ttf", 45) 
        tapStartText:setTextColor( 1, 1, 1 )

        textChangeSize(tapStartText,1)
        
        local gameTitle = display.newText(sceneGroup, "SCI-FI PLATFORMER", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY - 150, "akaDylan Collage.ttf", 52)   
        gameTitle:setTextColor( 0.3, 0.3, 1)

        gameTitle.fill.effect = "generator.linearGradient"
 
        gameTitle.fill.effect.color1 = { 0, 0, 0.2, 1}
        gameTitle.fill.effect.position1  = { 1, 0 }
        gameTitle.fill.effect.color2 = { 0.7, 0.7, 1, 1 }
        gameTitle.fill.effect.position2  = { 1, 1 }
        scaleFactor = display.actualContentWidth/display.actualContentHeight/1.77
        gameTitle:scale(scaleFactor,scaleFactor)

        composer.setVariable("env",1)
end


-- show()
function scene:show( event )
	local phase = event.phase

        if ( phase == "will" ) then

        elseif ( phase == "did" ) then
        end
end


-- hide()
function scene:hide( event )
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

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
