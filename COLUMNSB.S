	pea	boot(pc)
	move.w	#38,-(a7)
	trap	#14
	clr.l	(a7)
	trap	#1	
boot	and.b	#$fc,$484.w	
	lea	$ffff8240.w,a0
	move.w	#$777,$1e(a0)
	pea	docum(pc)
	move.w	#9,-(a7)
	trap	#1
	addq.l	#6,a7
	moveq	#6,d1
fade:	moveq	#2,d2
yul:	bsr	vblsync
	dbf	d2,yul
	sub.w	#$111,(a0)
	dbf	d1,fade
	move.w	#$2700,sr
lop	eor.w	#$005,(a0)
	nop
	btst	#4,$fffffa01.w
	bne.s	lop
	move.w	#$2300,sr			
	lea	clock(pc),a0
	move.l	$4ce.w,$612.w
	move.l	a0,$4ce.w
restart	clr.w	$608.w
	bsr	clrsc
	lea	storage(pc),a0
	moveq	#100,d0
klirtoo	clr.l	(a0)+
	dbf	d0,klirtoo
********
start	clr.l	$600.w
	movea.l	$44e.w,a6
	suba.w	#24*160-64,a6
	lea	$fffffc02.w,a0
	bsr	pause
	lea	storage(pc),a5	current boxes
	lea	4(a5),a2	old x,y
	move.w	#3,(a2)
	lea	14(a2),a4	bytemap
	move.l	a4,a0
	moveq	#20,d0	21 rows
	moveq	#7,d7	
hanrow	move.b	d7,(a0)
	add.l	d7,a0
	move.b	d7,(a0)+	
	dbf	d0,hanrow
	move.w	d7,d0	8 boxes in width
hanrr	move.b	d7,(a0)+
	dbf	d0,hanrr
	move.w	#40,4(a2)
	bsr	bytecon
	move.b	#$19,3(a5)
********	LOOP
newtile	bsr	print
 	moveq	#2,d7	3 squares
newsq	move.w	#17,-(a7)
	trap	#14
	addq.l	#2,a7
	lsr.w	#8,d0
	mulu	#6,d0
	lsr.w	#8,d0
	addq	#1,d0
	move.b	d0,(a5,d7)
	dbf	d7,newsq
	move.w	(a2),d6	new x
	moveq	#0,d7	new y
	;move.w	d6,(a2)		old x
	move.w	d7,2(a2)	old y
	bsr	seek	occupied?
	bne	quit
restore	move.w	4(a2),$610.w
keyrel	lea	$fffffc02.w,a0
	move.b	3(a5),d2
keyrox	tst.w	$610.w
	bmi.s	downone
	cmp.b	(a0),d2	release previous!
	beq.s	keyrox
	moveq	#1,d1	x vector
keyget	tst.w	$610.w
	bmi.s	downone
	move.b	(a0),d0	new key
	move.b	d0,3(a5)
	cmp.b	#$4d,d0
	beq.s	right
	cmp.b	#$4b,d0
	beq.s	left
	cmp.b	#$39,d0
	beq.s	drop
	cmp.b	#$13,d0
	beq.s	rotate
	cmp.b	#$10,d0
	beq	quit
	cmp.b	#$19,d0
	bne.s	keyget
	bsr	pause
	bra.s	keyget
downone	addq	#1,d7
	bsr	seek
	bne	putnev
	bsr	move
	lea	sound2(pc),a1
	bsr	sound
	bra	restore
left	neg.w	d1	go left
right	sub.w	#$1000,6(a2)
	move.w	d6,d0
	add.w	d1,d6
	bsr	seek
	beq.s	putnew
	move.w	d0,d6
	bra.s	keyrel
putnew	bsr	move
	bra	keyrel
rotate	sub.w	#$1000,6(a2)
	move.l	(a5),d0
	rol.l	#8,d0
	rol.w	#8,d0
	move.l	d0,(a5)
	bra.s	putnew
drop	addq	#1,d7
	bsr	seek
	beq.s	drop
