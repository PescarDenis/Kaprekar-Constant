DATA SEGMENT PARA PUBLIC 'DATA'
	INPUT_PROMPT DB "CHOOSE 1 FOR INTERACTIVE MODE, OR CHOOSE 2 FOR AUTOMATIC MODE: $" ; THE INITIAL STARTING MESSAGE THAT WILL APPEAR WHEN WE RUN THE PROGRAM
	WRONG_PROMPT DB "WRONG INPUT,TRY AGAIN: $" ;THE MESSAGE FOR THE WRONG INPUT
	INTERACTIVE_PROPMT DB "YOU CHOSE THE INTERACTIVE MODE, PLEASE ENTER A 4 DIGIT NUMBER: $" ;FOR CHOOSING THE INTERACTIVE MODE WE PRINT THIS MESSAGE
	KAPREKAR_ARRAY DB 4 DUP(?) ;WE WILL STORE THE DIGITS INTO THIS ARRAY
	RESULT_PROMPT DB "THE NUMBER OF ITERATIONS IS $" ;THE MESSAGE FOR THE COUNT OF ITERATIONS
	NEWLINE DB 13, 10, '$' ;THIS WILL BE USED TO ALWAYS PRINT A NEWLINE
	ASSCENDING_ARRAY DB 4 DUP(?) ;IN THIS VECTOR WE WILL HAVE THE SORTED DIGITS IN ASSCEDING ORDER
	INDEX_SORTED DB 3; WE WILL START FROM THE BACK OF THE ARRAY, AS WE ARE PUTTING THE HIGHEST ELEMENTS THERE
	DESCENDING_ARRAY DB 4 DUP(?) ;IN THIS VECTOR WE WILL HAVE THE SORTED DIGITS IN DESCENDING ORDER
	MINUS_PROMPT DB " - $" ;THIS IS THE MINUS SIGN FOR THE SUBTRACTIONS
	EQUAL_PROMPT DB " = $" ;EUQAL SIGN 
	GENERATE_KAPREKAR DB 4 DUP(0);IN THIS VECTOR WE WILL KEEP THE VALUES FROM 0000 TO 9999 
	FILE_NAME DB 'KAPRE.TXT',0 ; THIS WILL BE THE FILE WHERE WE GENERATE ALL THE VALUES FROM 0000 TO 9999, WITH THE NUMBER OF ITERATIONS
	ATTR_NORMAL     DW  0000H ;FOR FILE GENERATING
	ADR_FILE_NAME   DW  FILE_NAME;THE BUFFER/ADDRES OF THE FILE
    READ_WRITE      DB  02H
	NUM_BUFFER DB 10 DUP(?)     ; BUFFER TO HOLD THE ASSCII CHARACTER FROM THE GENERATE_KAPREKAR -> 0000 TO 9999
	SPACE DB ' ' ;JUST THE SPACE CHARACTER TO BE ABLE TO DIFFRENTIATE THE NUMBER AND THE IERATIONS
	ITERATIONS_COUNT DB 0 ; INITALISE THE COUNTER FOR THE AUTOMATIC MODE TO 0
	CHECK_PROMPT DB "CHECK FOR THE FILE KAPRE.TXT TO SEE THE NUMBERS FROM 0000 TO 9999 AND THEIR ITERATIONS $" ; A MESSAGE TO SHOW AFTER THE AUTOMATIC ITERATION
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE,DS:DATA  ;INISTIALISE THE CODE SEGMENT

MAIN PROC FAR
; INITIALISE THE STACK
PUSH DS
XOR AX,AX
MOV DS,AX
PUSH AX
MOV AX,DATA
MOV DS,AX

STARTING_POINT:
	LEA DX, INPUT_PROMPT ;LOAD THE ADDRESS OF THE INITIAL MESSAGE INTO DX TO BE ABLE TO PRINT IT
	MOV AH, 09H ; INDICATE THE PRINT FUNCTION
	INT 21H; CALL THE DOS TO ACTUALLY PRINT THE MESSAGE


	MOV AH,01H ;INDICATE THE ECHO FUNCTION, WE ACTUALLY NEED TO GIVE AN INPUT FOR THE KEYBOARD THE BE ABLE TO SELECT WHICH MODE DO WE WANT TO RUN
	INT 21H; CALL THE DOS TO BE ABLE TO GIVE AN INPUT FROM THE KEYBOARD

	MOV AH, 09H
	LEA DX,NEWLINE ;AFTER WE ENTERD THE NUMBER WE PRINT A NEWLINE
	INT 21H 

