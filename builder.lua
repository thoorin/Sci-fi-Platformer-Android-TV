-----------------------------------------------------------------------------------------
--
-- builder.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local c, g, cH, background, top, start
local en = require("environment")

local function setVariables(creator, game, collisionHandler)
    c = creator
    g = game
    cH = collisionHandler
end

local function createSetOfBlocks(start,top,width)
    local heightInPixels = display.contentHeight - top
    local height = math.ceil(heightInPixels/32)

    c.createBlockStartTop(start,top)
    for i=1,width do
        c.createBlockTop(start+32*i-1, top+1)
        c.createBlockTop(start+32*i, top)
        for j=1,height do 
            c.createBlock(start+31*i, top + 32*j)
        end
    end

    local endOfBlocks, endX = start+width*31, start+width*32+32
    local widthAdditionalBlocksPixels = endX - endOfBlocks
    local widhtAdditionalBlocks = math.floor(widthAdditionalBlocksPixels/32)

    for i=1,widhtAdditionalBlocks do
        for j=1,height do 
            c.createBlock(endOfBlocks+31*i, top + 32*j)
        end
    end

    c.createBlockEndTop(endX,top)

    for j=1,height do 
        c.createBlockStart(start,top + 32*j)
        c.createBlockEnd(endX, top + 32*j)
    end
end


local function createSetOfBlocksLeftHill(start,top,width,hillWidth,hillTop)
    local hillStart = start+(width-hillWidth)*32+32
    local heightInPixels = display.contentHeight - top
    local height = math.ceil(heightInPixels/32)

    local widthBeforeHill = width - hillWidth
    c.createBlockStartTop(start,top)
    for i=1,widthBeforeHill do
        c.createBlockTop(start+32*i-1, top+1)
        c.createBlockTop(start+32*i, top)
        for j=1,height do 
            c.createBlock(start+31*i, top + 32*j)
        end
    end

    local endOfBlocks = start+(width-hillWidth)*31
    local endX = start+(width-hillWidth)*32+32
          endX = top>hillTop and endX + 32 or endX
    local widthAdditionalBlocksPixels = endX - endOfBlocks
    local widthAdditionalBlocks = math.floor(widthAdditionalBlocksPixels/32)
    
    for j=1,height do 
        c.createBlockStart(start,top + 32*j)
    end

    local hillHeightInPixels = display.contentHeight - hillTop
    local hillHeight = math.ceil(hillHeightInPixels/32)
 
    for i=1,widthAdditionalBlocks do
        for j=1,height do 
            c.createBlock(endOfBlocks+31*i, top + 32*j)
        end
    end

    if (top<hillTop) then
        for j=1,hillHeight do 
            c.createBlock(endOfBlocks+widthAdditionalBlocksPixels, hillTop + 32*j)
        end
    end

    local heightStartHill = hillHeight-height-1

    for i=1,hillWidth do
        c.createBlockTop(hillStart+32*i-1, hillTop+1)
        c.createBlockTop(hillStart+32*i, hillTop)
        for j=1,hillHeight do 
            c.createBlock(hillStart+31*i, hillTop + 32*j)
        end
    end

    local b1,b2,b3,b4
    local sign = 1
    local t1,t2 = hillTop,top
    if (hillTop<top) then
        b1,b2,b3,b4 = c.createBlockBottomEnd,c.createBlockBottomEndEdge,c.createBlockStartTop,c.createBlockStart
        sign = - 1
        t1,t2 = top, hillTop
    else
        heightStartHill = height-hillHeight-1
        b1,b2,b3,b4 = c.createBlockBottomStart,c.createBlockBottomStartEdge,c.createBlockEndTop,c.createBlockEnd
    end
    b1(hillStart + 32*sign,t1)
    b2(hillStart,t1)
    b3(hillStart,t2)
    for j=1,heightStartHill do 
        b4(hillStart,t2 + 32*j)
    end

    endOfBlocks = hillStart + hillWidth*31
    endX = hillStart + hillWidth * 32 + 32
    widthAdditionalBlocksPixels = endX - endOfBlocks
    widthAdditionalBlocks = math.floor(widthAdditionalBlocksPixels/32)


    for i=1,widthAdditionalBlocks do
        for j=1,hillHeight do 
            c.createBlock(endOfBlocks+31*i, hillTop + 32*j)
        end
    end

    local widthInPixels = hillWidth*32+32
    c.createBlockEndTop(hillStart + widthInPixels,hillTop)

    for j=1,hillHeight do
        c.createBlockEnd(hillStart + widthInPixels,hillTop+32*j)
    end

end


local function createLevel0()
    g.setPlayer(c.createPlayer(100))
    top = display.contentHeight-64

    createSetOfBlocks(0,top,140)

    c.createTree1(200, top)
    c.createTree2(240, top)
    c.createSmallTree1(235,top)
    c.createTree1(260, top)
    c.createTree2(300, top)
    c.createSmallTree2(350,top)
    c.createBush3(345,top)
    c.createBush2(355,top)
    c.createTree1(400,top)
    c.createSmallTree1(420,top)
    c.createTree2(450,top)
    c.createMushroom1(470,top)
    c.createTree2(480,top)
    c.createSmallTree1(530,top)
    c.createTree1(550,top)
    c.createBush1(500,top)
    c.createBush1(520,top)
    c.createSmallTree2(575,top)
    c.createTree1(600, top)
    c.createTree1(700, top)
    c.createSmallTree1(660, top)
    c.createTree2(640, top)
    c.createSmallTree2(800,top)
    c.createTree2(770, top)
    c.createTree1(735, top)
    c.createStone(855,top)
    c.createBigBush1(830,top)
    c.createTree2(860,top)
    c.createTree1(830, top)
    c.createTree1(900,top)
    c.createSmallTree1(950,top)
    c.createTree2(980,top)
    c.createMushroom1(965,top)
    
    c.createStump(1220,top)
    c.createBigBush1(1250,top)
    c.createBigBush1(1270,top)
    c.createStump(1490,top)
    c.createFlowerReverse(1500,top) 

    c.createSmallTree1(1835,top)
    c.createTree1(1800,top)
    c.createMushroom1(1790,top)
    c.createTree2(1900,top)
    c.createTree1(1870,top)
    c.createTree1(1940,top)
    c.createStone(1970,top)
    c.createStone(1985,top)
    c.createSmallTree2(2050,top)
    c.createTree2(2010,top)
    c.createTree2(2150,top)
    c.createTree1(2090,top)
    c.createTree2(2280,top)
    c.createSmallTree2(2240,top)
    c.createTree1(2210,top)
    c.createTree2(2350,top)
    c.createSmallTree2(2480,top)
    c.createSmallTree1(2440,top)
    c.createBush1(2440,top)
    c.createBush2(2460,top)
    c.createTree1(2400,top)
    c.createTree1(2590, top)
    c.createTree2(2520,top)
    c.createTree1(2560,top)
    c.createTree1(2660,top)
    c.createTree2(2720,top)
    c.createTree2(2800,top)
    c.createSmallTree1(2780,top)
    c.createTree2(2930,top)
    c.createTree1(2850,top)
    c.createMushroom1(2855,top)
    c.createTree1(2990,top)

    c.createSign2(3200, top)

    c.createStone(3420, top)
    c.createBush1(3470, top)
    c.createTree2(3550, top)
    c.createSmallTree1(3600, top)

    c.createFlower(3700, top)
    c.createFlowerReverse(3720, top)
    c.createFlower(3750, top)
    c.createTouch()
end

