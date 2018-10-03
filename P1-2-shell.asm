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
# $8 = 8 (max index of nearArr)
# $9 = 10 (value of flagged of mainArr)
# $10 = Current master index
# $11 = where mainArr[$10] is loaded into
# $12 = nearArr indexer
# $13 =
# $16 = flag loop conditional
# $17 = number of values in knownArr
# #19 = Value of nearArr[i]
# $20 = Array index-er
# $21 = number of nearby closed squares
# $22 = number of nearby bombs
# $23 = Open conditional
# $24 = Flag conditional
# $25 = guess conditional
# $26 = number of opened + flagged squares
# $27 = 4
# $28 = array index regster

# Allocate arrays - *NOT* DONE
# Complete main Loop outline - DONE
# Complete Flagger and Opener sorting logic - DONE
# Mke sure "jr"'s are functioning properly - *NOT* DONE
# Make sure the program is indexing correctly - *NOT* DONE
# Create array of neighboring values and assign to correct array - *NOT* DONE
# Create array of neighboring value INDECIES - *NOT* DONE
# Complete Flagger and Opener action loops - DONE*???*
# Comment all code - 70% DONE

.data
# your data allocation/initialization goes here

mainArr: .word 256	# Master Array
knownArr: .word 256	# Array of known values
nearArr: .word 32
indexArr: .word 32

.text

			# First code run
			swi   567	   	    # Bury mines (returns # buried in $1)
			add $5, $0, $0		# Creates initial variable to put flags in
			addi $7, $0, -1		# Initialize $7 to be value of a bomb
			addi $9, $0, 10		# Initialize $9 to be the value assigned to flagged squares
			add $29, $31, $0	# Save memory link
			addi $27, $0, 4		# Initialize $27 to 4 
			addi $8, $0, 8

			# INITIAL GUESS
			addi  $2, $0, 0		# Mine field position 0
            addi  $3, $0, -1    # Guess
            swi   568           # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip		# If the guess did not return a bomb, run skip
			addi $5, $5, 1		# Adds 1 to the total number of flags
			addi $4, $0, 9

			#mult $2, $27		# Get correct index
			#mfhi $28			# Load index into $28
			
skip:		sb $4, mainArr[$28]	# store the returned value into the master array
			sb $0, knownArr[$0] # Store the index of the guessed value into knownArr	

			# MAIN LOOP
Loop:		add $23, $0, $0		# Reset Flag conditional 
			add $24, $0, $0		# Reset Open conditional 
			j Flag				# Run the flag function
			j Open				# Run the Open function
			add $25, $24, $23	# Add both conditinoal values
			beq $26, $25 Guess	# If neither do anything, run Guess function
			bne $1, $5 Loop		# If the number of flags != number of bombs, keep looping
			jr  $29  	  		# return to OS



Open:		add $20, $0, $0
			add $21, $0, $0
			lbu $11, nearArr[$10]# Load current index value into $11
nearBombs:	lbu $19, nearArr[$20]
			addi $20, $20, 4	# Add 4 to array index
			bne $19, $7 nearBombs
			addi $21, $21, 1	# Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs
			bne $21, $11, Open

			# OPEN SQUARES
			add $14, $14, $0
			addi $23, $0, 1		# Make conditional true
opener:		lbu $12, nearArr[$14]# Index at first neighbor value
			addi $14, $14, 1	# Add 1 to the nearArr index-er
			bne $12, $13 opener # Check if the neighbor is closed, if not skip to next neighbor
			addi $5, $5, 1		# If so, add 1 to number of opened squares
			lbu $13 indexArr[$14]# Load the 
			sb $13, mainArr[$13]# Store the value of a opened square in the mainArr
			add  $2, $0, $13	# Mine field position 25
            addi  $3, $0, 0     # Open
            swi   568           # returns result in $4 (9)
			bne $14, $8, opener# Loop until Run through all indexes


Flag:		add $20, $0, $0
			add $21, $0, $0
			add $22, $0, $0
			add $16, $0, $0
			lbu $11, nearArr[$10]# Load current index value into $11
nearBombs:	lbu $19, nearArr[$20]
			addi $20, $20, 4	# Add 4 to array index
			bne $19, $7 nearBombs
			addi $21, $21, 1	# Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs
			add $20, $0, $0