;NOW AFTER WE GIVE THE PROMPT INPUT 0 OR 1, WE MAKE THE FUNCTIONALLITY 
;WHEN APPELATING MOV AH,01H THE INPUT WILL BE STORED IN AL(ASCII VALUE)

CMP AL,'1' ; COMPARE WITH THE CHARACTER 1
JE INTERACTIVE_MODE ;IF THE VALUE IN AL==1 THEN WE GO TO THE INTERACTIVE MODE

CMP AL,'2' ;COMPARE WITH THE CHARACTER 2
JE AUTOMATIC_MODE ;IF THE VALUE IN AL EQUAL 2, GO TO THE AUTOMATIC_MODE

CMP AL,'1' ; IF THE USERS INTRODUCES A DIGIT WHICH IS NOT 1 OR 2 WE NEED TO GO BACK AT THE STARTING POINT
JL STARTING_POINT

CMP AL,'2'
JG STARTING_POINT

INTERACTIVE_MODE: ;THIS IS THE INTERACTIVE MODE
	CALL READ_INPUT;WE CALL A FUNCTION TO READ THE INPUT, A 4 DIGIT NUMBER (FUNCTION=PROCEDURE)
	CALL KAPREKAR ;WE CALL A FUNCTION TO PERFORM THE KAPREKARS ITERATIONS
	
AUTOMATIC_MODE: ;THIS IS THE AUTOMAITC MODE
	CALL GENERATE_FILE ;GO TO GENERATE FILE MODE


READ_INPUT PROC ;THE IDEA OF THIS PROCEDURE IS TO KEEP TRACK OF THE DIGITS THAT WE READ IN A KAPREKAR_ARRAY

	MOV AH,09H
	LEA DX,INTERACTIVE_PROPMT ;FUNCTION TO PRINT THE INTERACTIVE MODE PRINT AND ENTER THE 4 DIGIT NUMBER
	INT 21H
	READING: ;WE ARE NEVER GOING TO PHISICALLY BUILD THE NUMBERS, JUST MAKE OPERATIONS WITH THE DIGITS IN THE ARRAY
	
	
	XOR SI,SI; INITIALISE THE SI WITH 0
	MOV AH,01H ;WE NEED TO READ EACH CHARACTER FROM THE KEYBOARD
	INT 21H;
	
	CMP AL,'0' ;IF THE INPUT IS LESS THAN 0 WE GO TO THE INVALID STATEMENT
	JL INVALID
	CMP AL,'9' ;IF THE INPUT IS GREATER THAN 9 WE GO TO THE INVALID STATEMENT
	JG INVALID
	
	SUB AL,'0' ; WE SUBTRACT FROM AL 0 IN ORDER TO MAKE FROM ITS CHARACTER INTO ITS ASCII CODE
	MOV KAPREKAR_ARRAY[SI],AL ;STORE EACH DIGIT INTO THE ARRAY
	INC SI ;THEN INCREMENT SI
	
	MOV AH,01H ;WE NEED TO READ EACH CHARACTER FROM THE KEYBOARD
	INT 21H;
	
	CMP AL,'0' ;IF THE INPUT IS LESS THAN 0 WE GO TO THE INVALID STATEMENT
	JL INVALID
	CMP AL,'9' ;IF THE INPUT IS GREATER THAN 9 WE GO TO THE INVALID STATEMENT
	JG INVALID
	
	SUB AL,'0' ; WE SUBTRACT FROM AL 0 IN ORDER TO MAKE FROM ITS CHARACTER INTO ITS ASCII CODE
	MOV KAPREKAR_ARRAY[SI],AL ;STORE EACH DIGIT INTO THE ARRAY
	INC SI ;THEN INCREMENT SI
	
	MOV AH,01H ;WE NEED TO READ EACH CHARACTER FROM THE KEYBOARD
	INT 21H;
	
	CMP AL,'0' ;IF THE INPUT IS LESS THAN 0 WE GO TO THE INVALID STATEMENT
	JL INVALID
	CMP AL,'9' ;IF THE INPUT IS GREATER THAN 9 WE GO TO THE INVALID STATEMENT
	JG INVALID
	
	SUB AL,'0' ; WE SUBTRACT FROM AL 0 IN ORDER TO MAKE FROM ITS CHARACTER INTO ITS ASCII CODE
	MOV KAPREKAR_ARRAY[SI],AL ;STORE EACH DIGIT INTO THE ARRAY
	INC SI ;THEN INCREMENT SI
	
	MOV AH,01H ;WE NEED TO READ EACH CHARACTER FROM THE KEYBOARD
	INT 21H;
	
	CMP AL,'0' ;IF THE INPUT IS LESS THAN 0 WE GO TO THE INVALID STATEMENT
	JL INVALID
	CMP AL,'9' ;IF THE INPUT IS GREATER THAN 9 WE GO TO THE INVALID STATEMENT
	JG INVALID
	
	SUB AL,'0' ; WE SUBTRACT FROM AL 0 IN ORDER TO MAKE FROM ITS CHARACTER INTO ITS ASCII CODE
	MOV KAPREKAR_ARRAY[SI],AL ;STORE EACH DIGIT INTO THE ARRAY
	
	MOV AH, 09H
	LEA DX,NEWLINE ;PRINT A NEWLINE
	INT 21H
	
	RET
	
	INVALID:
	MOV AH, 09H
	LEA DX,NEWLINE ;PRINTS A NEWLINE IF THE ENTERD INPUT IS NOT GOOD
	INT 21H
	
	MOV AH,09H
	LEA DX,WRONG_PROMPT ;IF WE ENTERED A WRONG NUMBER WE GO BACK TO THE INITIAL READING "LOOP"
	INT 21H
	JMP READING
