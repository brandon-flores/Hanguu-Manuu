TITLE HANGMAN (SIMPLFIED .EXE FORMAT)
.MODEL SMALL
;---------------------------------------------
.STACK 100H
;---------------------------------------------
.DATA
	TEMP DB 32 DUP('$') 

	PROMPT3 DB 0DH,0AH,'What letter do you guess?  ', '$'
	PROMPT4 DB 0DH,0AH,'The word is:',0DH,0AH, '$'
	PROMPT5 DB 0DH,0AH,'Congratulations! You won the game',0DH,0AH, '$'
	PROMPT6 DB 0DH,0AH,'Sorry you missed.',0DH,0AH, '$'
	PROMPT7 DB 0DH,0AH,'Sorry, duplicate entry.  Please try again.',0DH,0AH, '$'
	PROMPT8 DB 0DH,0AH,'List of chosen letter(s): ', '$'
	CURRENTHIGH DB 0DH,0AH,'Score to beat: ', '$'
	CURRENTSCORE DB 0DH,0AH,'Your score: ', '$'
	CRLF   DB  0DH, 0AH, '$'
	NEWLINE DB 10,13,'$'
	
	FIG0    DB 0DH,0AH,' +=======+',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG1    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG2    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/        |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG3    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/ \      |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG4    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG5    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,' |       |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG6    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,' |       |',0DH,0AH,'/        |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG7    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,' |       |',0DH,0AH,'/ \      |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG8    DB 0DH,0AH,' +=======+',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'   \O/   |',0DH,0AH,'    |    |',0DH,0AH,'    |    |',0DH,0AH,'   / \   |',0DH,0AH,' ========+',0DH,0AH,'$'
	
	ERROR1_STR    DB 'Error in opening file.$'
  ERROR2_STR    DB 'Error reading from file.$'
  ERROR3_STR    DB 'No record read from file.$'
	ERROR4_STR    DB 'Error writing in file.$'
  ERROR5_STR    DB 'Record not written properly.$'
	
	WORDS  DB 'file.txt', 00H
	HIGHSCORETXT  DB 'high.txt', 00H
  FILEHANDLE    DW ?

	STACK_INPUT		DB 32 DUP('$') 
	RECORD_STR    DB 1001 DUP('$')  ;length = original length of record + 1 (for $)
  TOBESOLVED    DB 32 DUP(' ')  ;length = original length of record + 1 (for $)
	HIGH_STR    DB 32 DUP('$')    ;
	;HIGH_STR  DW 10
  ;      DW 0
	;			DW 10 DUP(0)
	
	
	;TEMP DB ?,'$'
	;STACK_INPUT DB ?,'$'
	CREDIT    DB ?
	correct   DB ?
	incorrect DB ?
	STR_L	  DB ?
	;MSG  DB ?,'$'
	MSG DB 32 DUP('$') 
	RES  DW 100 DUP ('$')
	RES2  DB 10
        DB 0
				DB 10 DUP(0)
  multiplier db 0ah
	
	COUNT DW ?
	SCORE DW ?
	;SCORE DW 10
  ;      DW 0
	;			DW 10 DUP(0)
	HIGHSCORE DW 100 DUP ('$')
	MODE DB 1 ;-------NORMAL OR EXTREME MODE-------;
	LOSE DW ? ;--------IF DEDZ NA BA-----------;
	TEN DW ?
	TOT DW ?
	COUNTER DW ?
	
	
  
;---------------------------------------------
.CODE
;*************************************************************************
;  MACRO FOR PRINTING STRINGS
;*************************************************************************
PRINTSTR MACRO STRING

MOV AH,9
LEA DX, STRING
INT 21H
ENDM

;*************************************************************************
;  MACRO FOR CLEARING STRINGS
;*************************************************************************
RESETS MACRO STRING 	
	LOCAL WIPE
	LOCAL ENDRESET
	XOR  SI,SI
WIPE:
     CMP  STRING[SI], '$'
		 JE ENDRESET
     MOV  STRING[SI], '$'
		 INC  SI
		 JMP WIPE
     
		 ENDRESET:
ENDM

MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX
	XOR BP,BP
	
	MOV SCORE,0
	
  ;MAINGAME:
