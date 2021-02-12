-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local M = {}

local interface 

local blocksArray
local canJump = false
local ply
local enemyTimer
local shootTimer
local shoots = false
local creator
local stopped
local paused = false

local pressed
local game = true

local frogAttack = audio.loadSound( "frog_attack.mp3" )
local blastSound = audio.loadSound( "blast.mp3" )
local jumpSound = audio.loadSound( "jump.mp3" )
--local trollWalk = audio.loadSound( "troll_steps.mp3" ) 
local trollWalkPlaying = false
local trollWalkChannel

local composer

audio.reserveChannels( 0 )

M.resetVariables = function()
    canJump = false
    ply = nil
    if (enemyTimer~=nil) then timer.cancel(enemyTimer) end
    if (enemyTimer~=nil) then timer.cancel(shootTimer) end
    shoots = false
    stopped = false
    game = true
    trollWalkPlaying = false 
end

M.setCreator = function( c )
    creator = c
end

M.setInterface = function( i )
    interface = i
end

M.setComposer = function( comp )
    composer = comp
end

M.setBlocks = function( blocks )
    blocksArray = blocks
end
 

M.setJump = function( boolean )
    canJump = boolean
end

M.setTrollWalkPlaying = function( boolean )
    trollWalkPlaying = boolean
end

M.getGame = function()
    return game
end

M.setGame = function( gameVal )
    game = gameVal
end

M.setShoots = function( val )
    shoots = val
end

M.setPlayer = function( player )
    ply = player
end

M.setPressed = function( val )
    pressed = val
end

M.setStopped = function( val )
    stopped = val
end

M.setCanJump = function( val )
    canJump = val
end


M.destroyBlocks = function()
    for i in ipairs(blocksArray) do display.remove(blocksArray[i]) end
    blocksArray = {}
end

M.movePlayer = function( moveOnY )
    ply.y = moveOnY
end

M.moveForward = function( moveBy )
    for i in ipairs(blocksArray) do 
        blocksArray[i].x = blocksArray[i].x - moveBy
    end
end

M.moving = function()
    for i in ipairs(blocksArray) do 
        local vx,vy = blocksArray[i]:getLinearVelocity()
        blocksArray[i]:setLinearVelocity(vx-160, vy) 
    end
end

M.stopping = function()
    for i in ipairs(blocksArray) do 
        local vx,vy = blocksArray[i]:getLinearVelocity()
        blocksArray[i]:setLinearVelocity( vx+160, vy) 
    end
end

M.death = function()   
    game = false
    ply:setSequence("death")
    ply:play()
    ply.x = ply.x - 20
    ply.y = ply.y + 12
    local vx,vy = ply:getLinearVelocity()

    if (vy >= 0) then ply.gravityScale = 0 end

    ply.isSensor = true

    if (stopped == false) then
        M.stopping()
        stopped = true
    end
    timer.performWithDelay(800,function() interface.deathScreen() end)
end

M.changeBlockDir = function( block )  
    local vx,vy = block:getLinearVelocity()

    print("vx: "..vx.."\nvy: "..vy.."\nname: "..block.myName.."\ndirection: "..block.direction.."\ncontacted: "..tostring(block.contacted))

    if (block.direction == "right") then
        block:setLinearVelocity(vx-200,0)
        block.direction = "left"
    else 
        block:setLinearVelocity(vx+200,0)
        block.direction = "right"
    end

    print("vx: "..vx.."\nvy: "..vy.."\nname: "..block.myName.."\ndirection: "..block.direction.."\ncontacted: "..tostring(block.contacted))

    timer.performWithDelay(3,function() block.contacted=false 
    end)
end


M.gameLoop = function()
        if (game == true) then
        if (ply.y > display.contentHeight+10) then
            M.death() 
        end

        if (ply.x < 0) then
            M.death() 
        end

        local vx,vy = ply:getLinearVelocity()
        if (ply.x < composer.getVariable("playerStartingPosition") - 0.1 and stopped == false and vy == 0) then
            print("Minus 1, before: "..ply.y)
            ply.y = ply.y - 1
            ply.x = composer.getVariable("playerStartingPosition")
            ply:setLinearVelocity(0,0)
        end    
    end
end

local function pause()
    ply:pause()
    local vx,vy = ply:getLinearVelocity()
    ply.lastVelocity = vy
    ply:setLinearVelocity(0,0)
    ply.gravityScale = 0
    game = false
    timer.pauseAll()
    paused = true

    for i in ipairs(blocksArray) do 
        local element = blocksArray[i]
        local vx,vy = element:getLinearVelocity()

        transition.pauseAll()

        if (element.objectType == "sprite") then
            element.wasPlaying = element.isPlaying
            element:pause() 
        elseif (element.objectType == "emitter") then
            element:pause()
        end
        
        element.lastVelocityX = vx
        element.lastVelocityY = vy
        element:setLinearVelocity( 0, 0) 
    end
end

local function play()
    ply:play()
    ply:setLinearVelocity(0,ply.lastVelocity+0.1)
    ply.gravityScale = 1 
    game = true
    shoots = false
    timer.resumeAll()
    paused = false

    for i in ipairs(blocksArray) do 
        local element = blocksArray[i]
        local vx,vy = element.lastVelocityX,element.lastVelocityY

        transition.resumeAll()

        if (element.objectType == "sprite" and element.wasPlaying) then
            element:play() 
        elseif (element.objectType == "emitter" and element.isVisible) then
            element:start()
        end
        element:setLinearVelocity( vx, vy) 
    end
