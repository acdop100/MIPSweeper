    #     Minesweeper
    #
    #  Your Name:	James Lehman
    #  Date:	10/5/18

    # $1 = Number of mines buried
    # $2 = Mine position
    # $3 = Command register
    # $4 = The returned value from the command
    # $5 = Number of bombs flagged
    # $6 = 
    # $7 = -1
    # $8 = max index of nearArr, 0-7
    # $9 = 9 (value of flagged of mainArr)
    # $10 = Current master index
    # $11 = Where mainArr($10) is loaded into
    # $12 = NearArr indexer
    # $13 = Number of values in mainArr
    # $16 = flag loop conditional
    # $17 = 
	# $18 = 
    # #19 = Value of nearArr(i)
    # $20 = Array index-er
    # $21 = Number of nearby closed squares
    # $22 = Number of nearby bombs
    # $23 = Open conditional
    # $24 = Flag conditional
    # $25 = Guess conditional
    # $26 = 
    # $27 = 9 (Number of closed square)
    # $28 = value of neighbor square
    # $29 = Memory Location of exit

    # Allocate arrays - DONE*???*
    # Complete main Loop outline - DONE
    # Complete flagger and Opener sorting logic - DONE
    # Complete flagger and Opener action loops - DONE
    # Make sure "jr"'s are functioning properly - *NOT* DONE
    # Make sure the program is indexing correctly - *NOT* DONE
    # Create array of neighboring values and assign to correct array - DONE
    # Create array of neighboring value indices - DONE
    # Comment all code - 90% DONE

.data

			mainArr: .word 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE
			nearArr: .word 0xEEEEEEEE, 0xEEEEEEEE    # Array of neighbor squares' values
			indexArr: .word 0xEEEEEEEE, 0xEEEEEEEE     # Array of neighbor squares' indices 
			doneArr: .word 0x00000000, 0x00000000     # Array of indices I have already done

.text
			# First code run
			swi   567	   	        # Bury mines (returns # buried in $1)
			add $5, $0, $0		    # Creates initial variable to put flags in
			addi $7, $0, -1		    # Initialize $7 to be value of a bomb
			addi $9, $0, 9		    # Initialize $9 to be the value assigned to flagged squares
			add $10, $0, $0
			addi $13, $0, 1			# Assume 1 square will be known from first guess
			add $16, $0, $0
			addi $17, $0, 0
			add $20, $0, $0
			add $21, $0, $0
			add $23, $0, $0
			addi $27, $0, 238		# Initialize $27 to 0
			add $29, $31, $0	    # Save memory link

			    # INITIAL GUESS
			addi  $2, $0, 0		    # Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip1	    # If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9			# make $4 9 because thats my value of a bomb
			sb $4, mainArr($23)		# store the returned value into the master array
			sb $23, indexArr($10)     # Store the index of the guessed value into mainArr
			j Guess					# Since we had a bomb on first guess, guess again. 

skip1:		beq $4, $0 skip2	    # If the guess did not return a bomb, run skip 
			sb $4, mainArr($23)		# store the returned value into the master array
			sb $23, indexArr($23)     # Store the index of the guessed value into mainArr
			#j Guess	
			j MainLoop

skip2:		sb $4, mainArr($23)	    # store the returned value into the master array
			sb $23, indexArr($23)     # Store the index of the guessed value into mainArr			

			    # MAIN LOOP
MainLoop:	addi $23, $0, 09
			add $23, $0, $0		    # Reset Flag conditional 
			add $24, $0, $0		    # Reset Open conditional
			add $10, $0, $0
			jal Flag				    # Run the flag function
nowOpen:	add $10, $0, $0
			add $17, $0, $0
			jal Open				    # Run the Open function
nowCheck:	add $25, $24, $23	    # Add both conditinoal values
			beq $0, $25 Guess	    # If neither do anything, run Guess function
			bne $1, $5 MainLoop	    # If the number of flags != number of bombs, keep looping
end:		jr  $29  	  		    # return to OS - ENDS
	