putnev	subq	#1,d7
	bsr	move
	lea	sound3(pc),a1
	bsr	sound
	lea	3(a5),a0
	move.w	d6,d4
	move.w	d7,d5
	bsr	bytemo
	moveq	#2,d0	3 boxes
boxset	move.b	-(a0),(a1)
	addq.l	#8,a1
	dbf	d0,boxset	
retest	clr.w	2(a2)	'no crash'
	moveq	#20,d7	21 rows
testrow	moveq	#5,d6	6 columns
testcmn	moveq	#1,d0	horiz
	bsr	aplyvec
	swap	d0	vertical
	bsr	aplyvec
	bset	#0,d0	diagonal left	
	bsr	aplyvec
	neg.w	d0	diagonal right
	bsr	aplyvec
	dbf	d6,testcmn
	dbf	d7,testrow
	moveq	#7,d7	8 frames
frame:	bsr	vblsync
	bsr	vblsync
	moveq	#21,d5	22 rows
rowxd	moveq	#7,d4	8 colms
colxd	bsr	bytemo
	btst	#7,(a1)
	beq.s	nektil
	moveq	#4,d1
	move.w	d7,d0	
	add.w	#18,d0
	bsr	makebox
nektil	dbf	d4,colxd
	dbf	d5,rowxd
	dbf	d7,frame
	move.l	a4,a0
	move.w	#21*8-1,d0 168 boxes	
clipmkd	btst	#7,(a0)	
	seq	d2
	and.b	d2,(a0)+
	dbf	d0,clipmkd
	move.l	a4,a0
	moveq	#7,d0	8 columns
columnn	moveq	#20,d1	21 rows
	move.w	d1,d6
rowwww	move.w	d1,d2
	lsl.w	#3,d2
	move.b	(a0,d2),d7
	bne.s	putt
decd1	dbf	d1,rowwww
skrol	move.w	d6,d2
	lsl.w	#3,d2
	clr.b	(a0,d2)
	dbf	d6,skrol		
nexc	addq.l	#1,a0
	dbf	d0,columnn
	bsr	bytecon
	tst.w	2(a2)
	beq	newtile
	bra	retest	
putt	move.w	d6,d2
	lsl.w	#3,d2
	move.b	d7,(a0,d2)
	dbf	d6,decd1
	bra.s	nexc
aplyvec	move.w	d6,d4
	addq	#1,d4
	move.w	d7,d5
	bsr	bytemo
	move.b	(a1),d1	
	bclr	#7,d1
	moveq	#1,d2	2 more boxes
delta	bsr.s	addvect
	bsr	bytemo
	move.b	(a1),d3
	beq.s	abort
	bclr	#7,d3
	cmp.b	d3,d1
	bne.s	abort
	dbf	d2,delta
	move.w	d6,d4
	addq	#1,d4
	move.w	d7,d5
	moveq	#2,d2	3 boxes to mark
	move.w	d2,2(a2)	'crash'
	bsr	score
markbox	bsr	bytemo
	bset	#7,(a1)
	bsr.s	addvect
	dbf	d2,markbox	
	lea	sound1(pc),a1
sound:	;in:	a1 as which command list
	lea	$ffff8800.w,a0
	moveq	#6,d2
send:	move.w	(a1)+,d3
	movep.w	d3,(a0)
	dbf	d2,send
abort:	rts
addvect	add.w	d0,d4
	swap	d0
	add.w	d0,d5
	swap	d0
	rts
seek	;input:d6,d7 as x,y
	;output:'ne' if occupied
	;uses:d3-d5,a1
	move.w	d6,d4
	move.w	d7,d5
	addq	#2,d5
	bsr	bytemo
	tst.b	(a1)
	rts	
move	;input:d6-d7 as new x,y
	;uses:d0-d5,d7,a1
	bsr	vblsync
	move.w	(a2),d4
	move.w	2(a2),d5	old cords
	lea	-3(a4),a0
	bsr.s	boxes3
	move.w	d6,d4
	move.w	d7,d5	new cord.s
	move.l	a5,a0
boxes3	;input:a0 as source boxes
	;uses:d0,d1,d5
	moveq	#2,d3	3 boxes