;*************************************************************************
;  FILE READING
;*************************************************************************
	LEA SI, RECORD_STR
	LEA DI, TOBESOLVED
	MOV BP,SI
	
	;-------READ FOR HIGHSCORE-------;
	LEA DX,HIGHSCORETXT
	CALL OPEN
	LEA DX, HIGH_STR
	CALL READ
	CALL STR2HEX
	MOV AX,TOT
	CALL HEX2DEC
	MOV DX,RES
	MOV HIGHSCORE,DX
	;PRINTSTR RES

	;PRINTSTR HIGH_STR
	;CALL STR2HEX
	;MOV AX,HIGH_STR
	;CALL HEX2DEC
	;MOV AX, RES
	;MOV HIGHSCORE,AX
	;RESETS RES
	
	CALL FILECLOSE
	
	;-------READ FOR WORDS-------;
  LEA DX, WORDS
	CALL OPEN
  LEA DX, RECORD_STR    ;address of input area
	CALL READ
  
	CALL GETCOUNT ;gets file string length
	MOV CREDIT,0		;initialize Credit
	MOV  correct,0		;initialize values of correct & incorrect
	MOV  incorrect,0
	MOV CX,7
	MOV LOSE,0
	
;*************************************************************************
;  LOOP FOR ALL WORDS IN THE FILE
;*************************************************************************
	PLAY:
	CALL GETLINE ; gets 1 line form file
	
  ;display record
	;PRINTSTR TOBESOLVED
	CMP LOSE,1
	JE EXIT
	CALL TABLE
	CALL matchWord
	
	;PRINTSTR NEWLINE
	CALL RESET

	LEA DI, TOBESOLVED
	
	CMP COUNT,0
	JNE PLAY
	
	CALL FILECLOSE
	
  JMP EXIT

DISPLAY_ERROR1:
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT

DISPLAY_ERROR2:
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT

DISPLAY_ERROR3:
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT:
  MOV AH, 4CH
  INT 21H
MAIN ENDP

FILECLOSE PROC
	 MOV AH, 3EH           ;request close file
  MOV BX, FILEHANDLE    ;file handle
  INT 21H
	RET
FILECLOSE ENDP
	

;*************************************************************************
;  OPEN procedure
;*************************************************************************

OPEN PROC
	MOV AH, 3DH           
	MOV AL, 00            
	INT 21H
	JC DISPLAY_ERROR1
	MOV FILEHANDLE, AX
	RET

OPEN ENDP

;*************************************************************************
;  READ procedure
;*************************************************************************

READ PROC
	MOV AH, 3FH           
	MOV BX, FILEHANDLE    
	MOV CX, 2000             
	INT 21H
	JC DISPLAY_ERROR2
	CMP AX, 00            
	JE DISPLAY_ERROR3

	RET

READ ENDP

;*************************************************************************
;  GETCOUNT procedure
;*************************************************************************	

GETCOUNT PROC
	MOV CX,AX
	MOV COUNT,CX
	RET
GETCOUNT ENDP

;*************************************************************************
;  GETLINE procedure
;*************************************************************************

GETLINE PROC
	MOV SI,BP
	;MOV TEMPSI, SI

	ITERATE:
		MOV AL,[SI]
		CMP AL,'*'
		JE ENDGET
		MOV [DI],AX
		INC SI
		INC DI
		DEC COUNT
	JMP ITERATE	
		
	
	ENDGET:
	DEC COUNT
	MOV AL,'$'
	MOV [DI],AX
	INC SI
	MOV BP,SI

	RET
GETLINE ENDP

;*************************************************************************
;  RESET procedure
;*************************************************************************

RESET PROC 	
		RESETS STACK_INPUT
		RESETS TEMP
		RESETS MSG
		 RET
RESET ENDP

;*************************************************************************
;  HEX TO DEC procedure
;*************************************************************************

HEX2DEC PROC 	
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	LEA SI,RES
	MOV CX,0
  MOV BX,10
   
LOOP1: MOV DX,0
       DIV BX
       ADD DL,30H
       PUSH DX
       INC CX
       CMP AX,9
       JG LOOP1
     
       ADD AL,30H
       MOV [SI],AL
     
