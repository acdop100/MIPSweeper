    #     Minesweeper
    #
    #  Your Name:	James Lehman
    #  Date:	10/5/18

    # $1 = Number of mines buried
    # $2 = Mine position
    # $3 = Command register
    # $4 = The returned value from the command
    # $5 = Number of bombs flagged
    # $6 = Master array
    # $7 = -1
    # $8 = 7 (max index of nearArr, 0-7)
    # $9 = 10 (value of flagged of mainArr)
    # $10 = Current master index
    # $11 = Where mainArr[$10] is loaded into
    # $12 = NearArr indexer
    # $13 = Number of values in knownArr
    # $16 = flag loop conditional
    # $17 = 
	# $18 = 
    # #19 = Value of nearArr[i]
    # $20 = Array index-er
    # $21 = Number of nearby closed squares
    # $22 = Number of nearby bombs
    # $23 = Open conditional
    # $24 = Flag conditional
    # $25 = Guess conditional
    # $26 = Number of opened + flagged squares
    # $27 = 9 (Number of closed square)
    # $28 = value of neighbor square
    # $29 = Memory Location of exit

    # Allocate arrays - DONE*???*
    # Complete main Loop outline - DONE
    # Complete flagger and Opener sorting logic - DONE
    # Complete flagger and Opener action loops - DONE
    # Make sure "jr"'s are functioning properly - *NOT* DONE
    # Make sure the program is indexing correctly - *NOT* DONE
    # Create array of neighboring values and assign to correct array - *NOT* DONE
    # Create array of neighboring value indices - *NOT* DONE
    # Comment all code - 90% DONE

.data

mainArr: .word 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909
knownArr: .word 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909	    # Array of known values
nearArr: .word 0x09090909, 0x09090909, 0x09090909, 0x09090909     # Array of neighbor squares' values
indexArr: .word 0x09090909, 0x09090909, 0x09090909, 0x09090909     # Array of neighbor squares' indices 

.text
			    # First code run
			swi   567	   	        # Bury mines (returns     # buried in $1)
			add $5, $0, $0		    # Creates initial variable to put flags in
			addi $7, $0, -1		    # Initialize $7 to be value of a bomb
			addi $9, $0, 10		    # Initialize $9 to be the value assigned to flagged squares
			add $29, $31, $0	    # Save memory link
			addi $27, $0, 9		    # Initialize $27 to 9 
			addi $8, $0, 7		    # Initialize $8 to max value of neighbor arrays
			addi $13, $0, 1		    # Assume 1 square will be known from first guess

			    # INITIAL GUESS
			addi  $2, $0, 0		    # Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip		    # If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9
			
skip:		sb $4, mainArr[$0]	    # store the returned value into the master array
			sb $0, knownArr[$0]     # Store the index of the guessed value into knownArr	

			    # MAIN LOOP
MainLoop:	add $23, $0, $0		    # Reset Flag conditional 
			add $24, $0, $0		    # Reset Open conditional 
			j Flag				    # Run the flag function
			j Open				    # Run the Open function
			add $25, $24, $23	    # Add both conditinoal values
			beq $0, $25 Guess	    # If neither do anything, run Guess function
			bne $1, $5 MainLoop	    # If the number of flags != number of bombs, keep looping
			jr  $29  	  		    # return to OS - ENDS


Open:		add $20, $0, $0		    # (Re-)Initialize index-ers
			add $21, $0, $0
			add $28, $0, $0
			add $10, $0, $0
			addi $10, $10, 1	    # Add 1 to known squares index-er
			lbu $11, knownArr[$10]  # Load current index value into $11
			# CREATES INDEX OF NEIGHBOR VALUES

			# Value and index of northwest neighbor
			addi $28, $10, -9
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of north neighbor
			addi $28, $10, -8
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of northeast neighbor
			addi $28, $10, -7
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of west neighbor
			addi $28, $10, -1
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of east neighbor
			addi $28, $10, +1
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of southwest neighbor
			addi $28, $10, +7
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of south neighbor
			addi $28, $10, +8
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1

			# Value and index of southeast neighbor
			addi $28, $10, +9
			sb $28, indexArr[$20]
			lbu $18, masterArr[$28]
			sb $18, nearArr[$20]
			addi $20, $20, 1


nearBombsO:	lbu $19, nearArr[$20]   # Load current neighbor value into $19
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $7 nearBombsO  # If the neighbor is not a bomb, re-loop
			addi $21, $21, 1	    # Add 1 to count of nearby flagged squares
			bne $21, $11, Open	    # If the square's value is equal to the number of flagged squares, skip
			beq $20, $8 opener      # Loop through values until all of the neighbor values have been run through
			bne $10, $13, Open		# Keep looping until all known values are run through
			jr $31

			# OPENS SQUARES
			add $14, $14, $0	    # (Re-)Initialize index-er
			addi $23, $0, 1		    # Make conditional true
opener:		lbu $12, nearArr[$14]   # Index at first neighbor value
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			bne $12, $27 opener      # Check if the neighbor is closed, if not skip to next neighbor
			addi $13, $13, 1		# Add 1 to number of known values
			addi $5, $5, 1		    # If so, add 1 to number of opened squares
			lbu $13 indexArr[$14]   # Load the index of the neighbor square into $13
			add  $2, $0, $13	    # Mine field position 25
            addi  $3, $0, 0         # Open
            swi   568               # returns result in $4 (9)
			sb $4, mainArr[$13]     # Store the value of a opened square in the mainArr
			bne $14, $8, opener     # Loop until Run through all indexes
			bne $20, $13, Open	    # Loop Open until run through all squares availables



