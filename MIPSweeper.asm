#     Minesweeper
#
#  Your Name:	James Lehman
#  Date:	10/5/18

################# PROGRAM EXPLANATION ####################
# First, 4 word arrays are created: 
# - mainArr is the array of all values for the game array. I used a 10x10 length array because this lets me not have to deal with edge cases. All edges are assigned the value of 11 (0B), and empty squares are EE
# - nearArr is an 8 byte array to store the value of a square's neighbors
# - indexArr is the same, except it stores the index number for the neighbros instead of their values
# - neighArr: an array of the values of where the neighbors are relevant to the current square (-11, -10, -9, -1, 1, 9, 10, 11)
# - subArr: Array of values that the function subtract uses to test against the square index in $11.
# - subvalsArr: an array of the values that you would subtract depending on what row you are in. 
# 
# After those are declared, the variables that needed repeatedly throughout the program are assigned. You can see what the purpose of each register is above
# Some of these registers are just initialized here first because there are needed for the guess function. Some retain their value for the duration of the program

#### GUESSING ####
# Guessing is achieved by having a register ($26) be the value of the previous square with unknown value. The program then loops until it can find the next square with an unknown value
# The value is then stored in $11 to send to the subtraction function (explained later)
# The returned value of 11 is the proper index value relevant to the games 8x8 board and not my 10x10 board
# The function then assigns that value to $2 and guesses
# If the guess returned a bomb, make $4 equal to 9 and store that instead and add to our flag counter ($5) and number of known squares ($13)
# Also, if the guess run is the first guess, it has the opportunity to guess again if the first square was a bomb. Otherwise it jumps to MainLoop
 
#### MAINLOOP ####
# All mainloop really does is reset some condintionals I set and then runs the FlagOrOpen function

#### FLAGOROPEN ####
# This one is a doozy so i'll break it up by it's sub-functions
# - First is the main fiiter. 
# - First, it checks whether the current square value ($11) is an edge square or a square of unknown value, and if so, jump to endNot, which adds 1 to the mainArr index-er ($12) but doesn't add to the number of checked squares.
# - Second, it checks whether the square is a square where we know all the neighbor values already (Fully known) or a bomb, and if so skip to endIf (explained later)
# - Finally it checks whether the loop is running in flag mode. If so, check to see whether $11 is zero, and if so skip to next number

# Next we move to Next (hehe) and resets some variables for neighLoop

#### NEIGHLOOP ####
# neighLoop finds all of the neighbor's values and the square's index values and stores both in nearArr and indexArr respectively
# - neighLoop only adds values to those arrays if the value is not an edge square. The total number of added values is stored in $8
# - Ends when the loop is run 8 times
# - Also keeps track of whether the neighbor is closed or a bomb and adds to $6 and $22 respectively if so 

#### EVALUATE ####
# This just resets the index-er ($22), makes the guessing conditional false, and inserts the F.K.S. value into that index 

#### EVALD ####
# The big mama. This bad boy does all of the flagging and opening of squares. 
# - Loops until a neighbor is found whose value is closed.
# - Subtract function is run to find proper index of the neighbor in regards to the 8x8 array
# - square is then flagged/opened
 
#### ENDIF ####
# This function adds 1 to count of squares run through ($10) and ends the main loop if the number of run sqaures equals the number of known squares
# - This allows the loop to run even when we add new values to the array in places before the current index
# - This also adds 1 to the indexer ($12), or adds 2 if we are jumping to a new row in the array
# - Also has conditional for whether the FlagOrOpen loop is running in flag or open mode and can switch between them
 
#### SUBTRACT #### 
# Uses subArr and subvalsArr to see what number needs to be subtracted from $11 for the row the square is on

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
			beq $4, $0, MainLoop
			bne $2, $0, MainLoop
			addi $11, $0, 3
			bne $4, $11, Guess
			j MainLoop
			
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

next:		add $20, $0, $0			# Reset index-ers
			add $8, $0, $0
			add $22, $0, $0	
			add $6, $0, $0

neighLoop:	lb $28, neighArr($20)
			add $28, $12, $28
			lbu $18, mainArr($28)	# Load the value of the array into $18
			addi $20, $20, 1		# Add 1 to the index of $20
			beq $18, $15, endNeigh	# If $18 is a value to ignore, then skip to next neighbor
			bne $18, $9 checkClose
			addi $6, $6, 1	    	# Add 1 to count of nearby flagged squares
checkClose:	bne $18, $27 endNeigh
			sb $28, indexArr($22)	# Store the value of $28 in indexArr
			addi $22, $22, 1	    # Add 1 to count of nearby closed squares
endNeigh:	slti $19, $20, 8
			bne $19, $0, neighLoop

			# Filters
			add $18, $6, $22	    # Finds total size
			bne $22, $0, nearClose
			sb $15, mainArr($12)	# Insert the value of $15 into the position to denote a square with fully known neighbors
			j endif
nearClose:	beq $21, $0 skippy
			beq $18, $11, endif	    # If Totalsize is not equal, loop back
			beq $6, $11 evaluate	# Run evaluate if the number of flags already equals the numbre of bombs
			j endif

skippy:		beq $6, $11 endif
			bne $18, $11, endif	    # If Totalsize is not equal, loop back
			
			# MAIN EVALUATION FUNCTION
evaluate:	add $22, $0, $0			# (Re-)Initialize index-er
			sb $15, mainArr($12)	# Insert the value of $15 into the position to denote a square with fully known neighbors
evald:		lbu $11 indexArr($22)   # Load the index of the neighbor square into $11
			addi $22, $22, 1	    # Add 1 to the nearArr index-er
			add $18, $11, $0
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
			sb $4, mainArr($18)     # Store the value of a opened square in the mainArr
			bne $14, $22, evald      # Loop until Run through all indexes

endif:		beq $1, $5, end			# If all flags are found, end game
			addi $10, $10, 1		# Add 1 to the counter 
			addi $12, $12, 1		# Add 1 to the index 

lineSkip:	bne $10, $13, FlagOrOpen # Loop Flag until run through all squares availables
			bne $21, $0 nowCheck	# If this was the Open loop, go to nowCheck
			addi $21, $0, 1			# Add 1 to the index
			j resetTen				# Jump to resetTen

			#Figure out how much to subtract
subtract:	add $20, $0, $0			# Reset indecies
			add $6, $0, $0
sbubby:		lb $28, subArr($20)		# Load the value of the array into $28
			slt $28, $28, $11 		# Is $28 less than $11?
			beq $28, $0, noSub		# If not, skip to noSub
			lb $28, subvalsArr($20)	# If not, load the correct value to subtract into $28...
			add $11, $11, $28		# ... And subtract it from $11
			jr $31					# And then return to the previous command
noSub:		addi $20, $20, 1		# Add 1 to the index $20
			slti $6, $20, 8			# If $20 is less than 8...
			bne $6, $0, sbubby		# ... Then reloop back to "sbubby"

end:		jr  $17  	  		    # return to OS - ENDS