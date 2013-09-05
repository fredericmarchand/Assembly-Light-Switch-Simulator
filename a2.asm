;Assembly language program  A2.ASM
;         Objective: 	The objective of the program is to switch the kitchen and living room lights
;			on and off by switching specific bits in an array
;         Inputs:       One strings.
;         Output:     	Messages telling the user what commands he has just performed.
%include  "io.mac"



.DATA
	start_msg    	db  'Lights Program has started: ',0
	com_msg		db  'This is the command you inputed: ',0
	bits_msg	db  'These are the values in the 16 byte array: ',0
	prompt_msg    	db  'Enter your command: ',0
	output_msg1	db  'You have turned on the kitchen light',0
	output_msg2	db  'You have turned off the kitchen light',0
	output_msg3	db  'You have turned on the living room light',0
	output_msg4	db  'You have turned off the living room light',0
	output_msg5	db  'Some of the symbols you entered are not recognized',0
	lights_msg	db  'Lights bytes bits: ',0
	quit_msg	db  'The program has terminated.',0
	one_msg		db  '1',0
	zero_msg	db  '0',0
	array1		TIMES 16	db  1	 ;reserve 16 bytes for the bits of the inputs
	array2		TIMES 2 	db  1	 ;reserve 2 bytes for carrying the commands
	

.UDATA
	lights		resb  1          ;stores the lights byte
	input_str      	resb  2		 ;input string < BUF_LEN chars
	bitmask		resb  1		 ;use this as the bitmask for getting bits in a byte	

.CODE
	.STARTUP
	mov	DL, 0		;put 0 in the d register
	mov 	[lights],DL	;put 0 in the lights byte
	nwln			;new line
      	PutStr	start_msg	;message is displayed to show the user that the program has started
	nwln			;new line
	nwln			;new line

get_input:
	PutStr	prompt_msg	;message is displayed to ask the user for input
	GetStr	input_str	;store the input string
	nwln			;new line
	PutStr com_msg		;output the command message
	PutStr input_str	;output the string that was just inputed
	nwln			;new line

do_this:
	mov ECX, 8		;put 8 in the c register
	mov EAX, 128		;put 128 in the bitmask
	mov ESI, array1		;store the address of array1 into ESI
	mov EBX, input_str	;move the input string into EBX
	mov DH,1		;put a 1 in DH
	mov DL,0		;put a 0 in DL
	PutStr bits_msg		;print the bits message

first_array_loop:
	test	[EBX],EAX       ;test the bits
     	jz	store_0      	;if tested bit is 0, jump to store_0
     	mov	[ESI],DH        ;otherwise, put 1 in the array
	PutStr  one_msg		;print 1
     	jmp	shiftmask	;jump to shiftmask

store_0:
	mov	[ESI],DL	;put 0 in the array
	PutStr  zero_msg	;print 0
	jmp	shiftmask	;jump to shiftmask
	

shiftmask:
	shr	EAX,1			;right shift the bitmask by 1
	inc	ESI			;move esi's pointer to the next position in the array
	loop	first_array_loop	;go back to the beginning of the loop and decrement the c register


do_this2:
	mov ECX, 8		;put 8 in the c register
	mov EAX, 32768		;put 32768 in the bitmask

second_array_loop:
	test	[EBX],EAX       ;test the bits
     	jz	store_0_2      	;if tested bit is 0 jump to store_0_2
     	mov	[ESI],DH        ;otherwise, store 1 in the array
	PutStr  one_msg		;print 1
     	jmp	shiftmask_2	;jump to shiftmask

store_0_2:
	mov	[ESI],DL	;put 0 in the array at the location that is pointed	
	PutStr  zero_msg	;print 0
	jmp	shiftmask_2	;jump to shiftmask
	

shiftmask_2:
	shr	EAX,1			;right shift the bitmask by 1
	inc	ESI			;move esi's pointer to the next position in the array
	loop	second_array_loop	;go back to the beginning of the loop and decrement the c register

	nwln				;new line
	nwln				;new line


pack_bytes:
	sub ESI, 16	;bring the pointer of the array back to the beginning
	mov ECX, 8	;put 8 in the c register
	mov EDI, array2	;put the second array in the edi register
	mov [EDI], DL	;put 0 in the first position of the array
	inc EDI		;increment the second array pointer
	mov [EDI], DL	;put 0 in the second position of the array
	dec EDI		;decrement the second array pointer back to the beginning
	xor EAX, EAX	;clear the a register
	mov EAX, 128	;put 128 in the bitmask

do:
	cmp [ESI], DH	;check if the position of the first array contains a 1
	jne shift	;if not, jump to shift
	or [EDI], EAX	;otherwise, use the logical-or with the bitmask and the first position of the array
	jmp shift	;jump to shift

shift:
	shr EAX, 1	;shift the bitmask right by 1
	inc ESI		;increment the first array pointer to the next position
	loop do		;loop back to do and decrement the c register