local function createLevel1()
    g.setPlayer(c.createPlayer(100))

    do
        top = display.contentHeight-232

        for i=1,20 do
            c.createBlockTop(i*32 - 16, top)
            for j=1,7 do 
                c.createBlock(i*32 - 16, top + 32*j)
            end
        end

        c.createBlockEndTop(654, top)
        c.createBlockEnd(654, top+32)
        c.createBush3(300,top)
        c.createFlower(500,top)
    end


    do
        top = display.contentHeight-168
        for i=1,5 do
            c.createBlockTop(i*32 + 686, top)
            for j=1,5 do
                c.createBlock(686+i*32, top + j*32)
            end
        end

        for i=1,2 do
            for j=1,2 do
                c.createBlock(622+i*32, top + j*32)
            end
        end

        for i=1,5 do 
            c.createBlockEnd(878, top + i*32)
        end
        
        c.createBlockEndTop(878,  top)

        c.createBlockBottomStartEdge(654,  top)
        c.createBlockBottomStart(686, top)
    end

    do 
        top = display.contentHeight-72

        c.createBlockStartTop(300,  top)
        
        c.createBlockBottomEnd(1292,  top)

        for i=1,2 do 
            c.createBlockStart(300, top + i*32)
        end

        for i=1,32 do 
            c.createBlockTop(i*32 + 300, top)
            for j=1,2 do 
                c.createBlock(i*32 + 300, top + j*32)
            end
        end

        c.createBush2(730,top)
        c.createSmallTree1(580,top)
        c.createSmallTree1(500,top)

        c.createBush3(680,top)
        c.createSmallTree2(420,top)
        c.createSmallTree2(750,top)
        c.createSmallTree2(620,top)

        c.createBush1(420,top)
        c.createTree1(400,top)
        c.createTree1(600,top)
        c.createTree1(700,top)

        c.createTree2(550,top)
        c.createTree2(650,top)

        c.createStump(450,top)
        
        c.createStone(310,top)
        
        c.createBush1(380,top)
        c.createBush1(640,top)
        c.createBush2(500,top)
        c.createBush2(520,top)

        c.createBush4(850,top)
        c.createMushroom1(580,top)

        c.createStone(1100,top)
    end

    do
        top = display.contentHeight-178

        c.createBlockStartTop(1324, top)
        for i=1,3 do 
            c.createBlockStart(1324, top + i*32)
        end
        
        c.createBlockBottomEndEdge(1324,  top+106)

        for i=1,8 do 
            c.createBlockTop(i*32 + 1324, top)
            for j=1,6 do 
                c.createBlock(i*32 + 1324, top + j*32)
            end
        end

        c.createTree2(1520,top)
        c.createBush2(1500,top)
        c.createBush1(1560,top)
    end

    do
        top = display.contentHeight-283
        start = 1612
        
        for i=1,7 do 
            c.createBlockTop(i*32 + start, top)
            for j=1,9 do 
                c.createBlock(i*32 + start, top + j*32)
            end
        end

        for i=1,6 do 
            c.createBlock(1612, top+105 + i*32)
        end

        c.createBlockStartTop(start, top)

        for i=1,3 do 
            c.createBlockStart(start, top + i*32)
        end

        c.createBlockBottomEnd(1580, top+105)
        c.createBlockBottomEndEdge(start, top+105)

        c.createBlockEndTop(1850, top)

        for i=1,9 do 
            c.createBlockEnd(1850, top + i*32)
        end

        c.createBush4(1680,top)
        c.createSign1(1700, top)
        c.createBush3(1720,top)
    end

    do
        start = 1970
        c.createBlockStartTop(start, top)
        for i=1,5 do 
            c.createBlockTop(i*32 + start, top)
            for j=1,9 do 
                c.createBlock(i*32 + start, top + j*32)
            end
        end

        for i=1,9 do 
            c.createBlockStart(start, top + i*32)
        end

        c.createBlockEndTop(start + 192, top)
        for i=1,9 do 
            c.createBlockEnd(start + 192, top + i*32)
        end

        c.createBush2(start+54,top)
        c.createBush4(start+104,top)
        c.createBush3(start+74,top)
        c.createBigBush1(start+154,top)   

    end

    do 
        top = display.contentHeight-335

        c.createBlockStartTop(2300, top)
        for i=1,5 do 
            c.createBlockTop(i*32 + 2300, top)
            for j=1,10 do 
                c.createBlock(i*32 + 2300, top + j*32)
            end
        end

        for i=1,10 do 
            c.createBlockStart(2300, top + i*32)
        end

        c.createBlockEndTop(2480, top)
        for i=1,10 do 
            c.createBlockEnd(2480, top + i*32)
        end

        c.createBush1(2330,top)
        c.createStone(2400,top)
    end

    do
        top = display.contentHeight-72

        c.createBlockStartTop(2800, top)
        for i=1,40 do 
            c.createBlockTop(i*32 + 2800, top)
            for j=1,2 do 
                c.createBlock(i*32 + 2800, top + j*32)
            end
        end

        for i=1,2 do 
            c.createBlockStart(2800, top + i*32)
        end

        c.createStone(2840,top)

        c.createFlower(3000,top)
        c.createBigStone(3050,top)

        c.createTree1(3100,top)
        c.createBush1(3140,top)
        c.createBush2(3190,top)
        c.createBush4(3210,top)
        c.createStone(3160,top)
        c.createSmallTree2(3200,top)

        c.createMushroom1(3150,top)

        c.createSign2(3240,top)

        c.createTree2(3400,top)
        c.createTree1(3500,top)
        c.createSmallTree1(3440,top)

        c.createTree2(3600,top)
        c.createTree1(3700,top)
        c.createSmallTree1(3660,top)
        c.createBush2(3580,top)
        c.createBush2(3710,top)
        c.createTree1(4000,top)
        c.createSmallTree1(3900,top)
    end
end

local function createLevel2()
    g.setPlayer(c.createPlayer(100))
    do
        top = display.contentHeight-68

        c.createTree2(0,top)
        c.createTree1(100,top)
        c.createSmallTree1(60,top)
        c.createBush2(20,top)
        c.createBush2(110,top)
        c.createTree1(200,top)
        c.createSmallTree1(150,top)
        
        c.createTree2(200,top)
        c.createTree1(300,top)
        c.createSmallTree1(260,top)
        c.createBush2(220,top)
        c.createBush2(310,top)
        c.createTree1(400,top)
        c.createSmallTree1(350,top)

        c.createFlower(400,top)
        c.createStone(640,top)
        c.createStone(550,top)
        c.createBigStone(600,top)

        c.createWater(580, top+12)
        for i=1,20 do
            c.createBlockTop(i*32 - 16, top)
            for j=1,2 do 
                c.createBlock(i*32 - 16, top + 32*j)
            end
        end


        c.createBlockEndTop(656, top)
        for i=1,2 do 
            c.createBlockEnd(656, top + i*32)
        end
        
        c.createWater(1000, top+12)
        

        c.createFlower(790,top)

        c.createBlockStartTop(790, top)
        for i=1,2 do 
            c.createBlockStart(790, top + i*32)
        end

        c.createBlockTop(792, top)
            for j=1,2 do 
                c.createBlock(792, top + 32*j)
            end

        c.createBlockEndTop(794, top)
        for i=1,2 do 
            c.createBlockEnd(794, top + i*32)
        end

        c.createBush2(990,top)
        c.createBush3(1050,top)
        
        c.createBush4(1150,top)
        c.createBush2(1190,top)
        c.createBush1(1170,top+3)
        c.createBigBush1(1220,top)
        c.createBush1(1250,top)
        c.createBush2(1270,top+3)
        c.createBush3(1300,top)

        c.createBlockStartTop(960, top)
        for i=1,2 do 
            c.createBlockStart(960, top + i*32)
        end

        for i=1,15 do
                c.createBlockTop(i*32 + 960, top)
                for j=1,2 do 
                    c.createBlock(i*32 + 960, top + 32*j)
                end
        end

        
        
    
    end
    
    do
        top = display.contentHeight-173
        start = 1470
        c.createBlockStartTop(start, top)

        c.createWater(2200, top+189)
     
        c.createStone(start+50,top+3)
        c.createFlower(start+100,top)
        c.createBigStone(start+150,top)

        for j=1,3 do 
            c.createBlockStart(start, top + 32*j)
        end
    
        c.createBlockBottomEndEdge(start, top + 105)
        c.createBlockBottomEnd(start-32, top + 105)

        for i=1,15 do
                c.createBlockTop(i*32 + start, top)
                for j=1,4 do 
                    c.createBlock(i*32 + start, top + 32*j)
                end
        end

        for i=1,16 do
            for j=1,4 do 
                c.createBlock(i*32 + start-32, top+105 + 32*j)
            end
        end

        c.createBlockEndTop(start+16*32,top)
        for j=1,5 do 
            c.createBlockEnd(start+16*32, top + 32*j)
        end

        c.createTigerBeetle(1800, top)
    end

    do
        top = display.contentHeight-14
        start = 2200

        c.createStone(start+8,top)
        c.createFlower(start+50,top)
        c.createFlowerReverse(start+75,top)
        c.createFlower(start+100,top)
        c.createFlower(start+200,top)
        c.createFlowerReverse(start+300,top)

        c.createBlockStartTop(2698, top-84)
        c.createBlockEndTop(2702, top-84)
        c.createBlockTop(2700, top-84)
        for i=1,4 do 
            c.createBlockStart(2698, top-84+32*i)
            c.createBlockEnd(2700, top-84+32*i)
            c.createBlock(2702, top-84+32*i)
        end

        c.createWater(2683, top)
        
        c.createBlockStartTop(start, top)
        for i=1,8 do 
            c.createBlockTop(start+i*32, top)
        end
        c.createBlockEndTop(start+9*32, top)

        c.createTigerBeetle(2400, top)

    end


    do
        top = display.contentHeight-192
        start = 2900
        
        
        c.createTree1(start + 200,top)
        c.createBush1(start + 240,top)
        c.createBush2(start + 250,top)
        c.createBush4(start + 310,top)
        c.createStone(start + 260,top)
        c.createSmallTree2(start + 300,top)

        c.createTree2(start + 400,top)
        c.createFlowerReverse(start+500,top)
        c.createBigStone(start + 560,top)

        for i=1,5 do
            c.createBush1(start + 540 + 100*i,top)
            c.createBush2(start + 550 + 100*i,top)
            c.createBush4(start + 610 + 100*i,top)
            c.createBigBush1(start + 580 + 100*i,top)
        end




        c.createBlockStartTop(start, top)
        for i=1,8 do 
            c.createBlockStart(start, top+32*i)
        end

        for i=1,27 do
            c.createBlockTop(i*32 + start, top)
            for j=1,6 do 
                c.createBlock(i*32 + start, top + 32*j)
            end
        end

        c.createSign2(3000,top)
    end
