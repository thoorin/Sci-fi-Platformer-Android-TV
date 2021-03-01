-----------------------------------------------------------------------------------------
--
-- fileHandler.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local fileName = "recordsPlatformer.txt"
local fileName2 = "currentLevel.txt"
local level 

M.generateFiles = function()
    print("Generating files")
    local path = system.pathForFile( fileName, system.DocumentsDirectory )
    local file = io.open( path )
    if not file then
        io.close()
        io.open( path, "w" )
        io.close()
    end

    path = system.pathForFile( fileName2, system.DocumentsDirectory )
    file = io.open( path )
    
    if not file then
        io.close()
        io.open( path, "w" )
        io.close()
    end
end

M.getRecord = function(lvl)
    local path = system.pathForFile( fileName, system.DocumentsDirectory )
    local file, errorString = io.open( path, "r" )
    level = lvl
    
    local records = {}

    if not file then
        print( "File error: " .. errorString )
    else
        
        for line in file:lines() do
            table.insert(records,tonumber(line))
        end
        io.close( file )
    end

    file = nil

    return records[level]
end

M.writeRecord = function(record)
    local records = {}

    local path = system.pathForFile( fileName, system.DocumentsDirectory )

    local file, errorString = io.open( path, "r" )
 
    if not file then
        print( "File error: " .. errorString )
    else

    for line in file:lines() do
        table.insert(records,line)
    end


    if (records[level]~=nil) then
        table.remove(records,level)
    end

    table.insert(records,level,record)

    io.close( file )
    end

    file, errorString = io.open( path, "w" )
 
    if not file then
        print( "File error: " .. errorString )
    else

    for i in ipairs(records) do
        file:write( records[i] )
        file:write( "\n" )
    end
    io.close( file )
    end
 
    file = nil
end

M.getCurrentLevel = function()
    local path = system.pathForFile( fileName2, system.DocumentsDirectory )
    local file, errorString = io.open( path, "r" )
    local currentLevel

    if not file then
        print( "File error: " .. errorString )
    else
        currentLevel = file:read( "*n" )
        io.close( file )
    end

    file = nil

    if (currentLevel == nil) then
        currentLevel = 1
    end

    return currentLevel
end


M.updateCurrentLevel = function()
    local path = system.pathForFile( fileName2, system.DocumentsDirectory )
    local currentLevel = M.getCurrentLevel() + 1

    local file, errorString = io.open( path, "w" )

    if not file then
        print( "File error: " .. errorString )
    else

    file:write( currentLevel )

    io.close( file )
    end
 
    file = nil
end



return M