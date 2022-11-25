.MODEL SMALL
.STACK 100H
.DATA
    TP DW 0

    TIME_TRACK DB 0

    TMP_LEN DW 0
    TMP_HIG DW 0
    
    TMP_X DW 0
    TMP_Y DW 0

    T_X DW 0
    T_Y DW 0
    _X DW 0
    _Y DW 0

    BOOL DB 0

    COL BYTE 0

    COLOR DB ?

;<----- MACROS ----->
; DRAW BOX
DRBX MACRO X, Y, L, H, C
    MOV _X, X
    MOV _Y, Y
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    MOV COLOR, C
    CALL DRAWBOX
ENDM

; DRAW LINE
DRLN MACRO X1, Y1, X2, Y2, C
    MOV _X, X1
    MOV _Y, Y1
    MOV T_X, X2
    MOV T_Y, Y2
    MOV COLOR, C
    CALL DRAWLINE
ENDM

; DRAW HORIZONTAL LINE
DRHLN MACRO X, Y, L, C
    MOV _X, X
    MOV _Y, Y
    MOV TMP_LEN, L
    MOV COLOR, C
    CALL DRAWHLINE
ENDM

; DRAW VERTICAL LINE
DRVLN MACRO X, Y, L, C
    MOV _X, X
    MOV _Y, Y
    MOV TMP_LEN, L
    MOV COLOR, C
    CALL DRAWVLINE
ENDM
;<----- END MACROS ----->

.CODE
MOV AX,@DATA
MOV DS,AX

MAIN PROC
    MOV AH,00H		;SET VIDEO MODE
    MOV AL,13H		;CHOOSE MODE 13
    INT 10H ; GRAPHICS INTERRUPT

    MOV AH, 06h 
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80	 
    MOV BH, 4h
    INT 10h

    MOV BX, 0
    LOOPER:
        DRBX BX, 185, 50, 5, 1H
        DRVLN BX, 185, 5, 4H
        MOV CX, BX
        ADD CX, 50
        DRVLN CX, 185, 5, 4H

	DRBX 0, 0, 50, 50, 12 ; brick 99

        MOV AH, 1 ; INTRUPT FOR KEYBOARD INPUT
        INT 16H
        MOV AH, 0
        INT 16H

        CMP AH, 4DH ; SCAN CODE RIGHT
        JNE SKIPER
        INC BX
        SKIPER:
        CMP AH, 4BH ; SCAN CODE LEFT
        JNE SKIPEE
        DEC BX
        SKIPEE:
    JMP LOOPER


;    MOV BX, 0
;    FPS:
;        MOV AH, 2CH
;        INT 21H
;        CMP DH, TIME_TRACK
;        JE FPS
;    
;    MOV AH, 06h 
;    MOV AL, 0
;    MOV CX, 0
;    MOV DH, 80
;    MOV DL, 80	 
;    MOV BH, 4h
;    INT 10h
;    
;    DRBX BX, 150, 50, 5
;
;    CMP COL, 0
;    JNE LEF
;        INC BX
;        JMP RIG
;    LEF:
;        DEC BX
;    RIG:
;        CMP BX, 100
;        JNE SF1
;            MOV COL, 1
;        SF1:
;        CMP BX, 0
;        JNE SF2
;            MOV COL, 0
;        SF2:  
;
;    MOV TIME_TRACK, DH
;    JMP FPS
MAIN ENDP
JMP EXIT

; TO DRAW A BOX
DRAWBOX PROC
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_H:
        MOV CX, _X
        MOV T_X, CX
        LOOP_W:
            MOV AH, 0CH ; 
            MOV AL, COLOR ;COLOUR
            MOV CX, T_X ; CX IS X-AXIS
            MOV DX, T_Y ; DX IS Y-AXIS
            INT 10H ; INTERRUP FOR GRAPHICS
            INC T_X
            MOV CX, TMP_LEN
            ADD CX, _X
            CMP T_X, CX
        JBE LOOP_W
        INC T_Y
        MOV CX, TMP_HIG
        ADD CX, _Y
        CMP T_Y, CX
    JBE LOOP_H
    RET
DRAWBOX ENDP

; TO DRAW A LINE BETWEEN COORDINATES
DRAWLINE PROC
    LOOP_L:
        MOV BOOL, 0
        MOV AH, 0CH ; 
        MOV AL, COLOR ; COLOUR
        MOV CX, _X ; CX IS X-AXIS
        MOV DX, _Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        MOV CX, T_X
        CMP _X, CX
        JE SKIP1
        JA DEC1
        INC _X
        MOV BOOL, 1
        JMP SKIP1
        DEC1:
            DEC _X
            MOV BOOL, 1
        SKIP1:
        MOV CX, T_Y
        CMP _Y, CX
        JE SKIP2
        JA DEC2
        INC _Y
        MOV BOOL, 1
        JMP SKIP2
        DEC2:
            DEC _Y
            MOV BOOL, 1
        SKIP2:
        CMP BOOL, 1
    JE LOOP_L
    RET
DRAWLINE ENDP

; TO DRAW A HPRIZONTAL LINE OF LENGTH L FROM SOME COORDINATES
DRAWHLINE PROC
    MOV CX, _X
    MOV T_X, CX
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_W:
        MOV AH, 0CH ; 
        MOV AL, COLOR ; COLOUR
        MOV CX, T_X ; CX IS X-AXIS
        MOV DX, T_Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        INC T_X
        MOV CX, TMP_LEN
        ADD CX, _X
        CMP T_X, CX
    JBE LOOP_W
    RET
DRAWHLINE ENDP

; TO DRAW A VERTICAL LINE OF LENGTH L FROM SOME COORDINATES
DRAWVLINE PROC
    MOV CX, _X
    MOV T_X, CX
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_H:
        MOV AH, 0CH ; 
        MOV AL, COLOR ; COLOUR
        MOV CX, T_X ; CX IS X-AXIS
        MOV DX, T_Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        INC T_Y
        MOV CX, TMP_LEN
        ADD CX, _Y
        CMP T_Y, CX
    JBE LOOP_H
    RET
DRAWVLINE ENDP

EXIT:
MOV AH, 4CH
INT 21H
END