end

local function createLevel3()
    g.setPlayer(c.createPlayer(100))
    do
        top = display.contentHeight-64
        start = 300

        c.createWater(start+600, top+12)

        c.createBush2(start + 330,top)
        c.createSmallTree1(start + 180,top)
        c.createSmallTree1(start + 100,top)

        c.createBush3(start + 280,top)
        c.createSmallTree2(start + 20,top)
        c.createSmallTree2(start + 350,top)
        c.createSmallTree2(start + 220,top)

        c.createBush1(start + 20,top)
        c.createTree1(start,top)
        c.createTree1(start + 200,top)
        c.createTree1(start + 300,top)

        c.createTree2(start + 150,top)
        c.createTree2(start + 250,top)

        c.createStump(start + 50,top)
        
        c.createStone(start - 100,top)
        
        c.createBush1(start - 20 ,top)
        c.createBush1(start + 240,top)
        c.createBush2(start + 100,top)
        c.createBush2(start + 120,top)
        
        for i=1,25 do
            c.createBlockTop(i*32 - 16, top)
            for j=1,2 do 
                c.createBlock(i*32 - 16, top + 32*j)
            end
        end

        c.createBlockEndTop(start+496, top)
        c.createTigerBeetle(start+450, top)
        
        for i=1,2 do 
            c.createBlockEnd(start+496, top + i*32)
        end

        c.createBlockStartTop(start+848, top)
        c.createBlockEndTop(start+850, top)
        c.createBlockTop(start+852, top)

        c.createWater(start+1021, top+12)
    end

    do
        top = display.contentHeight-96
        start = 1450

        c.createWater(start+250, top+42)
        c.createWater(start+670, top+42)

        c.createBlockStartTop(start, top)
        for i=1,3 do 
            c.createBlockStart(start, top + i*32)
        end

        c.createStump(start + 50, top)
        c.createEnemy(start+130, top)
        
        for i=1,5 do
            c.createBlockTop(start+32*i, top)
            for j=1,3 do 
                c.createBlock(start+32*i, top + 32*j)
            end
        end

        c.createBlockBottomEnd(start+161,top)
        c.createBlockBottomEndEdge(start+192,top)

        for i=1,3 do 
            c.createBlockStart(start+192, top-128 + i*32)
        end

        for i=1,3 do 
            c.createBlock(start+192, top + i*32)
        end

        for i=1,7 do 
            c.createBlock(start+222, top-128 + i*32)
            c.createBlockEnd(start+254, top-128 + i*32)
        end
        
        c.createBlockStartTop(start+192, top - 128)
        c.createBlockTop(start+223, top - 128)
        c.createBlockEndTop(start+254, top - 128)

        c.createTigerBeetle(start+220, top - 128)
    end

    do
        top = display.contentHeight-224
        start = 2050

        c.createFlower(start, top)

        c.createBlockStartTop(start-2, top)
        c.createBlockEndTop(start, top)
        for i=1,7 do 
            c.createBlockStart(start-2, top+32*i)
            c.createBlockEnd(start, top+32*i)
        end

        
    end

    do
        top = display.contentHeight-256
        start = 2350

        c.createBlockStartTop(start-2, top)
        c.createBlockEndTop(start, top)
        for i=1,8 do 
            c.createBlockStart(start-2, top+32*i)
            c.createBlockEnd(start, top+32*i)
        end

        c.createMovingBlock(start+80,top+32,0)
        
    end

    do
        top = display.contentHeight-288
        start = 2900

        
        c.createStone(start + 10, top)
        c.createBigStone(start + 50, top)
        c.createStone(start + 80, top)
        c.createBigStone(start + 150, top)
        c.createStone(start + 180, top)
        c.createStone(start + 260, top)
        c.createStone(start + 380, top)
        c.createBlockStartTop(start, top)
        for i=1,9 do 
            c.createBlockStart(start, top+32*i)
        end

        for j=1,12 do 
            c.createBlockTop(start+32*j, top)
            for i=1,9 do 
                c.createBlock(start+32*j, top+32*i)
            end
        end

        c.createTigerBeetle(start+200, top)

        c.createLandMine(start+350, top)
    end

    do
        top = display.contentHeight-320
        start = 3316

        c.createBlockStartTop(start, top)

        c.createBlockBottomEnd(start-32, top+32)
        c.createBlockBottomEndEdge(start, top+32)
        for j=1,11 do 
            c.createBlockTop(start+32*j, top)
        end

        c.createTree2(start+50, top)
        for j=1,13 do 
            for i=1,10 do 
                c.createBlock(start+32*j, top+32*i)
            end
        end
        
        for i=1,9 do 
            c.createBlock(start, top+32+32*i)
        end

        
        c.createEnemy(start+200, top)
        c.createLandMine(start+350, top)

        c.createSign2(start+184, top)

        c.createTigerBeetle(start+100, top)

    end

    do
        top = display.contentHeight-416
        start = 3700

        for i=0,9 do
            c.createStone(start + 10 + 180*i, top)
            c.createBigStone(start + 50 + 180*i, top)
            c.createStone(start + 80 + 180*i, top)
            c.createBigStone(start + 120 + 180*i, top)
            c.createStone(start + 150 + 180*i, top)
        end

        c.createBlockStartTop(start, top)

        c.createBlockBottomEnd(start-32, top+96)
        
        c.createBlockStart(start, top+32)
        
        for j=1,20 do 
            c.createBlockTop(start+32*j, top)
            for i=1,14 do 
                c.createBlock(start+32*j, top+32*i)
            end
        end

        for i=1,9 do 
            c.createBlock(start, top+64+32*i)
        end

        c.createBlockStart(start, top+64)
        c.createBlockBottomEndEdge(start, top+96)
    end
