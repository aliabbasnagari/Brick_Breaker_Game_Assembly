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

    MSG_PLAY DB "PLAY", '$'
    MSG_PAUSE DB "PAUSE", '$'
    MSG_GAMEOVER DB "GAME OVER", '$'
    MSG_LEVEL DB "LEVEL", '$' 
    MSG_LIVES DB "LIVES", '$'
    MSG_NAME DB "NAME", '$'
    MSG_SCORE DB "SCORE", '$'
    MSG_LOADING DB "LOADING LEVEL DATA...", '$'

    INSTRUCTIONS BYTE "Welcome to Brick Breaker game.",'$'
    INSTRUCTION1 BYTE "You have to break all the Bricks",'$'
    INSTRUCTION2 BYTE "without the ball hitting spikes.",'$'
    INSTRUCTION3 BYTE "You have 3 lives.",'$'
    INSTRUCTION4 BYTE "The game difficulty increases with", '$'
    INSTRUCTION5 BYTE "each level. Use navigation KEYS to",'$'
    INSTRUCTION6 BYTE "move the board. press space to PLAY",'$'
    INSTRUCTION7 BYTE " or pause the game.", '$'
    INSTRUCTION8 BYTE "Have FUN ", 3, '$'
    ; <--- END MESSAGES --->

    ; <--- OUTER BORDER --->
    X_MIN DW 60
    Y_MIN DW 5
    X_MAX DW 315
    Y_MAX DW 190
    
    ; <--- BALL DATA --->
    C_X DW 0
    C_Y DW 0
    X_DIR DB 0
    Y_DIR DB 0
    B_SPEED DW 3
    TP DW 0

    ; <--- BLOCKS DATA --->
    NO_BLOCKS DW 10
    REM_BLOCKS DB 10
    B_LEN DW 51
    B_HIG DW 15
    X_CORDS DW 060, 111, 162, 213, 264,
               060, 111, 162, 213, 264,
               060, 111, 162, 213, 264,
               060, 111, 162, 213, 264,

    Y_CORDS DW  005, 005, 005, 005, 005,
                020, 020, 020, 020, 020,
                035, 035, 035, 035, 035,
                050, 050, 050, 050, 050,

    B_COLOR DB  001, 002, 003, 004, 005,
                006, 007, 008, 009, 001, 
                002, 003, 006, 005, 004,
                009, 008, 007, 006, 005,

    B_HITS  DB  1,  1,  1,  1,  1,
                1,  1,  1,  1,  1,
                0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,

    IS_SPECIAL DB 1
    NO_FIXED DB 0

    ; <--- SLIDER DATA --->
    S_POS DW 130
    S_LEN DW 51
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
    GAMEOVER DB 0

    ; <--- LEVEL DATA --->
    LEVEL DB 1

    ;<--- PLAYER DATA --->
    PLAYER_NAME DB ?
    SCORE DW ?
    LIVES DB 3

    ;<--- SOUND DATA --->
    FREQ DW 7239
    DUR DB 0
    ISBEEP DB 0
    BEEPTIMER DB 0

    ;<--- COLLISION DATA --->
    X1_COLL DB 0
    X2_COLL DB 0
    Y1_COLL DB 0
    Y2_COLL DB 0

    ; <--- HELPING DATA --->
    RAND DB 0
    BOOL DB 0
    IS_MENU DB 1
    COL BYTE 0
    CURR_OPT WORD 25
    NO_DIG DB 0
    REM DB 0
    QUO DB 0

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
    PUSH DX
    CALL DRAWBOX
    POP DX
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

; DRAW BLOCK
DRSBLK MACRO X, Y, L, H, C
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
    CALL DRAWHBOX
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

; TEXT BACKGROUND
TXTBG MACRO
    DRBX 105, 25, 105, 15, BLACK 
    DRBX 105, 50, 105, 15, BLACK
    DRBX 105, 75, 105, 15, BLACK
    DRBX 105, 100, 105, 15, BLACK
ENDM

