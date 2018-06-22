;Design and develop an assembly language program to search a key element “X” in a list of ‘n’ 16-bit numbers. Adopt Binary search algorithm in your program for searching.
DISPLAY MACRO MSG			;MACRO TO DISPLAY A STRING.
	          LEA DX,MSG			;STARTING ADDRESS OF THE STRING TO BE DISPLAYED IS LOADED IN DX
	          MOV AH,09H			;FUNCTION TO DISPLAY STRING UNDER INT21H
	          INT 21H
	ENDM

DATA SEGMENT
ARRAY DW 1,2,3,4,5			;DATA IS STORED AS 16 BIT SORTED WORDS IN DATA SEGMENT FROM ARRAY
        N DW 5				;THE NUMBER OF DATA VALUES STORED
        KEY EQU 7			;KEY VALUE TO BE SEARCHED
	    MSG1 DB  'ELEMENT FOUND$'	;MESSAGE TO BE DISPLAYED IF KEY ELEMENT IS FOUND
	    MSG2 DB  'ELEMENT NOT FOUND$'   ;MESSAGE TO BE DISPLAYED IF KEY ELEMENT IS NOT FOUND
DATA ENDS
ASSUME CS:CODE,DS:DATA

CODE SEGMENT
START:          MOV AX,DATA	                  ;LOAD THE DATA SEGMENT BASE ADDRESS INTO 
  	               MOV DS,AX		;DS REGISTER USING AX
	               MOV BX,00H	 	;SET LOW
                        MOV CX,N			;SET HIGH POSITION
AGAIN:          CMP BX,CX      		;CHECK IF LOWER POSITION IS GREATER THAN UPPER
                        JG NOTFOUND  	 	;IF LOW>HIGH ,THEN LOW POSITION POINTER HAS GONE BEYOND THE END
                        MOV AX,BX	 	;LOW POSITION POINTER SET TO AX
                        ADD AX,CX        	 	;ADD LOW+HIGH & DIVIDE BY 2 TO GET MIDPOINT
                        SHR AX,01H    	 	;SHIFT RIGHT ONCE DIVIDES A NUMBER BY 2
                        MOV SI,AX	 		;SET SI AS POINTER TO MID
                        ADD SI,SI	 		;UPDATE POINTER POSITION FOR 16-BIT DATA
                        CMP ARRAY[SI],KEY  	;COMPARE MID VALUE & KEY
                        JE FOUND          	  	;IF EQUAL THEN KEY FOUND
                        JC SETLB            	  	;IF NOT EQUAL & IF KEY>MID THEN JUMP TO SETLB TO UPDATE LOW
                        DEC AX	          	    	;IF NOT EQUAL & IF KEY<MID THEN UPDATE HIGH i.e  MID=MID+1
                        MOV CX,AX       	 	;HIGH= NEW VALUE OF MID i.e MID-1
                        JMP AGAIN
SETLB:           INC AX	          	   	;MID=MID+1
	               MOV BX,AX   	 	;LOW = NEW VALUE OF MID i.e MID+1                  
	               JMP AGAIN   	 	;REPEAT LOOP
FOUND:         DISPLAY MSG1		; IF FOUND DISPLAY FOUND MESSAGE
	               JMP QUIT			;JUMP TO THE LABEL TO EXECUTE INTERRUPT TO EXIT PROGRAM
NOTFOUND: DISPLAY MSG2		;IF NOT FOUND DISPLAY NOT FOUND MESSAGE
QUIT:             MOV AH,4CH		;INTERRUPT TO EXIT PROGRAM EXECUTION
	               INT 21H
CODE ENDS
END START
