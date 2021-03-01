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

local g
local composer = require("composer")

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

    background.myName = "background"
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    return background
end

M.block = function(block, x, y)
    block.myName = "block"
    block.x, block.y = x, y
    physics.addBody( block, "kinematic", {bounce = 0 } )
    block.hittable = true
    table.insert( blocksArray, block )
end

M.blockSensor = function(block, x, y)
    block.myName = "blockU"
    block.x, block.y = x, y
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

local function createArrow( x, y, sign)
    local obj = display.newImageRect(selectGroup, "arrow.png", 64, 64 )
    obj.myName = "obj"
    obj.x, obj.y = x, y
    obj.isSensor = true
    obj.fill.effect = "filter.contrast"
    obj.rotation = 180 + 90 * sign * - 1
    obj.fill.effect.contrast = 1.3

    local function onObjectTap( event )
        composer.setVariable("env",composer.getVariable("env")+sign) 
        createMap(composer.getVariable("env"))
    end
    obj:addEventListener( "tap", onObjectTap )
    return obj
end

M.createArrowRight = function( x, y)
    return createArrow(x,y,1)
end

M.createArrowLeft = function( x, y)
    return createArrow(x,y,-1)
end

local function mapElement( x, y, obj, filter, elementType)
    obj.myName = "obj"
    obj.x, obj.y = x, y
    obj.isSensor = true
    obj:scale(4,4)

    obj.fill.effect = filter

    if (filter == "filter.contrast") then
        obj.fill.effect.contrast = 1.3
    else 
        obj.fill.effect.intensity = 0.25
    end

    local function onObjectTap( event )   
        if (elementType == "closed") then
            audio.play(wrongSound)
        else
            composer.removeScene("map", true)
            audio.play(clickSound)

            if (elementType == "credits") then
                composer.gotoScene( "credits" )
            else
                composer.gotoScene( "level" )
                local lvl = elementType == "tutorial" and 0 or obj[#obj]
                composer.setVariable( "lvl", lvl )
            end 
        end
        return true
    end
    obj:addEventListener( "tap", onObjectTap )

    return obj
end

local function createClosedTree( x, y)
    local obj = display.newImageRect(selectGroup, "Tree_2.png", 32, 32 )
    return mapElement( x, y, obj, "filter.grayscale", "closed")
end

local function createClosedCactus( x, y)
    local obj = display.newImageRect(selectGroup, "Cactus.png", 32, 32 )
    return mapElement( x, y, obj, "filter.grayscale", "closed")
end

local function createBook( x, y)
    local obj = display.newImageRect(selectGroup, "book.png", 32, 32 )
    return mapElement( x, y, obj, "filter.contrast", "tutorial")
end

local function createScroll( x, y)
    local obj = display.newImageRect(selectGroup, "scroll.png", 32, 32 )
    return mapElement( x, y, obj, "filter.contrast", "credits")
end

local function createCactus( x, y)
    local obj = display.newImageRect(selectGroup, "Cactus.png", 32, 32 )
    return mapElement( x, y, obj, "filter.contrast", "level")
end

local function createCurrentCactus( x, y)
    local obj = display.newImageRect(selectGroup, "Cactus.png", 32, 32 )
    return mapElement( x, y, obj, "filter.desaturate", "level")
end

local function createTree( x, y)
    local obj = display.newImageRect(selectGroup, "Tree_2.png", 32, 32 )
    return mapElement( x, y, obj, "filter.contrast", "level")
end

local function createCurrentTree( x, y)
    local obj = display.newImageRect(selectGroup, "Tree_2.png", 32, 32 )
    return mapElement( x, y, obj, "filter.desaturate", "level")
end

M.createMapElement = function( x, y, state)
    local env = composer.getVariable("env");
    if (env == 0) then
        if (state == "tutorial") then
            return createBook(x, y)
        else 
            return createScroll(x, y)
        end
    elseif (env == 1) then
        if (state == "played") then
            return createTree( x, y )
        elseif (state == "current") then
            return createCurrentTree( x, y )
        else
            return createClosedTree( x, y )
        end
    else
        if (state == "played") then
            return createCactus( x, y )
        elseif (state == "current") then
            return createCurrentCactus( x, y )
        else
            return createClosedCactus( x, y )
        end
    end
end

M.createObject = function(obj, x, y, scaleX, scaleY)
    obj.myName = "obj"
    obj.x, obj.y = x, y
    physics.addBody( obj, "kinematic", {isSensor = true} )
    obj:scale(scaleX,scaleY)
    table.insert( blocksArray, obj )
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

local function createEnd( x,y )
    local obj = display.newRect( frontGroup, x, y, 1,1000 )
    obj.x, obj.y = x, y
    physics.addBody( obj, "kinematic", {bounce = 0 } )
    obj.isSensor = true
    table.insert(blocksArray,obj)
    obj.isVisible = false
    obj.myName = "end"
end

M.createSign2 = function( x, y)
    local obj = display.newImageRect(frontGroup, "Sign_2.png", 32, 32 )
    obj.myName = "sign"
    obj.x, obj.y = x, y-26
    physics.addBody( obj, "kinematic", {bounce = 0 } )
    obj.isSensor = true
    table.insert( blocksArray, obj )
    createEnd(x,y)
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
    ship.x, ship.y = x, y-55
    physics.addBody( ship, "kinematic", {bounce = 0 } )
    ship.isSensor, ship.hittable = true, true
    table.insert( blocksArray, ship )
    createEnd(x-200,y)
end

M.createWater = function( x, y)
    local obj = display.newSprite(mainGroup, spriteSheets.getWaterSheet(), spriteSheets.getWaterSequences() )
    obj.myName = "water"
    obj.x, obj.y = x, y+38
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
    obj.x, obj.y = x, y-25
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
                obj:play() 
                emerge = true 
                obj.myName = "larva"
                obj.hittable = true
                audio.play(larvaEmergeSound)
            elseif (emerge or g.getGame() == false) then
                timer.cancel(timerLarva)
            end 
        end
    end,0)
    obj.timerEmerge = timerLarva

    table.insert( blocksArray, obj )