end

local function createLevel4()
    g.setPlayer(c.createPlayer(0))
    do
        top = display.contentHeight-416
        for i=0,1 do
            c.createStone(10 + 180*i, top)
            c.createBigStone(50 + 180*i, top)
            c.createStone(80 + 180*i, top)
            c.createBigStone(120 + 180*i, top)
            c.createStone(150 + 180*i, top)
        end
        for i=1,12 do
            c.createBlockTop(i*32 - 16, top)
            for j=1,9 do 
                c.createBlock(i*32 - 16, top + 32*j)
            end
        end

        c.createBlockEndTop(400, top)
        for i=1,9 do 
            c.createBlockEnd(400, top + i*32)
        end
    end

    do
        top = display.contentHeight-100

        c.createBush2(430,top)
        c.createSmallTree1(280,top)
        c.createSmallTree1(200,top)

        c.createBush3(380,top)
        c.createSmallTree2(120,top)
        c.createSmallTree2(450,top)
        c.createSmallTree2(320,top)

        c.createBush1(120,top)
        c.createTree1(100,top)
        c.createTree1(300,top)
        c.createTree1(400,top)

        c.createTree2(250,top)
        c.createTree2(350,top)

        c.createStump(150,top)
        
        c.createStone(10,top)
        
        c.createBush1(80,top)
        c.createBush1(340,top)
        c.createBush2(200,top)
        c.createBush2(220,top)


        c.createBush4(550,top)
        c.createMushroom1(280,top)


        for i=1,24 do
            c.createBlockTop(i*32 - 16, top)
            for j=1,3 do 
                c.createBlock(i*32 - 16, top + 32*j)
            end
        end

        for j=2,3 do 
            c.createBlock(784, top + 32*j)
        end
        c.createBlockEndTop(784, top) 
        c.createBlockBottomStartEdge(784, top + 32)
    end

    do
        top = display.contentHeight-350
        start = 944

        c.createBush1(start + 30,top)

        c.createTigerBeetle(start+64,top)
        c.createBlockStartTop(start, top)
        for j=1,8 do 
            c.createBlockStart(start, top + 32*j)
        end

        for i=1,3 do
            c.createBlockTop(start-1+32*i, top)
            for j=1,8 do 
                c.createBlock(start-1+32*i, top + 32*j)
            end
        end

        c.createMushroom1(start + 159, top + 160)
        c.createBlockEndTop(start+127, top)
        for j=1,4 do 
            c.createBlockEnd(start+127, top + 32*j)
        end
        c.createBlockBottomStartEdge(start+127, top + 160)
        c.createBlockBottomStart(start+159, top + 160)
        c.createBlockEndTop(start+191, top + 160)

        for i=1,3 do
            c.createBlockEnd(start+191, top + 160 +32*i)
            for j=1,2 do 
                c.createBlock(start+95+32*j, top + 160 + 32*i)
            end
        end
    end

    do
        top = display.contentHeight-68
        start = 816

        c.createBush3(start + 100, top)
        c.createStump(start + 400, top)

        c.createSmallTree2(start + 200, top)

        c.createBush1(start + 540,top)
        c.createBush2(start + 550,top)
        c.createBush4(start + 610,top)
        c.createBigBush1(start + 580,top)
        c.createFlower(start +550, top)


        c.createBlockBottomStart(start, top)

        c.createWater(start+900,top)

        for j=1,2 do 
            c.createBlock(start, top + 32*j)
        end

        for i=1,24 do
            c.createBlockTop(start+32*i-1, top+1)
            c.createBlockTop(start+32*i, top)
            for j=1,2 do 
                c.createBlock(start+31*i, top + 32*j)
            end
        end
        for j=1,2 do 
            c.createBlock(start+31*25, top + 32*j)
        end

        c.createBush1(start + 700, top)
        c.createBigBush1(start + 790, top-1)
        c.createBush4(start + 730, top+2)
        c.createBush3(start + 760, top)


        c.createBlockEndTop(start+800,top)
        for j=1,2 do 
            c.createBlockEnd(start+800, top + 32*j)
        end
        c.createEnemy(start+600,top)

    end

    do
        top = display.contentHeight-78
        start = 1732

        c.createWater(start+500,top+10)

        c.createStone(start + 20, top)

        c.createBlockStartTop(start, top)
        for j=1,2 do 
            c.createBlockStart(start, top + 32*j)
        end

        for i=1,8 do
            c.createBlockTop(start+32*i, top)
            for j=1,2 do 
                c.createBlock(start+32*i, top + 32*j)
            end
        end 
        
        c.createBlockEndTop(start+288, top)
        for j=1,2 do 
            c.createBlockEnd(start+288, top + 32*j)
        end

        c.createSign1(start + 200, top)
        c.createMushroom1(start + 195, top-2)
        c.createBush3(start + 240, top)
        c.createFlower(start + 270, top)

        c.createTigerBeetle(start+50,top)       
    end

    do
        top = display.contentHeight-68
        start = 2300

        for i=0,1 do
            c.createBush2(start + 430 + 410 * i,top)
            c.createSmallTree1(start + 280 + 410 * i,top)
            c.createSmallTree1(start + 200 + 410 * i,top)
            c.createSmallTree1(start + 160 + 410 * i,top)
            c.createSmallTree2(start + 180 + 410 * i,top)


            c.createBush3(start + 380 + 410 * i,top)
            c.createSmallTree2(start + 120 + 410 * i,top)
            c.createSmallTree2(start + 450 + 410 * i,top)
            c.createSmallTree2(start + 320 + 410 * i,top)

            c.createBush1(start + 120 + 410 * i,top)
            c.createTree1(start + 100 + 410 * i,top)
            c.createTree1(start + 150 + 410 * i,top)
            c.createTree1(start + 300 + 410 * i,top)
            c.createTree1(start + 400 + 410 * i,top)

            c.createTree2(start + 250 + 410 * i,top)
            c.createTree2(start + 350 + 410 * i,top)
            
            c.createBush1(start + 80 + 410 * i,top)
            c.createBush1(start + 370 + 410 * i,top)
            c.createBush2(start + 210 + 410 * i,top)
            c.createBush2(start + 230 + 410 * i,top)
        end
        c.createStump(start + 180,top)

        c.createFlower(start + 1000, top)
        c.createStone(start + 1020, top)

        c.createLandMine(start,top)

        c.createBlockStartTop(start, top)
        for j=1,2 do 
            c.createBlockStart(start, top + 32*j)
        end

        for i=1,36 do
            c.createBlockTop(start+32*i, top)
            for j=1,2 do 
                c.createBlock(start+32*i, top + 32*j)
            end
        end 
        --[[
        c.createEnemy(start+600,top)
        c.createEnemy(start+300,top)
        c.createEnemy(start+100,top)]]--

        c.createLandMine(start+500,top)
        c.createCrate(start+550,top-32)
        c.createLandMine(start+600,top)
        c.createLandMine(start+650,top)
        c.createLandMine(start+800,top)
        c.createLandMine(start+850,top)

        c.createTigerBeetle(start+900,top)

        c.createLandMine(start+1152,top)
    end

    
    do
        top = display.contentHeight-132
        start = 3484

        c.createBlockStartTop(start, top)
        c.createBlockStart(start, top + 32)
        c.createBlockBottomEnd(start-32, top + 64)
        c.createBlockBottomEndEdge(start, top + 64)

        c.createBush1(start + 30, top)
        c.createSmallTree1(start + 50, top)
        c.createSmallTree2(start + 150, top)
        c.createTree1(start + 100, top)
        c.createBush4(start + 90, top)
        c.createBigBush1(start + 130, top)
        c.createFlowerReverse(start + 110, top)
        c.createStone(start + 220, top)
        c.createFlower(start + 210, top)
        c.createFlowerReverse(start + 260, top)


        for j=1,2 do 
            c.createBlock(start, top + 64 + 32*j)
        end

        for i=1,22 do
            if (i~=22) then
                c.createBlockTop(start+32*i+1, top+1)
            end
            c.createBlockTop(start+32*i, top)
            for j=1,4 do 
                c.createBlock(start+31*i, top + 32*j)
            end
        end

        c.createBlockEndTop(start+704, top)
        for j=1,2 do 
            c.createBlockEnd(start+704, top + 32*j)
        end
        
        c.createLandMine(start+370,top)
        c.createCrate(start+400, top-64)
        c.createCrate(start+400, top-32)
        c.createCrate(start+432, top-32)

        c.createStone(start + 490, top)

        c.createStone(start + 570, top)
        c.createStone(start + 550, top)
        c.createBigStone(start + 590, top - 4)

        c.createTigerBeetle(start+650, top)
    end

    do
        top = display.contentHeight-68
        start = 4188

        for j=1,2 do 
            c.createBlock(start, top + 32*j)
        end

        for i=0,4 do
            c.createBush2(start + 430 + 410 * i,top)
            c.createSmallTree1(start + 280 + 410 * i,top)
            c.createSmallTree1(start + 200 + 410 * i,top)
            c.createSmallTree1(start + 160 + 410 * i,top)
            c.createSmallTree2(start + 180 + 410 * i,top)


            c.createBush3(start + 380 + 410 * i,top)
            c.createSmallTree2(start + 120 + 410 * i,top)
            c.createSmallTree2(start + 450 + 410 * i,top)
            c.createSmallTree2(start + 320 + 410 * i,top)

            c.createBush1(start + 120 + 410 * i,top)
            c.createTree1(start + 100 + 410 * i,top)
            c.createTree1(start + 150 + 410 * i,top)
            c.createTree1(start + 300 + 410 * i,top)
            c.createTree1(start + 400 + 410 * i,top)

            c.createTree2(start + 250 + 410 * i,top)
            c.createTree2(start + 350 + 410 * i,top)
            
            c.createBush1(start + 80 + 410 * i,top)
            c.createBush1(start + 370 + 410 * i,top)
            c.createBush2(start + 210 + 410 * i,top)
            c.createBush2(start + 230 + 410 * i,top)
        end

        c.createEnemy(start+500, top)
        c.createEnemy(start+200, top)
        c.createEnemy(start+600, top)
        c.createEnemy(start+1200, top)

        c.createStump(start+110, top)
        c.createSmallStump(start+150, top)

        c.createTree1(start+250, top)

        c.createSmallStump(start+300, top)
        c.createStump(start+330, top)
        c.createSmallStump(start+350, top)

        c.createSmallStump(start+470, top)
        c.createSmallTree2(start+500, top)
        c.createSmallStump(start+550, top)

        c.createSmallStump(start + 700, top)
        c.createTree2(start + 720, top)

        


        for i=1,50 do
            if (i~=50) then
            c.createBlockTop(start+32*i+1, top+1)
            end
            c.createBlockTop(start+32*i, top)
            for j=1,4 do 
                c.createBlock(start+31*i, top + 32*j)
            end
        end

        c.createBlockBottomStart(start+32, top)
        c.createBlockBottomStartEdge(start, top)
        c.createSign2(start+800, top)
    end
