-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local M = {}

local game, creator, interface, frontGroup
local playerContactedByBlock, playerContactedByMoving = false, false

local level, score, blocksContacted, particlesArray, win = 0, 0, 0, {}, false

local mineExplosion = audio.loadSound( "268557__cydon__explosion-001.mp3" )
local splashSound = audio.loadSound( "water_splash.mp3" )
local startSound = audio.loadSound( "ship_starting.mp3" )
local flyingSound = audio.loadSound( "ship_flying.mp3" )
local trollAttack = audio.loadSound( "troll_attack5.mp3" )
local trollDeath = audio.loadSound( "troll_attack2.mp3" )
local frogDeath = audio.loadSound( "frog_death.mp3" )
local stabSound = audio.loadSound( "stab.mp3" )
local hitSound = audio.loadSound( "boom9.wav" )

M.setLevel = function( lvl )
    level = lvl
end

M.setScore = function( val )
    score = val
end

M.setBlocksContacted = function( val )
    blocksContacted = val
end

M.setUp = function (g,c,i,fG,sc,bC)
    game, creator, interface, frontGroup = g, c, i, fG
    M.setScore(sc)
    M.setBlocksContacted(bC)
end

M.onCollision = function( event )
    local obj1 = event.object1
    local obj2 = event.object2
    local objs = { obj1, obj2 }
    local array = game.getBlocksArray()

    local function findObject( name )
        for index, value in ipairs(objs) do
            if (value.myName == name) then return value end
        end
        return false
    end

    if ( event.phase == "began" ) then    
        if ( findObject("player")) then
            player = findObject("player")

            if (findObject("block") or findObject("blockMoving")) then   
                local block = findObject("block") or findObject("blockMoving")
                if (block.myName == "block") then playerContactedByBlock = true else playerContactedByMoving = true end

                if ((player.y - block.y) < -46.4 or (playerContactedByMoving and (player.y - block.y) < -44)) then game.setCanJump(true) end

                if (math.abs(obj1.y - obj2.y) <= 46.4 and game.getStopped()==false and game.getCanJump()==false and game.getGame()==true and playerContactedByMoving==false) then 
                    game.stopping() 
                    game.setStopped(true)
                end

                blocksContacted = blocksContacted + 1
                
                if (game.getGame()==true) then
                    player:play()
                end

                if (win == false) then
                    local vx, vy = player:getLinearVelocity()
                    player:setLinearVelocity( 0,vy )
                end

                if (playerContactedByBlock == true and playerContactedByMoving == true and math.abs(obj1.y - obj2.y) < 46) then timer.performWithDelay(1,game.death);end
            end

            if ( findObject("mine"))
            then
                local mine = findObject("mine")

                timer.performWithDelay(200,function() 
                    if (game.getGame()) then
                        creator.createExplosion(mine.x,mine.y)
                        audio.play(mineExplosion)
                        mine.isVisible = false
                        player.isVisible = false 
                        game.death()
                    end
                end)
            end

            if ( findObject("spike"))
            then
                local spike = findObject("spike")

                if (game.getGame()) then
                    spike:play()
                    audio.play(stabSound)
                    timer.performWithDelay(1,function() game.death() end)
                end
            end

            if ( findObject("water"))
            then
                creator.getMiddleGroup():insert(player)
                timer.performWithDelay(1,function() creator.createWaterSplash(player.x,player.y) end)
                audio.play(splashSound, {channel = 0})
            end

            if ( findObject("end"))
            then
                game.stopping()
                win = true
                game.setGame(false)
                player:play()

                player:setLinearVelocity(160,0)
                if (level ~= 5) then
                    timer.performWithDelay( 1500, interface.winScreen, 1 )
                else 
                    timer.performWithDelay( 6000, interface.winScreen, 1 )
                end
                if (level == 3) then
                    timer.performWithDelay( 500, function() player:setLinearVelocity(160,-300) end, 1 )
                end
            end

            if (findObject("ship"))
            then    
                local ship = findObject("ship")
                timer.performWithDelay( 500, function()             
                    player.isVisible=false
                    ship:setLinearVelocity(0,-50) 
                end, 1 )
                timer.performWithDelay( 4000, function() ship:setLinearVelocity(400,0);
                    audio.stop(32)
                    audio.play(flyingSound, {channel = 32})
                end, 1 )

                audio.play(startSound, {channel = 32})
            end

            if ( findObject("enemy"))
            then
                local enemy = findObject("enemy")

                if (game.getGame()) then
                    audio.play(trollAttack)
                    enemy:setLinearVelocity(-160,0)
                    enemy:setSequence("attak")  
                    enemy:play()
                end
            end

            if ( findObject("shell")) then
                if (game.getGame()) then
                    local shell = findObject("shell")
                    local index = table.indexOf(array,shell )
                    table.remove(array,index)

                    audio.play(mineExplosion)
                    timer.cancel(shell.destroyTimer)
                    timer.performWithDelay(1,function() creator.createShellImpact(player.x,player.y-20) end)
                    display.remove( shell )
                    timer.performWithDelay(50,game.death)
                end
            end

            if ( findObject("poison")) then
                if (game.getGame() == true) then
                    local poison = findObject("poison") 
                    local index = table.indexOf(array,poison )
                    table.remove(array,index)

                    timer.cancel( poison.destroyTimer)

                    display.remove( poison )
                    timer.performWithDelay(1, function() creator.createPoisonImpact(player.x+20,player.y) end)
                    timer.performWithDelay(50,game.death)
                end
            end
        end

        if (findObject("poison") and findObject("block")) then
            local poison = findObject("poison") 
            local index = table.indexOf(array,poison )
            table.remove(array,index)

            timer.cancel( poison.destroyTimer)

            local block = findObject("block")
            display.remove( poison )
            
            timer.performWithDelay(1, function() creator.createPoisonImpact(block.x+35,block.y) end)
        end

        if (findObject("bullet") ) then
            local bullet = findObject("bullet")
            local other = obj1.myName == "bullet" and obj2 or obj1

            local hit = false

            local bulletX, bulletY = bullet.x, bullet.y

            if (other.hittable) then
                local index = table.indexOf(array,bullet) 
                table.remove(array,index)
                timer.cancel(bullet.destroyTimer)
                hit = true
                audio.play(hitSound)
            end

            if ( findObject("enemy"))
            then
                local enemy = findObject("enemy")
                score = score + 125

                timer.performWithDelay(1,function() creator.createFlash(bulletX+40, bulletY + 5) end)

                audio.stop(31)
                audio.play(trollDeath, {channel = 31})
                enemy:setSequence("die")
                enemy:play()
                enemy.myName = "deadOrk"
                enemy.hittable = false
                if (game.getGame()) then enemy:setLinearVelocity(-160,0) end
                enemy.detector:setLinearVelocity(-160,0)
            end

            if (findObject("frog"))
            then
                local frog = findObject("frog")

                score = score + 250
            
                timer.performWithDelay(1,function() creator.createFlash(bulletX+20, bulletY + 10) end)

                frog.myName = "deadFrog"
                frog:setSequence("death")
                audio.play(frogDeath)
                frog:play()
                frog.hittable = false

                local frogSpeed = game.getStopped() and 0 or -160
                frog:setLinearVelocity(frogSpeed,0)
            end

            if (findObject("larva"))
            then
                local larva = findObject("larva")
                local moveY = -15
                local moveX = 20

                score = score + 100
                
                timer.performWithDelay(1, function() creator.createFlash(bulletX+20, bulletY + 10) end)
                larva:setSequence("death") 
                larva:play()
                larva.myName = "deadLarva"
                larva.hittable = false
                transition.to( larva, { time=0, x=larva.x+moveX, y=larva.y+moveY } )
                
                if (larva.xScale == 1) then larva:scale(0.85,0.85) end
            end

            if ( findObject("block") or findObject("blockMoving") or findObject("ship"))
            then
                timer.performWithDelay(1, function() creator.createFlash(bulletX+40, bulletY+5) end)
            end

            if ( findObject("tank"))
            then
                local tank = findObject("tank")
                timer.performWithDelay(1,function() creator.createFlash(bulletX+40, bulletY + 5) end)

                tank.fill.effect = "filter.monotone"
    
                tank.fill.effect.r = 0
                tank.fill.effect.g = 0
                tank.fill.effect.b = 0
                tank.fill.effect.a = 0.6

                timer.performWithDelay(100,function()          
                    transition.to( tank.fill.effect, { time=200, r=1, g=1, b=1, a=0 } )
                end, 1)
                tank.lives = tank.lives - 1

                if (tank.lives < 1) then
                    timer.cancel(tank.enemyTimer)
                    tank.myName = "destroyed"

                    score = score + 200
                    timer.performWithDelay(1,function() creator.createExplosionTank(tank.x,tank.y)
                        audio.play(mineExplosion)
                     end)

                    tank.fill.effect = "filter.vignette" 
                    tank.fill.effect.radius = 0

                    timer.performWithDelay(1, function() creator.createSmokes(tank.x,tank.y) end)
                    tank.hittable = false
                end
            end

            if (hit) then
                display.remove( bullet ) 
            end
        end
            
        if ( (findObject("block") or findObject("blockU")) and findObject("blockMoving"))
        then
            local block = findObject("blockMoving")

            if (block.contacted == false) then
                block.contacted = true
                game.changeBlockDir( block )
            end
        end

        if ( findObject("block") )
        then

            if (findObject("detector"))
            then
                local detector = findObject("detector")
                detector.contacted = detector.contacted + 1
            end

            if (findObject("jumpDetector")) then
                local detector = findObject("jumpDetector") 
                detector.contacted = 1
            end
                
            if ( findObject("shell")) then
                local shell = findObject("shell")
                local index = table.indexOf(array, shell)
                table.remove(array,index)

                timer.cancel( shell.destroyTimer)

                audio.play(mineExplosion)
                timer.performWithDelay(1,function() creator.createShellImpact(shell.x,shell.y-30) 
                    display.remove( shell )
                end)

            end
        end
    end

    if ( event.phase == "ended" ) then
        if ( findObject("player") and (findObject("block") or findObject("blockMoving")))
        then
            blocksContacted = blocksContacted - 1
            if (findObject("block")) then playerContactedByBlock = false else playerContactedByMoving = false end
            
            if (blocksContacted == 0) then game.setCanJump(false) end
                 
            local player = findObject("player")

            if (win == false) then
                local vx, vy = player:getLinearVelocity()
                    player:setLinearVelocity( 0,vy )    
            end

            if (game.getStopped() and game.getGame()) then
                game.setStopped(false)
                game.moving()
            end
        end

        if ( findObject("block") )
        then
            if (findObject("detector"))
            then
                local detector = findObject("detector")
                detector.contacted = detector.contacted - 1

                local speed 
                if (detector.owner.myName == "enemy") then speed = 60 else speed = 480 end
                local vx,vy = detector.owner:getLinearVelocity()

                local sign
                if (detector.contacted == 0 ) then
                    if (detector.direction == "left") then
                        sign = 1
                        detector.direction = "right"
                    else
                        sign = -1
                        detector.direction = "left"
                    end

                    transition.to( detector, { time=0, x=detector.x+50*sign, y=detector.y } )
                    detector:setLinearVelocity(vx+speed*sign,0)
                    detector.owner:setLinearVelocity(vx+speed*sign,0)
                    detector.owner:scale(-1,1)
                end
            end

            if (findObject("jumpDetector"))
            then
                local detector = findObject("jumpDetector") 
                detector.contacted = 0
            end
        end
    end
    
end    

M.destroyParticles = function()
    for i in ipairs(particlesArray) do display.remove(particlesArray[i]) end  
    particlesArray = {}
end

M.getLevel = function()
    return level
end

M.getScore = function()
    return score
end

M.getBlocksContacted = function()
    return blocksContacted
end

return M