; BEEP SOUND
BEEP MACRO F, D
    MOV FREQ, F
    MOV DUR, D
    CALL PLAY_BEEP
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

    JMP_MENU:
    ; INNER AREA
    DRBX 5, 5, 310, 190, MAGINTA
    TXTBG
    START_MENU:
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
    DRBX 105, AX, 105, 15, BLACK    ;1ST-25,2ND-50
    
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
    LEA DX, MSG_EXIT
    MOV AH, 09h
    INT 21h
    
    mov ah, 01h
	int 16h
    JZ MENU_LABEL

    MOV AX, CURR_OPT
    ADD AX, 2
    DRCR 90, AX, MAGINTA

    MOV AH,00H
    INT 16H

    CMP AH,48h
    JE UPP
    CMP AH,50h
    JE DOWNN

    CMP AL,13
    JE ENTERR

    JMP START_MENU
    UPP:

    CMP CURR_OPT,25
    JE LAST
    MOV AX,CURR_OPT
    SUB AX,25
    MOV CURR_OPT,AX
    JMP START_MENU

    LAST:
    MOV CURR_OPT,100
    JMP START_MENU

    DOWNN:

    CMP CURR_OPT,100
    JE FIRST
    MOV AX,CURR_OPT
    ADD AX,25
    MOV CURR_OPT,AX
    JMP START_MENU

    FIRST:
    MOV CURR_OPT,25
    JMP START_MENU

    ENTERR:
    CMP CURR_OPT,25
    JE START_GAME
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
    JE START_MENU
    JNE INSTRUCTIONSS

    START_GAME:
    MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BROWN
    INT 10h

    DRBX 60, 5, 255, 185, LGRAY
    DRBX 60, 191, 255, 7, LGRAY
    MOV BX, 60
    LOOP_SPIKE:
        PUSH BX
        DRTR BX, 192, 8, DGRAY
        POP BX
        ADD BX, 10
        CMP BX, 310
        JBE LOOP_SPIKE

    CALL DRAWBLOCKS
    DRBX 5, 5, 50, 190, BLACK

    MVCR 11, 15
    ;STRING
    LEA DX, MSG_LAUNCH
    MOV AH, 09H
    INT 21H

    MOV C_X, 150
    MOV C_Y, 175
    MOV TIME_TRACK, 0
    LOOPER:
        .IF LIVES == 0
            MOV PLAY, 0
            MOV GAMEOVER, 1
            MVCR 11, 15
        .ENDIF

        .IF REM_BLOCKS == 0
            CALL SET_LEVEL
        .ENDIF

        MOV BX, C_X
        MOV DX, C_Y
        DRCR BX, DX, BLUE

        CALL PRINT_DATA

        MOV AH, 2CH
        INT 21H
        CMP TIME_TRACK, DL
        JE SKIP_BALL
            MOV TIME_TRACK, DL
            .IF PLAY == 1
                CALL MOVE_BALL
            .ENDIF
            .IF ISBEEP == 1
                INC BEEPTIMER
                MOV DL, DUR
                .IF BEEPTIMER == DL
                    CALL STOP_BEEP
                .ENDIF
            .ENDIF
        SKIP_BALL:
        MOV BX, C_X
        MOV DX, C_Y
        DRCR BX, DX, BLUE

        MOV BX, S_POS
        MOV CX, S_LEN
        DRBX BX, 185, CX, 5, GREEN

        MOV AH, 1 ; INTRUPT FOR KEYBOARD INPUT
        INT 16H
        JZ LOOPER
        MOV AH, 0
        INT 16H
        .IF AL == 8
            MOV PLAY, 0
            MOV IS_MENU, 1
            JMP JMP_MENU
        .ENDIF
        .IF PLAY == 0 && GAMEOVER == 0
            CMP AL, 32
            JNE LOOPER
            MOV PLAY, 1
            DRBX 85, 120 , 195, 10, LGRAY
        .ELSEIF GAMEOVER == 1
            .IF AL == 82 || AL == 114
                MOV PLAY, 1
                MOV LIVES, 3
                MOV GAMEOVER, 0
                DRBX 85, 120 , 195, 10, LGRAY
            .ELSE
                JMP LOOPER
            .ENDIF
        .ENDIF
        MOV BX, S_POS
        .IF AH == 4DH ; SCAN CODE RIGHT
            ADD BX, S_LEN
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
    MOV BX, C_X
    MOV DX, C_Y
    DRCR BX, DX, LGRAY
    MOV FREQ, 1715
    .IF X_DIR == 0
        MOV CX, B_SPEED
        LOOP_X1:
            CALL CHECKCOLLISION
            MOV BX, C_X
            ADD BX, 10
            .IF BX < X_MAX && X1_COLL == 0
                INC C_X
            .ELSE
                MOV BX, FREQ
                BEEP BX, 3
                MOV X_DIR, 1
                JMP SKIPBX
            .ENDIF
        LOOP LOOP_X1
    .ELSE
        MOV CX, B_SPEED
        LOOP_X2:
            CALL CHECKCOLLISION 
            MOV BX, C_X
            .IF BX > X_MIN && X2_COLL == 0
                DEC C_X
            .ELSE
                MOV BX, FREQ
                BEEP BX, 3
                MOV X_DIR, 0
                JMP SKIPBX
            .ENDIF
        LOOP LOOP_X2
    .ENDIF
    SKIPBX:
    MOV FREQ, 1715
    .IF Y_DIR == 0
        MOV CX, B_SPEED
        LOOP_Y1:
            CALL CHECKCOLLISION
            MOV BX, C_Y
            ADD BX, 9
            .IF BX >= Y_MAX
                CALL HIT_SPIKES
                MOV Y_DIR, 1
                JMP SKIPBY
            .ELSEIF BX >= 184
                MOV BX, S_POS
                SUB BX, 8
                .IF C_X >= BX
                    ADD BX, 8
                    ADD BX, S_LEN
                    .IF C_X < BX
                        MOV BX, FREQ
                        BEEP BX, 3
                        MOV Y_DIR, 1
                        JMP SKIPBY
                    .ELSE
                        JMP MOVY
                    .ENDIF
                .ELSE
                    JMP MOVY
                .ENDIF
            .ELSE
                MOVY:
                .IF Y1_COLL == 0
                    INC C_Y
                .ENDIF
            .ENDIF
        LOOP LOOP_Y1
    .ELSE
        MOV CX, B_SPEED
        LOOP_Y2:
            CALL CHECKCOLLISION
            MOV BX, C_Y
            .IF BX > Y_MIN && Y2_COLL == 0
                DEC C_Y
            .ELSE
                MOV BX, FREQ
                BEEP BX, 3
                MOV Y_DIR, 0
                JMP SKIPBY
            .ENDIF
        LOOP LOOP_Y2
    .ENDIF
    SKIPBY:
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
    MOV CX, LENGTHOF X_CORDS
    LOOP_B:
        PUSH CX
        MOV AX, [X_CORDS + SI]
        MOV BX, [Y_CORDS + SI]
        MOV CL, [B_COLOR + DI]
        .IF [B_HITS + DI] != 0
            DRBLK AX, BX, 51, 15, CL
        .ENDIF
        ADD SI, 2
        INC DI
        POP CX
    LOOP LOOP_B
    RET
