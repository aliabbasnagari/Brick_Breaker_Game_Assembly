;Draw DIAGONAL line
.model small
.stack 100h
.data
b1 db "Fizza Asif", '$'

;THESE ARE THE STARTING POINTS
s1 dw 30
s2 dw 50

s3 dw 90
s4 dw 40
.code
mov ax,@data
mov ds,ax



Mov ah,00h		;set video mode
Mov al,13h		;choose mode 13
Int 10h ; graphics interrupt

; LEFT DIAGONAL LINE
mov bx, 0
k1:
MOV AH, 0Ch ; 
MOV AL, 4h ;colour
MOV CX, s1 ; increments X-axis ; cx is x-axis
MOV DX, S1 ; Increments Y-axis ;dx is y-axis
INT 10H ; interrup for graphics
inc s1
inc bx
cmp bx, 30 ; a simple counter which determines the length of the line
je l2
jne k1

;RIGHT DIAGONAL LINE

l2:

mov bx, 0
k2:
MOV AH, 0Ch ; 
MOV AL, 4h ;colour
MOV CX, S3 ; increments x axis ; cx is x-axis
MOV DX, S4 ; dx is y-axis
INT 10H ; interrup for graphics
inc s4
dec s3
inc bx
cmp bx, 30 ; a simple counter which determines the length of the line
je END1
jne k2




end1:
mov ah, 4ch
int 21h
end
