import serial
import time


def switch_demo(argument,byte1,byte2,byte3,byte4):
    switcher = {
        0:  '\n\t\t\t Program Counter\nPC : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        53: '\nStage : Instruction Fetch\nInstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        54: 'Instruction \t: 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        55: '\nStage : Instruction Decode\nEXE : 0x{:0>2x} MEM : 0x{:0>2x} WB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        56: 'InstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        57: 'RegA \t\t : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        58: 'RegB \t\t : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        59: 'Instruction_ls : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        60: 'dir_Rs : 0x{:0>2x} dir_Rt : {:0>2x} dir_Rd : {:0>2x} PC_write[1] IF_ID_write[0] : 0b{:0>8b} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        61: '\nStage : Execute\nMEM : 0x{:0>2x} WB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte3,byte4,byte1,byte2,byte3,byte4),
        62: 'PC_write[1] IF_ID_write[0] : 0b{:b} rs : 0x{:0>2x} rt : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        63: 'PCJump : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        64: 'ALUResult : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        65: 'RegB : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        66: 'ALUZero : 0x{:0>2x} RegF_wreg : {:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte3,byte4,byte1,byte2,byte3,byte4),
        67: '\nStage : Memory\nWB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte4,byte1,byte2,byte3,byte4),
        68: 'PCJump : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        69: 'RegF_wd : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        70: 'ALUResult : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        71: 'PCSel : 0x{:0>2x} RegF_wreg : {:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte3,byte4,byte1,byte2,byte3,byte4),
        72: '\nStage : Write Back\nRegF_wd : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        73: 'RegF_wr : {:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte4,byte1,byte2,byte3,byte4)
    }
    print switcher.get(argument, "Error!!")

#switch_demo(1,4)


print ('\t\t\t\tMIPS - UNIDAD DE DEBUGGING')
ser = serial.Serial('/dev/ttyUSB1',19200,timeout=1)
print ('\t\tSerialPort: {} , BaudRate: {} , ByteSize: {}\n'.format(ser.name,ser.baudrate, ser.bytesize))

inline = ""
j=0


#var = raw_input("Write or Read? [w/r]: ")
	
	#if (var == "w"):
#print(" Escribimos ")
#ser.write("fasdf4444")

while 1:
	j=0
	#ser.write("fasdf4444")
	var = raw_input("Write or Read? [w/r]: ")
	
	if (var == "w"):
		print(" Escribimos ")
		ser.write('la puta madre...')

	#if (var == "r"):
	#	print(" Leemos!! ")
	
	#inline = ser.readline() # Lee hasta que se vacie el buffer.
	inline = ser.read(296) #Lee 296 bytes del buffer. 
	if (inline != ""):
		#print (inline)
		for i in range (4 , len(inline)+1 , 4):			
			reg = inline[i-4:i]
			byte1 = ord(reg[0]) - 48
			byte2 = ord(reg[1]) - 48
			byte3 = ord(reg[2]) - 48
			byte4 = ord(reg[3]) - 48

			if (j == 0 ):
				#print('\n\t\t\t PC')
				switch_demo(j,byte1,byte2,byte3,byte4)
			elif (j <= 32 ):
				if j==1:
					print('\n\t\t\t REGISTROS')
				print('Reg[{:0>2d}] : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(j-1,byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			elif (j <= 52 ):
				if j==33:
					print('\n\t\t\t MEMORIA')
				print('Mem[{:0>2d}] : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(j-33,byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			elif (j <= 73 ):
				if j == 53:
					print('\n\t\t\t LATCHS')
					#print('Stage : Instruction Fetch')
				switch_demo(j,byte1,byte2,byte3,byte4)
			else:
				print('Default: 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			j=j+1


