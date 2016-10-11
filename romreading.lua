
--File reading

function Loadfile(fileobj)


	local filestring = love.filesystem.read(fileobj)


	for N = 0, #filestring -1 do

	file[N] = filestring:byte( N + 1 )

	end

end

function fileread8(addr)
	val = file[addr]
	return val
end


function fileread16(addr)

	val1 = file[addr]

	val2 = (file[addr+1])


	val = val1 + val2*0x100


return val

end



function fileread16signed(addr)

val1 = file[addr]

	val2 = (file[addr+1])


val = val1 + val2*0x100


if val < 0x8000 then

		val = val

		else
	val = val - 0x10000

		end


return val

	end



function fileread32(addr)

val1 = file[addr]

val2 = (file[addr+1])*0x100

	val3 = (file[addr+2])*0x10000

	val4 = (file[addr+3])*0x1000000


val = val1 + val2 + val3 + val4


	return val

end




--Palette
function
colorgrab(adr)


	local alpha = bit.band(file[adr+1], 0xF0)

	local red = bit.band(file[adr+1], 0x0F)

	local green = (bit.band(file[adr], 0xF0))/0x10

	local blue = bit.band(file[adr], 0xF)


	local color = {(red * 17) , (green * 17) , (blue * 17),0xFF}

	return color

end



function palettedraw(size,adr,xpos,rows,length)


for height = 0,rows,1 do

love.graphics.setColor(0xFF,0xFF,0xFF,0xFF)

	love.graphics.print("Row: " .. height,xpos+(length+1.5)*16 ,9 + height*16)


	for row1 = 0,length,1 do

		adr = adr + size

	love.graphics.setColor(colorgrab(adr))

		love.graphics.rectangle("fill",xpos+4+row1*16, 8+height*16, 16, 16)

		end

	end


end



--Collison

function drawaxis(x,y,size)

	love.graphics.line(x-size,y,x+size,y)

	love.graphics.line(x,y-size,x,y+size)

end



function drawcolbox(adr,x,y,id,number)

	adr = adr + (number*8)


x1 = fileread16signed(adr+0x00)+x

	x2 = fileread16(adr+0x02)

	y1 = y + fileread16signed(adr+0x04)

	y2 = fileread16(adr+0x06)


	boxr = boxcolors[id*3 + 1]

	boxg = boxcolors[id*3 + 2]

	boxb = boxcolors[id*3 + 3]

	love.graphics.setColor(boxr,boxg,boxb,0xFF)

	drawaxis(x1,y1,4)

--love.graphics.print(string.format("X1,X2,Y1,Y2: %04d,%04d,%04d,%04d",x1,x2,y1,y2),64,128)
		love.graphics.rectangle("line",x1-x2,y1-y2,x2*2,y2*2)


love.graphics.setColor(boxr,boxg,boxb,0x80)
love.graphics.rectangle("fill",x1-x2,y1-y2,x2*2,y2*2)


end
