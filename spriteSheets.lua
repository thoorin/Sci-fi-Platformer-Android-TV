-----------------------------------------------------------------------------------------
--
-- creator.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local sheetOptionsPlayer = { width = 138, height = 123, numFrames = 14 }
local playerSheet = graphics.newImageSheet( "player.png", sheetOptionsPlayer )

local sheetOptionsPlayerDeath = { width = 200, height = 150, numFrames = 18 }
local playerDeathSheet = graphics.newImageSheet( "player_death.png", sheetOptionsPlayerDeath )

local playerSequences = {
    {
        name = "run",
        start = 1,
        count = 14,
        time = 800,
        loopCount = 0,
        sheet = playerSheet
    },
    {
        name = "death",
        start = 1,
        count = 18,
        time = 800,
        loopCount = 1,
        sheet = playerDeathSheet
    }
}

local sheetOptionsWater ={ width = 421, height = 512, numFrames = 17, sheetContentWidth = 7168, sheetContentHeight = 512 }
local waterSheet = graphics.newImageSheet( "spritesheet.png", sheetOptionsWater )

local waterSequences = {
    {
        name = "water",
        start = 1,
        count = 17,
        time = 1200,
        loopCount = 0
    }
}



local sheetOptionsLarvaEmerge = { width = 100, height = 77, numFrames = 10 }
local larvaEmergeSheet = graphics.newImageSheet( "tiger_beetle_emerge.png", sheetOptionsLarvaEmerge )

local sheetOptionsLarvaIdle = { width = 100, height = 92, numFrames = 30 }
local larvaIdleSheet = graphics.newImageSheet( "tiger_beetle_idle.png", sheetOptionsLarvaIdle)

local sheetOptionsLarvaDeath = { width = 200, height = 127, numFrames = 10 }
local larvaDeathSheet = graphics.newImageSheet( "tiger_beetle_death.png", sheetOptionsLarvaDeath )

local sheetOptionsLarvaAttack = { width = 130, height = 94, numFrames = 9 }
local larvaAttackSheet = graphics.newImageSheet( "larva_attack.png", sheetOptionsLarvaAttack )


local larvaSequences = {
    {
        name = "emerge",
        sheet = larvaEmergeSheet,
        start = 1,
        count = 10,
        time = 600,
        loopCount = 1
    },
    {
        name = "idle",
        sheet = larvaIdleSheet,
        start = 1,
        count = 30,
        time = 1200,
        loopCount = 0   
    },
    {
        name = "death",
        sheet = larvaDeathSheet,
        start = 1,
        count = 10,
        time = 600,
        loopCount = 1   
    },
    {
        name = "attack",
        sheet = larvaAttackSheet,
        start = 1,
        count = 9,
        time = 600,
        loopCount = 1   
    }
}

local sheetOptionsOrk = { width = 90, height = 67, numFrames = 7}
local orkWalkSheet = graphics.newImageSheet( "ork_walk.png", sheetOptionsOrk )

local sheetOptionsOrkStart = { width = 90, height = 67, numFrames = 2}
local orkStartSheet = graphics.newImageSheet( "ork_walk.png", sheetOptionsOrkStart )

local sheetOptionsOrkDIE = { width = 110, height = 65, numFrames = 7}
local orkDeathSheet = graphics.newImageSheet( "ork_die.png", sheetOptionsOrkDIE )

local sheetOptionsOrkATTACK = { width = 100, height = 120, numFrames = 7}
local orkAttackSheet = graphics.newImageSheet( "ork_attack.png", sheetOptionsOrkATTACK )

local orkSequences = {
    {
        name = "start",
        sheet = orkStartSheet,
        start = 1,
        count = 2,
        time = 2400,
        loopCount = 0
    },
    {
        name = "walk",
        sheet = orkWalkSheet,
        start = 1,
        count = 7,
        time = 600,
        loopCount = 0
    },
    {
        name = "die",
        sheet = orkDeathSheet,
        start = 1,
        count = 7,
        time = 600,
        loopCount = 1
    },
    {
        name = "attak",
        sheet = orkAttackSheet,
        start = 1,
        count = 7,
        time = 400,
        loopCount = 1
    }
}

local sheetOptionsExplosion = { width = 512, height = 512, numFrames = 64}
local explosionSheet = graphics.newImageSheet( "explosion.png", sheetOptionsExplosion )

local explosionSequences = {
    {
        name = "explode",
        start = 1,
        count = 64,
        time = 600,
        loopCount = 1
    }
}

