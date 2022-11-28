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

    ; <--- MESSAGES --->
    MSG_LAUNCH DB "PRESS SPACEBAR TO LAUNCH", '$'
    MSG_START BYTE " START GAME",'$'
    MSG_INST BYTE "INSTRUCTIONS",'$'
    MSG_HSCORE BYTE " HIGH SCORE",'$'
    MSG_EXIT BYTE "    EXIT",'$'

    INSTRUCTIONS BYTE "Welcome to Brick Breaker game.",'$'
    INSTRUCTION1 BYTE "You have to break all the Bricks",'$'
    INSTRUCTION2 BYTE "without the ball hitting spikes.",'$'
    INSTRUCTION3 BYTE "You have 3 lives.",'$'
    INSTRUCTION4 BYTE "The game difficulty increases with", '$'
    INSTRUCTION5 BYTE "each level. Use navigation KEYS to",'$'
    INSTRUCTION6 BYTE "move the board. press space to PLAY",'$'
    INSTRUCTION7 BYTE " or pause the game.", '$'
    INSTRUCTION8 BYTE "Have FUN ", 3, '$'

    ; <--- OUTER BORDER --->
    X_MIN DW 50
    Y_MIN DW 5
    X_MAX DW 300
    Y_MAX DW 180
    
    ; <--- BALL DATA --->
    C_X DW 0
    C_Y DW 0
    X_DIR DB 0
    Y_DIR DB 0
    B_SPEED DW 2
    TP DW 0

    ; <--- BLOCKS DATA --->
    NO_BLOCKS DW 0
    X_CORDS DW 50, 103, 156, 209, 262,
               50, 103, 156, 209, 262,
               50, 103, 156, 209, 262

    Y_CORDS DW  5, 5,  5,  5,  5,
               15, 15,  15,  15,  15,
               25, 25,  25,  25,  25

    B_COLOR DB  1,  2,   3,   4,   5,
                7,  8,   9,   10,  11, 
                13, 14,  15,  1,   2

    B_POINT DB  1,   1,   1,  1,   1,
                1,   1,   1,  1,   1,
                1,   1,   1,  1,   1

    B_HITS  DB  1,   1,   1,  1,   1,
                1,   1,   1,  1,   1,
                1,   1,   1,  1,   1

    ; <--- SLIDER DATA --->
    S_POS DW 130
    S_LEN DW 50
    S_SPEED DW 2

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

    ; <--- GAME STATUS --->
    PLAY DB 0
    ; <--- HELPING DATA --->
    BOOL DB 0
    IS_MENU DB 1
    COL BYTE 0
    CURR_OPT WORD 25

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

; DRAW HOLLOW BOX
DRHBX MACRO X, Y, L, H, C
    MOV _X, X
    MOV _Y, Y
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    MOV COLOR, C
    CALL DRAWHBOX
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

; DRAW TRAINGLE
DRTR MACRO X, Y, H, C
    MOV _X, X
    MOV _Y, Y
    MOV TMP_LEN, 0
    MOV TMP_HIG, H
    MOV AX, TMP_HIG
    MOV BL, 2
    DIV BL
    MOV AH, 0
    ADD _X, AX
    MOV COLOR, C
    CALL DRAWTRIANGLE
ENDM

; DRAW BLOCK
DRBLK MACRO X, Y, L, H, C
    PUSH X
    PUSH Y
    MOV _X, X
    MOV _Y, Y
    ADD _X, 2
    ADD _Y, 2
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    SUB TMP_LEN, 4
    SUB TMP_HIG, 4
    MOV COLOR, C
    CALL DRAWBOX
    POP Y
    POP X
    MOV _X, X
    MOV _Y, Y
    INC _X
    INC _Y
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    SUB TMP_LEN, 2
    SUB TMP_HIG, 2
    MOV COLOR, BLACK
    CALL DRAWHBOX
    
ENDM

; MOVE CURR_OPTSOR
MVCR MACRO X, Y
MOV AH, 02H
MOV BX, 0
MOV DL, X ;Column Number
MOV DH, Y ;Row Number
INT 10H
ENDM