pack_bytes2:
	mov ECX, 8	;put 8 in the c register
	inc EDI		;increment the pointer of the second array to the second location
	xor EAX, EAX	;clear the a register
	mov EAX, 128	;put 128 in the bitmask

do2:
	cmp [ESI], DH	;check if there is a 1 in the position pointed at in the first array
	jne shift2	;if not, jump to shift2
	or [EDI], EAX	;otherwise, use the exclusive-or with the bitmask and the second element of the second array
	jmp shift2	;jump to shift2


shift2:
	shr EAX, 1	;right shift the bitmask
	inc ESI		;increment the pointer of the first array
	loop do2	;loop back to do2 and decrement the c register


check_bytes:
	xor EAX, EAX		;clear the a register
	mov AH,128		;put 128 in the a register
	mov AL,0		;put 0 in AL
	mov ECX, 8		;put 8 in the c register
	dec EDI			;decrement the pointer of the second array back to the first position
	mov BL, [EDI]		;put the character in the first position of the second array in BL
	cmp BL, 'K'		;check if the first array posisiton is K
	je kitchen_on		;if so jump to kitchen_on
	cmp BL, 'k'		;check if the first array posisiton is k
	je kitchen_off		;if so jump to kitchen_off
	cmp BL, 'L'		;check if the first array posisiton is L
	je livingroom_on	;if so jump to livingroom_on
	cmp BL, 'l'		;check if the first array posisiton is l
	je livingroom_off	;if so jump to livingroom_off

	jmp check_bytes2	;jump to check_bytes2 if the character was meaningless


kitchen_on:
	PutStr  output_msg1	;tell the user he has just turned the kitchen light on 
	or AL, 1		;put a 1 in the first bit of the lights byte
	nwln			;new line
	jmp check_bytes2	;jump to terminate



kitchen_off:
	PutStr  output_msg2	;tell the user he has just turned the kitchen light off 
	nwln			;new line
	jmp check_bytes2	;jump to terminate



livingroom_on:
	PutStr  output_msg3	;tell the user he has just turned the living room light on 
	or AL, 16		;put a 1 in the 5th bit of the lights byte
	nwln			;new line
	jmp check_bytes2	;jump to terminate



livingroom_off:
	PutStr  output_msg4	;tell the user he has just turned the living room light off 
	nwln			;new line
	jmp check_bytes2	;jump to terminate



check_bytes2:
	inc EDI			;increment the pointer of the second array to the second element
	xor EBX, EBX		;clear the b register
	mov BL, [EDI]		;put the second element of the second array in BL
	cmp BL, 'K'		;check if the first array posisiton is K
	je kitchen_on2		;if so jump to kitchen_on
	cmp BL, 'k'		;check if the first array posisiton is k
	je kitchen_off2		;if so jump to kitchen_off
	cmp BL, 'L'		;check if the first array posisiton is L
	je livingroom_on2	;if so jump to livingroom_on
	cmp BL, 'l'		;check if the first array posisiton is l
	je livingroom_off2	;if so jump to livingroom_off

	jmp terminate		;jump to terminate if the character is meaningless


kitchen_on2:
	PutStr  output_msg1	;tell the user he has just turned the kitchen light on 
	or AL,1			;put a 1 in the first bit of the lights byte
	nwln			;new line
	PutStr lights_msg	;print a message about the lights byte
	jmp print_bit		;jump to terminate



kitchen_off2:
	PutStr  output_msg2	;tell the user he has just turned the kitchen light off 
	and AL,254		;clear the 1st bit of the lights byte
	nwln			;new line
	PutStr lights_msg	;print a message about the lights byte
	jmp print_bit		;jump to terminate



livingroom_on2:
	PutStr  output_msg3	;tell the user he has just turned the living room light on 
	or AL, 16		;put a 1 in the 5th bit of the lights byte
	nwln			;new line
	PutStr lights_msg	;print a message about the lights byte
	jmp print_bit		;jump to terminate



livingroom_off2:
	PutStr  output_msg4	;tell the user he has just turned the living room light off 
	and AL, 239		;clear the 5th bit of the lights byte 
	nwln			;new line
	PutStr lights_msg	;print a message about the lights byte
	jmp print_bit		;jump to terminate



print_bit:	
	test      AL,AH        	;test does not modify AL
     	jz        print_0      	;if tested bit is 0, print it
     	PutCh     '1'          	;otherwise, print 1
     	jmp       skip1		;jump to skip1

print_0:
	PutCh    '0'         	;print 0

skip1:
	shr      AH,1         	;right-shift mask bit to test next bit of the ASCII code
     	loop     print_bit   	;loop back to print_bit and decrement the c register
     	nwln			;new line



terminate:
	mov [lights], AL	;put AL into the lights byte
	nwln			;new line
	PutStr	quit_msg	;quit message
	nwln			;new line
	nwln			;new line

	.EXIT