local sheetOptionsBullet = { width = 25, height = 60, numFrames = 5}
local bulletSheet = graphics.newImageSheet( "bulletSheet.png", sheetOptionsBullet )

local bulletSequences = {
    {
        name = "bullet",
        start = 1,
        count = 5,
        time = 600,
        loopCount = 0
    }
}

local sheetOptionsSmoke = { width = 75, height = 175, numFrames = 8}
local smokeSheet = graphics.newImageSheet( "smoke.png", sheetOptionsSmoke )

local smokeSequences = {
    {
        name = "smoke",
        start = 1,
        count = 8,
        time = 600,
        loopCount = 1
    }
}

local sheetOptionsSmokes = { width = 180, height = 600, numFrames = 27}
local smokesSheet = graphics.newImageSheet( "smokes.png", sheetOptionsSmokes )

local smokesSequences = {
    {
        name = "smokes",
        start = 1,
        count = 27,
        time = 1600,
        loopCount = 0
    }
}

local sheetOptionsFrog = { width = 100, height = 81, numFrames = 17}
local frogSheet = graphics.newImageSheet( "frog_jump.png", sheetOptionsFrog )

local sheetOptionsFrogDeath = { width = 73, height = 72, numFrames = 24}
local frogDeathSheet = graphics.newImageSheet( "frog_death.png", sheetOptionsFrogDeath )

local sheetOptionsFrogAttack = { width = 66, height = 55, numFrames = 17}
local frogAttackSheet = graphics.newImageSheet( "frog_attack.png", sheetOptionsFrogAttack )

local frogSequences = {
    {
        name = "jump",
        sheet = frogSheet,
        start = 1,
        count = 17,
        time = 800,
        loopCount = 0
    },
    {
        name = "death",
        sheet = frogDeathSheet,
        start = 1,
        count = 24,
        time = 1200,
        loopCount = 1
    },
    {
        name = "attack",
        sheet = frogAttackSheet,
        start = 1,
        count = 17,
        time = 1200,
        loopCount = 1
    },
}


local sheetOptionsPoison = { width = 61, height = 20, numFrames = 12}
local poisonSheet = graphics.newImageSheet( "poison.png", sheetOptionsPoison )

local poisonSequences = {
    {
        name = "poison",
        start = 1,
        count = 12,
        time = 1000,
        loopCount = 0
    }
}

local sheetOptionsPoisonImpact = { width = 47, height = 75, numFrames = 12}
local poisonImpactSheet = graphics.newImageSheet( "poison_impact.png", sheetOptionsPoisonImpact )

local poisonImpactSequences = {
    {
        name = "poisonImpact",
        start = 1,
        count = 12,
        time = 400,
        loopCount = 1
    }
}

local sheetOptionsSpike = { width = 64, height = 183, numFrames =5}
local spikeSheet = graphics.newImageSheet( "spike.png", sheetOptionsSpike )

local spikeSequences = {
    {
        name = "spike",
        start = 3,
        count = 2,
        time = 100,
        loopCount = 1
    }
}

M.getPoisonImpactSheet = function()
    return poisonImpactSheet
end

M.getPoisonImpactSequences = function()
    return poisonImpactSequences
end

M.getPoisonSheet = function()
    return poisonSheet
end

M.getPoisonSequences = function()
    return poisonSequences
end

M.getExplosionSequences = function()
    return explosionSequences
end

M.getExplosionSheet = function()
    return explosionSheet
end

M.getExplosionSequences = function()
    return explosionSequences
end

M.getBulletSheet = function()
    return bulletSheet
end

M.getBulletSequences = function()
    return bulletSequences
end

M.getSmokeSheet = function()
    return smokeSheet
end

M.getSmokeSequences = function()
    return smokeSequences
end

M.getSmokesSheet = function()
    return smokesSheet
end

M.getSmokesSequences = function()
    return smokesSequences
end

M.getPlayerSheet = function()
    return playerSheet
end

M.getPlayerSequences = function()
    return playerSequences
end

M.getWaterSheet = function()
    return waterSheet
end

M.getWaterSequences = function()
    return waterSequences
end

M.getLarvaEmergeSheet = function()
    return larvaEmergeSheet
end

M.getLarvaSequences = function()
    return larvaSequences
end

M.getOrkStartSheet = function()
    return orkStartSheet
end

M.getOrkSequences = function()
    return orkSequences
end

M.getFrogSheet = function()
    return frogSheet
end

M.getFrogSequences = function()
    return frogSequences
end


M.getSpikeSheet = function()
    return spikeSheet
end

M.getSpikeSequences = function()
    return spikeSequences
end

return M