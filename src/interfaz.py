import serial
import time

print ('\t\t\t\tMIPS - UNIDAD DE DEBUGGING')
ser = serial.Serial('/dev/ttyUSB1',38400,timeout=1)
print ('\t\tSerialPort: {} , BaudRate: {} , ByteSize: {}\n'.format(ser.name,ser.baudrate, ser.bytesize))

inline = ""
j=0

while 1:
	inline = ser.readline()
	if (inline != ""):
		print (inline)
		for i in range (4 , len(inline)+1 , 4):			
			reg = inline[i-4:i]
			byte1 = ord(reg[0]) - 48
			byte2 = ord(reg[1]) - 48
			byte3 = ord(reg[2]) - 48
			byte4 = ord(reg[3]) - 48

			if (j == 0 ):
				print('\n\t\t\t PC')
				print('PC : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			elif (j <= 32 ):
				if j==1:
					print('\n\t\t\t REGISTROS')
				print('Reg[{:0>2d}] : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(j-1,byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			elif (j <= 52 ):
				if j==33:
					print('\n\t\t\t MEMORIA')
				print('Mem[{:0>2d}] : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(j-33,byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			elif (j <= 70 ):
				if j == 53:
					print('\n\t\t\t LATCHS')
					print('Stage : Instruction Fetch')
					print('InstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				elif j== 54:
					print('Instruction \t: 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				
				elif j == 55:
					print('\nStage : Instruction Decode')
					print('EXE : 0x{:0>2x} MEM : 0x{:0>2x} WB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				elif j == 56:
					print('InstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				elif j == 57:
					print('RegA \t\t : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				elif j == 58:
					print('RegB \t\t : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				elif j == 59:
					print('Instruction_ls : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				elif j == 60:
					print('dir_Rs : 0x{:0>2x} dir_Rt : {:0>2x} dir_Rd : {:0>2x} PC_write[1] IF_ID_write[0] : 0b{:0>8b} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
				
				elif j == 61:
					print('\nStage : Execute')
					print('EXE : 0x{:0>2x} MEM : 0x{:0>2x} WB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte2,byte3,byte4,byte1,byte2,byte3,byte4))

				#elif j == 62:
#					print('PC_write : 0b{:b} IF_ID_write : 0b{:b} rs : 0x{:0>2x} rt : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte[1]byte1[0],byte2,byte3,byte4,byte1,byte2,byte3,byte4))
#				elif j == 59:
#					print('InstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
#				elif j == 59:
#					print('InstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))

			else:
				print('0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			j=j+1