end

M.playerEvent = function( event )
    if (game == true) then
        if event.phase == "down" then
            pressed = true
            if (event.keyName == "left") then
                M.jump()
            elseif (shoots == false and event.keyName == "right") then
                    M.shoot()
                    shoots = true
            end
        end

        if event.phase == "up" then
            pressed = false
        end
    end

    if (event.keyName == event.phase) then
        if (paused) then
            play()
        else
            pause()
        end
    end
end

M.jump = function()
    if (canJump == true) then
        audio.play(jumpSound)
        ply:setLinearVelocity( 0, -300 )
        canJump = false
        ply:pause()
    else canJump = false
    end
end
    
M.shoot = function()
    audio.play(blastSound)
    shoots = true
    local vx,vy = ply:getLinearVelocity()
    creator.createBullet(ply.x + 50, ply.y + 5)
    --creator.createShootFlash(ply.x + 55, ply.y + 5,vy)
    shootTimer = timer.performWithDelay( 200, function () shoots = false if (pressed == true and game == true) then M.shoot() end end, 1 )
end

M.spriteListenerEnemy = function( event )
    local enemy = event.target 

    if (enemy.x < 1500 and enemy.sequence == "start") then enemy:setSequence("walk");enemy:play() end
    if (enemy.x < 1000 and trollWalkPlaying == false and enemy.x > 150 and game == true) then audio.play(trollWalk, {loops = -1, channel = 31}); trollWalkPlaying = true end
    if (enemy.x < 150 and trollWalkPlaying == true) then timer.performWithDelay(700, function() audio.stop(31); end) trollWalkPlaying = false end

    if ( event.phase == "ended" ) then 
        if (enemy.sequence == "die") then
            enemy.y = enemy.y + 10
        end

        if (enemy.sequence == "attak") then
            if (math.abs(enemy.y-ply.y)<60 and game == true) then
                local detectorsAndEnemies = creator.getDetectorsAndEnemies()
                local index = table.indexOf(detectorsAndEnemies,enemy)
                audio.stop(31)
                M.death()
                detectorsAndEnemies[index+2] = detectorsAndEnemies[index+2]+10
                detectorsAndEnemies[index+3] = detectorsAndEnemies[index+2]+10  
            end
        end
    end
end

M.spriteListenerFrog = function( event )
    local frog = event.target 

    local speed = 240
    local detector = frog[#frog]

    if (frog.sequence == "attack") then
        if (frog.frame == 15 and frog.x < 1300) then
            creator.createPoison(frog.x-25,frog.y)
        end

        if (frog.frame == 10 and frog.x < 1300 and frog.x > 0) then
            audio.play(frogAttack)
        end

        if (event.phase == "ended") then
            frog:setSequence("jump")
            frog:play()
            frog.y = frog.y-12
            frog.x = frog.x+12
        end
    end

    if (frog.sequence == "jump") then
        if (frog.frame == 13) then 
            local transitionX = frog[#frog-1] == 1 and 120 or -120

            detector.x = frog.x + transitionX

            if (stopped) then
                frog:setLinearVelocity(0,0) 
            else
                frog:setLinearVelocity(-160,0) 
            end
        end

        if (frog.frame == 17 and frog[#frog-1] == 0) then 
            frog:setSequence("attack")
            frog:play()
            frog.y = frog.y+12
            frog.x = frog.x-12
        end
        
        if (frog.frame == 3) then
            local vx, vy = frog:getLinearVelocity()

            if (detector[#detector]==0) then 
                frog:scale(-1,1)
                frog[#frog-1] = frog[#frog-1] == 0 and 1 or 0
            end

            if (frog[#frog-1] == 1) then 
                    frog:setLinearVelocity(vx+speed,0)  
            else
                    frog:setLinearVelocity(vx-speed,0)
            end
        end
    end
end



M.spriteListenerLarva = function( event )
    local larva = event.target 
    
    if (larva.x > 0 and larva.x < 420 and larva[#larva] == false and larva.sequence == "idle") then
        larva:setSequence("attack")
        larva:play()
        larva.x = larva.x-15
        larva.y = larva.y-2
        larva[#larva] = true
    end

    if ( event.phase == "ended" ) then 
        if (larva.sequence == "emerge") then
            larva:scale(0.85,0.85)
            larva.x = larva.x + 8
            larva:setSequence( "idle" )  
            larva:play()
        end
    end

    if ( event.phase == "began" ) then 
        if (larva.sequence == "attack") then
            timer.performWithDelay(300, function() 
                if (math.abs(larva.y-ply.y)<60 and game == true) then
                    M.death()
                end
            end)
        end
    end
        
end

M.spriteListenerSmokeExplosion = function( event )
    local thisSprite = event.target 

    if ( event.phase == "ended" ) then 

        local index = table.indexOf(blocksArray,thisSprite)
        table.remove( blocksArray, index )
        display.remove(thisSprite)

        if (thisSprite.sequence == "smoke") then
            thisSprite:removeSelf()
        end
    end
end


M.deletePlayer = function()
    ply:removeSelf()
    ply = {}
end

M.getEnemyTimer = function()
    return enemyTimer
end

M.getPlayer = function()
    return ply
end

M.getCanJump = function()
    return canJump
end

M.getStopped = function()
    return stopped
end

M.getBlocksArray = function()
    return blocksArray
end

M.deleteFromActiveEnemyArray = function(toDelete)
    local index = table.indexOf(activeEnemyArray,toDelete)
    table.remove( activeEnemyArray, index )
end

return M