Flag:		lbu $11, mainArr($10)  # Load current index value into $11
			add $26, $10, $0
			beq $11, $9, endif
			beq $11, $0, endif
			add $20, $0, $10
			beq $11, $27, newVal
	
			#add $25, $10, $0
			
return:		add $6, $0, $0			# (Re-)Initialize index-ers
			add $20, $0, $0		    
			add $22, $0, $0
			add $28, $0, $0
			addi $21, $0, 1
			beq $11, $9, endif
			beq $11, $0, endif
			# CREATES INDEX OF NEIGHBOR VALUES
			j neighVals


nearBombs:	lbu $19, nearArr($20)   # Load neighbor value to index
			addi $20, $20, 1	    # Add 1 to array index
			beq $20, $8 nearClose	# Loop until the index value is 7
			bne $19, $9 nearBombs	# If the value of the square is not a bomb, skip it
			addi $6, $6, 1	    	# Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs	# Loop until the index value is 7
nearClose:	add $20, $0, $0
nearClosed: lbu $19, nearArr($20)
			addi $20, $20, 1	    # Add 1 to array index
			beq $20, $8 check		# Loop until the index value is 7
			bne $19, $27 nearClosed	# Loop if the index is not unknown
			addi $22, $22, 1	    # Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed	# Loop until the index value is 7
			

check:		add $18, $6, $22	    # Finds total size
			bne $18, $11, endif	    # If Totalsize is not equal, loop back
			beq $0, $11, endif	    # If the current index equals zero, loop back
			beq $0, $22, endif	    # If number of closed squares nearby equals 0, loop back
			beq $11, $6, endif	    # If number of nearby flagged bombs equals the current index, loop back

			# ASSIGNS FLAGS
			add $14, $0, $0	    # (Re-)Initialize index-er
flagger:	lbu $12, nearArr($14)	# Load the value of the neighbor into $12
			lbu $11 indexArr($14)   # Load the neighbor index value into $13
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			beq $14, $8, endif	    # Loop until Run through all indexes
			bne $12, $27 flagger    # Check if the neighbor is empty, if not skip to next neighbor
			addi $24, $0, 1		    # Make conditional true
			addi $13, $13, 1		# Add 1 to number of known values
			addi $5, $5, 1		    # If neighbor is not closed, add 1 to number of flagged squares
			add  $2, $0, $11	    # Mine field position 25
            addi  $3, $0, 1         # Flag
            swi   568               # returns result in $4 (9)
			addi $4, $0, 9			# make $4 9 because thats my value of a bomb
			sb $4, mainArr($11)     # Store the value of a flagged square in the mainArr
			bne $14, $8, flagger     # Loop until Run through all indexes
endif:		addi $10, $10, 1
			beq $1, $5, end
			bne $10, $13, Flag	    # Loop Flag until run through all squares availables
			j nowOpen

Open:		lbu $11, mainArr($10)   # Load current neighbor value into $19
			beq $11, $9, endifO
			add $26, $10, $0
			add $20, $0, $0
			beq $11, $27, newVal
			#add $25, $10, $0
			
returnO:	add $21, $0, $0		    # (Re-)Initialize index-ers
			add $16, $0, $0
			j neighVals

nearBombsO:	beq $11, $0, openZ
nearBombss: lbu $19, nearArr($20)   # Load current neighbor value into $19
			addi $20, $20, 1	    # Add 1 to array index
			beq $20, $8 veriO	# Loop until the index value is 7
			bne $19, $9 nearBombss  # If the neighbor is not a bomb, re-loop
			addi $16, $16, 1	    # Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombss	# Loop until the index value is 7

			# OPENS SQUARES
veriO:		bne $16, $11, endifO

openZ:		add $16, $0, $0			# (Re-)Initialize index-er
			add $14, $0, $0	    	

