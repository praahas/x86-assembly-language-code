;Develop an assembly language program to compute nCr using recursive procedure. Assume that ‘n’ and ‘r’ are non-negative integers.
DATA SEGMENT		
                        N DW 5		;STORE THE VALUE FOR N IN MEMORY. 2 BYTES ARE ALLOCATED
                        R DW 2		;STORE THE VALUE OF R IN MEMORY. 2 BYTES ARE ALLOCATED
            RESULT DW 0		;RESULT IS INITIALIZE TO 0
DATA ENDS

ASSUME CS:CODE,DS:DATA

CODE SEGMENT
START:	MOV AX,DATA
                           MOV DS,AX
                           MOV AX,N	;N VALUE IS COPIED INTO AX REGISTER
                           MOV BX,R	;R VALUE IS COPIED INTO BX REGISTER
                           CALL NCR	;CALL PROCEDURE NCR TO CALCULATE THE NCR
                           INT 03H		;BREAKPOINT INTERRUPT
NCR PROC
                           CMP BX,0H	;CHECK IF R=0. IF R= 0, JUMP TO RES1 WHERE RESULT=RESULT+1 IS PERFORMED.
            	JE RES1
          	CMP BX,AX	;CHECK IF N=R. IF N=R, JUMP TO RES1 WHERE RESULT=RESULT+1 IS PERFORMED.
       		JE RES1
                           CMP BX,01H	;CHECK IF R=1. IF R= 1, JUMP TO RESN WHERE RESULT=RESULT+N IS PERFORMED.
                           JE RESN
                           DEC AX		;DECREMENT AX I.E N TO CHECK IF R= (N-1)
                           CMP BX,AX`	; IF R=N-1, JUMP TO INCR WHERE FIRST RESULT = RESULT+1 IS PERFOMRED 
                           JE INCR 		; & THEN RESULT= RESULT+N IS CALULATED . 
                           PUSH AX		;NEXT WE HAVE TO CALULCATE (N-1) CR 
                           PUSH BX		; SO FIRST PUSH THE CURRENT N & R ONTO THE STACK
                           CALL NCR	;CALL THE NCR PROCEDURE WITH THE PRESENT N & R VALUES.
                           POP BX		;ONCE THE CNTROL RETURNS FROM THE PROCEDURE, 
                           POP AX		; POP THE EARLIER PUSHED N & R  INTO REGISTERS AX & BX.
                           DEC BX		;DECREMEMENT R BY SO THAT WE OBTAIN R-1
                           PUSH AX		;NOW WE PUSH THE (N-1) AND (R-1) ONTO THE STACK AND THEN CALL NCR PROCEDURE
                           PUSH BX		;TO CALCULATE (N-1) C (R-1)
                           CALL NCR	;
                           POP BX		;AFTER ALL THE RECURSIVE CALLS THE FINAL N & R VALUES ARE STACK
                           POP AX		; POPPED FROM THE STACK INTO AX & BX
                           RET		;FINALLY THE RESULT IS UPDATED
RES1:                 INC RESULT
                           RET
INCR:	INC RESULT
RESN:	ADD RESULT,AX
           	RET
NCR ENDP
CODE ENDS
END START