DRAWBLOCKS ENDP

; TO DRAW SLIDER
DRAWSLIDER PROC
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
DRAWSLIDER ENDP

CHECKCOLLISION PROC USES CX
    MOV X1_COLL, 0
    MOV X2_COLL, 0
    MOV Y1_COLL, 0
    MOV Y2_COLL, 0
    MOV SI, 0
    MOV DI, 0
    .WHILE SI < SIZEOF X_CORDS
        .IF [B_HITS + DI] != 0
            MOV DX, C_Y
            MOV BX, [Y_CORDS + SI]
            ADD BX, 15
            ADD DX, 10
            .IF DX >= [Y_CORDS + SI] && C_Y <= BX
                MOV CX, C_X
                MOV AX, [X_CORDS + SI]
                ADD AX, 51
                ADD CX, 8
                .IF DX == [Y_CORDS + SI] && CX > [X_CORDS + SI]  && CX < AX
                    DEC C_Y
                    MOV FREQ, 4063
                    MOV Y_DIR, 1
                    MOV Y1_COLL, 1
                    DEC [B_HITS + DI]
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                   .IF BL != 50
                        ADD SCORE, BX
                        DEC [B_COLOR + DI]
                   .ENDIF
                    .IF [B_HITS + DI] == 0
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        DRBX AX, BX, 51, 15, LGRAY
                        DEC REM_BLOCKS
                    .ELSE
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        MOV DL, [B_COLOR + DI]
                        DRBLK AX, BX, 51, 15, DL
                    .ENDIF
                    RET
                .ENDIF
                ADD AX, 8
                MOV DX, C_Y
                MOV BX, [Y_CORDS + SI]
                ADD BX, 15
                .IF DX == BX && CX > [X_CORDS + SI]  && CX < AX
                    INC C_Y
                    MOV FREQ, 4063
                    MOV Y_DIR, 0
                    MOV Y2_COLL, 1
                    DEC [B_HITS + DI]
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                    .IF BL != 50
                        ADD SCORE, BX
                        DEC [B_COLOR + DI]
                   .ENDIF
                    .IF [B_HITS + DI] == 0
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        DRBX AX, BX, 51, 15, LGRAY
                        DEC REM_BLOCKS
                    .ELSE
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        MOV DL, [B_COLOR + DI]
                        DRBLK AX, BX, 51, 15, DL
                    .ENDIF
                    RET
                .ENDIF
                MOV CX, C_X
                ADD CX, 10 
                .IF CX == [X_CORDS + SI]
                    DEC C_X
                    MOV FREQ, 4063
                    MOV X_DIR, 1
                    MOV X1_COLL, 1
                    DEC [B_HITS + DI]
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                    .IF BL != 50
                        ADD SCORE, BX
                        DEC [B_COLOR + DI]
                   .ENDIF
                    .IF [B_HITS + DI] == 0
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        DRBX AX, BX, 51, 15, LGRAY
                        DEC REM_BLOCKS
                    .ELSE
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        MOV DL, [B_COLOR + DI]
                        DRBLK AX, BX, 51, 15, DL
                    .ENDIF
                    RET
                .ENDIF
                MOV AX, [X_CORDS + SI]
                ADD AX, 51
                .IF AX == C_X
                    INC C_X
                    MOV FREQ, 4063
                    MOV X_DIR, 0
                    MOV X2_COLL, 1
                    DEC [B_HITS + DI]
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                    .IF BL != 50
                        ADD SCORE, BX
                        DEC [B_COLOR + DI]
                   .ENDIF
                    .IF [B_HITS + DI] == 0
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        DRBX AX, BX, 51, 15, LGRAY
                        DEC REM_BLOCKS
                    .ELSE
                        MOV AX, [X_CORDS + SI]
                        MOV BX, [Y_CORDS + SI]
                        MOV DL, [B_COLOR + DI]
                        DRBLK AX, BX, 51, 15, DL
                    .ENDIF
                    RET
                .ENDIF
            .ENDIF
        .ENDIF
        ADD SI, 2
        INC DI
    .ENDW
    RET
