import serial
import time

# Esta tabla contiene el set de instrucciones implementado. 
# Se utiliza para mostrar informacion al usuario.
def instruction_set(argument):
    instr = {
        #KEY    :   (instruction, example, description)
        1  : ('Shift L logical          '    ,'sll  rd  rt shamt'    , 'sll  $t10 $t6 1  '),
        2  : ('Shift R logical          '    ,'srl  rd  rt      '    , 'srl  $t11 $t6 2  '),
        3  : ('Shift R arithmetic       '    ,'sra  rd  rt      '    , 'sra  $t12 $t4 3  '),
        4  : ('Shift L logical variable '    ,'sllv rd  rt  rs  '    , 'sllv $t20 $t6 $t1'),
        5  : ('Shift R logical variable '    ,'srlv rd  rt  rs  '    , 'srlv $t21 $t6 $t1'),
        6  : ('Shift R arithmetic variable'  ,'srav rd  rt  rs  '    , 'srav $t22 $t6 $t1'),
        7  : ('Addition (without overflow)'  ,'addu rd  rt  rs  '    , 'addu $t23 $t6 $t1'),
        8  : ('Subtract (without overflow)'  ,'subu rd  rt  rs  '    , 'subu $t24 $t6 $t1'),
        9  : ('AND                      '    ,'and  rd  rt  rs  '    , 'and  $t25 $t6 $t1'),
        10 : ('OR                       '    ,'or   rd  rt  rs  '    , 'or   $t26 $t6 $t1'),
        11 : ('Exclusive OR             '    ,'xor  rd  rt  rs  '    , 'xor  $t27 $t6 $t1'),
        12 : ('NOR                      '    ,'nor  rd  rt  rs  '    , 'nor  $t28 $t6 $t1'),
        13 : ('Set less than            '    ,'slt  rd  rt  rs  '    , 'slt  $t29 $t6 $t1'),
        14 : ('Load byte                '    ,'lb   rt  offset  '    , 'lb   $t30 16     '),
        15 : ('Load halfword            '    ,'lh   rt  offset  '    , 'lh   $t31 16     '),
        16 : ('Load word                '    ,'lw   rt  offset  '    , 'lw   $t32 16     '),
        17 : ('Load unsigned byte       '    ,'lbu  rt  offset  '    , 'lbu  $t33 16     '),
        18 : ('Load unsigned halfword   '    ,'lhu  rt  offset  '    , 'lhu  $t34 16     '),
        19 : ('Store byte               '    ,'sb   rt  offset  '    , 'sb   $t35 16     '),
        20 : ('Store halfword           '    ,'sh   rt  offset  '    , 'sh   $t36 16     '),
        21 : ('Store word               '    ,'sw   rt  offset  '    , 'sw   $t37 16     '),
        22 : ('ADD immediate (with overflow)','addi rt  rs imm  '    , 'addi $t40 $t6 16 '),
        23 : ('AND immediate (with overflow)','andi rt  rs imm  '    , 'andi $t41 $t6 16 '),
        24 : ('OR immediate             '    ,'ori  rt  rs imm  '    , 'ori  $t42 $t6 16 '),
        25 : ('XOR immediate            '    ,'xori rt  rs imm  '    , 'xori $t43 $t6 16 '),       
        26 : ('Set less than immediate  '    ,'slti rt  rs imm  '    , 'slti $t44 $t6 16 '),
        27 : ('Branch on equal          '    ,'beq  rt  rs imm  '    , 'beq  $t45 $t6 16 '),
        28 : ('Branch on not equal      '    ,'bne  rt  rs imm  '    , 'bne  $t46 $t6 16 '),
        29 : ('Load upper immediate     '    ,'lui  rt  imm     '    , 'lui  $t47 16     '),
        30 : ('Jump                     '    ,'j    target      '    , 'j    26          '),
        31 : ('Jump and link            '    ,'jal  target      '    , 'jal  26          '),
        32 : ('Jump register            '    ,'jr   rt          '    , 'jr   $t50        '),
        33 : ('Jump and link register   '    ,'jalr rd  rs      '    , 'jalr $t51 $t16   '),
        34 : ('Finish the program 	'    ,'halt 	'    , 'halt 	'),
    }
    return instr.get(argument) 