box	move.b	(a0,d3),d1	box #
	move.w	d1,d0
	bsr.s	makebox
	addq	#1,d5
	dbf	d3,box
	move.w	d6,(a2)
	move.w	d7,2(a2)
	rts					
bytecon	;uses:d0,d2,d5-d7,a1
	moveq	#21,d5	22 rows
rowxx	moveq	#7,d4	8 colms
colxx	bsr	bytemo
	move.b	(a1),d1
	move.w	d1,d0
	bsr.s	makebox
	dbf	d4,colxx
	dbf	d5,rowxx
	rts
makebox	;input:d0,d1,d4,d5 as tile#,color,x,y
	;uses:d0,d2,a1
	swap	d3
	ext.w	d0
	lsl.w	#3,d0
	lea	tiles(pc),a3
	adda.w	d0,a3	;which tile
	move.w	d4,d2
	move.w	d5,d0
	mulu	#160*8,d0
	lsr.w	#1,d2
	scs	d3
	lsl.w	#3,d2
	andi.w	#1,d3
	add.w	d2,d0
	add.w	d3,d0	
	lea	(a6,d0),a1	hotspot
	moveq	#7,d0	8 rows
rowbox	moveq	#2,d2	3 bits
bitbox	btst	d2,d1
	sne	d3
	andi.w	#$ff,d3
	move.b	(a3),(a1)
	and.b	d3,(a1)
	addq.l	#2,a1
	dbf	d2,bitbox
	addq.l	#1,a3
	adda.w	#154,a1
	dbf	d0,rowbox
	swap	d3
	rts
bytemo	;input:d4,d5 as x,y
	;output:a1 as offset
	;uses:d3,a1
	move.w	d5,d3
	lsl.w	#3,d3
	add.w	d4,d3	bytemap offset
	lea	(a4,d3),a1
	rts				
pause	move.w	$610.w,-(a7)
	move.b	d0,-(a7)
	moveq	#6,d1
	lea	$ffff8240.w,a1
	bsr	vblsync
blkout:	clr.w	(a1)+
	dbf	d1,blkout
	moveq	#2,d4
	moveq	#22,d5
	moveq	#3,d3	;4 tiles
pchar:	moveq	#35,d0
	sub.w	d3,d0
	moveq	#7,d1
	bsr	makebox
	addq	#1,d4
	dbf	d3,pchar
	move.b	(a7)+,d0
pslp:	cmp.b	(a0),d0
	beq.s	pslp
psewt	cmp.b	#$19,(a0)
	bne.s	psewt
	moveq	#3,d1
	lea	$ffff8240.w,a1
	lea	collist(pc),a3
	bsr.s	vblsync
restrc:	move.l	(a3)+,(a1)+
	dbf	d1,restrc
	bsr	print
	move.w	(a7)+,$610.w
	rts	
score:	;uses:exc. d0,a0
	lea	$600.w,a1
add:	move.b	(a1),d1
	addq	#1,d1
	cmp.b	#$a,d1
	beq.s	carry
	move.b	d1,(a1)
	rts
carry:	clr.b	(a1)+
	move.w	$608.w,d1
	eor.w	#1,$608.w
	sub.w	d1,4(a2)
	bra.s	add
clrsc:	movea.l	$44e.w,a0
	move.w	#7999,d0
chl:	clr.l	(a0)+
	dbf	d0,chl
	rts
print:	lea	$600.w,a0
	moveq	#5,d4
	moveq	#22,d5
	moveq	#3,d3	4 digits
digit:	move.b	(a0)+,d0
	addq	#8,d0
	moveq	#4,d1
	bsr     makebox
	subq	#1,d4
	dbf	d3,digit
	rts
vblsync	move.w	$464.w,d0
vblwait	cmp.w	$464.w,d0
	beq.s	vblwait
	rts
clock:	sub.w	#1,$610.w
	rts
quit	moveq	#1,d4
	moveq	#24,d5
	moveq	#5,d3	6 tiles
tchar:	moveq	#31,d0
	sub.w	d3,d0
	moveq	#3,d1
	bsr	makebox
	addq	#1,d4
	dbf	d3,tchar
	lea	sound4(pc),a1
	bsr	sound
	lea	$fffffc02.w,a0