READ_INPUT ENDP

KAPREKAR PROC ;THIS IS THE MAIN PROC FOR THE INTERACTIVE MODE
; THE IDEEA OF THE INTERACTIVE MODE IS, TO KEEP TRACK OF THE DIGITS THAT WE ARE READING FROM THE KEYBOARD IN AN ARRAY
;THEN APPELATE TWO SORTING FUNCTIONS,TO SORT THE DIGITS IN ASSCENDING AND IN DESCENDING ORDER
;THEN, AFTER WE HAVE THE TWO ARRAYS OF THE SORTED DIGITS, WE ARE GOING TO SUBTRACT ON EACH INDEX,THE DIGITS ON THAT POSITIONS
; AND UPDATE THE KAPREKAR_ARRAY IN ORDER TO LOOP UNTIL WE REACH THE KAPREKAR'S CONSTANT OR 0000

MOV BX,0 ; WE FIRST INTIALISE BX WITH 0, SO WE KNOW HOW MANY ITERATIONS WE HAVE TO MAKE

KAPREKAR_LOOP:

	UPDATE_KAPREKAR_ARRAY:	
	
		INC BL ;EVERY TIME THAT WE ARE DOING A SUBTRACTION INCREASE THE NUMBER OF ITERATIONS
		
		CALL SORT_DESCENDING ;WE SORT THE DIGITS IN DESCENDING ORDER
		
		CALL PRINT_KAPREKAR ; AFTER WE SORTED THE FIRST ARRAY IN DESCENDING ORDER WE PRINT THE NUMBER
		MOV AH,09H
		LEA DX,MINUS_PROMPT ; WE ALSO PRIN THE MINUS SIGN
		INT 21H
		
		CALL SORT_ASCENDING ;WE SORT THE DIGITS IN ASCENDING ORDER
		
		CALL PRINT_KAPREKAR ; AFTER WE SORT THE SECOND ARRAY IN WE ALSO PRIN THE NUMBER
		MOV AH,09H
		LEA DX,EQUAL_PROMPT ; WE ALSO PRIN THE MINUS SIGN
		INT 21H

		CALL KAPREKAR_ITERATIONS; ; A PROCEDURE TO CALCULATE THE ACTUAL KAPREKAR NUMBER -> SUBTRACT EACH DIGIT FROM THE DESCENDING AND ASCCENDING
		
		CALL PRINT_KAPREKAR ;AFTER WE HAVE THE FINAL VALUE PRINT IT
		
		MOV AH, 09H
		LEA DX,NEWLINE ;PRINT A NEWLINE AFTER WE HAVE FINISHED WITH EACH ITERATION
		INT 21H
		
	
	CHECK_CONSTANT:
		XOR SI,SI ;MAKE SI 0
		CMP KAPREKAR_ARRAY[SI],6 ;VERIFY AFER EACH ITERATION IF WE REACHED THE KAPREKAR CONSTANT
		JNE CHECK_ZERO
		CMP KAPREKAR_ARRAY[SI+1],1
		JNE CHECK_ZERO
		CMP KAPREKAR_ARRAY[SI+2],7
		JNE CHECK_ZERO
		CMP KAPREKAR_ARRAY[SI+3],4 ;IF ALSO THE LAST DIGIT CHECKS, THEN WE JUMP TO KAPREKAR FOUND
		JE KAPREKAR_FOUND
		
	CHECK_ZERO:
		XOR SI,SI ;MAKE SI 0
		CMP KAPREKAR_ARRAY[SI],0 ;IF WE DID NOT REACH THE KAPREKAR CONSTANT, CHECK IF WE HAVE REACHED 0000
		JNE UPDATE_KAPREKAR_ARRAY
		CMP KAPREKAR_ARRAY[SI+1],0
		JNE UPDATE_KAPREKAR_ARRAY
		CMP KAPREKAR_ARRAY[SI+2],0
		JNE UPDATE_KAPREKAR_ARRAY
		CMP KAPREKAR_ARRAY[SI+3],0
		JE KAPREKAR_FOUND
		
		
	JMP KAPREKAR_LOOP ;CONTINUE WITH THE LOOP


