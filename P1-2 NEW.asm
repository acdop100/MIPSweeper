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
# $17 = Value above a nonsense square
# $18 = Total size of neighbor values and for other stuff
# #19 = Value of nearArr(i)
# $20 = Array index-er
# $21 = Number of nearby closed squares
# $22 = Number of nearby bombs
# $24 = Guess conditional
# $27 = 238 (Number of closed square)
# $28 = value of neighbor square
.data
			mainArr: .word 	0x0B0B0B0B, 0x0B0B0B0B, 0xEE0B0B0B, 0xEEEEEEEE, 0x0BEEEEEE, 0xEEEEEE0B, 0xEEEEEEEE, 0xEE0B0BEE, 0xEEEEEEEE, 0x0BEEEEEE, 0xEEEEEE0B, 0xEEEEEEEE, 0xEE0B0BEE, 0xEEEEEEEE, 0x0BEEEEEE, 0xEEEEEE0B, 0xEEEEEEEE, 0xEE0B0BEE, 0xEEEEEEEE, 0x0BEEEEEE, 0xEEEEEE0B, 0xEEEEEEEE, 0x0B0B0BEE, 0x0B0B0B0B, 0x0B0B0B0B
			nearArr: .word 	0xEEEEEEEE, 0xEEEEEEEE   	# Array of neighbor squares' values
			indexArr: .word 0xEEEEEEEE, 0xEEEEEEEE     	# Array of neighbor squares' indices 
			neighArr: .word 0xFFF7F6F5, 0x0B0A0901    	# Array of neighbor squares' change values 
			subArr: .word 	0x313B454F, 0x09131D27		# Array of values to compare for subtraction 
			subvalsArr: .word 	0xEDEBE9E7, 0xF5F3F1EF	# Array of values to subtract 
.text
			# First code run
			swi   567	   	        # Bury mines (returns # buried in $1)
			add $5, $0, $0		    # Creates initial variable to put flags in		
			addi $7, $0, -1			# Initialize $7 to be value of a bomb
			addi $9, $0, 9			# Initialize $9 to be the value assigned to flagged squares	
			add $13, $0, $0
			addi $15, $0, 10		# Assign 10 to $15 to denote "Fully known" squares
			addi $16, $0, 11		# Assign 11 (0B) to 16 for filtering
			add $17, $31, $0	    # Save memory link
			add $21, $0, $0
			addi $26, $0, 11		# Initialize $26 to zero
			addi $27, $0, 238		# Initialize $27 to 0
			
			# INITIAL GUESS
			add  $2, $0, $0			# Mine field position 0
			j skip
			
			# MAIN LOOP
MainLoop:	add $24, $0, $0		    # Reset guess conditional 
			add $21, $0, $0
			j resetTen				# Run the Open function
nowCheck:	bne $0, $24 MainLoop	# If neither do anything, run Guess function
Guess:		addi $26, $26, 1
			lbu $24, mainArr($26)
			bne $24, $27, Guess		# If the index of mainArr at $24 isnt FF, then loop until it does
			add $11, $26, $0
			jal subtract
			add  $2, $0, $11		# Mine field position 0
skip:       addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip2	    # If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9			# make $4 9 because thats my value of a bomb
skip2:		sb $4, mainArr($26)		# store the returned value into the master array
			addi $13, $13, 1
			bne $2, $0, MainLoop
			bne $4, $7, MainLoop
			j Guess
			
			# CHOOSES WHICH SQUARES TO FLAG/OPEN
resetTen: 	add $10, $0, $0
			addi $12, $0, 10
endNot:		addi $12, $12, 1
FlagOrOpen:	lbu $11, mainArr($12)	# Load current neighbor value into $11
			beq $11, $27, endNot	# If $11 is a unknown square, loop to endNot
			beq $11, $16, endNot	# If $11 is an outside index, loop to endNot
			beq $11, $15, endif		# If $11 is an evaluated number, skip
			beq $11, $9, endif		# If $11 is a bomb, skip
			bne $11, $0, next		# Check if $11 is 0
			beq $11, $21, endif		# If $11 is 0 for Flag mode, skip

next:		add $20, $0, $0
			add $8, $0, $0
neighLoop:	lb $28, neighArr($20)
			add $28, $12, $28
			lbu $18, mainArr($28)	# Load the value of the array into $18
			addi $20, $20, 1		# Add 1 to the index of $20
			beq $18, $15, endNeigh	# If $18 is a value to ignore, then skip to next neighbor
			sb $28, indexArr($8)	# Store the value of $28 in indexArr
			sb $18, nearArr($8)		# Store the value of $18 into nearArr
			addi $8, $8, 1			# Add 1 to squares we need to check
endNeigh:	slti $6, $20, 8
			bne $6, $0, neighLoop
			beq $11, $0, evaluate	# If the square's value is 0, skip to evaluate function

			# FIND NUMBER OF NEIGHBOR BOMBS
			add $20, $0, $0
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
nearClosed: beq $20, $8 check		# Loop until the index value is equal to $8
			lbu $19, nearArr($20)
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $27 nearClosed	# Loop if the index is not unknown
			addi $22, $22, 1	    # Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed	# Loop until the index value is equal to $8

check:		bne $22, $0, check2
			sb $15, mainArr($12)	# Insert the value of $15 into the position to denote a square with fully known neighbors
			j endif

check2:		add $18, $6, $22	    # Finds total size
			bne $18, $11, endif	    # If Totalsize is not equal, loop back
			beq $0, $11, endif	    # If the current index equals zero, loop back
			
			# MAIN EVALUATION FUNCTION
evaluate:	add $14, $0, $0			# (Re-)Initialize index-er
			sb $15, mainArr($12)	# Insert the value of $15 into the position to denote a square with fully known neighbors
evald:		beq $14, $8, endif      # Loop until Run through all indexes
			lbu $11 indexArr($14)   # Load the index of the neighbor square into $11
			lbu $20, nearArr($14)   # Index at first neighbor value
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			bne $20, $27 evald      # Check if the neighbor is closed, if not skip to next neighbor
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
			addi $12, $12, 1		# Add 1 to the index 
			div $12, $15			# See if The new index is at the end of a line
			mflo $23
			bne $23, $9, lineSkip	# If it is, add another to get to the next index
			addi $12, $12, 2		# Add 2 to the index because we jump to next line
lineSkip:	bne $10, $13, FlagOrOpen # Loop Flag until run through all squares availables
			bne $21, $0 nowCheck	# If this was the Open loop, go to nowCheck
			addi $21, $0, 1			# Add 1 to the index
			j resetTen				# Jump to resetTen

			#Figure out how much to subtract
subtract:	add $20, $0, $0			# Reset indecies
			add $6, $0, $0
sbubby:		lb $28, subArr($20)		# Load the value of the array into $28
			slt $28, $11, $28		# Is $11 less than $28?
			bne $28, $0, noSub		# If so, skip to noSub
			lb $28, subvalsArr($20)	# If not, load the correct value to subtract into $28...
			add $11, $11, $28		# ... And subtract it from $11
			jr $31					# And then return to the previous command
noSub:		addi $20, $20, 1		# Add 1 to the index $20
			slti $6, $20, 8			# If $20 is less than 8...
			bne $6, $0, sbubby		# ... Then reloop back to "sbubby"

end:		jr  $17  	  		    # return to OS - ENDS