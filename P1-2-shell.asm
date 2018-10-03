#     Minesweeper
#
#  Your Name:	James Lehman
#  Date:	10/5/18

# $1 = number of mines buried
# $2 = mine position
# $3 = command register
# $4 = the returned value from the command
# $5 = number of bombs flagged
# $6 = master array
# $7 = -1
# $8 = 32 (max index of nearArr)
# $9 = -2 (value of index of masterArr?)
# $10 = Current master index
# $11 = where masterArr[$10] is loaded into
# 
# 
# #19 = 
# $20 = 
# $21 = number of nearby closed squares
# $22 = number of nearby bombs
# $23 = Open conditional
# $24 = Flag conditional
# $25 = guess conditional
# $26 = number of opened + flagged squares
# $27 = 4
# $28 = array index regster

.data
# your data allocation/initialization goes here

mainArr: .space 256
indexArr: .space 256
nearArr: .space 32
.text

MineSweep:	swi   567	   	    # Bury mines (returns # buried in $1)
			add $5, $0, $0		# Creates initial variable to put flags in
			addi $7, $0, -1
			add $29, $31, $0	# Save memory link
			addi $27, $0, 4
			addi $8, $0, 32

			# INITIAL GUESS
			addi  $2, $0, 0		# Mine field position 0
            addi  $3, $0, -1    # Guess
            swi   568           # returns result in $4 (-1: mine; 0-8: count)
			beq $4, $7 bomb
			
			mult $2, $27		# Get correct index
			mfhi $28			# Load index into $28
			sw $4, Arr[$28]		# store the returned value into the master array
			sw $28, Arr[$0] 	

Loop:		add $23, $0, $0		# Reset Flag conditional 
			add $23, $0, $0		# Reset Open conditional 
			j Flag				# Run the flag function
			j Open				# Run the Open function
			add $25, $24, $23	# Add both conditinoal values
			beq $26, $25 Guess	# If neither do anything, run Guess function
			bne $1, $5 Loop		# If the number of flags != number of bombs, keep looping
			jr  $29  	  		# return to OS
          

bomb:		addi $5, $5, 1		# Adds 1 to the total number of flags
			jr $31



Open:		add $20, $0, $0
			add $21, $0, $0
			lw $11, nearArr[$10]# Load current index value into $11
nearBombs:	lw $19, nearArr[$20]
			addi $20, $20, 4	# Add 4 to array index
			bne $19, $7 nearBombs
			addi $21, $21, 1	# Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs
			bne $21, $11, Open

			# OPEN SQUARES




Flag:		add $20, $0, $0
			add $21, $0, $0
			add $22, $0, $0
			lw $11, nearArr[$10]# Load current index value into $11
nearBombs:	lw $19, nearArr[$20]
			addi $20, $20, 4	# Add 4 to array index
			bne $19, $7 nearBombs
			addi $21, $21, 1	# Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs
			add $20, $0, $0
nearClosed: lw $19, nearArr[$20]
			addi $20, $20, 4	# Add 4 to array index
			bne $19, $9 nearClosed
			addi $22, $22, 1	# Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed
			add $18, $21, $22	# Finds total size
			bne $18, $11, Flag
			beq $0, $11, Flag
			beq $0, $22, Flag
			beq $11, $21, Flag

			# ASSIGNS FLAGS
			



			#addi $26, $0, $0	# Creates value for number of flagged and/or opened squares

Guess:		addi  $2, $0, 0		# Mine field position 0
            addi  $3, $0, -1    # Guess
            swi   568           # returns result in $4 (-1: mine; 0-8: count)
			beq $4, $7 bomb
			jr $31



	   # TEMP: open square 9 ($2: position, $3: command to OPEN)
           addi  $2, $0, 9		# Mine field position 9
           addi  $3, $0, 0      # Open
           swi   568            # returns result in $4 (-1: mine; 0-8: count)

	   # TEMP: flag square 25 ($2: position, $3: command to FLAG)
           addi  $2, $0, 25		# Mine field position 25
           addi  $3, $0, 1      # Flag
           swi   568            # returns result in $4 (9)

           # your code goes here