RET
KAPREKAR ENDP

KAPREKAR_FOUND:

	MOV AH, 09H
	LEA DX,NEWLINE ;PRINT A NEWLINE
	INT 21H 
	
	MOV AH,09H
	LEA DX, RESULT_PROMPT ;PRINT THE ITERATION PROMPT
	INT 21H
	
	MOV AH,02H ;THIS IS USED TO WRITE CHARACTERS ON THE SCREEN AND SENDS THE CHARACTERS IN DL TO DISPLAY
	MOV DL,BL ; IN BL WE WILL HAVE THE ACTUAL NUMBER OF ITERATIONS
	ADD DL,'0' ; MAKE IT AN ASCII, TO BE ABLE TO PRINT IT
	INT 21H

	
	MOV AH, 09H
	LEA DX,NEWLINE ;PRINT A NEWLINE
	INT 21H

	;TERMINATE THE PROGRAM, AFER WE PRINT THE ITERATIONS
	MOV AH,4CH; INDICATE THE TERMINATE FUNCTION
	INT 21H ;CALL THE DOS

	RET
	
SORT_ASCENDING PROC

;THE IDEEA OF THIS FUNCTION IS TO TAKE EACH DIGIT FROM THE KAPREKAR_ARRAY, WHICH IS THE INITIAL ARRAY AND PUT THEM IN A SORTED ARRAY
;WE WILL DO THAT BY COMPARING EACH DIGIT, LIKE IN BUBBLE SORT IN C LANGUAGE

	MOV CX, 4 ; number of iterations for the loop
    XOR DI,DI ;MAKES DI 0
	XOR AL,AL
	XOR AH,AH
    OUTER:
        PUSH CX ;PUSH CX INTO THE STACK
        MOV CX, 4; THE NUMBER OF INTERATIONS FOR EACH TRAVERSAL
        XOR SI,SI ;MAKES SI=0
        INNER:
            MOV AL, KAPREKAR_ARRAY[SI]; THIS WORKS LIKE A BUBBLE SORT
            CMP AL, KAPREKAR_ARRAY[DI] ;COMPARE IT WITH THE NEXT VALUE
            JB DONT ;IF THE NEXT VALUE IS LESS THAN THE CURRENT VALUE
                MOV AH, KAPREKAR_ARRAY[DI]
                MOV KAPREKAR_ARRAY[DI], AL ;SWAP THEM
                MOV KAPREKAR_ARRAY[SI], AH
            DONT:
                INC SI ;IF WE FOUND A SMALLEST ELEMENT THAN THE CURRENT VALUE, GO TO THE NEXT ONE
        LOOP INNER
        INC DI
        POP CX
    LOOP OUTER  
	
	XOR AL,AL; AL TAKES 0
	XOR AH,AH; AH TAKES 0
	MOV CX,4 ;WE HAVE 4 ELEMENTS IN OUR ARRAY
	XOR SI,SI ;SI TAKES 0
	UPDATE:
		MOV AL,KAPREKAR_ARRAY[SI]
		MOV ASSCENDING_ARRAY[SI],AL;MOVE THE VALUES SORTED IN ASCCENDING OREDER BASED ON THE BUBBLE SORT
		INC SI;
	LOOP UPDATE

RET
SORT_ASCENDING ENDP




SORT_DESCENDING PROC