Flag:		add $20, $0, $0		    # (Re-)Initialize index-ers
			add $21, $0, $0
			add $22, $0, $0
			add $16, $0, $0
			add $10, $0, $0
			addi $10, $10, 1	    # Add 1 to known squares index-er
			lbu $11, knownArr[$10]  # Load current index value into $11
			# CREATES INDEX OF NEIGHBOR VALUES

			beq $10, $0 NoNW	# These are selectors to decide which loop to run 
			addi $28, $0, 7
			beq $10, $28 NoNE	# For example, if the current array index is 124, we know that this is the pixel with no North or East neighbors
			addi $28, $0, 55
			beq $10, $28 NoSW
			addi $28, $0, 63
			beq $10, $28 NoSE

			addi $2, $0, 7
			slt $18, $10, $2
			bne $18, $0, NoN

			addi $2, $0, 55
			slt $18, $2, $10
			bne $18, $0, NoS

			addi $28, $0, 8		# I use Mod to find whether a pixel is at an index with no East or West neighbor
			div $1, $28
			mfhi	$18
			beq $18 $0, NoW
			
			addi $17, $0, 7
			div $1, $28
			mfhi	$18
			beq $17 $18, NoE


nearBombs:	lbu $11, knownArr[$10]  # Load current index value into $11
			lbu $19, nearArr[$20]   # Load neighbor value to index
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $7 nearBombs
			addi $21, $21, 1	    # Add 1 to count of nearby flagged squares
			bne $20, $8 nearBombs
			add $20, $0, $0
nearClosed: lbu $19, nearArr[$20]
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $9 nearClosed
			addi $22, $22, 1	    # Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed
			add $18, $21, $22	    # Finds total size
			addi $16, $16, 1	    # Incriment $16 by 1 
			bne $18, $11, Flag	    # If Totalsize is not equal, loop back
			beq $0, $11, Flag	    # If the current index equals zero, loop back
			beq $0, $22, Flag	    # If number of closed squares nearby equals 0, loop back
			beq $11, $21, Flag	    # If number of nearby flagged bombs equals the current index, loop back
			bne $16, $8, flagger    # Loop until Run through all indexes
			bne $10, $13, Flag		# Keep looping until all known values are run through
			jr $31

			# ASSIGNS FLAGS
			add $14, $14, $0	    # (Re-)Initialize index-er
			addi $24, $0, 1		    # Make conditional true
flagger:	lbu $12, nearArr[$14]	# Load the value of the neighbor into $12
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			beq $12, $9 flagger     # Check if the neighbor is flagged, if not skip to next neighbor
			addi $13, $13, 1		# Add 1 to number of known values
			addi $5, $5, 1		    # If neighbor is not closed, add 1 to number of flagged squares
			lbu $13 indexArr[$14]   # Load the neighbor index value into $13
			add  $2, $0, $13	    # Mine field position 25
            addi  $3, $0, 1         # Flag
            swi   568               # returns result in $4 (9)
			sb $4, mainArr[$13]     # Store the value of a flagged square in the mainArr
			bne $14, $8, flagger    # Loop until Run through all indexes
			bne $20, $18, Flag	    # Loop Flag until run through all squares availables
			jr $31

Guess:		addi  $2, $0, 0		    # Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			beq $4, $7 bomb
			jr $31

    # Index at first neighbor value
			    # addi $14, $14, 1	    # Add 1 to the nearArr index-er
			    # bne $12, $13 flagger    # Check if the neighbor is closed, if not skip to next neighbor
			    # addi $5, $5, 1		    # If so, add 1 to number of flagged squares
			    # lbu $13 indexArr[$14]
			    # sb $13, mainArr[$13]    # Store the value of a flagged square in the mainArr
			    # add  $2, $0, $13	    # Mine field position 25
                # addi  $3, $0, 1         # Flag
                # swi   568               # returns result in $4 (9)
			    # bne $14, $8, flagger    # Loop until Run through all indexes

    # upLeftF:	addi $24, $0, 1		    # Make conditional true
    # 			lbu $12, nearArr[$0]    # Index at first neighbor value
    # 			bne $12, $13 upF	    # Check if the neighbor is closed, if not skip to next neighbor
    # 			addi $5, $5, 1		    # If so, add 1 to number of flagged squares
    # 			sb $13, mainArr[]	    # Store the value of a flagged square in the mainArr
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # upF:		addi $14, $0, 1		    # Add 1 to the nearArr index-er
    # 			lbu $12, nearArr[$14]
    # 			bne $12, $13 upRightF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr[]
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # upRightF:	addi $14, $0, 1
    # 			lbu $12, nearArr[$14]
    # 			bne $12, $13 rightF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr[]
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # rightF:		addi $14, $0, 1
    # 			lbu $12, nearArr[$14]
    # 			bne $12, $13 leftF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr[]
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # leftF:		addi $14, $0, 1
    # 			lbu $12, nearArr[$14]
    # 			bne $12, $13 botRightF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr[]
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # botRightF:	addi $14, $0, 1
    # 			lbu $12, nearArr[$14]
    # 			bne $12, $13 botF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr[]
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # botF:		addi $14, $0, 1
    # 			lbu $12, nearArr[$14]
    # 			bne $12, $13 botLeftF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr[]
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # botLeftF:	addi $14, $0, 1
			    # lbu $12, nearArr[$14]
			    # bne $12, $13 end
			    # addi $5, $5, 1
			    # sb $13, mainArr[]
			    # addi  $2, $0, 25	    # Mine field position 25
                # addi  $3, $0, 1         # Flag
                # swi   568               # returns result in $4 (9)

			    #addi $26, $0, $0	    # Creates value for number of flagged and/or opened squares