CHECKCOLLISION ENDP

; PRINT GAME STATES
PRINT_DATA PROC
    MVCR 1, 1
    LEA DX, MSG_LEVEL
    MOV AH, 09H
    INT 21H

    MVCR 3, 2
    MOV AH, 09
    MOV AL, LEVEL
    ADD AL, 48
    MOV BL, YELLOW
    MOV CX, 1
    MOV BH, 0
    INT 10H

    MVCR 1, 4
    LEA DX, MSG_LIVES
    MOV AH, 09H
    INT 21H

    MVCR 2, 5
    MOV CX, 0
    MOV AH, 09
    MOV AL, 3
    MOV BL, RED
    MOV CL, LIVES
    MOV BH, 0
    INT 10H

    MVCR 1, 7
    LEA DX, MSG_SCORE
    MOV AH, 09H
    INT 21H

    MVCR 2, 8
    MOV AX, SCORE
    CALL PRINT_NUM

    RET
PRINT_DATA ENDP

; PRINT NUMBER OF MULTIPLE DIGITS
PRINT_NUM PROC
    MOV NO_DIG, 0
    MOV BX, AX
    LOOP_D:
        MOV AX, BX
        MOV BL, 10
        DIV BL
        MOV REM, AH
        MOV QUO, AL
        INC NO_DIG
        
        MOV AH, 0
        MOV BX, AX

        MOV AX, 0
        MOV AL, REM
        PUSH AX

        CMP QUO, 0
        JNE LOOP_D
    
    MOV CX, 0
    MOV CL, NO_DIG
    LOOP1:
        POP BX
        MOV AH, 02H
        MOV DL, BL
        ADD DL, 48
        INT 21h
    LOOP LOOP1
    RET
