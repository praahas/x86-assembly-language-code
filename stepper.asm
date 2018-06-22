;Design and develop an assembly program to drive a Stepper Motor interface and rotate the motor in specified direction (clockwise or counter-clockwise) by N steps.
DATA SEGMENT
          PORTC EQU 0E882H	; 8255 PORT C PORT# E882H GIVEN THE NAME PORTA
                CR EQU 0E883H	; 8255 CONTROL WORD ADDRESS E883H GIVEN THE NAME CR
                  N EQU 05	;THE COUNT OF FIVE IS REPRESENT BY N(NUMBER OF STEPS)
DATA ENDS

ASSUME CS:CODE,DS:DATA

CODE SEGMENT
          START: MOV AX,DATA
                      MOV DS,AX
                      MOV AL,80H	      ;80H IS COPIED TO AL TO LOAD INTO CR FOR SETTING PORT A,B & C AS OUTPUT PORTS
                      MOV DX,CR	      ; PORT ADDRESS IS 16 BIT, THEREFORE DX IS USED TO HOLD IT FOR IN & OUT
                      OUT DX,AL	      ;8 BIT DATA IN AL IS SENT TO CR WHOSE 16-BIT ADDRESS IS IN DX.
                      MOV CX,N	     ;COUNT OF NUMBER OF STEPS IS STORED IN CX
                      MOV AL,33H	     ;THE NUMBERS 33H,99H,CCH AND 66H WILL ACTIVE TWO SUCCESSIVE PORT PINS	
                      MOV DX,PORTC ;THEREBY ACTIVATING TWO SUCCESSIVE COILS CAUSING THE ROTOR TO ALIGN
            BACKR:OUT DX,AL 	    ;IN THE RESULTANT DIRECTION. INITIAL VALUE 33H IS SENT TO PORTC
                      ROR AL,01H	   ;33H ON ROTATION GIVES 99H & CCH & 66H IN SUCCESSIVE STEPS
                      PUSH CX	  ;PUSH THE COUNT ONTO STACK BEFORE CALLING DELAY AS CX WILL BE USED IN THE
                      CALL DELAY	  ;CODE FOR DELAY GENERATION
                      POP CX	; POP THE COUNT BACK INTO CX
                      LOOP BACKR	; REPEAT LOOP UNTIL THE CX BECOMES 0 .I.E SPECIFIED NUMBER OF STEPS.
                      MOV CX,N
                      MOV DX,PORTC
          BACKL:OUT DX,AL       ; CODE FOR ANTI-CLOCKWISE ROTATION
                      ROL AL,01H
                      PUSH CX
                      CALL DELAY
                      POP CX
                      LOOP BACKL
                      MOV AH,4CH	;INTERRUPT TO EXIT THE PROGRAM
                      INT 21H
DELAY PROC 		;PROCEDURE FOR DELAY GENERATION
           MOV BX,0F000H
      L1:MOV CX,00FFFH
      L2:LOOP L2
          DEC BX
          JNZ L1
          RET
DELAY ENDP
CODE ENDS
END START