nearClosed: lbu $19, nearArr[$20]
			addi $20, $20, 4	# Add 4 to array index
			bne $19, $9 nearClosed
			addi $22, $22, 1	# Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed
			add $18, $21, $22	# Finds total size
			addi $16, $16, 1	# Incriment $16 by 1
			beq $16, $17, end	# End if last index 
			bne $18, $11, Flag	# If Totalsize is not equal, loop back
			beq $0, $11, Flag	# If the current index equals zero, loop back
			beq $0, $22, Flag	# If number of closed squares nearby equals 0, loop back
			beq $11, $21, Flag	# If number of nearby flagged bombs equals the current index, loop back

			# ASSIGNS FLAGS
			add $14, $14, $0
			addi $24, $0, 1		# Make conditional true
flagger:	lbu $12, nearArr[$14]
			addi $14, $14, 1	# Add 1 to the nearArr index-er
			bne $12, $13 opener # Check if the neighbor is closed, if not skip to next neighbor
			addi $5, $5, 1		# If so, add 1 to number of flagged squares
			lbu $13 indexArr[$14]# Load the 
			sb $13, mainArr[$13]# Store the value of a flagged square in the mainArr
			add  $2, $0, $13	# Mine field position 25
            addi  $3, $0, 1     # Flag
            swi   568           # returns result in $4 (9)
			bne $14, $8, opener# Loop until Run through all indexes


# Index at first neighbor value
			# addi $14, $14, 1	# Add 1 to the nearArr index-er
			# bne $12, $13 flagger# Check if the neighbor is closed, if not skip to next neighbor
			# addi $5, $5, 1		# If so, add 1 to number of flagged squares
			# lbu $13 indexArr[$14]
			# sb $13, mainArr[$13]# Store the value of a flagged square in the mainArr
			# add  $2, $0, $13	# Mine field position 25
            # addi  $3, $0, 1     # Flag
            # swi   568           # returns result in $4 (9)
			# bne $14, $8, flagger# Loop until Run through all indexes

# upLeftF:	addi $24, $0, 1		# Make conditional true
# 			lbu $12, nearArr[$0]# Index at first neighbor value
# 			bne $12, $13 upF	# Check if the neighbor is closed, if not skip to next neighbor
# 			addi $5, $5, 1		# If so, add 1 to number of flagged squares
# 			sb $13, mainArr[]	# Store the value of a flagged square in the mainArr
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# upF:		addi $14, $0, 1		# Add 1 to the nearArr index-er
# 			lbu $12, nearArr[$14]
# 			bne $12, $13 upRightF
# 			addi $5, $5, 1
# 			sb $13, mainArr[]
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# upRightF:	addi $14, $0, 1
# 			lbu $12, nearArr[$14]
# 			bne $12, $13 rightF
# 			addi $5, $5, 1
# 			sb $13, mainArr[]
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# rightF:		addi $14, $0, 1
# 			lbu $12, nearArr[$14]
# 			bne $12, $13 leftF
# 			addi $5, $5, 1
# 			sb $13, mainArr[]
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# leftF:		addi $14, $0, 1
# 			lbu $12, nearArr[$14]
# 			bne $12, $13 botRightF
# 			addi $5, $5, 1
# 			sb $13, mainArr[]
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# botRightF:	addi $14, $0, 1
# 			lbu $12, nearArr[$14]
# 			bne $12, $13 botF
# 			addi $5, $5, 1
# 			sb $13, mainArr[]
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# botF:		addi $14, $0, 1
# 			lbu $12, nearArr[$14]
# 			bne $12, $13 botLeftF
# 			addi $5, $5, 1
# 			sb $13, mainArr[]
# 			addi  $2, $0, 25	# Mine field position 25
#             addi  $3, $0, 1     # Flag
#             swi   568           # returns result in $4 (9)

# botLeftF:	addi $14, $0, 1
			lbu $12, nearArr[$14]
			bne $12, $13 end
			addi $5, $5, 1
			sb $13, mainArr[]
			addi  $2, $0, 25	# Mine field position 25
            addi  $3, $0, 1     # Flag
            swi   568           # returns result in $4 (9)

end:		jr $31

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