end


local function createLevel5()
    g.setPlayer(c.createPlayer(300))
    
    do
        top = display.contentHeight-68

        c.createTree1(50, top)

        c.createStump(110, top)
        c.createSmallStump(150, top)

        c.createTree1(250, top)

        c.createSmallStump(300, top)
        c.createStump(330, top)
        c.createSmallStump(350, top)

        c.createFlower(400, top)
        c.createSmallStump(470, top)
        c.createSmallTree2(500, top)
        c.createSmallStump(550, top)

        c.createSmallStump(700, top)
        c.createTree2(720, top)

        c.createBush1(840,top)
        c.createBush2(850,top)
        c.createBush4(910,top)
        c.createBigBush1(880,top)
        c.createFlower(850, top)
        
        c.createBush2(1330,top)
        c.createSmallTree1(1180,top)
        c.createSmallTree1(1100,top)

        c.createBush3(1280,top)
        c.createSmallTree2(1020,top)
        c.createSmallTree2(1350,top)
        c.createSmallTree2(1220,top)

        c.createBush1(1020,top)
        c.createTree1(1000,top)
        c.createTree1(1000,top)
        c.createTree1(1100,top)

        c.createTree2(1150,top)
        c.createTree2(1250,top)

        c.createStump(1050,top)
        
        c.createStone(1510,top)
        
        c.createBush1(980,top)
        c.createBush1(1240,top)
        c.createBush2(1100,top)
        c.createBush2(1120,top)

        c.createBush4(1450,top)
        c.createMushroom1(1180,top)

        
        for j=1,3 do 
            c.createCrateBack(1820, top-64 + 32*j)
        end

        c.createWater(1800, top)

        for i=1,50 do
            c.createBlockTop(32*i-1, top+1)
            c.createBlockTop(32*i, top)
            for j=1,4 do 
                c.createBlock(31*i, top + 32*j)
            end
        end

        for i=51,52 do
            for j=1,4 do 
                c.createBlock(31*i, top + 32*j)
            end
        end

        c.createBlockEndTop(1632, top)
        for j=1,3 do 
            c.createBlockEnd(1632, top + 32*j)
        end

        c.createEnemy(1000,top)
        c.createEnemy(1400,top)

        c.createBlockStartTop(2900, top - 100)
        c.createBlockEndTop(2902, top - 100)
        for j=1,5 do 
            c.createBlockStart(2900, top - 100 + 32*j)
            c.createBlockEnd(2902, top - 100 + 32*j)
        end

        c.createWater(2700, top)

        c.createBlockStartTop(2000, top)
        for j=1,3 do 
            c.createBlockStart(2000, top + 32*j)
        end

        for i=1,20 do
            c.createBlockTop(2000+32*i, top)
            for j=1,3 do 
                c.createBlock(2000+32*i, top + 32*j)
            end
        end

        c.createBlockEndTop(2672, top)

        for j=1,3 do 
            c.createBlockEnd(2672, top + 32*j)
        end

        c.createStone(2010, top)
        c.createBigStone(2050, top)
        c.createStone(2080, top)
        c.createBigStone(2150, top)
        c.createStone(2180, top)
        c.createStone(2260, top)
        c.createFlowerReverse(2350, top)
        c.createStone(2380, top)

        c.createSign1(2450, top)

        c.createFlower(2530, top)
        c.createBigStone(2600, top)
        c.createSmallTree2(2650,top)

        c.createTigerBeetle(2070,top)


        c.createWater(3120, top)
        c.createWater(3540, top)
        c.createWater(3960, top)
        c.createWater(4380, top)

        
    end

    do
        top = display.contentHeight-210
        start = 3250

        c.createBlockTop(start+25, top)
        c.createBlockStartTop(start, top)
        c.createBlockEndTop(start+50, top)
        for i=1,8 do 
            c.createBlockBack(start+25, top+32*i)
            c.createBlockStartBack(start, top+32*i)        
            c.createBlockEndBack(start+50, top+32*i)
        end 

        c.createTigerBeetle(start+21, top)
    end

    do
        top = display.contentHeight-210
        start = 3600

        c.createBlockTop(start+25, top)
        c.createBlockStartTop(start, top)
        c.createBlockEndTop(start+50, top)
        for i=1,8 do 
            c.createBlockBack(start+25, top+32*i)
            c.createBlockStartBack(start, top+32*i)        
            c.createBlockEndBack(start+50, top+32*i)
        end 

        c.createTigerBeetle(start+21, top)
    end


    do
        top = display.contentHeight-210
        start = 3880



        for j=1,8 do
            if (j<8) then
                c.createBlockTop(start+32*j+1, top+1)
            end
            c.createBlockTop(start+32*j, top)
            for i=1,8 do 
                c.createBlockBack(start+31*j, top+32*i)
            end 
        end
        for i=1,8 do 
            c.createBlockBack(start+31*9, top+32*i)
        end 
        for i=1,8 do 
            c.createBlockStartBack(start, top+32*i)        
            c.createBlockEndBack(start+288, top+32*i)
        end 

        c.createBlockStartTop(start, top)
        c.createBlockEndTop(start+288, top)

        c.createBush3(start + 100, top)
        c.createTree1(start + 180, top)
        c.createMushroom1(start + 150, top)
        c.createMushroom1(start + 185, top)   
        c.createMushroom1(start + 210, top)

        c.createLandMine(start, top)
    end

    do
        top = display.contentHeight-210
        start = 4880
        c.createMovingBlock(4650,top,0)

        c.createStone(start + 4, top)
        c.createBigStone(start + 140, top)

        for i=1,36 do
            c.createBlockTop(start+i*32-1, top)
            c.createBlockTop(start+i*32, top)
            for j=1,6 do
                c.createBlock(start+i*31,top+j*32)
            end
        end
        for i=37,38 do
            for j=1,6 do
                c.createBlock(start+i*31,top+j*32)
            end
        end
        for i=1,6 do
            c.createBlockStart(start, top+32*i)
            c.createBlockEnd(start+1184,top+32*i)
        end
        c.createBlockStartTop(start,top)
        c.createBlockEndTop(start+1184,top)

        c.createLandMine(start+64,top)
        c.createLandMine(start+96,top)

        c.createLandMine(start+300,top)

        c.createTigerBeetle(start+220,top)

        start = start + 250
        for i=0,1 do
            c.createMushroom1(start + 315 + 410 * i, top)
            c.createMushroom1(start + 285 + 410 * i, top)
            c.createMushroom1(start + 190 + 410 * i, top)
            c.createBush2(start + 430 + 410 * i,top)
            c.createSmallTree1(start + 280 + 410 * i,top)
            c.createSmallTree1(start + 200 + 410 * i,top)
            c.createSmallTree1(start + 160 + 410 * i,top)
            c.createSmallTree2(start + 180 + 410 * i,top)



            c.createBush3(start + 380 + 410 * i,top)
            c.createSmallTree2(start + 120 + 410 * i,top)
            c.createSmallTree2(start + 450 + 410 * i,top)
            c.createSmallTree2(start + 320 + 410 * i,top)

            c.createBush1(start + 120 + 410 * i,top)
            c.createTree1(start + 100 + 410 * i,top)
            c.createTree1(start + 150 + 410 * i,top)
            c.createTree1(start + 300 + 410 * i,top)
            c.createTree1(start + 400 + 410 * i,top)

            c.createTree2(start + 250 + 410 * i,top)
            c.createTree2(start + 350 + 410 * i,top)
            
            c.createBush1(start + 80 + 410 * i,top)
            c.createBush1(start + 370 + 410 * i,top)
            c.createBush2(start + 210 + 410 * i,top)
            c.createBush2(start + 230 + 410 * i,top)
        end
        c.createLandMine(start+140,top)
        c.createLandMine(start+95,top)
    end

    
    do
        top = display.contentHeight-0
        start = 4580

        c.createBush3(start + 100, top)
        c.createStump(start + 400, top)

        c.createSmallTree2(start + 200, top)

        c.createBush1(start + 540,top)
        c.createBush2(start + 550,top)
        c.createBush4(start + 610,top)
        c.createBigBush1(start + 580,top)
        c.createFlower(start +550, top)

        c.createStone(start + 1050, top)
        c.createBigStone(start + 1110, top)
        c.createStone(start + 1155, top)
        c.createBigStone(start + 420, top)
        c.createStone(start + 510, top)
        c.createStone(start + 750, top)
        c.createFlowerReverse(start + 1220, top)
        c.createStone(start + 1110, top)

        c.createBush1(start + 1300,top)
        c.createBush2(start + 1310,top)
        c.createBush4(start + 1370,top)
        c.createBigBush1(start + 1340,top)
        c.createFlower(start +1310, top)

        c.createBlockStartTop(start, top-100)
        c.createBlockEndTop(start+2, top-100)
        for i=1,3 do
            c.createBlockStart(start, top-100+i*32)
            c.createBlockEnd(start+2, top-100+i*32)
        end

        c.createBlockBottomStart(start+32, top)

        for i=1,48 do
            c.createBlockTop(start+i*32+32, top)
        end
        c.createBlockEndTop(start+1600,top)

        c.createEnemy(start+1800, top)
        c.createEnemy(start+1300, top)

    end

    do
        top = display.contentHeight-48
        start = 6332

        c.createBlockStartTop(start,top)

        c.createStone(start + 90, top)

        c.createStone(start + 170, top)
        c.createStone(start + 150, top)
        c.createBigStone(start + 190, top - 4)

        c.createBush3(start + 370, top)

        c.createEnemy(start+3000,top)
        c.createEnemy(start+2800,top)
        c.createEnemy(start+3050,top)
        c.createBlockStart(start,top+32)
        for i=1,120 do
            c.createBlockTop(start+i*32+1, top+1)
            c.createBlockTop(start+i*32, top)
            c.createBlock(start+i*31, top+32)
        end

        for i=1,4 do
            c.createLandMine(start + 400 + 128*i,top)
        end

        c.createStone(start + 1000, top)
        c.createFlower(start + 1020, top)

        for i=1,3 do
            c.createLandMine(start + 1100 + 64*i,top)
        end

        c.createBush2(start + 1390,top)
        c.createBush3(start + 1450,top)
        
        for i=0,7 do
            local trans = i < 5 and 500 or 250
            c.createBush4(start + 1550 + i*trans,top)
            c.createBush2(start + 1590 + i*trans,top)
            c.createBush1(start + 1570 + i*trans,top+3)
            c.createBigBush1(start + 1620 + i*trans,top)
            c.createBush1(start + 1650 + i*trans,top)
            c.createBush2(start + 1670 + i*trans,top+3)
            c.createBush3(start + 1700 + i*trans,top)
        end

        c.createStump(start + 1900, top)
        c.createSmallStump(start + 1940, top)

        c.createStump(start + 2100, top)
        c.createStump(start + 2250, top)
        c.createBush4(start + 2420, top)

        c.createStump(start + 2750, top)
        c.createMushroom1(start + 2730, top)


        c.createShip(start+2500, top)
    end
