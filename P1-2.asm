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
# $11 = Where mainArr($12) is loaded into
# $12 = index number
# $13 = Number of values in mainArr
# $14 = For evaluate function
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
			mainArr: .word 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE
			indecies: .word	0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE
			nearArr: .word 0xEEEEEEEE, 0xEEEEEEEE    # Array of neighbor squares' values
			indexArr: .word 0xEEEEEEEE, 0xEEEEEEEE     # Array of neighbor squares' indices 
.text
			# First code run
			swi   567	   	        # Bury mines (returns # buried in $1)
			add $5, $0, $0		    # Creates initial variable to put flags in		
			addi $7, $0, -1			# Initialize $7 to be value of a bomb
			addi $9, $0, 9			# Initialize $9 to be the value assigned to flagged squares
			add $13, $0, $0			# Assume 1 square will be known from first guess	
			addi $15, $0, 10		# Assign 10 to $15 to denote "Fully known" squares
			add $26, $0, $0			# Initialize $26 to zero
			addi $27, $0, 238		# Initialize $27 to 0
			add $17, $31, $0	    # Save memory link

			# INITIAL GUESS
			addi  $2, $0, 0		    # Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip	    	# If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9			# make $4 9 because thats my value of a bomb
			sb $4, mainArr($26)		# store the returned value into the master array
			sb $26, indecies($0)	# store the returned value into the index array
			addi $13, $13, 1
			beq $4, $0 MainLoop		# If first square is zero, start running the main loop
			# Since we didn't have a zero on first guess, guess again 

Guess:		addi $26, $26, 1
			lbu $24, mainArr($26)
			bne $24, $27, Guess		# If the index of mainArr at $23 isnt FF, then loop until it does
			add  $2, $0, $26		# Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip		# If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9

skip:		sb $4, mainArr($26)		# store the returned value into the master array
			sb $26, indecies($13)     # Store the index of the guessed value into mainArr
			addi $13, $13, 1	

			# MAIN LOOP
MainLoop:	add $24, $0, $0		    # Reset guess conditional 
			add $21, $0, $0
nowOpen:	add $10, $0, $0
			j FlagOrOpen			# Run the Open function
nowCheck:	beq $0, $24 Guess	    # If neither do anything, run Guess function
			bne $1, $5 MainLoop	    # If the number of flags != number of bombs, keep looping
end:		jr  $17  	  		    # return to OS - ENDS
	
			# CHOOSES WHICH SQUARES TO FLAG/OPEN
FlagOrOpen:	lbu $12, indecies($10)  # Load current index value into $12
			lbu $11, mainArr($12)	# Load current neighbor value into $11
			beq $11, $15, endif		# If $11 is an evaluated number, skip
			beq $11, $9, endif		# If $11 is an evaluated number, skip
			bne $11, $0, next		# Check if $11 is 0
			beq $11, $21, endif		# If $11 is 0 for Flag mode, skip

next:		add $6, $0, $0			# (Re-)Initialize index-ers
			add $20, $0, $0
			jal neighVals				# Jumps to neighbor value finder

			# FIND NUMBER OF NEIGHBOR BOMBS
			beq $11, $0, evaluate	# If the square's value is 0, skip to evaluate function
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
			lbu $12, nearArr($14)   # Index at first neighbor value
			lbu $11 indexArr($14)   # Load the index of the neighbor square into $11
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			bne $12, $27 evald      # Check if the neighbor is closed, if not skip to next neighbor
			sb $11, indecies($13)	# Add $11 to the indicies to check later
			addi $13, $13, 1		# Add 1 to number of known values
			add  $2, $0, $11	    # Evaluate at position $11
			bne $21, $0 opener		# Check flag vs. open conditional

flagger:	addi  $3, $0, 1         # Flag
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			j evalEnd
			
opener:		addi  $3, $0, 0         # Open
evalEnd:    swi   568               # returns result in $4 (9)
			addi $24, $0, 1		    # Make open conditional true
			sb $4, mainArr($11)     # Store the value of a opened square in the mainArr
			bne $14, $8, evald      # Loop until Run through all indexes

endif:		beq $1, $5, end			# If all flags are found, end game
			addi $10, $10, 1		# Add 1 to the counter 
			bne $10, $13, FlagOrOpen # Loop Flag until run through all squares availables
			bne $21, $0 nowCheck	# If this was the Open loop, go to nowCheck
			addi $21, $0, 1
			j nowOpen

# FINDS NEIGHBOR VALUES
neighVals:  add $23, $31, $0
			addi $8, $0, 3		    # Initialize $8 to max value of neighbor arrays
			beq $12, $0 NoNW		# These are selectors to decide which loop to run 
			addi $28, $0, 7
			beq $12, $28 NoNE		# For example, if the current array index is 7, we know that this is the pixel with no North or East neighbors
			addi $28, $0, 56
			beq $12, $28 NoSW
			addi $28, $0, 63
			beq $12, $28 NoSE

			addi $8, $0, 5		    # Initialize $8 to max value of neighbor arrays
			addi $2, $0, 7
			slt $18, $12, $2
			bne $18, $0, NoN

			addi $28, $0, 8			# I use Mod to find whether a pixel is at an index with no East or West neighbor
			div $12, $28
			mfhi	$18
			beq $18 $0, NoW
			addi $28, $0, 7
			beq $28, $18, NoE

			addi $2, $0, 55
			slt $18, $2, $12
			bne $18, $0, NoS

			addi $8, $0, 8		    # Initialize $8 to max value of neighbor arrays
			j neighbors

NW:			addi $28, $12, -9
			j neighIndex

N:			addi $28, $12, -8
			j neighIndex

NE:			addi $28, $12, -7
			j neighIndex

W:			addi $28, $12, -1
			j neighIndex

E:			addi $28, $12, 1
			j neighIndex

SW:			addi $28, $12, 7
			j neighIndex

S:			addi $28, $12, 8
			j neighIndex

SE:			addi $28, $12, 9

neighIndex:	sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31
			

NoSW:		add $18, $12, $0
NoW:		jal N
			jal NE
NoNW:		jal E
			beq $12, $18, neighEnd
			jal S			
			jal SE			
			jal neighEnd

NoSE:		add $18, $12, $0
NoE:		jal NW			
			jal N			
NoNE:		jal W	
			beq $12, $18, neighEnd		
			jal SW			
			jal S			
			jal neighEnd

NoS:		jal NW			
			jal N			
			jal NE			
			jal W			
			jal E			
			jal neighEnd
	 
neighbors:  jal NW			
			jal N			
			jal NE			
NoN:		jal W			
			jal E	
			jal SW
			jal S
			jal SE
			
neighEnd:	add $20, $0, $0
			jr $23