compar	cmp.b	#$61,(a0)
	beq.s	termin
	cmp.b	#$62,(a0)
	beq	restart
	bra.s	compar
termin	move.l	$612.w,$4ce.w
	bsr	clrsc
	or.b	#$3,$484.w
	rts	
docum	dc.b	$1b,$59,37,47,"-COLUMNS"
	dc.b	$1b,$59,39,37,"Brought down to your boot by"
	dc.b	$1b,$59,40,43,"The NAVIGATOR of"
	dc.b	$1b,$59,41,40,"The FLYING ENTERPRISE."
	dc.b	$1b,$59,43,33,"To score, form rows of at least three"
	dc.b	$1b,$59,44,37,"with the same type of blocks."
	dc.b	$1b,$59,46,32,"Right/left cursor -- move"
	dc.b	$1b,$59,47,48,"R -- rotate"
	dc.b	$1b,$59,48,44,"SPACE -- drop"
	dc.b	$1b,$59,49,48,"P -- pause"
	dc.b	$1b,$59,50,48,"Q -- leave game:"
	dc.b	$1b,$59,52,53,"HELP - new game"
	dc.b	$1b,$59,53,53,"UNDO - quit"
	dc.b	0
	even
collist	dc.w	$000,$740,$040,$007,$407,$047,$400,$335
tiles	dc.l	$00000000,$00000000	0
	dc.l	$183c7eff,$ff7e3c18	1
	dc.l	$18183c3c,$7e7effff	2
	dc.l	$3c7ec3c3,$c3c37e3c	3
	dc.l	$c3e77e3c,$3c7ee7c3	4
	dc.l	$181818ff,$ff181818	5
	dc.l	$aa55ffff,$ffffaa55	6
	dc.l	$fefaf6ea,$d6aafe00	7
font	dc.l	$003c4242,$42423c00	0
	dc.l	$00182808,$08083c00	1
	dc.l	$003c420c,$30407e00	2
	dc.l	$007e0418,$04423c00	3
	dc.l	$000c1424,$447e0400	4
	dc.l	$007e407c,$02423c00	5
	dc.l	$003c407c,$42423c00	6
	dc.l	$007e4204,$08102000	7
	dc.l	$003c423c,$42423c00	8
	dc.l	$003c4242,$3e023c00	9
explode	dc.l	$00000000,$00000000
	dc.l	$01400000,$00000280
	dc.l	$00022000,$00044000
	dc.l	$00000410,$08200000
	dc.l	$00000018,$18000000
	dc.l	$00003c24,$243c0000
	dc.l	$007e4242,$42427e00
	dc.l	$ff818181,$818181ff
gmeovr	dc.l	$1c202e22,$1c00003f
	dc.l	$2253728a,$8a0000ff
	dc.l	$2e68ae28,$2e0000ff
	dc.l	$39454444,$380000ff
	dc.l	$1714a7a4,$470000ff
	dc.l	$78447848,$440000fc	
paus:	dc.l	$ff8eb5b5,$8cbdbdbd
	dc.l	$ff6dadad,$2dadadb3
	dc.l	$ff986b7b,$98eb6b98
	dc.l	$ff47dbdb,$dbdbdb87	
sound1:	dc.b	6,225
	dc.b	7,$c0
	dc.b	8,16
	dc.b	13,9
	dc.b	12,40
	dc.b	0,70
	dc.b	1,0
sound2:	dc.b	6,225
	dc.b	7,$c8
	dc.b	8,16
	dc.b	13,9
	dc.b	12,10
	dc.b	0,225
	dc.b	1,15
sound3:	dc.b	6,100
	dc.b	7,$c0
	dc.b	8,16
	dc.b	13,9
	dc.b	12,10
	dc.b	0,100
	dc.b	1,2		
sound4:	dc.b	6,100
	dc.b	7,$c1
	dc.b	8,16
	dc.b	13,$e
	dc.b	12,225
	dc.b	0,100
	dc.b	1,2		
storage	dc.b	"END."