end

local function createLevel6()
    g.setPlayer(c.createPlayer(300))
    
    do
        top = display.contentHeight-68

        for i=1,30 do
            c.createBlockTop(32*i-1, top+1)
            c.createBlockTop(32*i, top)
            for j=1,2 do 
                c.createBlock(31*i, top + 32*j)
            end
        end

        for j=1,2 do 
            c.createBlock(31*31, top + 32*j)
            c.createBlockEnd(992,top+32*j)
        end
        c.createBlockEndTop(992,top)

        c.createSkeleton(250, top)
        c.createDesertTree(700, top)
    end

    do
        top = display.contentHeight-128
        start = 1132

        c.createBlockStartTop(start,top)
        for j=1,4 do 
            c.createBlockStart(start,top+32*j)
            c.createBlock(start + 186, top+32*j)
        end

        for i=1,5 do
            c.createBlockTop(start + 32*i-1, top+1)
            c.createBlockTop(start + 32*i, top)
            for j=1,4 do 
                c.createBlock(start + 31*i, top + 32*j)
            end
        end
        c.createBlockBottomEnd(start + 192, top)

        c.createDesertBush1(start + 50, top)
        c.createStone(start + 120, top)
    end

    do
        top = display.contentHeight-275
        start = 1356

        c.createBlockStartTop(start,top)
        for j=1,4 do 
            c.createBlockStart(start, top + 32*j)
            c.createBlock(start-6, top + 132 + 32*j)
            c.createBlock(start, top + 132 + 32*j)
        end

        c.createBlockBottomEndEdge(start,top+147)

        for i=1,13 do
            c.createBlockTop(start + 32*i-1, top+1)
            c.createBlockTop(start + 32*i, top)
            for j=1,9 do 
                c.createBlock(start + 31*i, top + 32*j)
            end
        end

        for j=1,9 do 
            c.createBlock(start + 420, top + 32*j)
        end

        c.createEnemyTank(start + 300, top)
        c.createBlockEndTop(start + 448, top)
        for j=1,9 do 
            c.createBlockEnd(start + 448, top + 32*j)
        end

        c.createBigStone(start + 50, top)
        c.createGrass1(start + 300, top)
    end

    do
        top = display.contentHeight-200
        start = 2132

        c.createBlockStartTop(start, top)
        for j=1,6 do 
            c.createBlockStart(start, top + 32*j)
            c.createBlockEnd(start + 435, top + 32*j)
        end
        for i=1,13 do
            c.createBlockTop(start + 32*i-1, top+1)
            c.createBlockTop(start + 32*i, top)
            for j=1,6 do 
                c.createBlock(start + 31*i, top + 32*j)
            end
        end
        c.createLandMine(start + 200, top)
        c.createBlockEndTop(start + 435,top)

        c.createDesertBush2(start + 350, top)
    end

    do
        top = display.contentHeight-64
        start = 2090
        c.createBlockStartTop(start,top)
        for j=1,2 do 
            c.createBlockStart(start, top + 32*j)
        end
        for i=1,90 do
            c.createBlockTop(start + 32*i-1, top+1)
            c.createBlockTop(start + 32*i, top)
            for j=1,2 do 
                c.createBlock(start + 31*i, top + 32*j)
            end
        end

        c.createTigerBeetle(start + 150, top)
        c.createSign2(start + 1100,top)

        c.createBigStone(start + 12, top)
        c.createStone(start + 74, top)
        c.createGrass1(start + 400, top)
        c.createGrass2(start + 732, top)
        c.createGrass1(start + 700, top + 5)
        c.createGrass1(start + 764, top + 5)
        c.createCactus3(start + 1400, top)
    end
