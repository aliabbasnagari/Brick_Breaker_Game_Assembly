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

    ; <--- MESSAGES --->
    MSG_LAUNCH DB "PRESS SPACEBAR TO LAUNCH", '$'
    MSG_START BYTE " START GAME",'$'
    MSG_CONTINUE BYTE " CONTINUE",'$'
    MSG_INST BYTE "INSTRUCTIONS",'$'
    MSG_HSCORE BYTE " HIGH SCORE",'$'
    MSG_EXIT BYTE "    EXIT",'$'

    MSG_PLAY DB "PLAY", '$'
    MSG_PAUSE DB "PAUSE", '$'
    MSG_GAMEOVER DB "GAME OVER", '$'
    MSG_GOTOMENU DB "Press back to goto Main Menu.", '$'
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
    X_CORDS DW 060, 111, 162, 213, 264,
               060, 111, 162, 213, 264,
               060, 111, 162, 213, 264,
               060, 111, 162, 213, 264,

    Y_CORDS DW  005, 005, 005, 005, 005,
                020, 020, 020, 020, 020,
                035, 035, 035, 035, 035,
                050, 050, 050, 050, 050,

    B_COLOR DB  002, 003, 004, 005, 006,
                007, 008, 009, 010, 002, 
                002, 003, 006, 005, 004,
                009, 008, 007, 006, 005,

    B_HITS  DB  1,  1,  1,  1,  1,
                1,  1,  1,  1,  1,
                0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,

    RANDOMIZER DB 3, 8, 10, 13, 15, 16, 22, 24

    IS_SPECIAL DB 0
    NO_FIXED DB 0

    ; <--- SLIDER DATA --->
    S_POS DW 130
    S_LEN DW 51
    S_SPEED DW 5

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

    ; <--- FILE DATA--->
    FILENAMEE BYTE "BBSCORES.TXT", 0
    MSGG_1 BYTE "ENTER YOUR NAME : ",'$'
    NAMEE  BYTE 25 DUP(0),'$'
    BUFFER BYTE 200 DUP(0),'$'
    HANDLE DW 0
    QUOO BYTE  0
    REMM BYTE  0
    NO_DIGG BYTE  0

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
DRSBLK MACRO X, Y, L, H
    PUSH X
    PUSH Y
    MOV _X, X
    MOV _Y, Y
    ADD _X, 6
    ADD _Y, 6
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    SUB TMP_LEN, 12
    SUB TMP_HIG, 12
    MOV COLOR, RED
    CALL DRAWBOX
    POP Y
    POP X
    PUSH X
    PUSH Y
    MOV _X, X
    MOV _Y, Y
    ADD _X, 5
    ADD _Y, 5
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    SUB TMP_LEN, 10
    SUB TMP_HIG, 10
    MOV COLOR, 2
    CALL DRAWHBOX
    POP Y
    POP X
    PUSH X
    PUSH Y
    MOV _X, X
    MOV _Y, Y
    ADD _X, 4
    ADD _Y, 4
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    SUB TMP_LEN, 8
    SUB TMP_HIG, 8
    MOV COLOR, 3
    CALL DRAWHBOX
    POP Y
    POP X
    PUSH X
    PUSH Y
    MOV _X, X
    MOV _Y, Y
    ADD _X, 3
    ADD _Y, 3
    MOV TMP_LEN, L
    MOV TMP_HIG, H
    SUB TMP_LEN, 6
    SUB TMP_HIG, 6
    MOV COLOR, 5
    CALL DRAWHBOX
    POP Y
    POP X
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
    MOV COLOR, YELLOW
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
    DRBX 105, 125, 105, 15, BLACK
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

    NAME_INPUT:
        MOV AH, 06H ; BACKGROUND
        MOV AL, 0
        MOV CX, 0
        MOV DH, 80
        MOV DL, 80
        MOV BH, BROWN
        INT 10h
        DRBX 5, 5, 310, 190, MAGINTA ; INNER AREA
        CALL NAMEINPUT

    JMP_MENU:
        MOV AH, 06H ; BACKGROUND
        MOV AL, 0
        MOV CX, 0
        MOV DH, 80
        MOV DL, 80
        MOV BH, BROWN
        INT 10h
        DRBX 5, 5, 310, 190, MAGINTA ; INNER AREA
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
    DRBX 105, AX, 105, 15, BLACK
    
    MVCR 150, 80
    lea dx, MSG_START
    mov ah, 09h
    int 21h

    MVCR 150, 83
    lea dx, MSG_CONTINUE
    mov ah, 09h
    int 21h

    MVCR 150, 86
    lea dx, MSG_INST
    mov ah,09h
    int 21h

    MVCR 150, 89
    lea dx,MSG_HSCORE
    mov ah,09h
    int 21h

    MVCR 150, 92
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
    MOV CURR_OPT,125
    JMP START_MENU

    DOWNN:

    CMP CURR_OPT, 125
    JE FIRST
    MOV AX, CURR_OPT
    ADD AX, 25
    MOV CURR_OPT, AX
    JMP START_MENU

    FIRST:
    MOV CURR_OPT,25
    JMP START_MENU

    ENTERR:
    CMP CURR_OPT,25
    JE RESET_GAME
    CMP CURR_OPT,50
    JE START_GAME
    CMP CURR_OPT,75
    JE INSTRUCTIONSS
    CMP CURR_OPT,100
    JE HIGHSCORESS
    CMP CURR_OPT,125
    JE EXIT

    HIGHSCORESS:

     MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BROWN
    INT 10h

    MOV IS_MENU, 0
    CALL READ_FILE
    
    INPUT_HSCOREE:
    mov ah, 01h
	int 16h
    JZ INPUT_HSCOREE
    MOV AH, 00H
    INT 16H
    CMP AL, 08
    JE JMP_MENU
    JNE HIGHSCORESS

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

    RESET_GAME:
    MOV SCORE, 0
    MOV NO_BLOCKS, 10
    MOV REM_BLOCKS, 10
    MOV IS_SPECIAL, 0
    MOV NO_FIXED, 0
    MOV S_POS, 130
    MOV S_LEN, 51
    MOV S_SPEED, 2
    MOV LEVEL, 1
    MOV LIVES, 3

    MOV SI, 9
    MOV CX, NO_BLOCKS
    LOOP_RESET:
        .IF SI == 9
            MOV AL, 2
        .ELSE
            MOV AX, SI
            ADD AL, 2
        .ENDIF
        MOV B_COLOR[SI], AL
        MOV B_HITS[SI], 1
        DEC SI
    LOOP LOOP_RESET

    START_GAME:
    MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BROWN
    INT 10h

    DRBX 60, 5, 255, 185, LGRAY  ; GAME PLAY AREA
    DRBX 60, 191, 255, 7, LGRAY  ; SPIKES AREA
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

        MOV AL, REM_BLOCKS
        SUB AL, NO_FIXED
        .IF AL == 0
            CALL STOP_BEEP
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
        DRBX BX, 185, CX, 5, RED

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
        .IF AH == 4DH ; SCAN CODE RIGHT
            MOV CX, S_SPEED
            LOOP_SLIDER1:
            PUSH CX
                MOV BX, S_POS
                ADD BX, S_LEN
                INC BX
                .IF BX <= X_MAX
                    MOV BX, S_POS
                    DRVLN BX, 185, 5, LGRAY
                    INC S_POS
                .ELSE
                    POP CX
                    JMP LOOPER
                .ENDIF
            POP CX
            LOOP LOOP_SLIDER1
        .ELSEIF AH == 4BH ; SCAN CODE LEFT
            MOV CX, S_SPEED
            LOOP_SLIDER2:
            PUSH CX
                MOV BX, S_POS
                DEC BX
                .IF BX >= X_MIN
                    MOV BX, S_POS
                    ADD BX, S_LEN
                    DRVLN BX, 185, 5, LGRAY
                    MOV BX, S_SPEED
                    DEC S_POS
                .ELSE
                    POP CX
                    JMP LOOPER
                .ENDIF
            POP CX
            LOOP LOOP_SLIDER2
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
        .IF SI == 14 && IS_SPECIAL == 1
            DRSBLK AX, BX, 51, 15
        .ELSEIF [B_HITS + DI] != 0
            DRBLK AX, BX, 51, 15, CL
        .ENDIF
        ADD SI, 2
        INC DI
        POP CX
        DEC CX
        CMP CX, 0
        JNE LOOP_B
    RET