;THE IDEEA OF THIS FUNCTION IS TO TAKE EACH DIGIT FROM THE KAPREKAR_ARRAY, WHICH IS THE INITIAL ARRAY AND PUT THEM IN A SORTED ARRAY
;WE WILL DO THAT BY COMPARING EACH DIGIT, LIKE IN BUBBLE SORT IN C LANGUAGE

	MOV CX, 4 ; number of iterations for the loop
    XOR DI,DI ;MAKES DI 0
	XOR AL,AL
	XOR AH,AH
    OUTER1:
        PUSH CX ;PUSH CX INTO THE STACK
        MOV CX, 4; THE NUMBER OF INTERATIONS
        XOR SI,SI ;MAKES SI=0
        INNER1:
            MOV AL, KAPREKAR_ARRAY[SI]; THIS WORKS LIKE A BUBBLE SORT
            CMP AL, KAPREKAR_ARRAY[DI] ;COMPARE IT WITH THE NEXT VALUE
            JA DONT1 ;IF THE NEXT VALUE IS GREATER THAN THE CURRENT VALUE
                MOV AH, KAPREKAR_ARRAY[DI]
                MOV KAPREKAR_ARRAY[DI], AL ;SWAP THEM
                MOV KAPREKAR_ARRAY[SI], AH
            DONT1:
                INC SI
        LOOP INNER1
        INC DI
        POP CX
    LOOP OUTER1  
	
	XOR AL,AL; AL TAKES 0
	XOR AH,AH; AH TAKES 0
	MOV CX,4 ;WE HAVE 4 ELEMENTS IN OUR ARRAY
	XOR SI,SI ;SI TAKES 0
	UPDATE1:
		MOV AL,KAPREKAR_ARRAY[SI]
		MOV DESCENDING_ARRAY[SI],AL;MOVE THE VALUES SORTED IN DESCENDING OREDER BASED ON THE BUBBLE SORT
		INC SI;
	LOOP UPDATE1

RET
SORT_DESCENDING ENDP



KAPREKAR_ITERATIONS PROC

MOV CX,4 ; THE NUMBER OF ITERATIONS THAT WE HAVE TO MAKE THORUGH BOTH ARRAYS
MOV SI,3

	ITERATE_UPDATE: 
	XOR AL,AL;
	XOR AH,AH; MAKE AH AND AL 0
	MOV AL,ASSCENDING_ARRAY[SI] ;MOVE THE CURRENT VALUE OF THE ASCCENDING ARRAY IN AL
	CMP DESCENDING_ARRAY[SI],AL ;WE COMPARE EACH ELEMENT IN THE ORDERED VECTORS
	JAE INCREMENTING ;IF WE CAN MAKE THE SUBTRACTION,UPDATE THE KAPREKAR_ARRAY AND SUBTRACT SI
	JB UPDATE_CARRY ; IF THE ASSCENDING_ARRAY DIGIT IS GREATER THAN THE DESCENDING_ARRAY DIGIT, ADD 1 TO THE NEXT ASSCENDING DIGIT AND ADD 10 TO THE DESCENDING ARRAY
	
	
	INCREMENTING:
	SUB DESCENDING_ARRAY[SI],AL ;SUBTRACT FROM DESCENDING_ARRAY AL
	MOV AL,DESCENDING_ARRAY[SI] ;STORE THE TEMPORARY VALUE INTO AL
	MOV KAPREKAR_ARRAY[SI],AL ;THIS IS THE FINAL VALUE
	CMP SI,0 ;WE COMPARE SI WITH 0, SO WE KNOW THAT WE ARE DONE
	JE FINISH
	DEC SI ; SUBTRACT SI
	LOOP ITERATE_UPDATE
	
	UPDATE_CARRY:
	INC ASSCENDING_ARRAY[SI-1] ;ADD 1 TO EACH NEXT ASSCENDING ELEMENT, AS WE BOORROWED FROM IT 
	ADD DESCENDING_ARRAY[SI],10 ; ADD 10 TO THE DESCENDING ELEMENT TO BE ABLE TO PERFORM THE SUBTRACTION
	JMP INCREMENTING

	FINISH:
	RET
KAPREKAR_ITERATIONS ENDP

