;ENIGMA MACHINE
;The Enigma machine was created for Germany by Arthur Scherbius at the end of World War I. The theory behind the machine is
;that each letter typed should be shifted by a random number. This is accomplished by three rotors which rotate once per
;letter, when a rotor shifts it defines a new electrical pathway (i.e. a new shift amount). So as the message is typed the
;rotors move along to define new shifts each letter. However during World War II, a team called "Ultra", who were working for
;the Allies cracked the machine. This helped cut short the war.

;HOW TO USE THE SO CALLED MACHINE AND SEND ENCRYPTED MESSAGES TO YOUR FRIENDS!
;NOTE!! All the letters have to be input as uppercase!!

;First you can switch the orders of the letters in the alphabet making it hard to decrypt. To do so press the space bar. So
;you can switch A with P and now the order will be: PBCDEFGHIJKLMNOAQRSTUVWXYZ. To continue to keep switching the order press
;the space bar when prompt.
;Next is setting the three rotors. The rotors go from 3 to 1. Just enter a single letter for each rotor to set it.
;Lastly is entering the message to encrypt it. NOTE!! The message should have no SPACES, that is because having spaces makes
;it easier to decrypt then just a string of letters. Also just like a typewriter there is no backspace a mistake is a mistake,
;so you need to restart the message again. However if it’s one letter then it should be easy to figure out when decrypted.
;Hit enter or the “.” key when done and the encrypted message should be underneath the original message. To write another message
;press the space key to restart the whole process.

;NOW HOW DO WE DECRYPT A MESSAGE WE RECEIVED??
;Simple! All you need to know is the information about how the message was encrypted.
;That means you need to know what order of the letters were and what the three rotors were set to. Once all that data is inputted
;into machine, just type in the encrypted message and the result should be the original message.

;LET’S DO A CONTROL TEST
;Set the order of the letters to: ABCDEZGHIJRLMNOPQKSTUVWXYF. So F & Z are switched as well as R & K
;Next set the rotor 3 to: T, Set rotor 2 to: C, And Rotor 1 to: A
;Now the message will be: THEALLIESAREPLANNINGSOMETHINGINJUNE
;The encrypted message will be: AJQTGUJMNBTHOWLGLZRJCFXPSSNRPADIDKL
;Now to decrypt the message back to its original. Again, set the order of the letters to: ABCDEZGHIJRLMNOPQKSTUVWXYF and keep the
rotors the same: T,C,A. Now input the encrypted message and it will return back the original message.



INCLUDE Irvine32.inc

.data
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;MAPS
board		db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
alphabet	db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0

rot1		db "BDFHJLCPRTXVZNYEIWGAKMUSQO",0
revrot1		db "TAGBPCSDQEUFVNZHYIXJWLRKOM",0
rot2		db "AJDKSIRUXBLHWTMCQGZNPYFVOE",0
revrot2		db "AJPCZWRLFBDKOTYUQGENHXMIVS",0
rot3		db "EKMFLGDQVZNTOWYHXUSPAIBRCJ",0
revrot3		db "UWYGADFPVZBECKMTHXSLRINQOJ",0
reflect		db "YRUHQSLDPXNGOKMIEBFZCWVJAT",0

boardp		db "Would you like to switch letter on the board, if so press space: ",0
b1p			db "Enter the letter you wish to change the path too: ",0
b2p			db "This letter will go to which letter: ",0

ui1prompt	db "Please enter a characters FROM A-Z: UP TO 100",0
ui1echo		db "You entered this character: ",0

decryptindex	dd	0

b1			db	0	;breadboard input one
b2			db  0	;breadboard input two
b3			db  0   ;to go again to switch letters around
switch		db	0

countrot3rotates db	1	;# of times that rot has rotated
countrot2rotates db	0	;# of times that rot has rotated
countrot1rotates db 0	;# of times that rot has rotated

ui1			db ?	;user input for letter to encrypt
count		db ?	;keeping count here
arraypos	db ?	;position of given character in an array
mapedchar	db ?	;the character throughout the program that is getting encrypted

gofinterval1	db ?	;condition of rot3 as interval
gofinterval2	db ?	;condition of rot2 as interval
gofinterval3	db ?	;condition of rot1 as interval

rot3condition	db ?	;user input for condition of rot3
rot2condition	db ?	;user input for condition of rot2
rot1condition	db ?	;user input for condition of rot1

simonschar		db ?	;holds the users response character to the question do u want to go again
thisrot			db ?    ;This pays attention to where it is in the machine, 1 through 6.
rotssetbool		db 0	;if the rotors were set this equals one so they cant be reset again.
rot2e			db 0	;variable that keeps track of when rot2 was e
encrypted		db 100 dup(?)

