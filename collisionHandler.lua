-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local M = {}

local game
local creator
local interface
local playerContactedByBlock = false
local playerContactedByMoving = false
local blocksContacted = 0
local win = false
local mineExplosion = audio.loadSound( "268557__cydon__explosion-001.mp3" )
local splashSound = audio.loadSound( "water_splash.mp3" )
local startSound = audio.loadSound( "ship_starting.mp3" )
local flyingSound = audio.loadSound( "ship_flying.mp3" )
local trollAttack = audio.loadSound( "troll_attack5.mp3" )
local trollDeath = audio.loadSound( "troll_attack2.mp3" )
local frogDeath = audio.loadSound( "frog_death.mp3" )
local stabSound = audio.loadSound( "stab.mp3" )
local particlesArray = {}
local level = 0
local hitSound = audio.loadSound( "boom9.wav" )
local score = 0
local frontGroup

M.setGame = function(g)
    game = g
end

M.setFrontgroup = function(f)
    frontGroup = f
end

M.setCreator = function(c)
    creator = c
end

M.setInterface = function(i)
    interface = i
end

M.setLevel = function( lvl )
    level = lvl
end

M.setScore = function( val )
    score = val
end

M.setBlocksContacted = function( val )
    blocksContacted = val
end

M.onCollision = function( event )
    local obj1 = event.object1
    local obj2 = event.object2
    local objs = { obj1, obj2 }

    M.isCollided = function( name )
        for index, value in ipairs(objs) do
            if (value.myName == name) then return true end
        end
        return false
    end

    M.findObject = function( name )
        for index, value in ipairs(objs) do
            if (value.myName == name) then return value end
        end
        return false
    end

    if ( event.phase == "began" ) then    
        if ( M.isCollided("player")) then
            local player = M.findObject("player")

            if (M.isCollided("block") or M.isCollided("blockMoving")) 
            then   
                local block

                if (M.isCollided("block")) then playerContactedByBlock = true; block = M.findObject("block")end
                if (M.isCollided("blockMoving")) then playerContactedByMoving = true; block = M.findObject("blockMoving")end

                print(player.y - block.y)
                if ((player.y - block.y) < -46.4) then game.setCanJump(true) end
                if (playerContactedByMoving and (player.y - block.y) < -44) then game.setCanJump(true) end

                if (math.abs(obj1.y - obj2.y) <= 46.4 and game.getStopped()==false and game.getCanJump()==false and game.getGame()==true and M.findObject("blockMoving")==false) then 
                    game.stopping() 
                    game.setStopped(true)
                end

                blocksContacted = blocksContacted + 150
                
                if (game.getGame()==true) then
                    player:play()
                end

                if (win == false) then
                    local vx, vy = player:getLinearVelocity()
                    player:setLinearVelocity( 0,vy )
                end

                if (playerContactedByBlock == true and playerContactedByMoving == true and math.abs(obj1.y - obj2.y) < 46) then timer.performWithDelay(1,game.death);end
            end

            if ( M.isCollided("mine"))
            then
                local mine = M.findObject("mine")

                timer.performWithDelay(200,function() 
                    if (game.getGame()==true) then

                    creator.createExplosion(mine.x,mine.y)
                    audio.play(mineExplosion)

                    mine.isVisible = false

                    player.isVisible = false 
                    game.death()
                    end
                end)
            end

            if ( M.isCollided("spike"))
            then
                local spike = M.findObject("spike")

                if (game.getGame()==true) then
                    spike:play()
                    audio.play(stabSound)
                    timer.performWithDelay(1,function() game.death() end)
                end
            end

            if ( M.isCollided("water"))
            then
                creator.getMiddleGroup():insert(player)

                timer.performWithDelay(1,function() creator.createWaterSplash(player.x,player.y) end)

                audio.play(splashSound, {channel = 0})
            end

            if ( M.isCollided("end"))
            then
                game.stopping()
                win = true
                game.setGame(false)
                local blocksArray = game.getBlocksArray()

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

            if (M.isCollided("ship"))
            then    
                local ship = M.findObject("ship")
                timer.performWithDelay( 500, function()             player.isVisible=false
                    ship:setLinearVelocity(0,-50) end, 1 )
                timer.performWithDelay( 4000, function() ship:setLinearVelocity(400,0);
                    audio.stop(32)
                    audio.play(flyingSound, {channel = 32})
                end, 1 )

                audio.play(startSound, {channel = 32})
            end
            

            if ( M.isCollided("enemy"))
            then
                local enemy = M.findObject("enemy")

                if (game.getGame() == true) then
                    audio.play(trollAttack)
                    enemy:setLinearVelocity(-160,0)
                    enemy:setSequence("attak")  
                    enemy:play()
                end
                
            end

            if ( M.isCollided("shell")) then
                if (game.getGame() == true) then
                    local shell = M.findObject("shell") 
                    local array = game.getBlocksArray()
                    local index = table.indexOf(array,shell )
                    table.remove(array,index)

                    audio.play(mineExplosion)
                    timer.cancel( shell.destroyTimer)
                    timer.performWithDelay(1,function() creator.createShellImpact(player.x,player.y-20) end)
                    display.remove( shell )
                    timer.performWithDelay(50,game.death)
                end
            end

            if ( M.isCollided("poison")) then
                if (game.getGame() == true) then
                    local poison = M.findObject("poison") 
                    local array = game.getBlocksArray()
                    local index = table.indexOf(array,poison )
                    table.remove(array,index)

                    timer.cancel( poison.destroyTimer)

                    display.remove( poison )
                    timer.performWithDelay(1, function() creator.createPoisonImpact(player.x+20,player.y) end)
                    timer.performWithDelay(50,game.death)
                end
            end
        end

        if (M.isCollided("poison") and M.isCollided("block")) then
            local poison = M.findObject("poison") 
            local array = game.getBlocksArray()
            local index = table.indexOf(array,poison )
            table.remove(array,index)

            timer.cancel( poison.destroyTimer)

            local block = M.findObject("block")
            display.remove( poison )
            
            timer.performWithDelay(1, function() creator.createPoisonImpact(block.x+35,block.y) end)
        end

        if (M.isCollided("bullet") ) then
            local bullet = M.findObject("bullet")
            local other = obj1.myName == "bullet" and obj2 or obj1

            local array = game.getBlocksArray()

            local hit = false

            local bulletX, bulletY = bullet.x, bullet.y

            if (other.hittable) then
                local index = table.indexOf(array,bullet) 
                table.remove(array,index)
                timer.cancel(bullet.destroyTimer)
                hit = true
                audio.play(hitSound)
            end

            if ( M.isCollided("enemy"))
            then
                local arr = creator.getDetectorsAndEnemies()
                local enemy = M.findObject("enemy")

                score = score + 125

                timer.performWithDelay(1,function() creator.createFlash(bulletX+40, bulletY + 5) end)

                audio.stop(31)
                audio.play(trollDeath, {channel = 31})
                enemy:setSequence("die")
                enemy:play()
                enemy.myName = "deadOrk"
                enemy.hittable = false
                if (game.getGame() == true) then enemy:setLinearVelocity(-160,0) end
                local index = table.indexOf(arr,enemy)
                local leftDetector = arr[index-1]
                local rightDetector = arr[index+1]
                creator.deleteDetector(leftDetector,rightDetector)
                display.remove( leftDetector )
                display.remove( rightDetector )
            end

            if (M.isCollided("frog"))
            then
                local frog = M.findObject("frog")

                score = score + 250
                
                timer.performWithDelay(1,function() creator.createFlash(bulletX+20, bulletY + 10) end)

                frog.myName = "deadFrog"
                frog:setSequence("death")
                audio.play(frogDeath)
                frog:play()
                frog.hittable = false
                if (game.getStopped()) then
                    frog:setLinearVelocity(0,0)
                else
                    frog:setLinearVelocity(-160,0)
                end
            end

            if (M.isCollided("larva"))
            then
                local larva = M.findObject("larva")
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

            if ( M.isCollided("block") or M.isCollided("blockMoving") or M.isCollided("ship"))
            then
                timer.performWithDelay(1, function() creator.createFlash(bulletX+40, bulletY+5) end)
            end

            if ( M.isCollided("tank"))
            then
                local tank = M.findObject("tank")
                timer.performWithDelay(1,function() creator.createFlash(bulletX+40, bulletY + 5) end)

                tank.fill.effect = "filter.monotone"
    
                tank.fill.effect.r = 0
                tank.fill.effect.g = 0
                tank.fill.effect.b = 0
                tank.fill.effect.a = 0.6

                timer.performWithDelay(100,function()          
                    transition.to( tank.fill.effect, { time=200, r=1, g=1, b=1, a=0 } )
                end, 1)
                tank[#tank] = tank[#tank] - 1

                if (tank[#tank] < 1) then
                    timer.cancel(tank[#tank-1])
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

        if ( M.isCollided("deleter"))
        then 
            local obj
            if (obj1.myName == "deleter") then
                obj = obj2
            else
                obj = obj1
            end
            if (obj.myName == "frog" or obj.myName == "enemy") then
                timer.cancel(obj.timer)
            end
            local array = game.getBlocksArray()
            local index = table.indexOf(array, obj)
            table.remove(array,index)
            display.remove(obj)

        end
            
        if ( (M.isCollided("block") or M.isCollided("blockU")) and M.isCollided("blockMoving"))
        then
            local block = M.findObject("blockMoving")

            print("block contacted before: "..tostring(block.contacted))
            if (block.contacted == false) then
                block.contacted = true
                game.changeBlockDir( block )
            end
            print("block contacted after: "..tostring(block.contacted))
        end

        if ( M.isCollided("block") )
        then

            if (M.isCollided("detectorL") or M.isCollided("detectorR"))
            then
                local detector
                local indexToEnemy
                local indexCollision
                if (M.isCollided("detectorL")) 
                then 
                    detector = M.findObject("detectorL")
                    indexToEnemy = 1
                    indexCollision = 3
                else 
                    detector = M.findObject("detectorR")
                    indexToEnemy = -1
                    indexCollision = 2
                end
                    
                local array = creator.getDetectorsAndEnemies()
                local index = table.indexOf(array,detector)

                array[index+indexCollision] = array[index+indexCollision]+1
            end

            if (M.isCollided("jumpDetector")) then
                local detector = M.findObject("jumpDetector") 
                if (detector[#detector] == 0) then
                    detector[#detector] = 1
                end
            end
                
            if ( M.isCollided("shell")) then
                local shell = M.findObject("shell")
                local array = game.getBlocksArray()
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
        if ( M.isCollided("player") and (M.isCollided("block") or M.isCollided("blockMoving")))
        then
            blocksContacted = blocksContacted - 1
            if (M.isCollided("block")) then playerContactedByBlock = false end
            if (M.isCollided("blockMoving")) then playerContactedByMoving = false end
            
            if (blocksContacted == 0) then game.setCanJump(false) end
                 
            local player = M.findObject("player")

            if (win == false) then
                local vx, vy = player:getLinearVelocity()
                    player:setLinearVelocity( 0,vy )    
            end

            if (game.getStopped() and game.getGame()) then
                game.setStopped(false)
                game.moving()
            end
        end

        if ( M.isCollided("block") )
        then
            if (M.isCollided("detectorL") or M.isCollided("detectorR"))
            then
                local detector
                local indexToEnemy
                local indexCollision

                if (M.isCollided("detectorL")) then 
                    detector = M.findObject("detectorL")
                    indexToEnemy = 1
                    indexCollision = 3
                else
                    detector = M.findObject("detectorR")
                    indexToEnemy = -1
                    indexCollision = 2
                end

                local array = creator.getDetectorsAndEnemies()
                local index = table.indexOf(array,detector)

                array[index+indexCollision] = array[index+indexCollision]-1
                
                local speed 
                if (array[index+indexToEnemy].myName == "enemy") then speed = 60 else speed = 480 end
                local vx,vy = array[index+indexToEnemy]:getLinearVelocity()

                local sign
                if (array[index+indexCollision] == 0 ) then
                    if (detector.myName == "detectorL") then
                        sign = 1
                    else
                        sign = -1
                    end

                    array[index]:setLinearVelocity(vx+speed*sign,0)
                    array[index+1*sign]:setLinearVelocity(vx+speed*sign,0)
                    array[index+1*sign]:scale(-1,1)
                    array[index+2*sign]:setLinearVelocity(vx+speed*sign,0)
                end
            end

            if (M.isCollided("jumpDetector"))
            then
                local detector = M.findObject("jumpDetector") 
                detector[#detector] = 0
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