LOOP2: POP AX
       INC SI
       MOV [SI],AL
       LOOP LOOP2
		
		INC SI
		MOV AL,'$'
		MOV [SI],AL
    
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
		RET
HEX2DEC ENDP

;*************************************************************************
;  STRING TO HEX procedure
;*************************************************************************

STR2HEX PROC 	
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	
	XOR SI,SI
	XOR AX,AX
	XOR BX,BX
	MOV TEN,10
	MOV TOT,0
	
	
	LOOP0:
	CMP HIGH_STR[SI],'$'
	JE END00
	
	MOV CX,TEN
	MOV AX, TOT
	MUL CX
	MOV TOT,AX
	
	XOR AX,AX
	
	MOV AL,HIGH_STR[SI]
	SUB AL,30H
	
	ADD TOT,AX

	INC SI
	JMP LOOP0
END00:
			
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	
	RET
STR2HEX ENDP

;*************************************************************************
;  TABLE procedure
;*************************************************************************

TABLE PROC 	
;copy string
	XOR SI,SI
COPY0:
	CMP TOBESOLVED[SI],'$'
	JE END0
	MOV AL,TOBESOLVED[SI]
	MOV MSG[SI],AL
	INC SI
	JMP COPY0
END0:
	MOV MSG[SI],'$'
	;PRINTSTR MSG
  CALL displayEmpty    	 	
	
	RET
TABLE ENDP

;**************************************************************************
;	displayEmpty Procedure
;**************************************************************************
displayEmpty PROC
	MOV STR_L,0		;initialize string length
	MOV BL,'-'
	PRINTSTR CRLF
;display dash
	XOR SI,SI		;resets index
BEGIN:
	CMP MSG[SI],'$'
	JE End_
	MOV TEMP[SI],BL
	INC STR_L
	INC SI
	JMP BEGIN
End_ :
	MOV TEMP[SI],'$'

	PRINTSTR TEMP
	PRINTSTR CRLF

 	RET

displayEmpty ENDP

;***************************************************************************
;	matchWord Procedure
;***************************************************************************
wins:
jmp WINCASE
looses:
jmp LOOSE
RESETINC:
MOV CREDIT,0		;initialize Credit
MOV  correct,0		;initialize values of correct & incorrect
MOV  incorrect,0
MOV CX,7
JMP CONT
;RET
matchWord PROC
	CMP MODE,2
	JNE RESETINC
	CONT:
	;MOV CREDIT,0		;initialize Credit
	;MOV  correct,0		;initialize values of correct & incorrect
	;MOV  incorrect,0
	;MOV CX,7
INPUT:	;*********************** user input loop ***************************
	CMP CX,0
	JE  looses
	MOV DL,correct
	CMP DL,STR_L
	JE  wins
OTHER_INPUT:
	MOV AX, SCORE
	CALL HEX2DEC
	PRINTSTR CURRENTHIGH
	PRINTSTR HIGH_STR     ;----TODO CONVERT TO HEX-------;
	;PRINTSTR HIGHSCORE
	PRINTSTR CURRENTSCORE
	PRINTSTR RES  ;-----CONVERTED SCORE TO DEC----------;
	PRINTSTR CRLF
	PRINTSTR PROMPT3  ;--------USER INPUT PROMPT---------;
	MOV AH,1
	INT 21H
	MOV BL,AL		;save input to BL
	XOR SI,SI
CHECK_DUP:			;check if there is a duplicate entry
	CMP STACK_INPUT[SI],'$'
	JE  STORE_INPUT		
	CMP AL,STACK_INPUT[SI]
	JE  DUPLICATE
	INC SI
	JMP CHECK_DUP
DUPLICATE:
	PRINTSTR PROMPT7
	JMP OTHER_INPUT	
STORE_INPUT:
	MOV STACK_INPUT[SI],BL
	INC SI
	MOV STACK_INPUT[SI],'$'

	PRINTSTR PROMPT8
	PRINTSTR STACK_INPUT

	PRINTSTR PROMPT4  ;Comment the user's guessing 
	XOR SI,SI		;resets index