PRINT_KAPREKAR PROC

	XOR SI,SI; MAKE SI 0
	
	MOV AH,02H ;THIS IS USED TO WRITE CHARACTERS ON THE SCREEN AND SENDS THE CHARACTERS IN DL TO DISPLAY
	MOV DL,KAPREKAR_ARRAY[SI] ;MOVE THE CURRENT ELEMENT INTO DL
	ADD DL,'0' ; MAKE IT AN ASCII, TO BE ABLE TO PRINT IT
	INT 21H
	
	MOV AH,02H ;THIS IS USED TO WRITE CHARACTERS ON THE SCREEN AND SENDS THE CHARACTERS IN DL TO DISPLAY
	MOV DL,KAPREKAR_ARRAY[SI+1] ;MOVE THE CURRENT ELEMENT INTO DL
	ADD DL,'0' ; MAKE IT AN ASCII, TO BE ABLE TO PRINT IT
	INT 21H
	
	MOV AH,02H ;THIS IS USED TO WRITE CHARACTERS ON THE SCREEN AND SENDS THE CHARACTERS IN DL TO DISPLAY
	MOV DL,KAPREKAR_ARRAY[SI+2] ;MOVE THE CURRENT ELEMENT INTO DL
	ADD DL,'0' ; MAKE IT AN ASCII, TO BE ABLE TO PRINT IT
	INT 21H
	
	MOV AH,02H ;THIS IS USED TO WRITE CHARACTERS ON THE SCREEN AND SENDS THE CHARACTERS IN DL TO DISPLAY
	MOV DL,KAPREKAR_ARRAY[SI+3] ;MOVE THE CURRENT ELEMENT INTO DL
	ADD DL,'0' ; MAKE IT AN ASCII, TO BE ABLE TO PRINT IT
	INT 21H

RET
PRINT_KAPREKAR ENDP

GENERATE_FILE PROC
; THIS WILL BE A FUNCTION TO GENERATE ALL THE ITERATION BETWEEN 0000 AND 9999

	MOV AH, 3CH ;FUNCTION TO CREATE A FILE
    XOR CX, CX ;MAKES CX
    OR CX, ATTR_NORMAL
    MOV DX, ADR_FILE_NAME
    INT 21H

	;OPEN THE FILE
    MOV AH, 3DH
    MOV AL, 0
    OR AL, READ_WRITE
    MOV DX, ADR_FILE_NAME
    INT 21H
    MOV BX, AX ; GET THE FILE HANDLE
	

;FIRST MAKE ALL THE DIGITS 0 IN THE KAPREKAR_ARRAY
	STARTING_ARRAY:
		XOR SI,SI ; MAKE SI 0
		MOV KAPREKAR_ARRAY[SI],0
		MOV KAPREKAR_ARRAY[SI+1],0
		MOV KAPREKAR_ARRAY[SI+2],0
		MOV KAPREKAR_ARRAY[SI+3],0
	
	STARTING_PROC:
	MOV ITERATIONS_COUNT,0 ; MAKE THE ITERATIONS_COUNT 0
		
	INCREMENT_UDPATE:
			
			INC ITERATIONS_COUNT ;INCREMENT THE ITERATION COUNT WITH 1
			CALL SORT_DESCENDING 
			CALL SORT_ASCENDING
			CALL KAPREKAR_ITERATIONS
			;PERFORM THE KAPREKAR ITERATIONS
		
	CHECK_CONSTANT1:
		XOR SI,SI ;MAKE SI 0
		CMP KAPREKAR_ARRAY[SI],6 ;VERIFY AFER EACH ITERATION IF WE REACHED THE KAPREKAR CONSTANT
		JNE CHECK_ZERO1
		CMP KAPREKAR_ARRAY[SI+1],1
		JNE CHECK_ZERO1
		CMP KAPREKAR_ARRAY[SI+2],7
		JNE CHECK_ZERO1
		CMP KAPREKAR_ARRAY[SI+3],4 ;IF ALSO THE LAST DIGIT CHECKS, THEN WE JUMP TO KAPREKAR FOUND
		JE KAPREKAR_FOUND1
		
	CHECK_ZERO1:
		XOR SI,SI ;MAKE SI 0
		CMP KAPREKAR_ARRAY[SI],0 ;IF WE DID NOT REACH THE KAPREKAR CONSTANT, CHECK IF WE HAVE REACHED 0000
		JNE INCREMENT_UDPATE
		CMP KAPREKAR_ARRAY[SI+1],0
		JNE INCREMENT_UDPATE
		CMP KAPREKAR_ARRAY[SI+2],0
		JNE INCREMENT_UDPATE
		CMP KAPREKAR_ARRAY[SI+3],0
		JE KAPREKAR_FOUND1			


