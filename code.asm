Include Irvine32.inc
.data
   n Byte "Hunain Arif (19k-0299)",0dh,0ah,
		  "Khizer Riaz(19k-1296)",0dh,0ah,
		  "Taha Aslam (19k-0147)",0

menu	BYTE "**MAIN MENU**",0dh,0ah
		BYTE "1. Play with computer (1 Player).",0dh,0ah
		BYTE "2. Instruction.",0dh,0ah
		BYTE "3. Exit.",0dh,0ah,0dh,0ah,0dh,0ah
		BYTE "Enter your choice: ",0
choice  BYTE ?

inst	BYTE "**INSTRUCTIONs**",0dh,0ah,0dh,0ah
		BYTE "Use arrow keys to move the cursor.",0dh,0ah
		BYTE "Press space bar to click.",0



ques	BYTE "QUESTION",0
msgQ	BYTE "Do you want to play again...?",0
msgQ1   BYTE "1: YES          2:NO",0
arr		BYTE 9 dup(' ')		; ARRAY to maintain the signs of both player

space	BYTE "   ",0			; print TABLE (pattern of tic-tac-toe)
lh		BYTE "----",0			; line horizontal
row		BYTE ?					; store line number 

symbol	BYTE ?					; store sign of current player
locate	BYTE ?					; store the location of current cell
count	BYTE 0					; tells numbers of elements in  array

drw		BYTE "Game tie.",0
win		BYTE "WINNER",0
win1	BYTE "Player 1 has won the game",0
win3	BYTE "Computer has won the game",0
endflag BYTE 0
restart BYTE 0

scoreHD	BYTE "**SCORE**",0
scoreP1 BYTE 0
scoreP2 BYTE 0
msgP1	BYTE "Player 1 wins= ",0

msgc	BYTE "Computer wins= ",0


.code
main PROC

call randomize
mov edx,offset n
call writeString
mov eax,1000
call delay

shoru:
mov restart,0
mov choice,0
mov endFlag,0
mov count,0
mov ecx,9
mov ebx,0
initial:
mov arr[ebx],' '
mov al,arr[ebx]		; reset the array
inc ebx
loop initial

again:					; repeat  untill the user want to quit 
call clrscr
mov edx,OFFSET menu		; display the main menu
call writeString
call readDec
mov choice,al
cmp choice,3
je khatam
cmp choice,2
jb gameStart			; gamestart
call instruction
call waitMsg
jmp again


gameStart:
call clrscr

call display		; table print ho rha he
call score			; score display kar rha he player aur computer ka

L1:					
inc count
mov al,count
test al,1			
jp P2				

call p1turn

jmp next

P2:
cmp choice,1
je c2

jmp next

c2:
call compTurn

jmp compNext

NEXT:
call input			; take input from user
cmp restart,1
je shoru
compNext:			; dont take input if it is computer's turn
call condition

cmp endFlag,0		; if game end then end flag becomes 1
je L1

mov endFlag,0
mov count,0
mov ecx,9
mov ebx,0

reset:
mov arr[ebx],' '
mov al,arr[ebx]		; reset the array
inc ebx
loop reset

call waitmsg

call clrscr
mov edx,OFFSET ques
call writestring
call crlf
mov edx,OFFSET msgQ		; ask to play again
call writestring
call crlf
mov edx,offset msgQ1
call writestring 
call crlf
call readDec
cmp eax,2
je shoru			; if no then ends the game

jmp gameStart

khatam:
call clrscr
EXIT
main ENDP

;**INSTRUCTION**
instruction PROC
call clrscr
mov dl,3
mov dh,0
call gotoXY
mov edx,OFFSET inst
call writeString
call crlf
call crlf
ret
instruction ENDP


;**Player 1 turn**
p1turn PROC
mov dl,0
mov dh,2
call gotoXY
mov edx,OFFSET msgQ1
call WriteString
mov symbol,'X'		; passing player 1 symbol as argument
ret
p1turn ENDP


;***Computer turn**
compTurn PROC

change:
mov eax,9
call randomRange
mov ebx,eax
mov al,arr[ebx]
cmp al,' '
jne change

mov arr[ebx],'O'
mov symbol,'O'

mov dh,4
mov dl,11
cmp ebx,2
ja r2
mov ecx , ebx
inc ecx
jmp set

r2:
cmp ebx,5
ja r3
mov ecx,ebx
sub ecx,2
mov dh,6
jmp set

r3:
mov ecx,ebx
sub ecx,5
mov dh,8

