local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local gameLoopTimer

local creator
local builder = require("builder")
local interface = require("interface")
local game = require("game")
local collisionHandler = require("collisionHandler")
local fileHandler = require("fileHandler")

local sceneGroup
local physics = require( "physics" )    

local musicTrack
audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )

function setSceneGroup()
        sceneGroup:insert( creator.getBackGroup() )
        sceneGroup:insert( creator.getMiddleGroup() )
        sceneGroup:insert( creator.getMainGroup() )    
        sceneGroup:insert( creator.getPlayerGroup() )
        sceneGroup:insert( creator.getFrontGroup() )
end

function getSceneGroup()
        return sceneGroup
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    
    -- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup = self.view

    physics.start()

       
    --game.moveForward(3500)
    --game.movePlayer(100)

end


-- show()
function scene:show( event )
    

	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        Runtime:addEventListener( "collision", collisionHandler.onCollision )
        Runtime:addEventListener( "touch", game.playerEvent )

        gameLoopTimer = timer.performWithDelay( 25, game.gameLoop, 0 )

	elseif ( phase == "did" ) then
                -- Code here runs when the scene is entirely on screen   
                creator = require("creator")
                creator.setGame(game)

                builder.setUp(creator, game, collisionHandler, composer.getVariable("lvl"))

                musicTrack = composer.getVariable("lvl") > 5 and audio.loadStream( "dessert_song.MP3") or audio.loadStream( "s6.mp3")

                game.setUp(composer,creator,creator.getBlocksArray(),interface)
                
                interface.setUp(game,creator,builder,collisionHandler,fileHandler)
                interface.pauseIcon()

                collisionHandler.setUp(game,creator,interface,creator.getFrontGroup(),0,0)

                game.moving()                  
                audio.play( musicTrack, { channel=1, loops=-1 } )
                setSceneGroup()
	end
end


-- hide()
function scene:hide( event )
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(gameLoopTimer)
        game.resetVariables()
        for i=1,32 do
                audio.stop(i)
        end

	elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        blocksArray = nil

        Runtime:removeEventListener( "collision", collisionHandler.onCollision )
        Runtime:removeEventListener( "touch", game.playerEvent )
        package.loaded["creator"] = nil
        audio.stop(1)
        
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