TXTBG MACRO
    DRBX 105, 25, 105, 15, BLACK 
    DRBX 105, 50, 105, 15, BLACK
    DRBX 105, 75, 105, 15, BLACK
    DRBX 105, 100, 105, 15, BLACK
ENDM
;<----- END MACROS ----->

.CODE
MOV AX, @DATA
MOV DS, AX

MAIN PROC
    MOV AH, 00H		; SET VIDEO MODE
    MOV AL, 13H		; CHOOSE MODE 13
    INT 10H         ; GRAPHICS INTERRUPT

    ; BACKGROUND
    MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BROWN
    INT 10h
    ; INNER AREA
    DRBX 10, 10, 300, 180, MAGINTA
    TXTBG

    START_HERE:
    .IF IS_MENU == 0
        DRBX 10, 10, 300, 180, MAGINTA
        TXTBG
        MOV IS_MENU, 1
    .ENDIF

    MOV AX, CURR_OPT
    ADD AX, 2
    DRCR 90, AX, GREEN

    MENU_LABEL:
    MOV AX, CURR_OPT
    DRBX 105, AX, 105, 15, BLACK       ;1ST-25,2ND-50
    
    MVCR 150, 80
    lea dx, MSG_START
    mov ah, 09h
    int 21h

    MVCR 150, 83
    lea dx, MSG_INST
    mov ah,09h
    int 21h

    MVCR 150, 86
    lea dx,MSG_HSCORE
    mov ah,09h
    int 21h

    MVCR 150, 89
    lea dx,MSG_EXIT
    mov ah,09h
    int 21h
    
    mov ah, 01h
	int 16h
    JZ MENU_LABEL

    MOV AX, CURR_OPT
    DRCR 90, AX, MAGINTA

    MOV AH,00H
    INT 16H

    CMP AH,48h
    JE UPP
    CMP AH,50h
    JE DOWNN

    CMP AL,13
    JE ENTERR

    JMP START_HERE
    UPP:

    CMP CURR_OPT,25
    JE LAST
    MOV AX,CURR_OPT
    SUB AX,25
    MOV CURR_OPT,AX
    JMP START_HERE

    LAST:
    MOV CURR_OPT,100
    JMP START_HERE

    DOWNN:

    CMP CURR_OPT,100
    JE FIRST
    MOV AX,CURR_OPT
    ADD AX,25
    MOV CURR_OPT,AX
    JMP START_HERE

    FIRST:
    MOV CURR_OPT,25
    JMP START_HERE

    ENTERR:
    CMP CURR_OPT,25
    JE STARTGAME
    CMP CURR_OPT,50
    JE INSTRUCTIONSS

    CMP CURR_OPT,100
    JE EXIT

    INSTRUCTIONSS:
    MOV IS_MENU, 0
    DRBX 10, 10, 300, 180, MAGINTA
    MVCR 5, 3
    lea dx, INSTRUCTIONS
    mov ah,09h
    int 21h
    MVCR 3, 6
    lea dx,INSTRUCTION1
    mov ah,09h
    int 21h
    MVCR 3, 8
    lea dx,INSTRUCTION2
    mov ah,09h
    int 21h
    MVCR 3, 10
    lea dx,INSTRUCTION3
    mov ah,09h
    int 21h
    MVCR 3, 12
    lea dx,INSTRUCTION4
    mov ah,09h
    int 21h
    MVCR 3, 14
    lea dx,INSTRUCTION5
    mov ah,09h
    int 21h
    MVCR 3, 16
    lea dx,INSTRUCTION6
    mov ah,09h
    int 21h
    MVCR 3, 18
    lea dx,INSTRUCTION7
    mov ah,09h
    int 21h
    MVCR 15, 22
    lea dx,INSTRUCTION8
    mov ah,09h
    int 21h

    INPUT_INST:
    mov ah, 01h
	int 16h
    JZ INPUT_INST
    MOV AH, 00H
    INT 16H
    CMP AL, 08
    JE START_HERE
    JNE INSTRUCTIONSS

    STARTGAME:
    MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BROWN
    INT 10h

    DRBX 50, 5, 265, 185, LGRAY
    DRBX 50, 191, 265, 7, LGRAY
    MOV BX, 50
    LOOP_SPIKE:
    PUSH BX
        DRTR BX, 192, 8, DGRAY
        POP BX
        ADD BX, 10
        CMP BX, 310
        JBE LOOP_SPIKE


    CALL DRAWBLOCKS

    MOV DX, 0
    MOV AH, 02h
    MOV BX, 0
    MOV DL, 11
    MOV DH, 15
    INT 10H

    ;STRING
    LEA DX, MSG_LAUNCH
    MOV AH, 09H
    INT 21H

    MOV TIME_TRACK, 0
    MOV C_X, 150
    MOV C_Y, 175
    LOOPER:
        MOV BX, C_X
        MOV DX, C_Y
        DRCR BX, DX, BLUE

        MOV AH, 2CH
        INT 21H
        CMP TIME_TRACK, DL
        JE SKIP_BALL
            MOV TIME_TRACK, DL
            .IF PLAY == 1
                CALL MOVE_BALL
            .ENDIF
        SKIP_BALL:
        MOV BX, C_X
        MOV DX, C_Y
        DRCR BX, DX, BLUE

        MOV BX, S_POS
        DRBX BX, 185, 50, 5, GREEN

        MOV AH, 1 ; INTRUPT FOR KEYBOARD INPUT
        INT 16H
        JZ LOOPER
        MOV BX, S_POS
        MOV AH, 0
        INT 16H
        .IF PLAY == 0
            CMP AL, 32
            JNE LOOPER
            MOV PLAY, 1
            DRBX 85, 120 , 195, 10, LGRAY
        .ENDIF
        .IF AH == 4DH ; SCAN CODE RIGHT
            ADD BX, 40
            .IF BX < X_MAX
                MOV BX, S_POS
                MOV CX, S_SPEED
                DEC CX
                DRBX BX, 185, CX, 5, LGRAY

                MOV BX, S_SPEED
                ADD S_POS, BX
            .ENDIF
        .ELSEIF AH == 4BH ; SCAN CODE LEFT
            .IF BX > X_MIN
                MOV BX, S_POS
                ADD BX, S_LEN
                MOV CX, S_SPEED
                DEC CX
                DEC BX
                DRBX BX, 185, CX, 5, LGRAY

                MOV BX, S_SPEED
                SUB S_POS, BX
            .ENDIF
        .ENDIF
    JMP LOOPER

