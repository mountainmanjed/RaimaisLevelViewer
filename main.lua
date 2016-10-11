love.graphics.setBackgroundColor(00,00,90)
require("ObjectTables")

bit = require("numberlua")
file = {}
require("romreading")
level = 1
enemydisplay = 1

function drawaxis(x,y,size)
    love.graphics.setColor(0xff,0xFF,0xFF,0xFF)
	love.graphics.line(x-size,y,x+size,y)
	love.graphics.line(x,y-size,x,y+size)
end

function drawoutline(x,y,xr,yr)
for height = 0,1,1 do
    for xboxes = 0,xr,1 do
    love.graphics.setColor(0xff,0xFF,0xFF,0xFF)
        love.graphics.rectangle("fill",x+xboxes*16, y+height*384, 15, 15)
        end
    end
for width = 0,1,1 do
    for yboxes = 0,yr,1 do
    love.graphics.setColor(0xff,0xFF,0xFF,0xFF)
        love.graphics.rectangle("fill",x+width*624, 16+y+yboxes*16 , 15, 15)
    end
end
end

function drawbarrier(baddr,x,y)
for barrier = 0,5,1 do
for fullrow = 0,33,1 do
    baddr = baddr + 1
    text = fileread8(baddr)
        if file[baddr] ~= 0 then
        imagey = bit.band(text,0xF0)
        imagex = bit.band(text,0x0F)*16
        local quad = love.graphics.newQuad(imagex, imagey, 16, 16, 256,256)
        love.graphics.draw(tiles,quad,x+fullrow*16, y+barrier*48,0,2,2)
        --love.graphics.rectangle("fill",x+fullrow*16, y+barrier*48, 15, 15)
        end
    love.graphics.print(string.format("%02X",text),32+fullrow*16,440+barrier*48)
    end

for partialrow1 = 0,11,1 do
    baddr = baddr + 1
    text = fileread8(baddr)
        if file[baddr] ~= 0 then
        imagey = bit.band(text,0xF0)
        imagex = bit.band(text,0x0F)*16
        local quad = love.graphics.newQuad(imagex, imagey, 16, 16, 256,256)
        love.graphics.draw(tiles,quad,x+partialrow1*48, 16+y+barrier*48,0,2,2)
        --love.graphics.rectangle("fill",x+partialrow1*48, 16+y+barrier*48, 15, 15)
        end
    love.graphics.print(string.format("%02X",text),32+partialrow1*48,456+barrier*48)
    end

for partialrow2 = 0,11,1 do
    baddr = baddr + 1
    text = fileread8(baddr)
        if file[baddr] ~= 0 then
            imagey = bit.band(text,0xF0)
            imagex = bit.band(text,0x0F)*16
            local quad = love.graphics.newQuad(imagex, imagey, 16, 16, 256,256)
            love.graphics.draw(tiles,quad,x+partialrow2*48,32+y+barrier*48,0,2,2)
            --love.graphics.rectangle("fill",x+partialrow2*48, 32+y+barrier*48, 15, 15)
        end
    love.graphics.print(string.format("%02X",text),32+partialrow2*48,472+barrier*48)
    end
end

for finalrow = 0,33,1 do
    baddr = baddr + 1
    barrier = file[baddr]
    if file[baddr] ~= 0 then
        imagey = bit.band(barrier,0xF0)
        imagex = bit.band(barrier,0x0F)*16
        --love.graphics.rectangle("fill",x+finalrow*16, y+18*16, 15, 15)
        local quad = love.graphics.newQuad(imagex, imagey, 16, 16, 256,256)
        love.graphics.draw(tiles,quad,x+finalrow*16,y+18*16,0,2,2)
        end
    love.graphics.print(string.format("%02X",barrier),32+finalrow*16,440+18*16)
    end
end

function drawpellets(daddr,x,y)
for height = 0,7,1 do
--    love.graphics.print(string.format("Addr: %06X",adr+1),x+(300) ,y + height*16)
    for rows = 0,12,1 do
        daddr = daddr + 1
        oid = file[daddr]+1
    	love.graphics.print(string.format("%02s",objects[oid]),x+rows*20,y+height*16)
    end
    end
end

function drawlevelobjects(oaddr,x,y)
local objcount = 0