end



local function createLevel7()
    g.setPlayer(c.createPlayer(300))
    
    do
        top = display.contentHeight-64

        createSetOfBlocks(0,top,50)

        c.createEnemyTank(1200,top)
        c.createLandMine(1300,top)

        c.createMovingBlock(2400,top,0)
        c.createGrass1(200, top)
        c.createCactus2(700, top)
        c.createBigStone(760, top)

        c.createCactus1(1400,top)
    end

    do
        top = display.contentHeight-128
        start = 2450

        local width = 30
        local hillWidth = 10
        local hillStart = start+(width-hillWidth)*32+32
        local hillTop = top-128

        createSetOfBlocksLeftHill(start,top,width,hillWidth,hillTop)

        c.createCrate(start + 150, top-32)
        c.createSpike(start + 150, top-32)
        c.createLandMine(start + 500, top)

        c.createSpike(hillStart,hillTop)
        c.createEnemy(hillStart+510,hillTop)
        c.createEnemy(hillStart+200,hillTop)

        c.createGrass2(start + 34, top)
        c.createGrass1(start + 180, top)
        c.createDesertTree(start + 300, top)
        c.createGrass2(start + 330, top)
        c.createDesertBush1(start + 600, top)

        c.createStone(hillStart + 100, hillTop)
        c.createBigStone(hillStart + 220, hillTop)
        c.createStone(hillStart + 330, hillTop)
    end

    
    do
        top = display.contentHeight-32
        start = 3700

        createSetOfBlocks(start,top,50)

        c.createSpike(start+110,top-32)
        c.createCrate(start + 110,top-32)
        c.createEnemyTank(start + 500, top)

        c.createSkeleton(start + 260, top)
        c.createCactus3(start + 745, top)
        c.createGrass1(start + 920, top)
        c.createGrass2(start + 945, top)
        c.createCactus1(start + 910, top)
        c.createStone(start + 1098, top)
        c.createDesertBush1(start + 1370, top)

        c.createSign2(start + 700, top)
    end

end

local function createLevel8()
    g.setPlayer(c.createPlayer(300))
    
    do
        top = display.contentHeight-32
        local hillTop = top-128

        createSetOfBlocksLeftHill(0,top,55,30,hillTop)
        c.createTigerBeetle(700,top)
        c.createTigerBeetle(770,top)

        c.createSpike(832,hillTop)
        c.createLandMine(940,hillTop)
        c.createTigerBeetle(880,hillTop)


        c.createStone(1100, hillTop)
        c.createBigStone(1150, hillTop)
        c.createStone(1200, hillTop)

        c.createTigerBeetle(1050,hillTop)

        c.createCrate(1368,hillTop-32)
        c.createCrate(1400,hillTop-32)
        c.createCrate(1400,hillTop-64)

        c.createBigStone(1800, hillTop)

        c.createLandMine(1336,hillTop)
        c.createSpike(1400,hillTop-64)
        c.createTigerBeetle(1600,hillTop)
        c.createTigerBeetle(1680,hillTop)

        c.createDesertBush2 (280, top)

        c.createStone(500, top)
        c.createStone(520, top)
        c.createBigStone(580, top)
        c.createStone(610, top)
        c.createStone(650, top)

        c.createStone(832, hillTop)

        c.createGrass1(1480, hillTop)
        c.createStone(1400, hillTop)
        c.createBigStone(1450, hillTop)
        c.createStone(1500, hillTop)


    end

    do
        top = display.contentHeight-240
        start = 2100

        createSetOfBlocks(start,top,2)
        c.createLandMine(start + 50, top)
    end

    do
        top = display.contentHeight-32
        start = 2500

        createSetOfBlocks(start,top,10)

        c.createDesertTree(start + 300, top)
        c.createGrass1(start +  330, top)
        c.createSkeleton(start + 260, top)
        c.createFrog(start+100,top)
    end

    do
        top = display.contentHeight-32
        start = 3000

        createSetOfBlocks(start,top,30)
        c.createSign2(start + 200, top)

        c.createBigStone(start + 50, top)
        c.createDesertBush2(start + 250, top)
        c.createStone(start + 330, top)
        c.createDesertBush1(start + 580, top)
        c.createGrass2(start + 610, top)
        c.createStone(start + 660, top)
        c.createCactus1(start + 860, top)
    end

end

local function createLevel9()
    g.setPlayer(c.createPlayer(300))
     
    do
        top = display.contentHeight-32

        createSetOfBlocks(0,top,30)
        c.createCrate(980,top-32)
        c.createSpike(980,top-32)

        c.createCactus1(200, top)
        c.createGrass2(620, top)
        c.createStone(661, top)
        c.createGrass1(995,top)
    end

    do
        top = display.contentHeight
        start = 1250
        hillTop = top-96
        createSetOfBlocksLeftHill(start,top,40,15,hillTop)
        c.createEnemyTank(start + 300, top)

        c.createFrog(start + 850, hillTop)
        c.createEnemyTank(start + 1200, hillTop)

        c.createStone(start + 54, top)
        c.createDesertBush1(start + 460, top)

        c.createDesertBush2(start + 940, hillTop)
        c.createCactus3(start + 900, hillTop)

        c.createGrass2(start+1200, hillTop)
    end

    do
        top = display.contentHeight - 192
        start = 3400

        createSetOfBlocks(start,top,10)
        c.createEnemyTank(start+100,top)

        c.createBigStone(start + 320, top)
    end

    do
        top = display.contentHeight - 32
        start = 2900

        c.createSign1(start + 420, top)

        createSetOfBlocks(start,top,32)
        c.createFrog(start + 500, top)

        c.createStone(start+160, top)
        c.createSkeleton(start+200, top)
        c.createBigStone(start+270, top)
    end

    do
        top = display.contentHeight - 64
        start = 4100

        createSetOfBlocks(start,top,2)
        c.createDesertBush2(start + 70, top)
    end

    do
        top = display.contentHeight - 64
        start = 4480

        createSetOfBlocks(start,top,20)
        c.createCrate(start + 75, top - 32)
        c.createSpike(start + 75, top - 32)

        c.createEnemyTank(start + 400, top)
        c.createEnemyTank(start + 500, top)

        c.createGrass2(start+32, top)
        c.createCactus2(start + 610, top)
    end

    do
        top = display.contentHeight - 128
        start = 5450

        c.createBlockStartTop(start, top)
        c.createBlockEndTop(start + 3, top)
        for i=1,4 do
            c.createBlockStart(start, top + i*32)
            c.createBlockEnd(start + 3, top + i*32)
        end
        c.createSpike(start,top)
    end

    do
        top = display.contentHeight - 192
        start = 5750

        createSetOfBlocks(start,top,100)
        c.createSign2(start + 300, top)

        c.createStone(start + 30, top)
        c.createBigStone(start + 99, top)
        c.createGrass1(start + 60, top)

        c.createDesertTree(start + 450, top)
        c.createDesertBush1(start + 490, top-3)
    end