MAIN ENDP
JMP EXIT

; <----- Functions ----->

; TO MOVE THE BALL IN THE PLAY AREA
MOVE_BALL PROC
    CALL CHECKCOLLISION

    MOV BX, C_X
    MOV DX, C_Y
    DRCR BX, DX, LGRAY
    
    .IF X_DIR == 0
        MOV BX, C_X
        .IF BX < X_MAX
            MOV BX, B_SPEED
            ADD C_X, BX
        .ELSE
            MOV X_DIR, 1
        .ENDIF
    .ELSE
        MOV BX, C_X
        .IF BX > X_MIN
            MOV BX, B_SPEED
            SUB C_X, BX
        .ELSE
            MOV X_DIR, 0
        .ENDIF
    .ENDIF

    .IF Y_DIR == 0
        MOV BX, C_Y
        .IF BX >= Y_MAX
            MOV Y_DIR, 1
        .ELSEIF BX >= 175
            MOV BX, S_POS
            .IF C_X >= BX
                ADD BX, 50
                .IF C_X < BX
                    MOV Y_DIR, 1
                .ELSE
                    JMP MOVEL
                .ENDIF
            .ELSE
                JMP MOVEL
            .ENDIF
        .ELSE
            MOVEL:
            MOV BX, B_SPEED
            ADD C_Y, BX
            RET
        .ENDIF
    .ENDIF

     MOV BX, C_Y
    .IF BX > Y_MIN
        MOV BX, B_SPEED
        SUB C_Y, BX
    .ELSE
        MOV Y_DIR, 0
    .ENDIF
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