end


M.createMovingBlock = function( x, y, delay )
    local block = display.newImageRect(mainGroup, en.getMovingBlock(), 64, 32 )
    block.myName = "blockMoving"
    block.x, block.y = x, y
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

local function explosion(x, y, scaleX, scaleY)
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

local function biggerExplosion(x,y,scaleX,scaleY)
    local explosion = explosion(x,y,scaleX,scaleY)
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
    explosion(x, y - 100, 0.75, 0.75)
end

M.createExplosionTank = function(x,y)
    local explosion = biggerExplosion(x, y - 70, 0.75, 1.5)
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

local function projectile(x, y, projectile, name, destroyTime, rot, vx)
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
    projectile(x+15,y,bullet,"bullet",1450,90,400)
    audio.play( fireSound, {channel = 0})
    bullet:play()
    bullet.objectType = "sprite"
end

local function createShell( x,y )
    local shell = display.newImageRect(mainGroup, "shell.png", 15, 8 )
    projectile(x,y,shell,"shell",1800,180,-600)
    shell.isSensor = true
end

M.createShellImpact = function( x,y )
    local impact = biggerExplosion(x,y,0.4,0.6)
end

M.createPoison = function( x,y )
    local poison = display.newSprite( frontGroup, spriteSheets.getPoisonSheet(), spriteSheets.getPoisonSequences())
    projectile(x,y,poison,"poison",2200,0,-500)
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

local function createSmoke( x,y )
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
    player.x, player.y = composer.getVariable("playerStartingPosition"), y
    local nw, nh = player.width*0.25, player.height*0.25;

    physics.addBody( player, "dynamic", {bounce = 0,density = 0, shape={-nw,-nh,nw-20,-nh,nw-20,nh,-nw,nh} })
    player.isFixedRotation = true
    player.myName = "player"
    player:play()
    player:scale(0.5,0.5)

    return player
end


M.createEnemy = function( x, y)
    local enemy = display.newSprite( frontGroup, spriteSheets.getOrkStartSheet(), spriteSheets.getOrkSequences() )
    local direction = "left"
    enemy.x, enemy.y = x, y-47
    physics.addBody( enemy, "kinematic", {bounce = 0 } )
    enemy.isSensor = true
    enemy.isFixedRotation = true
    enemy.myName = "enemy"
    enemy:scale(-1,1)
    enemy.hittable = true
    enemy:play()
    enemy.objectType = "sprite"
    enemy:addEventListener( "sprite", g.spriteListenerEnemy )

    local detector = display.newRect( frontGroup, x-30, enemy.y+50, 10, 10 )
    detector.myName = "detector"
    detector.isFixedRotation = true
    physics.addBody( detector, "dynamic", {bounce = 0 } )
    detector.isSensor = true
    detector.gravityScale = 0
    detector.isVisible = false
    detector.contacted = 0
    detector.owner = enemy
    detector.direction = "left"
    
    local speed = 30
    enemy:setLinearVelocity( -speed, 0)
    detector:setLinearVelocity( -speed, 0)

    enemy.detector = detector

    table.insert( blocksArray, enemy )
    table.insert( blocksArray, detector )
