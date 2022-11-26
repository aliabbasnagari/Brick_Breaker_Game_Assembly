.MODEL SMALL
.STACK 100H
.DATA

    ; <--- Colors --->
    BLACK    EQU 0
    BLUE     EQU 1
    GREEN    EQU 2
    CAYAN    EQU 3
    RED      EQU 4
    MAGINTA  EQU 5
    BROWN    EQU 6
    LGRAY    EQU 7
    DGRAY    EQU 8
    LBLUE    EQU 9
    LGREEN   EQU 10
    LCAYAN   EQU 11
    LRED     EQU 12
    LMAGINTA EQU 13
    YELLOW   EQU 14
    WHITE    EQU 15
    ; <--- END COLORS --->

    ; <--- OUTER BORDER --->
    XY_MIN DW 10
    X_MAX DW 300
    Y_MAX DW 180
    
    ; <--- BALL DATA --->
    C_X DW 0
    C_Y DW 0
    X_DIR DB 0
    Y_DIR DB 0
    B_SPEED DW 10
    TP DW 0

    ; <--- FPS DATA --->
    TIME_TRACK DB 0

    ; <--- SHAPES DATA --->
    TMP_LEN DW 0
    TMP_HIG DW 0

    TMP_X DW 0
    TMP_Y DW 0
    
    T_X DW 0
    T_Y DW 0

    _X DW 0
    _Y DW 0

    COLOR DB ?

    ; <--- HELPING DATA --->
    BOOL DB 0
    COL BYTE 0

;<----- MACROS ----->
; X = X-Coordinate, Y = Y-Coordinate, L = length, H = Height, C = Color
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

; DRAW CIRCLE
DRCR MACRO X, Y, C
    MOV C_X, X
    MOV C_Y, Y

    MOV AX, C_X
    MOV CX, C_Y
    ADD AX, 4
    DRBX AX, CX, 1, 9, C
    MOV AX, C_X
    ADD AX, 2
    MOV CX, C_Y
    ADD CX, 1
    DRBX AX, CX, 5, 7, C
    MOV AX, C_X
    ADD AX, 1
    MOV CX, C_Y
    ADD CX, 2
    DRBX AX, CX, 7, 5, C
    MOV AX, C_X
    MOV CX, C_Y
    ADD CX, 4
    DRBX AX, CX, 9, 1, C
ENDM
;<----- END MACROS ----->

.CODE
MOV AX,@DATA
MOV DS,AX

MAIN PROC
    MOV AH,00H		;SET VIDEO MODE
    MOV AL,13H		;CHOOSE MODE 13
    INT 10H         ; GRAPHICS INTERRUPT

    MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BROWN
    INT 10h

    DRBX 10, 10, 300, 180, LGRAY

    MOV TIME_TRACK, 0
    MOV C_X, 10
    MOV C_Y, 10
    MOV BX, 0
    LOOPER:

        PUSH BX
        MOV AH, 2CH
        INT 21H
        CMP TIME_TRACK, DL
        JE SKIP_BALL
        MOV TIME_TRACK, DL
        CALL MOVE_BALL
        SKIP_BALL:
        MOV BX, C_X
        MOV DX, C_Y
        DRCR BX, DX, BLUE

        POP BX
        DRBX BX, 185, 50, 5, 1H
        DRVLN BX, 185, 5, 4H
        MOV CX, BX
        ADD CX, 50
        DRVLN CX, 185, 5, 4H

        MOV AH, 1 ; INTRUPT FOR KEYBOARD INPUT
        INT 16H
        JZ LOOPER
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

MAIN ENDP
JMP EXIT

; <----- Functions ----->

MOVE_BALL PROC
    MOV BX, C_X
    MOV DX, C_Y
    DRCR BX, DX, BLUE
    TIMER:
    MOV AH, 2CH
    INT 21H
    CMP TIME_TRACK, DL
    JE TIMER
    MOV TIME_TRACK, DL

    MOV BX, C_X
    MOV DX, C_Y
    DRCR BX, DX, LGRAY
    XX:
    CMP X_DIR, 0
    JNE X_REV
        MOV BX, C_X
        CMP BX, X_MAX
        JAE CNG_X1
            MOV BX, B_SPEED
            ADD C_X, BX
            JMP YY
        CNG_X1:
        MOV X_DIR, 1
    X_REV:
        MOV BX, C_X
        CMP BX, XY_MIN
        JBE CNG_X2
            MOV BX, B_SPEED
            SUB C_X, BX
            JMP YY
        CNG_X2:
        MOV X_DIR, 0

    YY:
    CMP Y_DIR, 0
    JNE Y_REV
        MOV BX, C_Y
        CMP BX, Y_MAX
        JAE CNG_Y1
            MOV BX, B_SPEED
            ADD C_Y, BX
            JMP ENDL
        CNG_Y1:
        MOV Y_DIR, 1
    Y_REV:
        MOV BX, C_Y
        CMP BX, XY_MIN
        JBE CNG_Y2
            MOV BX, B_SPEED
            SUB C_Y, BX
            JMP ENDL
        CNG_Y2:
        MOV Y_DIR, 0
    ENDL:
    RET
MOVE_BALL ENDP
; TO DRAW A BOX
DRAWBOX PROC
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_H:
        MOV CX, _X
        MOV T_X, CX
        LOOP_W:
            MOV AH, 0CH 
            MOV AL, COLOR   ;COLOUR
            MOV CX, T_X     ; CX IS X-AXIS
            MOV DX, T_Y     ; DX IS Y-AXIS
            INT 10H         ; INTERRUP FOR GRAPHICS
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
        MOV AH, 0CH
        MOV AL, COLOR   ; COLOUR
        MOV CX, _X      ; CX IS X-AXIS
        MOV DX, _Y      ; DX IS Y-AXIS
        INT 10H         ; INTERRUP FOR GRAPHICS
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
        MOV AH, 0CH 
        MOV AL, COLOR   ; COLOUR
        MOV CX, T_X     ; CX IS X-AXIS
        MOV DX, T_Y     ; DX IS Y-AXIS
        INT 10H         ; INTERRUP FOR GRAPHICS
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
        MOV AH, 0CH
        MOV AL, COLOR   ; COLOUR
        MOV CX, T_X     ; CX IS X-AXIS
        MOV DX, T_Y     ; DX IS Y-AXIS
        INT 10H         ; INTERRUP FOR GRAPHICS
        INC T_Y
        MOV CX, TMP_LEN
        ADD CX, _Y
        CMP T_Y, CX
    JBE LOOP_H
    RET
DRAWVLINE ENDP
; <----- End Functions ----->

EXIT:
MOV AH, 4CH
INT 21H
END