; TO DRAW A HOLLOW BOX
DRAWHBOX PROC
MOV CX, _X
    MOV T_X, CX
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_W:
        MOV AH, 0CH ; 
        MOV AL, COLOR ;COLOUR
        MOV CX, T_X ; INCREMENTS X AXIS ; CX IS X-AXIS
        MOV DX, T_Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        INC T_X
        MOV CX, TMP_LEN
        ADD CX, _X
        CMP T_X, CX
    JBE LOOP_W

    MOV CX, _X
    MOV T_X, CX
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_X:
        MOV AH, 0CH ; 
        MOV AL, COLOR ;COLOUR
        MOV CX, T_X ; INCREMENTS X AXIS ; CX IS X-AXIS
        MOV DX, T_Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        INC T_Y
        MOV CX, TMP_HIG
        ADD CX, _Y
        CMP T_Y, CX
    JBE LOOP_X


    MOV CX, _X
    MOV T_X, CX
    MOV CX, _Y
    ADD CX, TMP_HIG
    MOV T_Y, CX
    LOOP_Y:
        MOV AH, 0CH ; 
        MOV AL, COLOR ;COLOUR
        MOV CX, T_X ; INCREMENTS X AXIS ; CX IS X-AXIS
        MOV DX, T_Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        INC T_X
        MOV CX, TMP_LEN
        ADD CX, _X
        CMP T_X, CX
    JBE LOOP_Y

    MOV CX, _X
    ADD CX, TMP_LEN
    MOV T_X, CX
    MOV CX, _Y
    MOV T_Y, CX
    LOOP_Z:
        MOV AH, 0CH ; 
        MOV AL, COLOR ;COLOUR
        MOV CX, T_X ; INCREMENTS X AXIS ; CX IS X-AXIS
        MOV DX, T_Y ; DX IS Y-AXIS
        INT 10H ; INTERRUP FOR GRAPHICS
        INC T_Y
        MOV CX, TMP_HIG
        ADD CX, _Y
        CMP T_Y, CX
    JBE LOOP_Z

    RET
DRAWHBOX ENDP

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

; TO DRAW A TRIANGLE
DRAWTRIANGLE PROC
    MOV BOOL, 0
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
        .IF BOOL == 0
            ADD TMP_LEN, 2
            DEC _X
            MOV BOOL, 1
        .ELSE
            MOV BOOL, 0
        .ENDIF
        INC T_Y
        MOV CX, TMP_HIG
        ADD CX, _Y
        CMP T_Y, CX
    JBE LOOP_H
    RET
DRAWTRIANGLE ENDP

; DRAW BLOCKS
DRAWBLOCKS PROC
    MOV SI, 0
    MOV DI, 0
    MOV NO_BLOCKS, 0
    DRBX 50, 5, 265, 35, LGRAY
    LOOP_B:
        MOV AX, [X_CORDS + SI]
        MOV BX, [Y_CORDS + SI]
        MOV CL, [B_COLOR + DI]
        .IF [B_HITS + DI] != 0
            DRBLK AX, BX, 53, 10, CL
        .ENDIF
        ADD SI, 2
        INC DI
        INC NO_BLOCKS
        CMP NO_BLOCKS, 15
        JB LOOP_B
    RET
DRAWBLOCKS ENDP

CHECKCOLLISION PROC
    MOV CX, C_X
    MOV DX, C_Y
    .IF Y_DIR == 1
        MOV SI, 0
        MOV DI, 0
        .WHILE SI < SIZEOF Y_CORDS
            MOV AX, [Y_CORDS + SI]
            MOV BX, [X_CORDS + SI]
            ADD AX, 10
            ADD BX, 50
            .IF DX <= AX && CX <= BX && [B_HITS + DI] != 0
                MOV AX, 0
                MOV Y_DIR, 0
                DEC [B_HITS + DI]
                CALL DRAWBLOCKS
                RET
            .ENDIF
            ADD SI, 2
            INC DI
        .ENDW
    .ENDIF
    RET
CHECKCOLLISION ENDP
; <----- End Functions ----->

EXIT:
MOV AH, 00H		;SET VIDEO MODE
MOV AL, 03H		;CHOOSE MODE 13
INT 10H

MOV AH, 4CH
INT 21H
END