end

M.createFrog = function( x, y)
    local enemy = display.newSprite( frontGroup, spriteSheets.getFrogSheet(), spriteSheets.getFrogSequences() )
    enemy.x, enemy.y = x, y-47
    physics.addBody( enemy, "kinematic", {bounce = 0 } )
    enemy.isSensor, enemy.isFixedRotation, enemy.hittable = true, true, true
    enemy.myName = "frog"
    enemy:addEventListener( "sprite", g.spriteListenerFrog )
    enemy:play()
    enemy.objectType = "sprite"
    enemy.direction = "left"

    local jumpDetector = display.newRect( frontGroup, x-140, enemy.y+50, 10, 10 )
    jumpDetector.myName = "jumpDetector"
    jumpDetector.isFixedRotation = true
    physics.addBody( jumpDetector, "dynamic", {bounce = 0 } )
    jumpDetector.isSensor = true
    jumpDetector.gravityScale = 0
    jumpDetector.isVisible = false
    jumpDetector.contacted = 0

    enemy.jumpDetector = jumpDetector

    enemy:setLinearVelocity( 0, 0)

    table.insert( blocksArray, enemy )
    table.insert( blocksArray, jumpDetector )
end


M.createEnemyTank = function( x, y)
    local enemy = display.newImageRect(backGroup, "tank.png", 128, 88 )
    enemy.x, enemy.y = x, y-45
    physics.addBody( enemy, "kinematic", {bounce = 0 } )
    enemy.isSensor = true
    enemy.isFixedRotation = true
    enemy.myName = "tank"
    enemy.hittable = true
    enemy.lives = 2

    local function shoot( event )
        if (enemy.x < 1400) then
            audio.play(tankShoot)
            createSmoke(enemy.x-90, enemy.y+5)
            createShell(enemy.x-70, enemy.y+5)
        end
        if (enemy.x < 0) then
            timer.cancel(event.source)
        end
    end

    local enemyTimer = timer.performWithDelay( 3300, shoot, 0 )
    enemy.enemyTimer = enemyTimer

    table.insert( blocksArray, enemy )
end

M.createSpike = function( x, y)
    local obj = display.newSprite(frontGroup, spriteSheets.getSpikeSheet(), spriteSheets.getSpikeSequences() )
    obj:scale(0.25,0.25)
    obj.myName = "spike"
    local nw, nh = obj.width*0.1, obj.height*0.02
    physics.addBody( obj, "kinematic",{ density = 2.5, bounce = 0, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} })
    obj.x, obj.y = x-35, y
    obj.rotation = 270
    obj.isSensor = true
    obj.objectType = "sprite"
    table.insert( blocksArray, obj )
end

M.createLandMine = function( x, y)
    local obj = display.newImageRect(frontGroup, "land_mine.png", 24, 20 )
    obj.myName = "mine"
    obj.x, obj.y = x, y-15
    local nw, nh = obj.width*0.05, obj.height*0.25
    physics.addBody( obj, "kinematic", {bounce = 0, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh}  } )
    obj.isSensor = true
    table.insert( blocksArray, obj )
end

local function touch( x )
    local touch = display.newImageRect(frontGroup, "touch.png", 105, 140 )
    touch.myName = "touch"
    touch.x, touch.y = x, 200
    touch.isSensor = true
    return touch
end

M.createTouch = function()
    local scaleFactor = display.actualContentWidth/display.actualContentHeight/1.94

    local leftX = display.contentWidth-display.actualContentWidth*0.65
    local left = touch(leftX)
    local text = display.newText(frontGroup,"      Touch left half \nof the screen to jump",leftX,300,"ethnocentric rg.ttf", 30, "center")
    text:setFillColor(0,0,0.2);
    text:scale(scaleFactor,scaleFactor)

    local leftGroup = display.newGroup();
    leftGroup:insert(left)
    leftGroup:insert(text)
    leftGroup.alpha = 0

    transition.fadeIn(leftGroup, { time = 1400});
    transition.fadeOut(leftGroup,{ time = 1400, delay = 6500});

    local rightX = display.contentWidth-display.actualContentWidth*0.35
    local right = touch(rightX)

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

M.destroyBlocks = function()
    for i in ipairs(blocksArray) do display.remove(blocksArray[i]) end
    blocksArray = {}
end

M.deleteMiddleGroup = function()
    middleGroup:removeSelf()
end

M.deleteBackground = function()
    background.removeSelf()
end

M.printBlocks = function()
    for i in ipairs(blocksArray) do print(blocksArray[i]) end
end

return M