repeat objcount = objcount + 1
until fileread8(oaddr + (objcount * 3)) == 0x00


for objloop = 0,objcount-1,1 do
    oaddr = oaddr + 3
    local objx  = fileread8(oaddr)
    local objy  = fileread8(oaddr + 1)
    local objid = fileread8(oaddr + 2) - 1
    local imgy = bit.band(objid,0x0F)*32
        if objx ~= 0 then
            local quad = love.graphics.newQuad(0, imgy, 32, 32, 32,512)
            love.graphics.draw(objectsgfx,quad,x+objx*16,(y+objy*16)-32,0,2,2)
        	love.graphics.print(string.format("%02X %02X %02X",objx,objy,objid+1),800,500+objloop*16)
            --love.graphics.draw(objectsgfx,quad,182,182,0,2,2)

        end
    end
end



function drawpelletsgfx(daddr,x,y)
for height = 0,7,1 do
--    love.graphics.print(string.format("Addr: %06X",adr+1),x+(300) ,y + height*16)
    for rows = 0,12,1 do
        daddr = daddr + 1
        if file[daddr] ~= 0 then
            dot = file[daddr]
            imagey = bit.band(dot,0xF0)
            imagex = bit.band(dot,0x0F)*16
            love.graphics.setColor(0xFF,0xFF,0xFF,0xFF)
            --love.graphics.image("fill",16+x+rows*48, 16+y+height*48, 31, 31)
            --love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
            local quad = love.graphics.newQuad(imagex, imagey, 16, 16, 256,256)
            love.graphics.draw(tiles,quad,16+x+rows*48,16+y+height*48,0,2,2)
        end
    end
    end
end

function drawenemy(eaddr,x,y)
for e = 0,15,1 do
eaddr = eaddr + 0x0E
local id  = fileread8(eaddr)
local enx = x + fileread16(eaddr+2)
local eny = y + fileread8(eaddr+1)
local mimspeed = fileread8(eaddr + 4)
local maxspeed = fileread8(eaddr + 5)
local facing = bit.band(fileread8(eaddr + 6), 0x03)
--Facing directions 0left, 1 up, 2 right, 3 down
local quad = love.graphics.newQuad(id*16, 0, 16, 16, 144,16)

if file[eaddr] ~= 0 then
    love.graphics.draw(enemygfx,quad,(enx*2)-facemath[facing*2+1],(eny*2)-facemath[facing*2+2],math.rad(facing*90),2,2)
    --drawaxis((enx*2)-16,(eny*2)-80,16)
    love.graphics.print(string.format("Enemy%02X - ID:%d ; X,Y: %d,%d ;  Speed Min/Max: %d / %0d ",e,id,enx,eny,mimspeed,maxspeed),800,300+e*16)
end
end
end

function love.load()
Loadfile("b36-09.bin")
objectsgfx = love.graphics.newImage("SpecialT.png")
tiles = love.graphics.newImage("RaimaisTiles.png")
enemygfx = love.graphics.newImage("Enemies.png")
love.keyboard.setKeyRepeat(true)
end

function love.update()
roundaddr = roundaddresstable[level]

    function love.keypressed(key, isrepeat)
    	if key == "up" or key == "w" then
            if roundaddr > 0x667 then
            level = level - 1
            end
    	elseif key == "down" or key == "s" then
            if roundaddr < 0x1F999 then
            level = level + 1
            end
        elseif key == "x" then
            if enemydisplay == 1 then
            enemydisplay = 0
            elseif enemydisplay == 0 then
            enemydisplay = 1
            end
        end
    end

love.load()
end


function love.draw()
love.graphics.setColor(0xff,0xFF,0xFF,0xFF)
love.graphics.print(string.format("Addr: %06X",roundaddr),0,0)
love.graphics.print(string.format("Name: %s",StageNameTable[level]),0,16)


drawoutline(32,32,39,22)
drawbarrier(roundaddr - 0x001,80,80)
drawpellets(roundaddr + 0x17D,800,32)
drawpelletsgfx(roundaddr + 0x17D,32,32)
drawlevelobjects(roundaddr + 0x1e3,32,32)

if enemydisplay == 1 then
drawenemy(roundaddr + 0x246 - 0x0E,32,32)
end


end
