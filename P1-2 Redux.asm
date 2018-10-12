#     Minesweeper
#
#  Your Name:	James Lehman
#  Date:	10/5/18
# $1 = Number of mines buried
# $2 = Mine position
# $3 = Command register
# $4 = The returned value from the command
# $5 = Number of bombs flagged
# $6 = number of bombs
# $7 = -1
# $8 = max index of nearArr, 0-7
# $9 = 9 (value of flagged of mainArr)
# $10 = Current master index
# $11 = Where mainArr($10) is loaded into
# $10 = index number
# $13 = Number of values in mainArr
# $14 = For evaluate function
# $15 = Value on nonsense square
# $17 = Memory Location of exit 
# $18 = Total size of neighbor values and for other stuff
# #19 = Value of nearArr(i)
# $20 = Array index-er
# $21 = Number of nearby closed squares
# $22 = Number of nearby bombs
# $24 = Guess conditional
# $27 = 238 (Number of closed square)
# $28 = value of neighbor square
.data
			mainArr: .word 0x0A0A0A0A, 0x0A0A0A0A, 0xEE0A0A0A, 0xEEEEEEEE, 0x0AEEEEEE, 0xEEEEEE0A, 0xEEEEEEEE, 0xEE0A0AEE, 0xEEEEEEEE, 0x0AEEEEEE, 0xEEEEEE0A, 0xEEEEEEEE, 0xEE0A0AEE, 0xEEEEEEEE, 0x0AEEEEEE, 0xEEEEEE0A, 0xEEEEEEEE, 0xEE0A0AEE, 0xEEEEEEEE, 0x0AEEEEEE, 0xEEEEEE0A, 0xEEEEEEEE, 0x0A0A0AEE, 0x0A0A0A0A, 0x0A0A0A0A
			nearArr: .word 0xEEEEEEEE, 0xEEEEEEEE    # Array of neighbor squares' values
			indexArr: .word 0xEEEEEEEE, 0xEEEEEEEE     # Array of neighbor squares' indices 
.text
			# First code run
			swi   567	   	        # Bury mines (returns # buried in $1)
			add $5, $0, $0		    # Creates initial variable to put flags in		
			addi $7, $0, -1			# Initialize $7 to be value of a bomb
			addi $9, $0, 9			# Initialize $9 to be the value assigned to flagged squares	
			add $13, $0, $0
			addi $15, $0, 10		# Assign 10 to $15 to denote "Fully known" squares
			add $21, $0, $0
			addi $26, $0, 11			# Initialize $26 to zero
			addi $27, $0, 238		# Initialize $27 to 0
			add $17, $31, $0	    # Save memory link

			# INITIAL GUESS
			add  $2, $0, $0		# Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip2	    # If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9			# make $4 9 because thats my value of a bomb
skip2:		sb $4, mainArr($26)		# store the returned value into the master array
			addi $13, $13, 1
			beq $4, $0 MainLoop		# If first square is zero, start running the main loop
			# Since we didn't have a zero on first guess, guess again 

Guess:		addi $26, $26, 1
			lbu $24, mainArr($26)
			bne $24, $27, Guess		# If the index of mainArr at $23 isnt FF, then loop until it does
			add $11, $26, $0
			jal subtract
			add  $2, $0, $11		# Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip		# If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9

skip:		sb $4, mainArr($26)		# store the returned value into the master array
			addi $13, $13, 1	

			# MAIN LOOP
MainLoop:	add $24, $0, $0		    # Reset guess conditional 
			add $21, $0, $0
			j resetTen				# Run the Open function
nowCheck:	beq $0, $24 Guess	    # If neither do anything, run Guess function
			bne $1, $5 MainLoop	    # If the number of flags != number of bombs, keep looping
end:		jr  $17  	  		    # return to OS - ENDS
	
			# CHOOSES WHICH SQUARES TO FLAG/OPEN
resetTen: 	add $10, $0, $0
			addi $12, $0, 11
FlagOrOpen:	lbu $11, mainArr($12)	# Load current neighbor value into $11
			beq $11, $15, endif		# If $11 is an evaluated number, skip
			beq $11, $9, endif		# If $11 is an evaluated number, skip
			bne $11, $0, next		# Check if $11 is 0
			beq $11, $21, endif		# If $11 is 0 for Flag mode, skip