RET
GENERATE_FILE ENDP

KAPREKAR_FOUND1 : ;AFTER WE REACH TO 0000 OR KAPREKAR CONSTANT THEN, PRINT THE ITERATIONS FOR EACH NUMBER 
	
	
	CALL PRINT_KAPREKAR_GENERATE
	
	XOR SI,SI ;MAKE SI 0
	MOV KAPREKAR_ARRAY[SI],0
	MOV KAPREKAR_ARRAY[SI+1],0
	MOV KAPREKAR_ARRAY[SI+2],0
	MOV KAPREKAR_ARRAY[SI+3],0
	
	MOV SI,3; WE ARE STARTING FROM THE BACK
	
	UPDATE_UNITS:
	INC GENERATE_KAPREKAR[SI] ; DO THIS TO BE ABLE TO ALSO GET THE  10,20,30 ETC. BASED ON THE ALGORIHM BELOW
	
	UPDATE_GENERATED_KAPREKAR: ;THE IDEEA IS TO HAVE ANOTHER VECTOR ->GENERATED KAPREKAR AND STOCK THE VALUES THERE, AND THEN MOVE THEM IN THE ACTUAL KAPREKAR ARRAY
	;AS ALL THE FUNCTIONS APPELATED ABOVE WORK ON THAT ARRAY
		MOV AL,GENERATE_KAPREKAR[SI] ;TEMPORARLY STOCK IT INTO AL
		MOV KAPREKAR_ARRAY[SI],AL ;UPDATE THE KAPREKAR_ARRAY
		MOV AL,GENERATE_KAPREKAR[SI-1] ;TEMPORARLY STOCK IT INTO AL
		MOV KAPREKAR_ARRAY[SI-1],AL ; THE IDEEA IS TO ALWAYS UPDATE THE ARRAY, WHEN WE UPDATE THE DIGITS
		MOV AL,GENERATE_KAPREKAR[SI-2] 
		MOV KAPREKAR_ARRAY[SI-2],AL ;
		MOV AL,GENERATE_KAPREKAR[SI-3] ;
		MOV KAPREKAR_ARRAY[SI-3],AL ;
		CMP GENERATE_KAPREKAR[SI],9 ;IF WE HAVE REACHED THE DIGIT 9 THEN GO TO THE TENS DIGIT
		JA TENS_UPDATE ;IF WE REACH 10 ON THAT POSITION JUMP TO THE TENS_UPDATE
		JMP STARTING_PROC ;IF WE STILL COUNT, AT EVERY UNIT UPDATE GO THE STARTING_PROC
		
	TENS_UPDATE:
	MOV GENERATE_KAPREKAR[SI],0 ;MAKE THE UNITS EQUAL TO 0
	MOV KAPREKAR_ARRAY[SI],0 ;ALSO UPDATE THE KAPREKAR ARRAY
	
	INC GENERATE_KAPREKAR[SI-1] ;INCREMENT THE TENS DIGIT 
	MOV AL,GENERATE_KAPREKAR[SI-1] ;TEMPORARLY STOCK IT INTO AL
	MOV KAPREKAR_ARRAY[SI-1],AL ;UPDATE THE KAPREKAR_ARRAY
	
	CMP GENERATE_KAPREKAR[SI-1],9 ;IF WE REACH 10 ON THAT POSITION
	JA HUNDREDS_UPDATE; UPDATE THE HUNDREDS DIGIT
	JMP UPDATE_GENERATED_KAPREKAR ;IF NOT , GO TO THE INITIAL STATEMENT, TO UPDATE THE UNITS AND CONTINUE
	
	HUNDREDS_UPDATE:
	MOV GENERATE_KAPREKAR[SI],0 ;MAKE THE UNITS EQUAL TO 0
	MOV GENERATE_KAPREKAR[SI-1],0 ;MAKE THE TENS EQUAL TO 0
	
	MOV KAPREKAR_ARRAY[SI],0 ;ALSO UPDATE THE KAPREKAR ARRAY
	MOV KAPREKAR_ARRAY[SI-1],0 ;ALSO UPDATE THE KAPREKAR ARRAY
	
	INC GENERATE_KAPREKAR[SI-2] ;INCREMENT THE TENS DIGIT 
	MOV AL,GENERATE_KAPREKAR[SI-2] ;TEMPORARLY STOCK IT INTO AL
	MOV KAPREKAR_ARRAY[SI-2],AL ;UPDATE THE KAPREKAR_ARRAY 
	
	CMP GENERATE_KAPREKAR[SI-2],9 ;IF WE REACH 10 ON THAT POSITION
	JA THOUSANDS_UPDATE; UPDATE THE HUNDREDS DIGIT
	JMP UPDATE_GENERATED_KAPREKAR ;IF NOT , GO TO THE INITIAL STATEMENT, TO UPDATE THE UNITS AND CONTINUE
	
	THOUSANDS_UPDATE:
	MOV GENERATE_KAPREKAR[SI],0 ;MAKE THE UNITS EQUAL TO 0
	MOV GENERATE_KAPREKAR[SI-1],0 ;MAKE THE TENS EQUAL TO 0
	MOV GENERATE_KAPREKAR[SI-2],0 ;MAKE THE UNITS EQUAL TO 0
	
	MOV KAPREKAR_ARRAY[SI],0 ;ALSO UPDATE THE KAPREKAR ARRAY
	MOV KAPREKAR_ARRAY[SI-1],0 ;ALSO UPDATE THE KAPREKAR ARRAY
	MOV KAPREKAR_ARRAY[SI-2],0 ;ALSO UPDATE THE KAPREKAR ARRAY
	
	INC GENERATE_KAPREKAR[SI-3] ;INCREMENT THE TENS DIGIT 
	MOV AL,GENERATE_KAPREKAR[SI-3] ;TEMPORARLY STOCK IT INTO AL
	MOV KAPREKAR_ARRAY[SI-3],AL ;UPDATE THE KAPREKAR_ARRAY
	
	CMP GENERATE_KAPREKAR[SI-3],9 ;IF WE REACH 10 ON THAT POSITION
	JA TERMINATE; WHEN WE OVERREACHED THE THOUSANDS DIGITS WE ARE DONE WITH THE ITERATIONS
	JMP UPDATE_GENERATED_KAPREKAR ;IF NOT , GO TO THE INITIAL STATEMENT, TO UPDATE THE UNITS AND CONTINUE


	TERMINATE:
	
	MOV AH, 09H
	LEA DX,CHECK_PROMPT;AFTER WE REACHED THE END OF THE AUTOMATIC MODE, PRINT A MESSAGE
	INT 21H 

	MOV AH, 3EH ;CLOSE THE FILE
    INT 21H
	
	MOV AH,4CH; INDICATE THE TERMINATE FUNCTION
	INT 21H ;CALL THE DOS

