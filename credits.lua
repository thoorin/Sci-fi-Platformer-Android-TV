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

local delayTime

local function inAndOut( group )
    transition.fadeIn(group, {delay = delayTime, time = 1400})
    transition.fadeOut(group,{delay = delayTime + 6000, time = 1400})
    delayTime = delayTime + 7400
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
end


-- show()
function scene:show( event )
	local phase = event.phase

        if ( phase == "will" ) then
            delayTime = 0

            local asset0 = display.newText(sceneGroup, "Created by Marek Škreko\n\n\n\nSpecial thanks to Petra Husárová\nfor help with testing\n", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY-50, "PermanentMarker-Regular.ttf",30)  
            asset0:setTextColor( 0, 0, 0)
            asset0.alpha = 0
        
            inAndOut(asset0)
        
            local assets = display.newText(sceneGroup, "Assets used:", display.contentWidth-display.actualContentWidth*0.6, 100, "PermanentMarker-Regular.ttf",50)   
            assets:setTextColor( 0, 0, 0)
            assets.alpha = 0

            transition.fadeIn(assets, {delay = delayTime, time = 1400})
            transition.fadeOut(assets,{delay = delayTime + 6000, time = 1400})
        
            local asset1 = display.newText(sceneGroup, "Player by dasidsaidsij\n\nForest tileset and Desert tileset \nby Zuhria Alfitra from gameart2d.com\n\n", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY+50, "PermanentMarker-Regular.ttf",30)  
            asset1:setTextColor( 0, 0, 0)
            asset1.alpha = 0
        
            inAndOut(asset1)
        
            local asset2 = display.newText(sceneGroup, "Interface and Orcs by craftpix.net\n\nPlayer Projectile by Krasi Wasilev \n(freegameassets.blogspot.com)\n\nLand Mine by Idznak", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY-50, "PermanentMarker-Regular.ttf",30)  
            asset2:setTextColor( 0, 0, 0)
            asset2.alpha = 0
        
            inAndOut(asset2)
        
            local asset3 = display.newText(sceneGroup, "Explosions by Sinestesia Studio\n\nTiger Beetle Larva by Nick Noir\n\nFlower and Water by Bayat Games\n\nFrog by Isra Maraver (ismartal)", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset3:setTextColor( 0, 0, 0)
            asset3.alpha = 0
        
            inAndOut(asset3)
        
            local asset4 = display.newText(sceneGroup, "Tanks, Smokes and Spikes\nby Robert Brooks\nfrom gamedeveloperstudio.com\n\nMenu/Ending/Credits Background\nby Swapnil Rane\nfrom madfireongames.com\n\nSpaceship by bevouliin.com", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset4:setTextColor( 0, 0, 0)
            asset4.alpha = 0
        
            inAndOut(asset4)
        
            local asset5 = display.newText(sceneGroup, "Touch gestures by macrovector\nwww.freepik.com\n\nFireworks by jellyfizh\nfrom opengameart.org\n\nScroll (symbol for Credits) and Book\n(symbol for Tutorial)\nby Olga Bikmullina", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset5:setTextColor( 0, 0, 0)
            asset5.alpha = 0
        
            inAndOut(asset5)
        
            local asset6 = display.newText(sceneGroup, "Song for Forest Planet\nby Dong-Young Kim\n\nSong for Desert Planet by Vishwa Jay\n\nPlayer Jump sound by kfatehi\n\nPlayer Shoot Sound by nsstudios", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset6:setTextColor( 0, 0, 0)
            asset6.alpha = 0
        
            inAndOut(asset6)
        
            local asset7 = display.newText(sceneGroup, "Player Projectile Impact Sound by dklon\n\nLarva Sound by LucasDuff\n\nExplosion by cydon\n\nOrc Sounds by Darsycho", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset7:setTextColor( 0, 0, 0)
            asset7.alpha = 0
        
            inAndOut(asset7)
        
            local asset8 = display.newText(sceneGroup, "Spaceship sounds\nby jacksonacademyashmore\nand IFartInUrGeneralDirection\n(from freesound.org)\n\nPermanent Marker font by Font Diner\n\nAka Dylan font by akaType\n\nTank Shoot sound by Cyberkineticfilms", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset8:setTextColor( 0, 0, 0)
            asset8.alpha = 0
        
            inAndOut(asset8)
        
            local asset9 = display.newText(sceneGroup, "Poison Splash sound by JustInvoke\n\nFrog Death sound by jacobalcook\n\nSpike Stabbing sound by InspectorJ\n\nWater Splash sound by genel", display.contentWidth-display.actualContentWidth*0.5, display.contentCenterY, "PermanentMarker-Regular.ttf",30)  
            asset9:setTextColor( 0, 0, 0)
            asset9.alpha = 0
        
            inAndOut(asset9)

            timer.performWithDelay(delayTime, function() composer.gotoScene("map") end)

            Runtime:addEventListener( "touch", tapEvent)

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
