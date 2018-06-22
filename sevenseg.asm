;Design and develop an assembly program to display messages “FIRE” and “HELP” alternately with flickering effects on a 7-segment display interface for a suitable period of time. Ensure a flashing rate that makes it easy to read both the messages.
DATA SEGMENT
            PORTA EQU 0E880H		 	 ; 8255 PORT A PORT# E880H GIVEN THE NAME PORTA
            PORTC EQU 0E882H			 ; 8255 PORT C PORT# E882H GIVEN THE NAME PORTA
                    CR EQU 0E883H           		 ; 8255 CONTROL WORD ADDRESS E883H GIVEN THE NAME CR
                  FIRE  DB 79H,50H,06H,71H,0,0		 ;DATA CORRESPONDING TO E,R,I,F ON 7 SEGMENT DISPLAY
                  HELP DB 73H,38H,79H,76H,0,0	 ;DATA CORRESPONDING TO P,L,E,H ON 7 SEGMENT DISPLAY
DATA ENDS

ASSUME CS:CODE, DS:DATA

CODE SEGMENT
            START: MOV AX,DATA
                        MOV DS,AX
                        MOV AL,80H  	;80H IS COPIED TO AL TO LOAD INTO CR FOR SETTING PORT A,B & C AS OUTPUT PORTS
                        MOV DX,CR 	; PORT ADDRESS IS 16 BIT, THEREFORE DX IS USED TO HOLD IT FOR IN & OUT
                        OUT  DX,AL	;8 BIT DATA IN AL IS SENT TO CR WHOSE 16-BIT ADDRESS IS IN DX.
            RDISP:MOV DI,50	;E,R,I & F WILL BE DISPLAYED 50 TIMES ON THE 7 SEGMENT DISPLAY INTERFACE.
            FIRE1:MOV  SI,OFFSET  FIRE ; SET SI AS A POINTER TO THE ADDRESS FIRE WHICH HOLD BYTES FOR E,R,I,F,
                        CALL  DISPLAY ; CALL DISPLAY PROCEDURE
                        DEC DI	;DECREMENT DI & CHECK IF IT IS 0. THUS THIS LOOP WILL REPEAT 50 TIMES
                        JNZ  FIRE1	
                        MOV DI,50	;
           HELP1:MOV  SI,OFFSET  HELP ; P,L,E,H WILL BE DISPLAYED 50 TIMES ON THE 7 SEGMENT DISPLAY INTERFACE.
                        CALL  DISPLAY		; CALL DISPLAY PROCEDURE
                        DEC  DI		;DECREMENT DI & CHECK IF IT IS 0. THUS THIS LOOP WILL REPEAT 50 TIMES
                        JNZ  HELP1
                        MOV AH,01H		;AH=01H INT 16H WILL SET THE ZERO FLAG. BY DEFAULT. IF A USER PRESSES 
                        INT 16H		;ANYKEY ON THE KEYBOARD THEN ZERO FLAG GETS CLEARED. THIS LOGIC IS 
                        JZ  RDISP		USED TO EXIT THE PROGRAM IF USER PRESSES A KEY ON THE KEYBOARD
                        MOV AH,4CH
                        INT 21H
      DISPLAY:MOV CX,06H		;COUNT OF THE NUMBER OF 7 SEGMENT UNITS IN THE INTERFACE KIT.
                        MOV  BL,00H		;BL HOLDS THE VALUE THAT SELECTS 1 OF THE 6 UNITS IN THE KIT
            ADISP:MOV  AL,BL    		;THE SELECTION VALUE IN BL IS SENT TO THE KIT VIA PORT C.
                        MOV  DX,PORTC	
                        OUT  DX,AL		;DATA TO BE DISPLAYED ON THE 7 SEGMENT UNITS WILL BE SENT TO THE 
                        MOV  DX,PORTA	;UNIT SELECTED BY PORT C VIA PORT A
                        LODSB		;PICKS THE DATA FROM LOCATION POINTED AT BY SI & COPIES IT TO AL AFTER
                        OUT  DX,AL		;WHICH IT INCREMENTS SI TO POINT TO THE NEXT MEMORY LOCATION
                        CALL  DELAY		;DELAY PROCEDURE TO GIVE  DELAY BETWEEN SUCCESSIVE CHARACTERS
                        INC  BL		;INCREMENT BL TO SELECT THE NEXT 7 SEGMENT UNIT		
                        CMP  BL,05H		;CHECK IF BL HAS REACHED 5 & IS POINTING TO THE LAST SEGMENT.
                        JLE  EDISP		;IF IT HAS NOT THEN JUMP TO EDISP WHERE CX WILL GET DECREMENTED
                        MOV BL,00H		;IF BL HAS POINTED TO THE LAST UNIT, THEN RESET BL
            EDISP:LOOP ADISP		;LOOP TO ADISP IF CX IS NOT 0
                        RET			;IF 6 UNITS HAVE BEEN ACTIVATED THEN EXIT TO CALLER
            DELAY:PUSH BX		;CODE FOR GENERATING DELAY
                        PUSH CX
                        MOV BX, 0FFH         
                  L1:MOV CX, 0FFFH
                  L2:LOOP L2
                       DEC BX
                       JNZ L1
                  POP CX
                  POP BX
                       RET
CODE ENDS
END  START