# Esta tabla contiene la estructura de las instrucciones implementadas en el MIPS.
# Se utiliza para codificar el assembler escrito por el usuario.
def opcode(argument):
    op = {
    	#KEY	:	(estructura,cant_param, param1,param2,..)
    	'sll'	:	('000000_00000_RT_RD_SHAMT_000000',4,'REG_D','REG_T','SHAMT'), #
    	'srl'	:	('000000_00000_RT_RD_SHAMT_000010',4,'REG_D','REG_T','SHAMT'), #
    	'sra'	:	('000000_00000_RT_RD_SHAMT_000011',4,'REG_D','REG_T','SHAMT'), #
    	'sllv'	:	('000000_RS_RT_RD_00000_000100',4,'REG_D','REG_T','REG_S'), #
    	'srlv'	:	('000000_RS_RT_RD_00000_000110',4,'REG_D','REG_T','REG_S'), #
    	'srav'	:	('000000_RS_RT_RD_00000_000111',4,'REG_D','REG_T','REG_S'), #
        'addu'	:	('000000_RS_RT_RD_00000_100001',4,'REG_D','REG_T','REG_S'), #100001
        'subu'	:	('000000_RS_RT_RD_00000_100011',4,'REG_D','REG_T','REG_S'), #100011 
        'and'	:	('000000_RS_RT_RD_00000_100100',4,'REG_D','REG_T','REG_S'), #100100
        'or' 	:	('000000_RS_RT_RD_00000_100101',4,'REG_D','REG_T','REG_S'), #100101
        'xor'	:	('000000_RS_RT_RD_00000_100110',4,'REG_D','REG_T','REG_S'), #100110
        'nor'	:	('000000_RS_RT_RD_00000_100111',4,'REG_D','REG_T','REG_S'), #100111	
        'slt'	:	('000000_RS_RT_RD_00000_101010',4,'REG_D','REG_T','REG_S'), #101010
        'lb'	:	('100000_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Load byte -> lb rt address
        'lh'	:	('100001_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Load halfword -> lh rt address
        'lw'	:	('100011_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Load word -> lw rt address
        'lbu'	:	('100100_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Load unsigned byte -> lbu rt address
        'lhu'	:	('100101_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Load unsigned halfword -> lhu rt address
        'sb'	:	('101000_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Store byte -> sb rt address
        'sh'	:	('101001_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Store halfword -> sh rt address
        'sw'	:	('101011_RS_RT_OFFSET',4,'REG_T','REG_S','OFFSET'), #Store word -> sw rt address
        'addi'	:	('001000_RS_RT_IMMEDIATE',4,'REG_T','REG_S','IMMEDIATE'), #Addition immediate (with overflow) -> addi rt rs im
        'andi'	:	('001100_RS_RT_IMMEDIATE',4,'REG_T','REG_S','IMMEDIATE'), #AND immediate -> andi rt rs im
        'ori'	:	('001110_RS_RT_IMMEDIATE',4,'REG_T','REG_S','IMMEDIATE'), #OR immediate -> ori rt rs im
        'xori'	:	('001111_RS_RT_IMMEDIATE',4,'REG_T','REG_S','IMMEDIATE'), #XOR immediate -> xori rt rs im
        'lui'	:	('010000_00000_RT_IMMEDIATE',3,'REG_T','IMMEDIATE'), #Load upper immediate -> lui im
        'slti'	:	('001010_RS_RT_IMMEDIATE',4,'REG_T','REG_S','IMMEDIATE'), #Set less than immediate -> sltirt rs im
        'beq'	:	('000100_RS_RT_OFFSET',4,'REG_S','REG_T','OFFSET'), #Branch on equal -> beq rs rt label
        'bne'	:	('000101_RS_RT_OFFSET',4,'REG_S','REG_T','OFFSET'), #Branch on not equal -> bne rs rt label
        'j'		:	('000010_TARGET',2,'TARGET'), #jump -> j target
        'jal'	:	('000011_TARGET',2,'TARGET'), #jump and link -> jal target
        'jr'	:	('000000_RS_000000000000000_001000',2,'REG_S'), #jump register -> jr rs
        'jalr'	:	('000000_RS_00000_RD_00000_001001',3,'REG_S','REG_D'), #jump and link register -> jalr rs,rd  !!!!!
        'halt'	:	('01111111111111111111111111111110') # HALT
    }
    return op.get(argument) 

# Esta tabla contiene el orden y etiqueta de los datos que se reciben por UART 
# Se utiliza para presentar al usuario los datos recibidos.
def parseo(argument,byte1,byte2,byte3,byte4):
    switcher = {
        0:  '\n\t\t\t Program Counter\nPC : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        53: '\nStage : Instruction Fetch\nInstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        54: 'Instruction \t: 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        55: '\nStage : Instruction Decode\nEXE : 0x{:0>2x} MEM : 0x{:0>2x} WB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        56: 'InstructionAddress : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        57: 'RegA \t\t : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        58: 'RegB \t\t : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        59: 'Instruction_ls : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        60: 'dir_Rs : 0x{:0>2x} dir_Rt : 0x{:0>2x} dir_Rd : 0x{:0>2x} PC_write[1] IF_ID_write[0] : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        61: '\nStage : Execute\nMEM : 0x{:0>2x} WB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte3,byte4,byte1,byte2,byte3,byte4),
        62: 'PC_write[1] IF_ID_write[0] : 0b{:b} rs : 0x{:0>2x} rt : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        63: 'PCJump : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        64: 'ALUResult : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        65: 'RegB : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        66: 'ALUZero : 0x{:0>2x} RegF_wreg : {:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte3,byte4,byte1,byte2,byte3,byte4),
        67: '\nStage : Memory\nWB : 0x{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte4,byte1,byte2,byte3,byte4),
        #68: 'PCJump : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        68: 'RegF_wd : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        69: 'ALUResult : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        70: 'PCSel : 0x{:0>2x} RegF_wreg : {:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte3,byte4,byte1,byte2,byte3,byte4),
        71: '\nStage : Write Back\nRegF_wd : 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4),
        72: 'RegF_wr : {:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte4,byte1,byte2,byte3,byte4)
    }
    print switcher.get(argument, "Error!!")

# Esta funcion se encarga de enviar los datos por UART
# Parsea el argumento de 32bits en 4 grupos de 8bits, con 8 bits se representa un caracter ascii.
# Suma el peso de cada bit y concatena el ascii correspondiente a ese valor. Luego envia los 4 caracteres ascii 
def send(argument):
	print(argument)
	send = ''
	for j in range (0,32,8): # parseo el string en 4 grupos de 8 caracteres
		a = argument[j:j+8]
		cont = 0
		for i in range (0,8,1): # tomo cada uno de los caracteres del grupo
			cont = cont + int(a[i])*(2**(7-i)) # calculo el peso y lo sumo
		send = send + '{:c}'.format(cont)

	print('send: {} len: {}'.format(send, len(send)))
	ser.write(send)

# Esta funcion se encarga de desarmar la instruccion de assembler y transformarla en 32 caracteres (1 o 0) 
# Es necesario reordenar y adicionar datos segun la instruccion. 
def decode(cmd):
	print(cmd)

	try:
		cmd = cmd.lower()
		instruction = cmd.split(' ')
		print(instruction)

		binary_instruction = ''
		struct = opcode(instruction[0])[0]

		binary_instruction = binary_instruction + '{}'.format(struct)
		print("")

		print(binary_instruction + ' <- estructura')

		cant_param = opcode(instruction[0])[1]
		print(cant_param)

		for i in range(2,cant_param+1,1):
			
			instruction[i-1]=instruction[i-1].replace("$t","")
			instruction[i-1]=instruction[i-1].replace("r","")
			
			if((opcode(instruction[0])[i]) == 'REG_D'):
				#instruction[i-1]=instruction[i-1].replace("$t","")
				binary_instruction = binary_instruction.replace('RD','{:0>5b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} RD'.format(i-1))

			elif((opcode(instruction[0])[i]) == 'REG_T'):
				#instruction[i-1]=instruction[i-1].replace("$t","")
				binary_instruction = binary_instruction.replace('RT','{:0>5b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} RT'.format(i-1))

			elif((opcode(instruction[0])[i]) == 'REG_S'):
				#instruction[i-1]=instruction[i-1].replace("$t","")
				binary_instruction = binary_instruction.replace('RS','{:0>5b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} RS'.format(i-1))

			elif((opcode(instruction[0])[i]) == 'SHAMT'):
				binary_instruction = binary_instruction.replace('SHAMT','{:0>5b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} SHAMT'.format(i-1))

			elif((opcode(instruction[0])[i]) == 'OFFSET'):
				binary_instruction = binary_instruction.replace('OFFSET','{:0>16b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} OFFSET'.format(i-1))

			elif((opcode(instruction[0])[i]) == 'IMMEDIATE'):
				binary_instruction = binary_instruction.replace('IMMEDIATE','{:0>16b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} IMMEDIATE'.format(i-1))

			elif((opcode(instruction[0])[i]) == 'TARGET'):
				binary_instruction = binary_instruction.replace('TARGET','{:0>26b}'.format(int(instruction[i-1])))
				print(binary_instruction + ' <- param{} TARGET'.format(i-1))

		print(binary_instruction)
		binary_instruction = binary_instruction.replace("_","")
		print('Instruccion: {}\nLongitud: {}'.format(binary_instruction, len(binary_instruction)))
		return binary_instruction

	except:
		print("\nERROR - INSTRUCCION INVALIDA\n\n")
		return -1 


########################################  INTERACCION CON EL USUARIO  ######################################## 

print ('\t\t\t\tMIPS - UNIDAD DE DEBUGGING')

# Configuracion de la comunicacion serial
try:
	ser = serial.Serial('/dev/ttyUSB1',19200,timeout=1) 
	print ('\t\tSerialPort: {} , BaudRate: {} , ByteSize: {}\n'.format(ser.name,ser.baudrate, ser.bytesize))
except:
	print('ERROR - Asegurese de conectar el dispositivo ')
	exit()

# Seleccion del modo de debugging
print('Debugging Mode: \n\t 1) Debug at the end of the program (default)\n\t 2) Debug for each clock')
debug_mode = raw_input("Select the number of the mode: ")
if (debug_mode == '2'):
	send("00000000000000000000000000000001")
else:
	send("00000000000000000000000000000010")

# Se imprime el set de instrucciones soportado por el MIPS
print ('  ------------------------------ INSTRUCTION SET ------------------------------\n')
print ('| \t\tNAME   \t\t|\tINSTRUCTION \t|\tEXAMPLE \t|')
for i in range (1,35):
    print ('| {}\t|   {}\t|   {}\t|'.format(instruction_set(i)[0], instruction_set(i)[1], instruction_set(i)[2] ))
print ('  -----------------------------------------------------------------------------')


# Seleccion del modo de carga del programa de usuario
print('Load Program Mode: \n\t 1) Load from file (default) \n\t 2) Manual Loading')
load_mode = raw_input("Select the number of the mode: ")
if (load_mode != '2'):
	print ('  ---------------------------------- PROGRAM ----------------------------------\n')
	try:
		f = open ('TEST1.txt','r') #program_addi	
		while True:
			line = f.readline()
			if not line:
				print("LOAD SUCCESSFULLY")
				break
			line = line[:-1]
			print('{:^30}'.format(line))
			b_instruction=decode(line)
			send(b_instruction)
			time.sleep(1)
	except:
		print ("ERROR")
		mode = 1
		pass
	f.close
	send(opcode('halt')) #instruccion HALT
	print ('\n  -----------------------------------------------------------------------------')
	
if (load_mode == '2'):
	print("\n\t\tManual Loading")
	while (1):
		in_comando = raw_input("Write one instruction: ")
		in_comando = in_comando.lower()

		if (in_comando == "exit"): # comando de salida
		    print("\n\tGOODBYE !!\n")
		    exit()

		if (in_comando == 'halt'):
			send(opcode(in_comando)) #instruccion HALT
			break

		b_instruction=decode(in_comando)
		#print(b_instruction)
		send(b_instruction)


print ("\n\nWait for debug data ...")


while 1:
	# Si el modo de debug es en cada ciclo necesito enviar un dato para recibir insformacion.	
	if (debug_mode == '2'):
		var = raw_input("Press a keyboard for debug ")
		ser.write("1")

	inline = ""
	inline = ser.readline() # Lee hasta que se vacie el buffer.
	#inline = ser.read(296) #Lee 296 bytes del buffer. 
	if (inline != ""):
		#print (inline)
		j=0
		# Se separa el string recibido cada 4 caracteres (32bits), luego se obtiene el numero entero restandole 48 al valor
		# del caracter ascii y se pone la etiqueta correspondiente al dato. 
		for i in range (4 , len(inline)+1 , 4):			
			reg = inline[i-4:i]
			byte1 = ord(reg[0]) - 48 & 0xff
			byte2 = ord(reg[1]) - 48 & 0xff
			byte3 = ord(reg[2]) - 48 & 0xff
			byte4 = ord(reg[3]) - 48 & 0xff
			
			if (j == 0 ):
				parseo(j,byte1,byte2,byte3,byte4)
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
				parseo(j,byte1,byte2,byte3,byte4)
			else:
				print('Default: 0x{:0>2x}{:0>2x}{:0>2x}{:0>2x} : 0b{:0>8b}_{:0>8b}_{:0>8b}_{:0>8b}'.format(byte1,byte2,byte3,byte4,byte1,byte2,byte3,byte4))
			j=j+1