simonsaysprompt		db "Press SPACE BAR to continue, or the ANY OTHER KEY to exit: ", 0
printarrayprompt	db "This array is: ",0
notinalphabetprompt	db "That character is not in the alphabet.",0
mapedtoprompt		db "Coresponding letter in that rotor is: ",0
againprompt			db "Again? Press ",0
rot3conditionprompt	db "Enter Rot3 Initial Condition: ",0
rot2conditionprompt	db "Enter Rot2 Initial Condition: ",0
rot1conditionprompt	db "Enter Rot1 Initial Condition: ",0
keepgoing				db "+++++++++PRESS ENTER OR PERIOD TO STOP INPUTING LETTERS++++++++++",0

secondXPos db 0
secondYPos db 0

.code
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;PROCS
;reset				;resets after simonsaysyes
;setui1				;get user input
;checkarray			;will find arraypos
;printarray			;prints array
;findmapedchar		;finds the position of the mapedchar					;
;gof				;sets condiiton of rotor taking into consideratoin rotations
;gob				;rotates back to original state
;encrypt			;CALL multiple procs to encrypt
;simonsays			;ask user if they'd like to go again
;rot1function		;
;rot2function		;
;rot3function		;
;revrot1function	;
;revrot2function	;
;revrot3function	;
;reflectfunction	;
	
main PROC
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

MOV EAX,0
MOV EDX,0
MOV ECX,0
MOV EBX,0

thatway:

CALL reset

MOV ESI, offset encrypted
MOV ECX, 100

L1:
	MOV EAX,0
	MOV [ESI],AL
	inc ESI
LOOP L1

CALL clrscr
CALL setboard
MOV EAX, green + (black*16)
CALL settextcolor

CALL encrypt
CALL simonsays
JMP thatway
CALL crlf

exit
main endp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


redtext proc
MOV EAX, red + (black*16)
CALL settextcolor
ret
redtext endp

reset proc
MOV rotssetbool,0
MOV countrot3rotates,1	
MOV countrot2rotates,0	
MOV countrot1rotates,0
CALL resetboard
ret
reset endp

resetboard PROC
MOV ECX,LENGTHOF board
DEC ECX
MOV ESI,OFFSET board
MOV EAX,'A'

FINALLOOPY:
MOV [ESI],AL
INC ESI
inc EAX
LOOP FINALLOOPY

ret
resetboard ENDP

greentext proc
MOV EAX, green + (black*16)
CALL settextcolor
ret
greentext endp

yellowtext proc
MOV EAX, yellow + (black*16)
CALL settextcolor
ret
yellowtext endp

WHITEtext proc
MOV EAX, WHITE + (black*16)
CALL settextcolor
ret
WHITEtext endp

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

simonsays proc
CALL redtext
MOV EDX, offset simonsaysprompt
CALL writestring
CALL greentext
CALL readchar
MOV simonschar, AL
CMP simonschar,' '
JE simonsaysyes
JNE simonsaysno
simonsaysyes:
ret
simonsaysno:
exit
simonsays endp

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=

encrypt proc
;When w is hit  
;they both both turn on e 

somemore:
CALL setui1
MOV BL,'.'
.if ui1 ==BL
CALL encryptproc
ret
.endif

MOV BL,13
.if ui1 ==BL
CALL encryptproc
ret
.endif

CALL yellowtext

MOV BL,gofinterval1
MOV thisrot,1
CALL gof
CALL rot1function
MOV BL, gofinterval1
CALL gob

MOV thisrot,2
MOV BL,gofinterval2
CALL gof
MOV BL, countrot2rotates
;ADD gofinterval2,BL
CALL rot2function
;SUB gofinterval2,BL
MOV BL, gofinterval2
CALL gob

MOV thisrot,3
MOV BL,gofinterval3
CALL gof
CALL rot3function
MOV BL, gofinterval3
CALL gob

CALL reflectfunction

MOV thisrot,4
MOV BL,gofinterval3
CALL gof
CALL revrot3function
MOV BL, gofinterval3
CALL gob

MOV thisrot,5
MOV BL,gofinterval2
CALL gof
CALL revrot2function
MOV BL, gofinterval2
CALL gob

MOV thisrot,6
MOV BL,gofinterval1
CALL gof
CALL revrot1function
MOV BL, gofinterval1
CALL gob

;inc countrot3rotates

.IF rot2e==1
INC COUNTROT1ROTATES
INC COUNTROT2ROTATES
MOV rot2e,0
.ENDIF


JMP somemore
ret 
encrypt endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