PRINT_NUM ENDP

; IF HIT SPIKES AT BOTTOM
HIT_SPIKES PROC
    DEC LIVES
    BEEP 6833, 5
    .IF LIVES != 0
        MVCR 11, 15
        LEA DX, MSG_LAUNCH
        MOV AH, 09H
        INT 21H
        MOV CX, S_POS
        ADD CX, 20
        MOV C_X, CX
        MOV C_Y, 175
    .ELSE
        MVCR 17, 15
        LEA DX, MSG_GAMEOVER
        MOV AH, 09H
        INT 21H
        MOV AX, S_POS
        DRBX AX, 185, 51, 5, LGRAY
        MOV S_POS, 130
        MOV C_X, 150
        MOV C_Y, 175
    .ENDIF
    MOV PLAY, 0
    DRBX 5, 5, 50, 70, BLACK
    CALL PRINT_DATA
    RET
HIT_SPIKES ENDP

; TO PRODUCE SOUNDS
PLAY_BEEP PROC
    PUSH AX
    MOV BEEPTIMER, 0
    MOV ISBEEP, 1
    MOV AL, 182
    OUT 43h, AL
    MOV AX, FREQ
    OUT 42h, AL
    MOV AL, AH
    OUT 42h, AL 
    IN  AL, 61h
    OR  AL, 3H
    OUT 61h, AL
    POP AX
    RET
PLAY_BEEP ENDP

; TO STOP SOUND
STOP_BEEP PROC
    PUSH AX
    MOV ISBEEP, 0
    IN AL, 61h
    AND AL, 0FCh 
    OUT 61h, AL
    POP AX
    RET
STOP_BEEP ENDP

SET_LEVEL PROC
    MOV PLAY, 0
    INC LEVEL
    ADD B_SPEED, 1
    SUB S_LEN, 6
    MVCR 11, 15
    LEA DX, MSG_LOADING
    MOV AH, 09H
    INT 21H
    ADD NO_BLOCKS, 5
    MOV AX, NO_BLOCKS
    MOV REM_BLOCKS, AL
    MOV AX, C_X
    MOV BX, C_Y
    DRCR AX, BX, LGRAY
    MOV C_X, 150
    MOV C_Y, 175
    MOV SI, 0
    MOV CX, 0
    MOV CL, REM_BLOCKS
    LOOPBLK:
    PUSH CX
        CALL GET_RAND
        MOV DL, RAND
        .IF DL == 10 || DL == 11 || DL == 12 && LEVEL == 3
            MOV IS_SPECIAL, 1
            MOV DH, 10
            MOV [B_COLOR + SI], 50
            MOV [B_HITS + SI], DH
            INC NO_FIXED
        .ELSEIF
            MOV DH, LEVEL
            MOV [B_COLOR + SI], DL
            MOV [B_HITS + SI], DH
        .ENDIF
        INC SI
    POP CX
    LOOP LOOPBLK
    MVCR 11, 15
    LEA DX, MSG_LAUNCH
    MOV AH, 09H
    INT 21H
    CALL DRAWBLOCKS
    RET
SET_LEVEL ENDP

GET_RAND PROC
    RANDOM:
    MOV AH, 2CH
    INT 21H
    CMP DL, RAND
    JE RANDOM
    MOV RAND, DL
    .IF RAND > 12 || RAND < 2
        JMP RANDOM
    .ENDIF
    RET
GET_RAND ENDP

; <----- End Functions ----->

EXIT:
MOV AH, 00H		;SET VIDEO MODE
MOV AL, 03H		;CHOOSE MODE 13
INT 10H

MOV AH, 4CH
INT 21H
END