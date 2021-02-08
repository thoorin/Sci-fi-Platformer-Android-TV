-----------------------------------------------------------------------------------------
--
-- creator.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local mainGroup = display.newGroup()
local playerGroup = display.newGroup()
local frontGroup = display.newGroup()
local backGroup = display.newGroup()
local middleGroup = display.newGroup()
local selectGroup = display.newGroup()
local enemyTimers = {}
local enemyArray = {}
local detectorsAndEnemies = {}
local g
local composer = require("composer")

local particleArray = {}
local blocksArray = {}
local en = require("environment")
local spriteSheets = require("spriteSheets")
local json = require( "json" )

local poisonImpact = audio.loadSound( "poison_impact.mp3" )
local tankShoot = audio.loadSound( "tank_shoot.mp3" ) 
local larvaEmergeSound = audio.loadSound( "larva_emerging3.mp3" )
local wrongSound = audio.loadSound( "wrong.mp3" )
local filePath = system.pathForFile( "flash.json" )
local filePath1 = system.pathForFile( "water_splash.json" )
local f = io.open( filePath, "r" )
local f1 = io.open( filePath1, "r" )
local emitterData = f:read( "*a" )
local emitterData1 = f1:read( "*a" )
f:close()
f1:close()
local emitterParams = json.decode( emitterData )
local emitterParams1 = json.decode( emitterData1 )

M.setGame = function( game )
    g = game
end

M.createBackground = function()
    local background = display.newImageRect( backGroup, en.getBackground(), 1066, 488)
    --display.contentHeight, display.contentHeight
    background.myName = "background"
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    return background
end

M.createMovableCrate = function( x, y)
    local block = display.newImageRect(mainGroup,"crate.png",32,32)
    block.myName = "block"
    block.x = x
    block.y = y
    physics.addBody( block, "dynamic", {density=1.0, friction=0.5, bounce=0.3} )
    block.hittable = true
    table.insert( blocksArray, block )
end

M.block = function(block, x, y)
    block.myName = "block"
    block.x = x
    block.y = y
    physics.addBody( block, "kinematic", {bounce = 0 } )
    block.hittable = true
    table.insert( blocksArray, block )
end

M.blockSensor = function(block, x, y)
    block.myName = "blockU"
    block.x = x
    block.y = y
    physics.addBody( block, "kinematic", {isSensor = true} )
    table.insert( blocksArray, block )
end

M.createBlockTop = function( x,y ) 
    local block = display.newImageRect(mainGroup, en.getBlockTop(), 32, 32 )
    M.block(block, x,y)
end

M.createBlockEndTop = function( x, y )
    local block = display.newImageRect(mainGroup, en.getBlockEndTop(), 32, 32 )
    M.block(block, x,y)
end

M.createBlockStartTop = function( x, y )
    local block = display.newImageRect(mainGroup, en.getBlockStartTop(), 32, 32 )
    M.block(block, x,y)
end