set:
add dl,4
loop set

call gotoXY
mov eax,'O'
call writeChar

ret
compTurn ENDP

;***Display scores of both player***
score PROC
mov dl,9
mov dh,11
call gotoXY
mov edx,OFFSET scoreHD
call WriteString
call crlf

mov edx,OFFSET msgP1
call WriteString
movzx eax,scoreP1
call writeDec
call crlf

cmp choice,1
je P3


P3:
mov edx,OFFSET msgc
call WriteString
movzx eax,scoreP2
call writeDec
ret
score ENDP

;***Take input from user***
input PROC
mov dh,4
mov dl,15
mov locate,0

START:
call gotoXY
call readchar
cmp ah,48h
je up
cmp ah,50h
je down
cmp ah,4Bh
je left
cmp ah,4Dh
je right
cmp al,' '
je print		; print symbol of player

jmp start		; if enter any other character dosen't do any movement

PRINT:			
movzx esi,locate
mov al,arr[esi]
cmp al,' '		; check for empty space
jne START		; if not empty do nothing and go back to take another input
mov al,symbol
call writeChar
movzx esi,locate
mov arr[esi],al
ret

DOWN:
cmp dh,8
je uppest
add dh,2
add locate,3
jmp start
UPPEST:
sub locate,6
mov dh,4
jmp start

UP:
cmp dh,4
je downest
sub dh,2
sub locate,3
jmp start
DOWNEST:
add locate,6
mov dh,8
jmp start

LEFT:
cmp dl,15
je rightest
sub dl,4
sub locate,1
jmp start
RIGHTEST:
add locate,2
mov dl,23
jmp start

RIGHT:
cmp dl,23
je leftest
add dl,4
add locate,1
jmp start
LEFTEST:
sub locate,2
mov dl,15
jmp start


input ENDP

;***Display the table***
display PROC
mov dl,7
mov dh,0
call gotoXY


mov dh,4
mov dl,14
mov row,4

mov ecx,3
L1:
call gotoXY
push ecx
mov ecx,2
L2:
mov edx,offset space
call writestring		; print 3 spaces
mov al,"|"
call writechar
loop L2

pop ecx
cmp ecx,1
je stop					; skip printing horizontal lines in last
push ecx

inc row
mov dh,row
mov dl,14
call gotoXY				; goto next line

mov ecx,3
L3:
mov edx,offset lh
call writestring		; print horizontal line
loop L3

inc row
mov dh,row
mov dl,14
pop ecx
STOP:
loop L1

ret
display ENDP


;***Check all condition***
condition PROC
mov ebx,0
ROWS:					; checking conditions of all rows
cmp arr[ebx],' '
je next1		; if empty go to checking column conditions
mov al,arr[ebx]
cmp al,arr[ebx+1]
jne nextRow				; if not equal go to checking next row condition
cmp al,arr[ebx+2]
je winner
nextRow:
cmp ebx,6
je next1
add ebx,3
jmp rows

NEXT1:
mov ebx,0
COLUMNS:				; checking conditions of all columns
cmp arr[ebx],' '
je next2
mov al,arr[ebx]
cmp al,arr[ebx+3]
jne nextColumn			; if not equal go to checking next column condition
cmp al,arr[ebx+6]
je winner
nextColumn:
cmp ebx,2
je next2
inc ebx
jmp columns

NEXT2:
mov ebx,0
DIAGONALS:				; checking conditions of all diagonals
cmp arr[ebx],' '
je draw
mov al,arr[ebx]
cmp al,arr[4]
jne nextDiagonal				; if not equal go to checking next column condition
mov ecx,8
sub ecx,ebx
cmp al,arr[ecx]
je winner
nextDiagonal:
cmp ebx,2
je draw
add ebx,2
jmp diagonals

DRAW:
cmp count,9
jne return
mov dl,5
mov dh,15
call gotoXY
mov edx,OFFSET drw
call writestring
call crlf
mov endFlag,1
ret

WINNER:
mov ebx,OFFSET win
cmp symbol,'X'
je p1w				; player 1 won the game
cmp choice,1
je cw				; computer won the game

p1w:
inc scoreP1
mov dl,10
mov dh,15
call gotoXY
mov edx,OFFSET win1
call writestring
call crlf 
call crlf
mov endFlag,1
ret

cw:
inc scoreP2
mov dl,10
mov dh,15
call gotoXY
mov edx,OFFSET win3
call writestring
call crlf
call crlf
mov endFlag,1

RETURN:
ret
condition ENDP

END main