RET

PRINT_KAPREKAR_GENERATE PROC

	MOV SI, 0 ;INITALISE ARRAY INDEX
	
 PRINT_DIGITS:
		MOV AH, 0           
		MOV AL, GENERATE_KAPREKAR[SI] ;LOAD THE DIGIT
		ADD AL, '0'; CONVERT TO ASCII
		MOV [NUM_BUFFER], AL ; STORE THE ASCII CHARAC IN THE BUFFER

		MOV AH, 40h ; FUNCTION TO PRINT THE CHARACTER
		MOV DX, OFFSET NUM_BUFFER ; ADDRESS OF THE CHARACTER IN BUFFER
		MOV CX, 1  ; NR. OF CHARAC. TO PRINT
		INT 21h ;CALL DOS

		INC SI ; MOVE TO THE NEXT DIGIT
		
		CMP SI, 4 ; CHECK IF WE HAVE REACHED THE END OF THE ARRAY
		JNE PRINT_DIGITS ; IF NOT, PRINT THE NEXT DIGIT
	
	MOV AH, 40h         
    MOV DX, OFFSET SPACE ; WE PRINT A SPACE CHARACTER IN THE FILE
    MOV CX, 1           
    INT 21h             
	
	MOV AH, 0 ;CLEAR AH
    MOV AL, ITERATIONS_COUNT ; LOAD THE NUMBER OF ITERATIONS 
    ADD AL, '0'         
    MOV [NUM_BUFFER], AL ; STORE THE ASCII CHARACTER IN THE BUFFER

    MOV AH, 40h        
    MOV DX, OFFSET NUM_BUFFER 
    MOV CX, 1           
    INT 21h             
	
	MOV AH, 40H
	LEA DX,NEWLINE ;PRINT A NEWLINE
	INT 21H
RET
PRINT_KAPREKAR_GENERATE ENDP

RET
MAIN ENDP
CODE ENDS
END MAIN