setboard PROC
here:
MOV EDX,offset boardp
CALL writestring
CALL CRLF
CALL readchar
CMP AL,' '
JE notdoneyet
JNE weredone
weredone:
ret

notdoneyet:
MOV EDX, offset b1p
CALL writestring
CALL readchar
CALL writechar
CALL CRLF
MOV ESI,offset board
CALL checkarray
MOV BL,arraypos
MOV b1,BL

MOV EDX, offset b2p
CALL writestring
CALL readchar
CALL writechar
;CALL CRLF
MOV ESI,offset board
CALL checkarray
MOV BL,arraypos
MOV b2,BL
; SWITCH

MOV ESI, offset board
MOV EDI, offset board

MOV EAX,0
MOV AL,b1
ADD ESI,EAX
MOV AL,[ESI]

MOV ebx,0
MOV BL,b2
ADD EDI,ebx
MOV BL,[EDI]

MOV [EDI],AL
MOV [ESI],BL

MOV ECX, SIZEOF BOARD
MOV eSI,offset board
CALL YELLOWTEXT
CALL printarray
CALL WHITETEXT
CALL crlf
JMP here

RET
setboard ENDP

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

gof proc
; the go forward transfermation
; takes in:
; MOV ebx,gofinterval1
; returns:

MOV DL,BL
MOV AL,mapedchar
ADD AL,BL

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CMP AL,'Z'
JG jgz1
JLE jlez1
jgz1:
MOV BL,'A'
MOV DL, 'Z'
SUB AL, DL
ADD AL, BL
DEC AL
jlez1:
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.if thisrot==1
.IF GOFINTERVAL1==26
MOV GOFINTERVAL1,0
.ENDIF

MOV DL, GOFINTERVAL1
ADD DL,COUNTROT3ROTATES	

.if DL == 23
inc countrot2rotates
.endif
MOV DL, GOFINTERVAL2
ADD DL,COUNTROT2ROTATES
.IF DL==4
MOV rot2e,1
;CALL DUMPREGS
.ENDIF

.endif
.if thisrot==2
ADD AL,countrot2rotates

.endif
.if thisrot==3
ADD AL,countrot1rotates
.endif
.if thisrot==4
ADD AL,countrot1rotates
.endif
.if thisrot==5
ADD AL,countrot2rotates

.endif
.if thisrot==6

.endif


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CMP AL,'Z'
JG jgz
JLE jlez
jgz:
MOV BL,'A'
MOV DL, 'Z'
SUB AL, DL
ADD AL, BL
DEC AL
jlez:

CALL checkarray
MOV ESI, offset alphabet
CALL findmapedchar

ret
gof endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

gob proc
; takes in:
; MOV ebx, gofinterval1
; returns:

MOV AL, BL
SUB mapedchar, AL

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CMP mapedchar, 'A'
jl mla1
jge mgea1
mla1:
MOV AL,'A'
SUB AL, mapedchar
MOV BL, 'Z'
SUB BL,AL
MOV mapedchar, BL

inc mapedchar
mgea1:

.if thisrot==1

.endif
.if thisrot==2
MOV AL,countrot2rotates
SUB mapedchar, AL
.endif
.if thisrot==3
MOV AL,countrot1rotates
SUB mapedchar, AL
.endif
.if thisrot==4
MOV AL,countrot1rotates
SUB mapedchar, AL
.endif
.if thisrot==5
MOV AL,countrot2rotates
SUB mapedchar, AL

.endif
.if thisrot==6

.ENDIF

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CMP mapedchar, 'A'
jl mla
jge mgea
mla:
MOV AL,'A'
SUB AL, mapedchar
MOV BL, 'Z'
SUB BL,AL
MOV mapedchar, BL

inc mapedchar
mgea:

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

MOV AL, mapedchar

.if thisrot==6
MOV ESI,offset encrypted
MOV EDI,DECRYPTINDEX
.IF EDI==LENGTHOF ENCRYPTED
MOV EDI,0
.ENDIF
ADD ESI,decryptindex
MOV [ESI],AL
INC DECRYPTINDEX
;CALL CRLF
;CALL CRLF
.ENDIF

;CALL writechar

ret
gob endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

encryptproc PROC
CALL CRLF
MOV ECX,LENGTHOF ENCRYPTED
MOV EDI,OFFSET ENCRYPTED
LAZY:
MOV EAX,[EDI]

MOV switch,1
CALL CHECKARRAY
MOV AL,ARRAYPOS
MOV ESI, offset alphabet
CALL findmapedchar