DRAWBLOCKS ENDP

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
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                   .IF BL != 00
                        DEC [B_HITS + DI]
                        SUB BX, 2
                        ADD SCORE, BX
                        DEC [B_COLOR + DI]
                    .ELSEIF SI == 14 && IS_SPECIAL == 1
                        CALL ISSPECIAL
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
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                    .IF BL != 00
                        DEC [B_HITS + DI]
                        SUB BX, 2
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
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                    .IF BL != 00
                        DEC [B_HITS + DI]
                        SUB BX, 2
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
                    MOV BX, 0
                    MOV BL, [B_COLOR + DI]
                    .IF BL != 00
                        DEC [B_HITS + DI]
                        SUB BX, 2
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
        CALL SAV_SCORE
        CALL WRITE_FILE
        MVCR 20, 15
        LEA DX, MSG_GAMEOVER
        MOV AH, 09H
        INT 21H
        MVCR 9, 17
        LEA DX, MSG_GOTOMENU
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

; TO SET LEVELS
SET_LEVEL PROC
    MOV PLAY, 0
    INC LEVEL
    ADD B_SPEED, 1
    SUB S_LEN, 5
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
    MOV CX, S_POS
    DRBX CX, 175, 51, 15, LGRAY
    MOV S_POS, 120
    MOV SI, 0
    MOV CX, 0
    MOV CL, REM_BLOCKS
    LOOPBLK:
    PUSH CX
        CALL GET_RAND
        MOV DL, RAND
        .IF LEVEL == 3
            MOV IS_SPECIAL, 1
            .IF DL == 11 || DL == 12
                MOV DH, 10
                MOV [B_COLOR + SI], 00
                MOV [B_HITS + SI], DH
                INC NO_FIXED
            .ELSE
                JMP SKIPED
            .ENDIF
        .ELSEIF
            SKIPED:
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
    .IF RAND > 12 || RAND < 3
        JMP RANDOM
    .ENDIF
    RET