M.createBlockStart = function(x,y)
    local block = display.newImageRect(mainGroup, en.getBlockStart(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockEnd = function( x, y)
    local block = display.newImageRect(mainGroup, en.getBlockEnd(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockStartBack = function(x,y)
    local block = display.newImageRect(middleGroup, en.getBlockStart(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockEndBack = function( x, y)
    local block = display.newImageRect(middleGroup, en.getBlockEnd(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockBottomStart = function( x, y)
    local block = display.newImageRect(mainGroup, en.getBlockBottomStart(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockBottomStartEdge = function( x, y)
    local block = display.newImageRect(mainGroup, en.getBlockBottomStartEdge(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockBottomEnd = function( x, y)
    local block = display.newImageRect(mainGroup, en.getBlockBottomEnd(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockBottomEndEdge = function( x, y)
    local block = display.newImageRect(mainGroup, en.getBlockBottomEndEdge(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlock = function( x, y)
    local block = display.newImageRect(mainGroup, en.getBlock(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createBlockBack = function( x, y)
    local block = display.newImageRect(middleGroup, en.getBlock(), 32, 32 )
    M.blockSensor(block, x,y)
end

M.createCrate = function( x, y)
    local crate = display.newImageRect(mainGroup, "Crate.png", 32, 32 )
    M.block(crate,x,y)
end

M.createCrateBack = function( x, y)
    local crate = display.newImageRect(middleGroup, "Crate.png", 32, 32 )
    M.block(crate,x,y)
end


M.createObject = function(obj, x, y, scaleX, scaleY)
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    physics.addBody( obj, "kinematic", {isSensor = true} )
    obj:scale(scaleX,scaleY)
    table.insert( blocksArray, obj )
end

M.createArrowRight = function( x, y)
    local obj = display.newImageRect(selectGroup, "arrow.png", 64, 64 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj.fill.effect = "filter.contrast"
    obj.rotation = 90
 
    obj.fill.effect.contrast = 1.3
    local function onObjectTap( event )
        composer.setVariable("env",composer.getVariable("env")+1) 
        createMap(composer.getVariable("env"))
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createArrowLeft = function( x, y)
    local obj = display.newImageRect(selectGroup, "arrow.png", 64, 64 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj.fill.effect = "filter.contrast"
    obj.rotation = 270

    obj.fill.effect.contrast = 1.3
    local function onObjectTap( event ) 
        composer.setVariable("env",composer.getVariable("env")-1) 
        createMap(composer.getVariable("env"))
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createCactus = function( x, y)
    local obj = display.newImageRect(selectGroup, "Cactus.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj:scale(4,4)
    obj.fill.effect = "filter.contrast"
 
    obj.fill.effect.contrast = 1.3
    local function onObjectTap( event )   
        composer.gotoScene( "level" )
        composer.removeScene("map", true)
        composer.setVariable( "lvl", obj[#obj] )
        audio.play(clickSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end


M.createCurrentCactus = function( x, y)
    local obj = display.newImageRect(selectGroup, "Cactus.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj:scale(4,4)
    obj.fill.effect = "filter.desaturate"
    obj.fill.effect.intensity = 0.25
    local function onObjectTap( event )   
        composer.gotoScene( "level" )
        composer.removeScene("map", true)
        composer.setVariable( "lvl", obj[#obj] )
        audio.play(clickSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createClosedCactus = function( x, y)
    local obj = display.newImageRect(selectGroup, "Cactus.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj.fill.effect = "filter.grayscale"
    obj:scale(4,4)
    local function onObjectTap( event )   
        audio.play(wrongSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createTree = function( x, y)
    local obj = display.newImageRect(selectGroup, "Tree_2.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj:scale(4,4)
    obj.fill.effect = "filter.contrast"

 
    obj.fill.effect.contrast = 1.3
    local function onObjectTap( event )   
        composer.gotoScene( "level" )
        composer.removeScene("map", true)
        composer.setVariable( "lvl", obj[#obj] )
        audio.play(clickSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createCurrentTree = function( x, y)
    local obj = display.newImageRect(selectGroup, "Tree_2.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj:scale(4,4)
    obj.fill.effect = "filter.desaturate"
    obj.fill.effect.intensity = 0.25
    local function onObjectTap( event )   
        composer.gotoScene( "level" )
        composer.removeScene("map", true)
        composer.setVariable( "lvl", obj[#obj] )
        audio.play(clickSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createClosedTree = function( x, y)
    local obj = display.newImageRect(selectGroup, "Tree_2.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj.fill.effect = "filter.grayscale"
    obj:scale(4,4)
    local function onObjectTap( event )   
        audio.play(wrongSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createScroll = function( x, y)
    local obj = display.newImageRect(selectGroup, "scroll.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj:scale(4,4)
    obj.fill.effect = "filter.contrast"

 
    obj.fill.effect.contrast = 1.3
    local function onObjectTap( event )   
        composer.gotoScene( "credits" )
        composer.removeScene("map", true)
        audio.play(clickSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createBook = function( x, y)
    local obj = display.newImageRect(selectGroup, "book.png", 32, 32 )
    obj.myName = "obj"
    obj.x = x
    obj.y = y
    obj.isSensor = true
    obj:scale(4,4)
    obj.fill.effect = "filter.contrast"

 
    obj.fill.effect.contrast = 1.3
    local function onObjectTap( event )   
        composer.gotoScene( "level" )
        composer.removeScene("map", true)
        composer.setVariable( "lvl", 0 )
        audio.play(clickSound)
        return true
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createMapElement = function( x, y, state)
    local env = composer.getVariable("env");
    if (env == 0) then
        if (state == "tutorial") then
            return M.createBook(x, y)
        else 
            return M.createScroll(x, y)
        end
    elseif (env == 1) then
        if (state == "played") then
            return M.createTree( x, y )
        elseif (state == "current") then
            return M.createCurrentTree( x, y )
        else
            return M.createClosedTree( x, y )
        end
    else
        if (state == "played") then
            return M.createCactus( x, y )
        elseif (state == "current") then
            return M.createCurrentCactus( x, y )
        else
            return M.createClosedCactus( x, y )
        end
    end
end

M.createTree1 = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree_2.png", 32, 32 )
    M.createObject(obj,x,y-79,4,4)
end

M.createStump = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree_1.png", 32, 32 )
    M.createObject(obj,x,y-27,1.5,0.75)
end

M.createSmallStump = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree_1.png", 32, 32 )
    M.createObject(obj,x,y-22,1,0.5)
end

M.createSmallTree1 = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree_2.png", 32, 32 )
    M.createObject(obj,x,y-64,3,3)
end

M.createTree2 = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree_3.png", 32, 32 )
    M.createObject(obj,x,y-79,4,4)
end

M.createSmallTree2 = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree_3.png", 32, 32 )
    M.createObject(obj,x,y-64,3,3)
end

M.createStone = function( x, y)
    local obj = display.newImageRect(frontGroup,  en.getStone(), 32, 32 )
    M.createObject(obj,x,y-20,1,0.5)
end

M.createBigStone = function( x, y)
    local obj = display.newImageRect(frontGroup,  en.getStone(), 32, 32 )
    M.createObject(obj,x,y-20,1.5,0.75)
end

M.createDesertBush1 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Bush1.png", 72, 44 )
    M.createObject(obj,x,y-35,1,1)
end

M.createDesertBush2 = function( x, y)
    local obj = display.newImageRect(backGroup, "Bush2.png", 65, 37 )
    M.createObject(obj,x,y-35,1,1)
end

M.createBush1 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Bush (1).png", 32, 32 )
    M.createObject(obj,x,y-20,1,0.5)
end

M.createBigBush1 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Bush (1).png", 32, 32 )
    M.createObject(obj,x,y-23,1.6,0.8)
end

M.createBush2 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Bush (2).png", 32, 32 )
    M.createObject(obj,x,y-20,1,0.5)
end

M.createBush3 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Bush (3).png", 32, 32 )
    M.createObject(obj,x,y-20,1.5,0.75)
end

M.createBush4 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Bush (4).png", 32, 32 )
    M.createObject(obj,x,y-20,1.5,0.5)
end

M.createMushroom1 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Mushroom_1.png", 32, 32 )
    M.createObject(obj,x,y-20,0.5,0.4)
end

M.createSign1 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Sign_1.png", 32, 32 )
    M.createObject(obj,x,y-32,1,1)
end

M.createSign2 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Sign_2.png", 32, 32 )
    obj.myName = "sign"
    obj.x = x
    obj.y = y-26
    physics.addBody( obj, "kinematic", {bounce = 0 } )
    obj.isSensor = true
    table.insert( blocksArray, obj )
    M.createEnd(x,y)
end

M.createFlower = function( x, y)
    local obj = display.newImageRect(frontGroup, "Asset 14.png", 32, 32 )
    M.createObject(obj,x,y-20,0.5,0.5)
end

M.createFlowerReverse = function( x, y)
    local obj = display.newImageRect(frontGroup, "Asset 14.png", 32, 32 )
    obj:scale(-1,1)
    M.createObject(obj,x,y-20,0.5,0.5)
end

M.createDesertTree = function( x, y)
    local obj = display.newImageRect(mainGroup, "Tree.png", 156, 130 )
    M.createObject(obj,x,y-81,1,1)
end

M.createSkeleton = function( x, y)
    local obj = display.newImageRect(frontGroup, "Skeleton.png", 96, 32 )
    M.createObject(obj,x,y-25,1,1)
end

M.createGrass1 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Grass1.png", 64, 32 )
    M.createObject(obj,x,y-32,1,1)
end

M.createGrass2 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Grass2.png", 64, 32 )
    M.createObject(obj,x,y-32,1,1)
end

M.createGrass2Back = function( x, y)
    local obj = display.newImageRect(backGroup, "Grass2.png", 64, 32 )
    M.createObject(obj,x,y-32,1,1)
end

M.createCactus1 = function( x, y)
    local obj = display.newImageRect(mainGroup, "Cactus.png", 64, 64 )
    M.createObject(obj,x,y-48,1,1)
end

M.createCactus2 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Cactus2.png", 35, 27 )
    M.createObject(obj,x,y-30,1,1)
end

M.createCactus3 = function( x, y)
    local obj = display.newImageRect(mainGroup, "Cactus3.png", 64, 62 )
    M.createObject(obj,x,y-47,1,1)
end

M.createShip = function( x, y)
    local ship = display.newImageRect(frontGroup, "ship.png", 160, 160 )
    ship.myName = "ship"
    ship.x = x
    ship.y = y-55
    physics.addBody( ship, "kinematic", {bounce = 0 } )
    ship.isSensor = true
    ship.hittable = true
    table.insert( blocksArray, ship )
    M.createEnd(x-200,y)
end

M.createWater = function( x, y)
    local obj = display.newSprite(mainGroup, spriteSheets.getWaterSheet(), spriteSheets.getWaterSequences() )
    obj.myName = "water"
    obj.x = x
    obj.y = y+38
    local scaleX,scaleY = 1,0.2;
    obj:scale(scaleX,scaleY)
    local nw, nh = obj.width*scaleX*0.5, obj.height*scaleY*0.5;
    physics.addBody( obj, "kinematic",{ density = 2.5, bounce = 0, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} })
    obj.isSensor = true
    obj:play()
    obj.objectType = "sprite"
    table.insert( blocksArray, obj )
end


M.createTigerBeetle = function( x, y)
    local obj = display.newSprite(frontGroup, spriteSheets.getLarvaEmergeSheet(), spriteSheets.getLarvaSequences() )
    obj.myName = "hiddenLarva"
    obj.x = x
    obj.y = y-25
    --local nw, nh = obj.width*scaleX*0.5, obj.height*scaleY*0.5;
    --physics.addBody( obj, "kinematic",{ density = 2.5, bounce = 0, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} })
    physics.addBody( obj, "kinematic" )
    obj.isSensor = true
    obj:addEventListener( "sprite", g.spriteListenerLarva )
    obj.hittable = false
    obj.objectType = "sprite"

    local emerge = false
    local timerLarva
    timerLarva = timer.performWithDelay(10,function() 
        if (obj.myName == "hiddenLarva")then 
            if (obj.x < display.screenOriginX+750 and emerge == false) then 
                obj:play(); emerge = true 
                obj.myName = "larva"
                obj.hittable = true
                audio.play(larvaEmergeSound)
            elseif (emerge == true or g.getGame() == false) then
                timer.cancel(timerLarva)
            end 
        end
    end,0)
    obj.timerEmerge = timerLarva

    table.insert( obj, false)
    table.insert( blocksArray, obj )
    table.insert( enemyArray, obj )
end


M.createMovingBlock = function( x, y, delay )
    local block = display.newImageRect(mainGroup, en.getMovingBlock(), 64, 32 )
    block.myName = "blockMoving"
    block.x = x
    block.y = y
    physics.addBody( block, "dynamic", { density = 10, bounce = 0 } )
    block.gravityScale = 0
    block.isFixedRotation = true
    block.hittable = true
    block.direction = "left"
    block.blockTimer = timer.performWithDelay(delay, function() 
        local vx,vy = block:getLinearVelocity()
        block:setLinearVelocity(vx-100, 0)
    end)
    block.contacted = false
    
    table.insert( blocksArray, block )

end

M.explosion = function(x, y, scaleX, scaleY)
    local explosion = display.newSprite( frontGroup, spriteSheets.getExplosionSheet(), spriteSheets.getExplosionSequences())
    explosion.x = x
    explosion.y = y
    explosion.myName = "explosion"
    explosion:play()
    explosion:addEventListener( "sprite", g.spriteListenerSmokeExplosion )
    explosion.rotation = 270
    explosion:scale(scaleX,scaleY)
    explosion.isPlaying = true
    explosion.objectType = "sprite"

    return explosion
end

M.biggerExplosion = function(x,y,scaleX,scaleY)
    local explosion = M.explosion(x,y,scaleX,scaleY)
    physics.addBody( explosion, "kinematic")
    explosion.isSensor = true
    if (g.getStopped() == true) then
        explosion:setLinearVelocity(0, 0)
    else
        explosion:setLinearVelocity(-160, 0)
    end
    table.insert(blocksArray,explosion)
end

M.createExplosion = function(x,y)
    M.explosion(x, y - 100, 0.75, 0.75)
end


M.createExplosionTank = function(x,y)
    local explosion = M.biggerExplosion(x, y - 70, 0.75, 1.5)
end

M.createShootFlash = function( x,y,vy )
    local flash = display.newImageRect(frontGroup, "shoot.png", 50, 32 )
    flash.myName = "flash"
    flash.x = x
    flash.y = y

    physics.addBody( flash, "kinematic")
    flash:setLinearVelocity(0,vy)
    flash.isSensor = true
    timer.performWithDelay(100,function() display.remove(flash) end)
end

M.createFlash = function( x,y )
    local flash = display.newEmitter( emitterParams)
    flash.myName = "flash"
    flash.x = x
    flash.y = y
    frontGroup:insert(flash)

    physics.addBody( flash, "kinematic")
    flash.isSensor = true
    local vx = -160
    if (g.getStopped()) then vx = 0 end
    flash:setLinearVelocity(vx,0)
    timer.performWithDelay(200,function() flash.isVisible = false end)
    --transition.moveBy( flash, { x=-160, y=0, time=360 } )     
    table.insert(blocksArray,flash)
    flash.objectType = "emitter"
    --physics.addBody( flash, "kinematic")
end

M.createWaterSplash = function( x,y )
    local splash = display.newEmitter( emitterParams1)
    splash.myName = "splash"
    splash.x = x
    splash.y = y
    middleGroup:insert(splash)  
    physics.addBody( splash, "kinematic")
    splash.isSensor = true
    local vx = -160
    if (g.getStopped()) then vx = 0 end
    splash:setLinearVelocity(vx,0)
    table.insert(blocksArray,splash)
    splash.objectType = "emitter"

    return splash  
end

M.projectile = function(x, y, projectile, name, destroyTime, rot, vx)
    projectile.x = x
    projectile.y = y
    projectile.myName = name
    physics.addBody( projectile, "dynamic")
    projectile.gravityScale = 0
    local projectileDestroyTimer = timer.performWithDelay(destroyTime, function()   
        local index = table.indexOf(blocksArray,projectile) 
        table.remove(blocksArray,index)
        display.remove(projectile)
    end)
    projectile.rotation = rot
    projectile.isFixedRotation = true
    projectile:setLinearVelocity( vx, 0)
    projectile.destroyTimer = projectileDestroyTimer
    table.insert(blocksArray,projectile)
end

M.createBullet = function( x,y )
    local bullet = display.newSprite( mainGroup, spriteSheets.getBulletSheet(), spriteSheets.getBulletSequences())
    M.projectile(x+15,y,bullet,"bullet",1450,90,400)
    audio.play( fireSound, {channel = 0})
    bullet:play()
    bullet.objectType = "sprite"
end

M.createShell = function( x,y )
    local shell = display.newImageRect(mainGroup, "shell.png", 15, 8 )
    M.projectile(x,y,shell,"shell",1800,180,-600)
    shell.isSensor = true
end

M.createShellImpact = function( x,y )
    local impact = M.biggerExplosion(x,y,0.4,0.6)
end

M.createPoison = function( x,y )
    local poison = display.newSprite( frontGroup, spriteSheets.getPoisonSheet(), spriteSheets.getPoisonSequences())
    M.projectile(x,y,poison,"poison",2200,0,-500)
    audio.play( fireSound, {channel = 0})
    poison:play()
    poison.isSensor = true
    poison.objectType = "sprite"
end

M.createPoisonImpact = function( x,y )
    local impact = display.newSprite( frontGroup, spriteSheets.getPoisonImpactSheet(), spriteSheets.getPoisonImpactSequences())
    impact.x = x
    impact.y = y
    if (impact.x > 0 and impact.x < 800) then
        audio.play(poisonImpact)
    end
    impact.myName = "poisonImpact"
    physics.addBody( impact, "kinematic")
    impact.isSensor = true
    impact:play()
    --impact:addEventListener( "sprite", g.spriteListenerSmokeExplosion )
    table.insert(blocksArray,impact)
    impact.objectType = "sprite"
    if (g.getStopped() == false) then impact:setLinearVelocity(-160,0) end
end

M.smoke = function(smoke, x, y, vx, scaleX, scaleY)
    smoke.x = x
    smoke.y = y
    smoke:scale(scaleX,scaleY)
    smoke.myName = "smoke"
    physics.addBody( smoke, "kinematic")
    smoke:play()
    smoke:setLinearVelocity( vx, 0)
    smoke.isSensor = true
    smoke:addEventListener( "sprite", g.spriteListenerSmokeExplosion )
    table.insert(blocksArray,smoke)
    smoke.objectType = "sprite"
end

M.createSmoke = function( x,y )
    local smoke = display.newSprite( mainGroup, spriteSheets.getSmokeSheet(), spriteSheets.getSmokeSequences() )
    M.smoke(smoke, x+15, y, -220, 0.5, 0.5)
    smoke.rotation = 180
end

M.createSmokes = function( x,y )
    local smoke = display.newSprite( backGroup, spriteSheets.getSmokesSheet(), spriteSheets.getSmokesSequences() )
    M.smoke(smoke, x-65, y-18, -160, 0.1, 0.1)
end

M.createPlayer = function(y)
    local player = display.newSprite( playerGroup, spriteSheets.getPlayerSheet(), spriteSheets.getPlayerSequences() )
    player.x = composer.getVariable("playerStartingPosition")
    player.y = y
    local nw, nh = player.width*0.25, player.height*0.25;
    --
    physics.addBody( player, "dynamic", {bounce = 0,density = 0, shape={-nw,-nh,nw-20,-nh,nw-20,nh,-nw,nh} })
    player.isFixedRotation = true
    player.myName = "player"
    player:play()
    player:scale(0.5,0.5)


    --M.createDeleter(50, y)
    return player
end


M.createEnemy = function( x, y)
    local enemy = display.newSprite( frontGroup, spriteSheets.getOrkStartSheet(), spriteSheets.getOrkSequences() )
    local direction = "left"
    enemy.x = x
    enemy.y = y-47
    physics.addBody( enemy, "kinematic", {bounce = 0 } )
    enemy.isSensor = true
    enemy.isFixedRotation = true
    enemy.myName = "enemy"
    enemy:scale(-1,1)
    enemy.hittable = true
    enemy:play()
    enemy.objectType = "sprite"

    enemy:addEventListener( "sprite", g.spriteListenerEnemy )
    local leftDetector = display.newRect( frontGroup, x-30, enemy.y+50, 10, 10 )
    leftDetector.myName = "detectorL"
    leftDetector.isFixedRotation = true
    physics.addBody( leftDetector, "dynamic", {bounce = 0 } )
    leftDetector.isSensor = true
    leftDetector.gravityScale = 0
    leftDetector.isVisible = false

    local rightDetector = display.newRect( frontGroup, x+20, enemy.y+50, 10, 10 )
    rightDetector.myName = "detectorR"
    rightDetector.isFixedRotation = true
    physics.addBody( rightDetector, "dynamic", {bounce = 0 } )
    rightDetector.isSensor = true
    rightDetector.gravityScale = 0
    rightDetector.isVisible = false

    table.insert(detectorsAndEnemies,leftDetector)
    table.insert(detectorsAndEnemies,enemy)
    table.insert(detectorsAndEnemies,rightDetector)
    table.insert(detectorsAndEnemies,0)
    table.insert(detectorsAndEnemies,0)
    
    local speed = 30

    enemy:setLinearVelocity( -speed, 0)
    leftDetector:setLinearVelocity( -speed, 0)
    rightDetector:setLinearVelocity( -speed, 0)

    table.insert( blocksArray, enemy )
    table.insert( blocksArray, rightDetector )
    table.insert( blocksArray, leftDetector )


    --enemy.timer = timer.performWithDelay(500, function() if (enemy.x < 1000) then enemy:play() end end, 0);
end

M.createFrog = function( x, y)
    local enemy = display.newSprite( frontGroup, spriteSheets.getFrogSheet(), spriteSheets.getFrogSequences() )
    enemy.x = x
    enemy.y = y-47
    physics.addBody( enemy, "kinematic", {bounce = 0 } )
    enemy.isSensor = true
    enemy.isFixedRotation = true
    enemy.hittable = true
    enemy.myName = "frog"
    enemy:addEventListener( "sprite", g.spriteListenerFrog )
    enemy:play()
    enemy.objectType = "sprite"

    local jumpDetector = display.newRect( frontGroup, x-140, enemy.y+50, 10, 10 )
    jumpDetector.myName = "jumpDetector"
    jumpDetector.isFixedRotation = true
    physics.addBody( jumpDetector, "dynamic", {bounce = 0 } )
    jumpDetector.isSensor = true
    jumpDetector.gravityScale = 0
    jumpDetector.isVisible = false
    table.insert(jumpDetector,0)

    table.insert(enemy,0)
    table.insert(enemy,jumpDetector)

    enemy:setLinearVelocity( 0, 0)

    table.insert( blocksArray, enemy )
    table.insert( blocksArray, jumpDetector )

    --enemy.timer = timer.performWithDelay(500, function() if (enemy.x < 800) then enemy:play() end end, 0);
end

M.createEnd = function( x,y )
    local obj = display.newRect( frontGroup, x, y, 1,1000 )
    obj.x = x
    obj.y = y
    physics.addBody( obj, "kinematic", {bounce = 0 } )
    obj.isSensor = true
    table.insert(blocksArray,obj)
    obj.isVisible = false
    obj.myName = "end"
end

M.createDeleter = function( x,y )
    local deleter = display.newRect( frontGroup, x, y, 1,1000 )
    deleter.x = x
    deleter.y = y
    physics.addBody( deleter, "dynamic", {bounce = 0 } )
    deleter.gravityScale = 0
    deleter.isSensor = true
    deleter.myName = "deleter"
end

M.createEnemyTank = function( x, y)
    local enemy = display.newImageRect(backGroup, "tank.png", 128, 88 )
    enemy.x = x
    enemy.y = y-45
    physics.addBody( enemy, "kinematic", {bounce = 0 } )
    enemy.isSensor = true
    enemy.isFixedRotation = true
    enemy.myName = "tank"
    enemy.hittable = true

    local function shoot( event )
        if (enemy.x < 1400) then
            audio.play(tankShoot)
            M.createSmoke(enemy.x-90, enemy.y+5)
            M.createShell(enemy.x-70, enemy.y+5)
        end
        if (enemy.x < 0) then
            timer.cancel(event.source)
        end
    end

    local enemyTimer = timer.performWithDelay( 3300, shoot, 0 )
    table.insert( enemy, enemyTimer)
    table.insert( enemyTimers, enemyTimer)
    table.insert( enemy, 2)

    table.insert( blocksArray, enemy )
end

M.createSpike = function( x, y)
    local obj = display.newSprite(frontGroup, spriteSheets.getSpikeSheet(), spriteSheets.getSpikeSequences() )
    obj:scale(0.25,0.25)
    obj.myName = "spike"
    local nw, nh = obj.width*0.1, obj.height*0.02
    physics.addBody( obj, "kinematic",{ density = 2.5, bounce = 0, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} })
    obj.x = x-35
    obj.y = y
    obj.rotation = 270
    obj.isSensor = true
    obj.objectType = "sprite"
    table.insert( blocksArray, obj )
end

M.createLandMine = function( x, y)
    local obj = display.newImageRect(frontGroup, "land_mine.png", 24, 20 )
    obj.myName = "mine"
    obj.x = x
    obj.y = y-15
    local nw, nh = obj.width*0.05, obj.height*0.25
    physics.addBody( obj, "kinematic", {bounce = 0, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh}  } )

    obj.isSensor = true
    table.insert( blocksArray, obj )
end

M.createTouch = function()
    local leftX = display.contentWidth-display.actualContentWidth*0.65
    local left = display.newImageRect(frontGroup, "touch.png", 105, 140 )
    left.myName = "touch"
    left.x = leftX
    left.y = 200
    left.isSensor = true

    local text = display.newText(frontGroup,"      Touch left half \nof the screen to jump",leftX,300,"ethnocentric rg.ttf", 30, "center")
    text:setFillColor(0,0,0.2);
    scaleFactor = display.actualContentWidth/display.actualContentHeight/1.94
    text:scale(scaleFactor,scaleFactor)

    local leftGroup = display.newGroup();
    leftGroup:insert(left)
    leftGroup:insert(text)
    leftGroup.alpha = 0

    transition.fadeIn(leftGroup, { time = 1400});
    transition.fadeOut(leftGroup,{ time = 1400, delay = 6500});

    local rightX = display.contentWidth-display.actualContentWidth*0.35
    local right = display.newImageRect(frontGroup, "touch.png", 105, 140 )
    right.myName = "touch"
    right.x = rightX
    right.y = 200
    right.isSensor = true

    local textRight = display.newText(frontGroup,"      Touch right half \nof the screen to shoot",rightX,300,"ethnocentric rg.ttf", 30, "center")
    textRight:setFillColor(0,0,0.2);
    textRight:scale(scaleFactor,scaleFactor)

    local rightGroup = display.newGroup();
    rightGroup:insert(right)
    rightGroup:insert(textRight)
    rightGroup.alpha = 0

    transition.fadeIn(rightGroup, { time = 1400, delay = 8000});
    transition.fadeOut(rightGroup,{ time = 1400, delay = 14500});
end

M.getMainGroup = function()
    return mainGroup
end

M.getPlayerGroup = function()
    return playerGroup
end

M.getMiddleGroup = function()
    return middleGroup
end

M.getPlayer = function()
    return playerGroup
end

M.getBackGroup = function()
    return backGroup
end

M.getFrontGroup = function()
    return frontGroup
end

M.getBlocksArray = function()
    return blocksArray
end

M.cancelEnemyTimers = function()
    for i in ipairs(enemyTimers) do
        timer.cancel(enemyTimers[i])
    end
end

M.getTrollChannel = function()
    return trollWalkChannel
end

M.getEnemyArray = function()
    return enemyArray
end

M.getDetectorsAndEnemies = function()
    return detectorsAndEnemies
end

M.destroyBlocks = function()
    for i in ipairs(blocksArray) do display.remove(blocksArray[i]) end
    blocksArray = {}
end

M.deleteDetectors = function()
    for i in ipairs(detectorsAndEnemies) do if (type(detectorsAndEnemies[i]) ~= 'number') then
        detectorsAndEnemies[i]:removeSelf() else
        detectorsAndEnemies[i]=0
    end
    end
    detectorsAndEnemies = {}
end

M.deleteDetector = function(leftDetector,rightDetector)
    table.remove(detectorsAndEnemies, table.indexOf(detectorsAndEnemies,leftDetector))
    table.remove(detectorsAndEnemies, table.indexOf(detectorsAndEnemies,rightDetector))
    table.remove(blocksArray, table.indexOf(blocksArray,leftDetector))
    table.remove(blocksArray, table.indexOf(blocksArray,rightDetector))
end

M.deleteEnemyArray = function()
    enemyArray = {}
end

M.deleteMiddleGroup = function()
    middleGroup:removeSelf()
end

M.deleteFromEnemyArray = function(toDelete)
    local index = table.indexOf(enemyArray,toDelete)
    table.remove( enemyArray, index )
end

M.deleteBackground = function()
    background.removeSelf()
end

M.setTrollWalk = function( val)
    trollWalkPlaying = val
end


M.getTrollWalk = function( val)
    return trollWalkPlaying
end

M.printBlocks = function()
    for i in ipairs(blocksArray) do print(blocksArray[i]) end
end





return M