next:		add $20, $0, $0
			add $8, $0, $0
			addi $28, $12, -11
			jal neighIndex
			addi $28, $12, -10
			jal neighIndex
			addi $28, $12, -9
			jal neighIndex
			addi $28, $12, -1
			jal neighIndex
			addi $28, $12, 1
			jal neighIndex
			addi $28, $12, 9
			jal neighIndex
			addi $28, $12, 10
			jal neighIndex
			addi $28, $12, 11
			jal neighIndex
			add $20, $0, $0

			# FIND NUMBER OF NEIGHBOR BOMBS
			beq $11, $0, evaluate	# If the square's value is 0, skip to evaluate function
			add $6, $0, $0
nearBombs:	beq $20, $8 nearClose	# Loop until the index value is 7
			lbu $19, nearArr($20)   # Load neighbor value to index
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $9 nearBombs	# If the value of the square is not a bomb, skip it
			addi $6, $6, 1	    	# Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs	# Loop until the index value is 7

nearClose:	beq $21, $0 skippy
			beq $6, $11 evaluate	# Run evaluate if the number of flags already equals the numbre of bombs
			j endif

			# FIND NUMBER OF CLOSED SQUARES (if Flag == true)
skippy:		beq $6, $11 endif
			add $20, $0, $0			# (Re-)Initialize index-ers
			add $22, $0, $0	
nearClosed: beq $20, $8 check	# Loop until the index value is 7
			lbu $19, nearArr($20)
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $27 nearClosed	# Loop if the index is not unknown
			addi $22, $22, 1	    # Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed	# Loop until the index value is 7

check:		add $18, $6, $22	    # Finds total size
			bne $18, $11, endif	    # If Totalsize is not equal, loop back
			beq $0, $11, endif	    # If the current index equals zero, loop back
			
			# MAIN EVALUATION FUNCTION
evaluate:	add $14, $0, $0			# (Re-)Initialize index-er
			sb $15, mainArr($12)	# Insert the value of $15 into the position to denote a square with fully known neighbors
evald:		beq $14, $8, endif      # Loop until Run through all indexes
			lbu $11 indexArr($14)   # Load the index of the neighbor square into $11
			lbu $16, nearArr($14)   # Index at first neighbor value
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			bne $16, $27 evald      # Check if the neighbor is closed, if not skip to next neighbor
			add $25, $11, $0
			jal subtract

flagger:	addi $13, $13, 1		# Add 1 to number of known values
			add  $2, $0, $11	    # Evaluate at position $11
			bne $21, $0 opener		# Check flag vs. open conditional
			addi  $3, $0, 1         # Flag
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			j evalEnd
			
opener:		addi  $3, $0, 0         # Open
evalEnd:    swi   568               # returns result in $4 (9)
			addi $24, $0, 1		    # Make open conditional true
			sb $4, mainArr($25)     # Store the value of a opened square in the mainArr
			bne $14, $8, evald      # Loop until Run through all indexes

endif:		beq $1, $5, end			# If all flags are found, end game
			addi $10, $10, 1		# Add 1 to the counter 
			addi $12, $12, 1		# Add 1 to the counter 
			bne $10, $13, FlagOrOpen # Loop Flag until run through all squares availables
			bne $21, $0 nowCheck	# If this was the Open loop, go to nowCheck
			addi $21, $0, 1
			j resetTen

neighIndex:	lbu $18, mainArr($28)
			addi $20, $20, 1
			beq $18, $15, endNeigh
			sb $28, indexArr($8)
			sb $18, nearArr($8)
			addi $8, $8, 1
endNeigh:	jr $31

			#Figure out how much to subtract
subtract:	slti $6, $11, 0x4F
			beq $6, $0, sub1
			slti $6, $11, 0x45
			beq $6, $0, sub7
			slti $6, $11, 0x3B
			beq $6, $0, sub6
			slti $6, $11, 0x31
			beq $6, $0, sub5
			slti $6, $11, 0x24
			beq $6, $0, sub4
			slti $6, $11, 0x1D
			beq $6, $0, sub3
			slti $6, $11, 0x13
			beq $6, $0, sub2
			addiu $11, $11, -11
			jr $31			
sub7:		addiu $11, $11, -23
			jr $31
sub6:		addiu $11, $11, -21
			jr $31
sub5:		addiu $11, $11, -19
			jr $31
sub4:		addiu $11, $11, -17
			jr $31
sub3:		addiu $11, $11, -15
			jr $31
sub2:		addiu $11, $11, -13
			jr $31
sub1:		addiu $11, $11, -25
			jr $31