;Design and develop an assembly program to sort a given set of ‘n’ 16-bit numbers in ascending order. Adopt Bubble Sort algorithm to sort given elements.
DATA SEGMENT			
            ARRAY DW 5,4,1,2,3		;DATA IS STORED AS 16 BIT WORDS IN DATA SEGMENT FROM ARRAY
                       N DW 5			;THE NUMBER OF DATA VALUES STORED
DATA ENDS

ASSUME CS:CODE, DS:DATA

CODE SEGMENT
START:	MOV AX,DATA	;LOAD THE DATA SEGMENT BASE ADDRESS INTO DS REGISTER USING AX
                      	MOV DS,AX
                           MOV BX,N		;LOAD THE COUNT OF VALUES INTO BX i.e .INDEX FOR OUTER LOOP
                           DEC BX
OUTLOOP:	MOV CX,BX		;LOAD THE COUNT OF VALUES INTO CX i.e .INDEX FOR INNER LOOP
                           MOV SI,0			;SET POINTER SI TO 0 TO POINT TO FIRST WORD OF ARRAY
INLOOP:	MOV AX,ARRAY[SI]	;LOAD THE VALUE POINTED AT BY THE POINTER SI INTO AX 
                           INC SI			;INCREMENT POINTER SI TWICE TO POINT TO NEXT WORD
                           INC SI			;NOTE: INCREMENTING ONCE WOULD POINT TO NEXT BYTE.
                           CMP AX,ARRAY[SI]	;COMPARE THE VALUE IN AX WITH VALUE POINTED AT BY SI IN ARRAY
                           JC NEXT			;IF VALUE IN AX IS GREATER THEN SWAP, ELSE PROCEED
                           XCHG AX,ARRAY[SI]	;IF AX>ARRAY[SI] THE VALUES GET SWAPPED HERE
                           MOV ARRAY[SI-2],AX	
NEXT:	LOOP INLOOP		;REPEAT LOOP UNTIX CX BECOMES 0, INDICATING END OF INNER LOOP
                           DEC BX		;DECREMENT COUNT FOR OUTER LOOP
                           JNZ OUTLOOP		;IF OUTER LOOP INDEX HAS NOT BECOME 0 REPEAT THE OUTERLOOP
                           INT 03H		;BREAKPOINT INTERRUPT SO THAT DATA SEGMENT CAN BE OBSERVED
CODE ENDS
END START	

;NOTE:
; To view output in data segment, after running debug program, type d ds:0000 to view the data segment.
; To view output in data segment, after running debug program, type d ds:0000 0009 to view only the 5 sorted ;words in locations 0000H,0001H,0002H,0003H,0004H,0005H,0006H,0007H,0008H,0009H	