COMPARE:;*********************** compares an char input to a word ***********
	CMP MSG[SI],'$'
	JE GETINPUT
	CMP BL,MSG[SI]		;input matches any letter of the word?
	JE GAIN_CORRECT
	INC SI
	JMP COMPARE	

GAIN_CORRECT:
	MOV TEMP[SI],BL
	INC SI
	INC SCORE ;----player score-----;
	INC correct
	INC CREDIT
	JMP COMPARE
GETINPUT:
	PRINTSTR TEMP
	CMP CREDIT,0
	JG  GAIN_SCORE
	DEC CX
	INC incorrect
GAIN_SCORE:
	CALL DISPLAY
	XOR SI,SI		;resets index
	MOV CREDIT,0
	JMP INPUT
WINCASE:
	CMP MODE,2
	JNE NORESETINC
	;MOV incorrect,8
	CONT0:
	CALL DISPLAY
	PRINTSTR PROMPT5
	JMP RESULT
LOOSE:
	MOV LOSE,1
	PRINTSTR PROMPT6	
RESULT:
	CALL GETSIZE
	MOV AX,TOT
	CMP SCORE,AX
	JG WRITE
	CONTINUE:
	RET			;return to main

matchWord ENDP

NORESETINC:
MOV incorrect,8
JMP CONT0

WRITE:
	MOV AH, 3CH           ;request create file
  MOV CX, 00            ;normal attribute
  LEA DX, HIGHSCORETXT  ;load path and file name
  INT 21H
  JC DISPLAY_ERROR6     ;if there's error in creating file, carry flag = 1, otherwise 0
  MOV FILEHANDLE, AX

  ;write file
  MOV AH, 40H           ;request write record
  MOV BX, FILEHANDLE    ;file handle
  MOV CX, COUNTER            ;record length
  LEA DX, RES    ;address of output area
  INT 21H
  JC DISPLAY_ERROR4     ;if carry flag = 1, there's error in writing (nothing is written)
  CMP AX, COUNTER            ;after writing, set AX to size of chars nga na write
  JNE DISPLAY_ERROR5  
  
  ;close file handle
  MOV AH, 3EH           ;request close file
  MOV BX, FILEHANDLE    ;file handle
  INT 21H
	JMP CONTINUE
	
	DISPLAY_ERROR4:
	LEA DX, ERROR4_STR
	MOV AH, 09
	INT 21H
	JMP EXIT1
	
	DISPLAY_ERROR5:
	LEA DX, ERROR5_STR
	MOV AH, 09
	INT 21H
	JMP EXIT1
	
	DISPLAY_ERROR6:
	LEA DX, ERROR1_STR
	MOV AH, 09
	INT 21H
	JMP EXIT1

	EXIT1:
 	MOV AX, 4C00H
	INT 21H	

;*************************************************************************
;	SIZE OF CURRENT SCORE procedure
;*************************************************************************	

GETSIZE PROC
	MOV COUNTER,0
	XOR SI,SI
COPY10:
	CMP RES[SI],'$'
	JE END10
	INC COUNTER
	INC SI
	JMP COPY10
END10:
	MOV MSG[SI],'$'
	
RET
GETSIZE ENDP

;RET
;*************************************************************************
;	Display (bitmap) procedure
;*************************************************************************
DISPLAY PROC
;checking score value and display
        CMP incorrect,0
        JE DISP0

        CMP incorrect,1
        JE DISP1

        CMP incorrect,2
        JE DISP2

        CMP incorrect,3
        JE DISP3

        CMP incorrect,4
        JE DISP4

        CMP incorrect,5
        JE DISP5

        CMP incorrect,6
        JE DISP6

        CMP incorrect,7
        JE DISP7

        CMP incorrect,8
        JE DISP8

		
RET

DISP0:
	PRINTSTR FIG0
	RET

DISP1:
	PRINTSTR FIG1
	RET

DISP2:
	PRINTSTR FIG2
	RET

DISP3:
	PRINTSTR FIG3
	RET

DISP4:
	PRINTSTR FIG4
	RET

DISP5:
	PRINTSTR FIG5
	RET

DISP6:
	PRINTSTR FIG6
	RET

DISP7:
  PRINTSTR FIG7
  RET

DISP8:
	PRINTSTR FIG8
	RET

DISPLAY ENDP

END MAIN