opener:		lbu $12, nearArr($14)   # Index at first neighbor value
			lbu $11 indexArr($14)   # Load the index of the neighbor square into $13
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			beq $14, $8, endifO     # Loop until Run through all indexes
			bne $12, $27 opener     # Check if the neighbor is closed, if not skip to next neighbor
			addi $23, $0, 1		    # Make conditional true
			addi $13, $13, 1		# Add 1 to number of known values
			add  $2, $0, $11	    # Mine field position $11
            addi  $3, $0, 0         # Open
            swi   568               # returns result in $4 (9)
			sb $4, mainArr($11)     # Store the value of a opened square in the mainArr
			bne $14, $8, opener     # Loop until Run through all indexes
			
endifO:		addi $10, $10, 1
			beq $1, $5, end
			bne $10, $13, Open	    # Loop Open until run through all squares availables
			j nowCheck

Guess:		addi $23, $23, 1
			lbu $24, mainArr($23)
			bne $24, $27, Guess		# If the index of mainArr at $23 isnt FF, then loop until it does
			add  $2, $0, $23		# Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			addi $13, $13, 1
			bne $4, $7 skip2		# If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9
			j skip2


newVal: 	addi $26, $26, 1		
			lbu $21, mainArr($26)	
			beq $21, $27, newVal	# If the index of mainArr at $23 isnt FF, then loop until it does
			slt $4, $17, $26
			beq $4, $0 newVal
			beq $17, $26, newVal
valPass:	lbu $11, mainArr($26)   # Load current neighbor value into $19
			add $17, $26, $0
			bne $20, $0, return
			j returnO




neighVals:  beq $26, $0 NoNW		# These are selectors to decide which loop to run 
			addi $28, $0, 7
			beq $26, $28 NoNE		# For example, if the current array index is 124, we know that this is the pixel with no North or East neighbors
			addi $28, $0, 55
			beq $26, $28 NoSW
			addi $28, $0, 62
			beq $26, $28 NoSE

			addi $2, $0, 7
			slt $18, $26, $2
			bne $18, $0, NoN

			addi $2, $0, 55
			slt $18, $2, $26
			bne $18, $0, NoS

			addi $28, $0, 8			# I use Mod to find whether a pixel is at an index with no East or West neighbor
			div $26, $28
			mfhi	$18
			beq $18 $0, NoW
			
			addi $28, $0, 8
			div $26, $28
			mfhi	$18
			addi $28, $0, 7
			beq $28, $18, NoE
			j neighbors


NoNW:		jal E
			jal S
			jal SE
			add $20, $0, $0
			addi $8, $0, 4		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs

NoNE:		jal W
			jal SW
			jal S
			add $20, $0, $0
			addi $8, $0, 4		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs


NoSW:		jal N
			jal NE
			jal E
			add $20, $0, $0
			addi $8, $0, 4		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs
			


NoSE:		jal NW
			jal N
			jal W
			add $20, $0, $0
			addi $8, $0, 4		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs


NoN:		jal W
			jal E
			jal SW
			jal S
			jal SE
			add $20, $0, $0
			addi $8, $0, 6		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs


NoW:		jal N
			jal NE
			jal E
			jal S
			jal SE
			add $20, $0, $0
			addi $8, $0, 6		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs


NoE:		jal NW
			jal N
			jal W
			jal SW
			jal S
			add $20, $0, $0
			addi $8, $0, 6		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs


NoS:		jal NW
			jal N
			jal NE
			jal W
			jal E
			add $20, $0, $0
			addi $8, $0, 6		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs



	 
			 # Value and index of northwest neighbor
neighbors:  jal NW
			jal N
			jal NE
			jal W
			jal E
			jal SW
			jal S
			jal SE
			add $20, $0, $0
			addi $8, $0, 9		    # Initialize $8 to max value of neighbor arrays
			beq $21, $0 nearBombsO
			j nearBombs


NW:			addi $28, $26, -9
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of north neighbor
N:			addi $28, $26, -8
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of northeast neighbor
NE: 		addi $28, $26, -7
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of west neighbor
W:			addi $28, $26, -1
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of east neighbor
E:			addi $28, $26, +1
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of southwest neighbor
SW:			addi $28, $26, +7
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of south neighbor
S:			addi $28, $26, +8
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of southeast neighbor
SE:			addi $28, $26, +9
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31