CALL WRITECHAR
INC EDI
LOOP LAZY
CALL CRLF
RET
encryptproc ENDP

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
setui1 proc
; prompts user for character to put into cipher
; takes in nothing
; returns nothing, puts user input in2 ui1
; also prompts user for conditions

MOV BL,0
.if rotssetbool==0
MOV DECRYPTINDEX,0
;GET ROT3CONDITOIN__________________________
MOV EDX, offset rot3conditionprompt
CALL writestring
CALL readchar
CALL writechar
MOV rot3condition, AL 
CALL crlf
CALL checkarray
MOV DL, arraypos
MOV gofinterval1, DL


;GET ROT2CONDITOIN__________________________
MOV EDX, offset rot2conditionprompt
CALL writestring
CALL readchar
CALL writechar
MOV rot2condition, AL
CALL crlf
CALL checkarray
MOV DL, arraypos
MOV gofinterval2, DL


;GET ROT1CONDITOIN__________________________
MOV EDX, offset rot1conditionprompt
CALL writestring
CALL readchar
CALL writechar
MOV rot1condition, AL
CALL crlf

CALL checkarray
MOV DL, arraypos
MOV gofinterval3, DL
MOV rotssetbool,1

CALL redtext
MOV EDX, offset keepgoing
CALL writestring
CALL greentext
CALL crlf
MOV EDX, offset ui1prompt
CALL writestring
CALL CRLF
CALL YELLOWTEXT
.endif		;jumps to here if rots have been set
ADD gofinterval1, 1;DL

; get ui1

CALL readchar
MOV ui1, AL
;CALL crlf
;MOV EDX, offset ui1echo
;CALL writestring
CALL writechar
;CALL crlf
MOV mapedchar, AL
CALL checkarray
MOV ESI,offset board
CALL findmapedchar

ret
setui1 endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

findmapedchar proc
; finds a charaacter in ceasermap
; takes in offset of array in ESI
; returns nothing

MOV EAX,0
MOV AL, arraypos
ADD ESI, EAX
MOV EAX, [ESI]
MOV mapedchar, AL
;CALL crlf
;MOV EDX, offset mapedtoprompt
;CALL writestring
;CALL writechar
;CALL crlf
ret
findmapedchar endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

checkarray proc
; checks to see if a user input is in the array
; takes in:
; MOV AL, LETTER TO COMPARE
; returns nothing- moves location of AL in alphabet string to arraypos

MOV ESI, offset alphabet
.if switch==1
MOV ESI,offset board
.endif
MOV switch,0
MOV ECX, lengthof alphabet
cmploop:
MOV BL,[ESI]
CMP AL, BL
JE jejmp
ADD ESI, 1

CMP ECX,1; to see if its time to jump out of loop
JE ecxjejmp; jumps out of looop when loop is going to end
loop cmploop

ecxjejmp:
;CALL crlf
;MOV EDX, offset notinalphabetprompt
;CALL writestring
ret

jejmp:

MOV EAX, lengthof alphabet
SUB EAX, ECX
MOV arraypos, AL
;CALL writedec
ret
checkarray endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

printarray proc uses  EDX EAX
; prints array
; takes in:
; MOV ECX, SIZEOF ARRAYNAME
; MOV ESI, offset ARRAYNAME
; returns nothing

CALL crlf
;MOV EDX, offset printarrayprompt
;CALL writestring
;CALL crlf

L1:  ;loop to print out ceasermap characters
MOV aL, [ESI]
CALL writechar ;writes from AL register
inc ESI
loop L1

ret
printarray endp
;arraypos



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;rot functions
; finds the letter correspoding to userinput
; takes in:
; returns:
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rot1function proc

MOV AL, mapedchar
CALL checkarray

MOV ESI, offset rot1
CALL findmapedchar

ret
rot1function endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rot2function proc

MOV AL, mapedchar
CALL checkarray
MOV ESI, offset rot2
CALL findmapedchar

ret
rot2function endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rot3function proc

MOV AL, mapedchar
CALL checkarray
MOV ESI, offset rot3
CALL findmapedchar

ret
rot3function endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

revrot1function proc

MOV AL, mapedchar
CALL checkarray
MOV ESI, offset revrot1
CALL findmapedchar

ret
revrot1function endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

revrot2function proc

MOV AL, mapedchar
CALL checkarray
MOV ESI, offset revrot2
CALL findmapedchar

ret
revrot2function endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

revrot3function proc

MOV AL, mapedchar
CALL checkarray
MOV ESI, offset revrot3
CALL findmapedchar

ret
revrot3function endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

reflectfunction proc

MOV AL, mapedchar
CALL checkarray
MOV ESI, offset reflect
CALL findmapedchar

ret
reflectfunction endp

END main
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++