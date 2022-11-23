.MODEL SMALL
.STACK 100H
.DATA
    S1 DW 0
    S2 DW 0

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

    COL BYTE 0

DRBX MACRO X, Y, L, H
    MOV _X, X
    MOV _Y, Y
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    CALL DRAWBX
ENDM

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
    FPS:
        MOV AH, 2CH
        INT 21H
        CMP DH, TIME_TRACK
        JE FPS
    
    MOV AH, 06h 
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80	 
    MOV BH, 4h
    INT 10h
    
    CDBX BX, 150, 50, 5

    CMP COL, 0
    JNE LEF
        INC BX
        JMP RIG
    LEF:
        DEC BX
    RIG:
        CMP BX, 100
        JNE SF1
            MOV COL, 1
        SF1:
        CMP BX, 0
        JNE SF2
            MOV COL, 0
        SF2:  

    MOV TIME_TRACK, DH
    JMP FPS
MAIN ENDP
JMP EXIT


DRAWBX PROC
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_H:
        MOV CX, _X
        MOV T_X, CX
        LOOP_W:
            MOV AH, 0CH ; 
            MOV AL, 1H ;COLOUR
            MOV CX, T_X ; INCREMENTS X AXIS ; CX IS X-AXIS
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
DRAWBX ENDP




EXIT:
MOV AH, 4CH
INT 21H
END
