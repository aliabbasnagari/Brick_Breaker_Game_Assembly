.model small 
.stack 100h
.data

.code
main proc
mov ax,@data
mov ds,ax
mov ax,0




main endp

mov ah,4ch
int 21h
end