GET_RAND ENDP

NAMEINPUT PROC
    DRBX 70, 70, 170, 50, BLACK
    MVCR 10, 10
    LEA DX,MSGG_1
    MOV AH,09
    INT 21H

    MOV AH,02H
    MOV DL,10
    INT 21H

    MOV AH,02H
    MOV BX,0
    MOV DH, 12 ;Row Number
    MOV DL, 10 ;Column Number
    INT 10H

    MOV SI,4
    .WHILE(AL!=13)
	    MOV AH,01H
	    INT 21H
	    .IF AL != 13
	    	MOV NAMEE[SI],AL
	    .ENDIF
	    INC SI
	.ENDW
	MOV NAMEE[25], 10
	RET
NAMEINPUT ENDP

READ_FILE PROC
	MOV AH,3DH				      	
    MOV AL,02					  	
	MOV DX,OFFSET FILENAMEE			
	INT 21H							
	MOV HANDLE, AX

    MOV AH, 06H ; BACKGROUND
    MOV AL, 0
    MOV CX, 0
    MOV DH, 80
    MOV DL, 80
    MOV BH, BLACK
    INT 10h
       
	MOV BX,0
	mov ah,3fh
	mov cx,200					           ;cx is how many bytes to read.
	mov dx,offset buffer					 ; dos functions like dx having pointers for some reason.
	mov bx,handle						 ; bx needs the file handle.
	int 21h

    MVCR 0, 2
        
	lea dx,buffer
	mov ah,09h
	int 21h

    MVCR 3, 23
	lea dx,MSG_GOTOMENU
	mov ah,09h
	int 21h

	RET
READ_FILE ENDP

WRITE_FILE PROC USES AX BX CX DX SI
	MOV AH,3DH				      	
	MOV AL,02					  	
	MOV DX,OFFSET FILENAMEE			
	INT 21H							
	MOV HANDLE,AX

	MOV BX,HANDLE
	MOV CX,0
	MOV DX, 0
	MOV AH,42H
	MOV AL,2
	INT 21H
	MOV AH, 40H                   ; SERVICE TO WRITE TO A FILE
	MOV BX, HANDLE
	MOV CX, LENGTHOF NAMEE        ; STRING LENGTH.
	MOV DX, OFFSET NAMEE
	INT 21H
			
	MOV AH, 3EH 
	MOV BX, HANDLE
	INT 21H
	RET
WRITE_FILE ENDP


SAV_SCORE PROC USES AX BX CX DX SI
    MOV NO_DIGG, 0
    MOV BX, SCORE
    LOOP_D:
    	MOV AX, BX
    	MOV BL, 10
    	DIV BL
    	MOV REMM, AH
    	MOV QUOO, AL
    	INC NO_DIGG
        
		MOV AH, 0
		MOV BX, AX

		MOV AX, 0
		MOV AL, REMM
		PUSH AX

	CMP QUOO, 0
	JNE LOOP_D
    
	MOV CX, 0
	MOV CL, NO_DIGG
	MOV SI,21
	LOOP1:
		POP BX
		ADD BL,48
		MOV NAMEE[SI], BL
		INC SI
    LOOP LOOP1

	MOV AL,LEVEL
	ADD AL,48
	MOV NAMEE[17],AL
	RET
SAV_SCORE ENDP

ISSPECIAL PROC USES AX SI DI
MOV AL, REM_BLOCKS
SUB AL, NO_FIXED
.IF AL < 5
    PUSH DI
    MOV DI, 0
    LOOP_SP:
        MOV [B_HITS + SI], 0
        INC DI
    CMP DI, NO_BLOCKS
    JNE LOOP_SP
    POP DI
.ELSE
    CALL RAND_REMOVE
.ENDIF
ISSPECIAL ENDP

RAND_REMOVE PROC USES SI AX CX
MOV SI, NO_BLOCKS
MOV AX, 0
MOV CX, LENGTHOF B_HITS
HEREE:
LOOP_REM:
    .IF AX == 5
        RET
    .ENDIF
    .IF [B_HITS + SI] != 0
        MOV [B_HITS + SI], 0
    .ENDIF
    ADD SI, 2
LOOP LOOP_REM
.IF AX < 4
    MOV SI, NO_BLOCKS
    DEC SI
    JMP HEREE
.ENDIF
    RET
RAND_REMOVE ENDP

; <----- End Functions ----->

EXIT:
MOV AH, 00H		;SET VIDEO MODE
MOV AL, 03H		;CHOOSE MODE 13
INT 10H

MOV AH, 4CH
INT 21H
END