end

local function createLevel10()
    g.setPlayer(c.createPlayer(100))
     
    do
        top = display.contentHeight - 192

        createSetOfBlocks(0,top,30)

        c.createLandMine(900,top)
        c.createTigerBeetle(800,top)
        createSetOfBlocks(1200,top,0)

        c.createDesertTree(250, top)
        c.createDesertBush1(290, top-3)

        c.createStone(600, top)
        c.createStone(620, top)
        c.createStone(680, top)
        c.createBigStone(650, top)
        
        c.createStone(1205, top)
    end

    do
        top = display.contentHeight - 128
        start = 1600

        createSetOfBlocks(start,top,40)
        c.createLandMine(start + 150, top)
        c.createLandMine(start + 400, top)
        c.createCrate(start + 800, top-32)
        c.createCrate(start + 800, top-64)
        c.createSpike(start + 800, top-32)
        c.createSpike(start + 800, top-64)
        c.createLandMine(start + 800, top-64)
        c.createTigerBeetle(start + 970, top)

        c.createStone(start + 60, top)
        c.createCactus3(start + 320, top)
        c.createGrass2(start + 580, top)
        c.createGrass1(start + 620, top)
        
        c.createSkeleton(start + 1100, top)
        c.createDesertBush2(start + 1200, top)
    end

    do
        top = display.contentHeight - 128
        start = 3270
        hillTop = top - 128

        c.createSign1(start + 400, top)
        c.createBlockStartTop(start, top)
        c.createBlockEndTop(start + 2, top)
        for i=1,4 do
            c.createBlockStart(start, top+32*i)
            c.createBlockEnd(start+2, top+32*i)
        end

        c.createEnemy(start + 700, top)
        c.createTigerBeetle(start + 420, top)
        createSetOfBlocksLeftHill(start + 370, top, 35, 15, hillTop)

        c.createSpike(start + 1042, hillTop)
        c.createSkeleton(start + 1200,hillTop)

        c.createEnemy(start + 1200, hillTop)
        c.createEnemy(start + 1400, hillTop)

        c.createStone(start + 500, top)
        c.createCactus3(start +  620, top)
        c.createGrass1(start + 640, top)
        c.createGrass2(start + 670, top)
        c.createBigStone(start + 800, top)
        c.createCactus2(start + 890, top)
        c.createGrass2(start + 870, top)

        c.createGrass1(start + 1510,hillTop)
        c.createCactus1(start + 1500,hillTop)
        c.createBigStone(start + 1500,hillTop)
        c.createStone(start + 1510,hillTop)
        c.createStone(start + 1490,hillTop)
    end

    do 
        top = display.contentHeight - 256
        start = 5150

        createSetOfBlocks(start,top,12)
        c.createGrass2Back(start + 310, top)
        c.createEnemy(start + 50, top)
        c.createEnemyTank(start + 250, top)

        c.createDesertBush2(start + 100,top)
       
    end

    do 
        top = display.contentHeight - 64
        start =  5700
        lowLandTop = top + 64
        tryingPlaceBoulder = top + 58

        createSetOfBlocksLeftHill(start,top,30,20,lowLandTop)
        c.createEnemyTank(start + 200, top)
        c.createEnemyTank(start + 800, lowLandTop)
        c.createEnemyTank(start + 900, lowLandTop)

        c.createGrass2(start + 400, lowLandTop)
        c.createBigStone(start + 400, tryingPlaceBoulder)
        c.createCactus3(start + 600, lowLandTop)
        
    end

    do 
        top = display.contentHeight - 86
        start =  6700

        createSetOfBlocks(start,top,5)
        c.createFrog(start + 50,top)
        c.createSpike(start,top)
    end

    do 
        top = display.contentHeight - 128
        start =  7200

        createSetOfBlocksLeftHill(start, top, 26, 14, top-128)

        c.createGrass2(start + 410, top - 128)
        c.createGrass2(start + 430, top - 128)
        c.createGrass1(start + 450, top - 128)
        c.createGrass1(start + 470, top - 128)
        c.createGrass2(start + 490, top - 128)
        c.createGrass2(start + 530, top - 128)
        c.createGrass2(start + 550, top - 128)
        c.createGrass2(start + 570, top - 128)
        c.createGrass2(start + 590, top - 128)
        c.createGrass1(start + 610, top - 128)
        c.createGrass2(start + 630, top - 128)
        c.createGrass2(start + 650, top - 128)
        c.createGrass2(start + 670, top - 128)
        c.createGrass2(start + 690, top - 128)
        c.createGrass2(start + 710, top - 128)
        c.createGrass2(start + 750, top - 128)
        c.createGrass2(start + 770, top - 128)
        c.createGrass1(start + 790, top - 128)
        c.createGrass2(start + 810, top - 128)
        c.createGrass2(start + 830, top - 128)
        c.createGrass1(start + 850, top - 128)
        c.createGrass2(start + 870, top - 128)
        c.createGrass2(start + 890, top - 128)
        c.createGrass2(start + 900, top - 128)
        

        c.createFrog(start + 600, top-128)
        c.createFrog(start + 750, top-128)

        c.createDesertTree(start + 200, top)
        c.createGrass1(start + 38, top)
        c.createGrass1(start + 150, top)
        c.createGrass2(start + 180, top)
        c.createGrass2(start + 300, top)
        c.createGrass1(start + 380, top)
       
    end

    do 
        top = display.contentHeight
        start =  8450

        createSetOfBlocks(start, top, 120)
        c.createLandMine(start, top)
        c.createLandMine(start+200, top)
        c.createLandMine(start+232, top)

        c.createShip(start + 1400, top)

        c.createSkeleton(start + 80, top)
        c.createBigStone(start + 300, top)
        c.createCactus1(start + 428, top)
        c.createCactus2(start + 450, top)
        c.createCactus3(start + 520, top)
        c.createCactus2(start + 580, top)
        c.createStone(start + 640, top)
        c.createDesertBush1(start + 910, top)
        c.createGrass2(start + 1100, top)
        c.createGrass1(start + 1550, top)
        c.createGrass2(start + 1700, top)
        c.createGrass2(start + 1750, top)
        c.createDesertBush2(start + 1900, top)

        c.createEnemy(start + 2000, top)
    end
end

local createLevels = {createLevel0, createLevel1, createLevel2, createLevel3, createLevel4, createLevel5, 
createLevel6, createLevel7, createLevel8, createLevel9, createLevel10}

local function updateBackground(environment)
  display.remove(background)
  en.setEnvironment(environment)
  background = c.createBackground() 
end 

local function createLevel(level)
  g.setStopped(false)

  local environment = level <= 5 and 1 or 2
  updateBackground(environment)

  cH.setLevel(level)
  createLevels[level+1]()
end

M.setUp = function(creator, game, collisionHandler, level)
  setVariables(creator,game,collisionHandler)
  createLevel(level)
end

return M