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
    # $26 = Number of opened + flagged squares
    # $27 = 9 (Number of closed square)
    # $28 = value of neighbor square
    # $29 = Memory Location of exit
	# $30 = register used to return to previous command

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

			mainArr: .word 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF
			nearArr: .word 0xFFFFFFFF, 0xFFFFFFFF    # Array of neighbor squares' values
			indexArr: .word 0xFFFFFFFF, 0xFFFFFFFF     # Array of neighbor squares' indices 

.text
			# First code run
			swi   567	   	        # Bury mines (returns # buried in $1)
			add $5, $0, $0		    # Creates initial variable to put flags in
			addi $7, $0, -1		    # Initialize $7 to be value of a bomb
			addi $9, $0, 10		    # Initialize $9 to be the value assigned to flagged squares
			add $29, $31, $0	    # Save memory link
			addi $27, $0, 9		    # Initialize $27 to 9 
			addi $8, $0, 8		    # Initialize $8 to max value of neighbor arrays
			addi $13, $0, 1		    # Assume 1 square will be known from first guess

			    # INITIAL GUESS
			addi  $2, $0, 0		    # Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip		    # If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9
			
skip:		sb $4, mainArr($0)	    # store the returned value into the master array
			#sb $0, mainArr($0)      # Store the index of the guessed value into mainArr	

			    # MAIN LOOP
MainLoop:	add $23, $0, $0		    # Reset Flag conditional 
			add $24, $0, $0		    # Reset Open conditional 
			add $10, $0, $0
			jal Flag				    # Run the flag function
			add $10, $0, $0
			jal Open				    # Run the Open function
			add $25, $24, $23	    # Add both conditinoal values
			addi $16, $0, 255
			beq $0, $25 Guess	    # If neither do anything, run Guess function
			bne $1, $5 MainLoop	    # If the number of flags != number of bombs, keep looping
			jr  $29  	  		    # return to OS - ENDS


Open:		add $30, $31, $0
			add $20, $0, $0		    # (Re-)Initialize index-ers
			addi $21, $0, 1
			add $16, $0, $0
			add $28, $0, $0
			
			#lbu $11, mainArr($10)  # Load current index value into $11
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
			div $10, $28
			mfhi	$18
			beq $18 $0, NoW
			
			addi $17, $0, 7
			div $10, $28
			mfhi	$18
			beq $17 $18, NoE
			j neighbors



nearBombsO:	lbu $19, nearArr($20)   # Load current neighbor value into $19
			addi $20, $20, 1	    # Add 1 to array index
			beq $20, $8 endifO		# Loop until the index value is 7
			bne $19, $7 nearBombsO  # If the neighbor is not a bomb, re-loop
			addi $16, $16, 1	    # Add 1 to count of nearby flagged squares
			bne $16, $11, Open	    # If the square's value is equal to the number of flagged squares, skip

			# OPENS SQUARES
			add $14, $14, $0	    # (Re-)Initialize index-er
			addi $23, $0, 1		    # Make conditional true
opener:		lbu $12, nearArr($14)   # Index at first neighbor value
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			bne $14, $8, opener     # Loop until Run through all indexes
			bne $12, $27 opener     # Check if the neighbor is closed, if not skip to next neighbor
			addi $13, $13, 1		# Add 1 to number of known values
			lbu $13 indexArr($14)   # Load the index of the neighbor square into $13
			add  $2, $0, $13	    # Mine field position 25
            addi  $3, $0, 0         # Open
            swi   568               # returns result in $4 (9)
			sb $4, mainArr($13)     # Store the value of a opened square in the mainArr
endifO:		addi $10, $0, 1
			bne $10, $13, Open	    # Loop Open until run through all squares availables
			jr $30

Flag:		add $30, $31, $0
			add $20, $0, $0		    # (Re-)Initialize index-ers
			add $21, $0, $0
			add $22, $0, $0
			lbu $11, mainArr($10)  # Load current index value into $11
			# CREATES INDEX OF NEIGHBOR VALUES

			beq $10, $0 NoNW		# These are selectors to decide which loop to run 
			addi $28, $0, 7
			beq $10, $28 NoNE		# For example, if the current array index is 124, we know that this is the pixel with no North or East neighbors
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

			addi $28, $0, 8			# I use Mod to find whether a pixel is at an index with no East or West neighbor
			div $10, $28
			mfhi	$18
			beq $18 $0, NoW
			
			addi $17, $0, 7
			div $10, $28
			mfhi	$18
			beq $17 $18, NoE
			j neighbors


nearBombs:	lbu $11, mainArr($10)   # Load current index value into $11
			lbu $19, nearArr($20)   # Load neighbor value to index
			addi $20, $20, 1	    # Add 1 to array index
			beq $20, $8 endif		# Loop until the index value is 7
			bne $19, $7 nearBombs	# If the value of the square is not a bomb, skip it
			addi $21, $21, 1	    # Add 1 to count of nearby flagged squares
			add $20, $0, $0
nearClosed: lbu $19, nearArr($20)
			addi $20, $20, 1	    # Add 1 to array index
			bne $19, $9 nearClosed
			addi $22, $22, 1	    # Add 1 to count of nearby closed squares
			bne $20, $8 nearClosed
			add $18, $21, $22	    # Finds total size
			bne $18, $11, Flag	    # If Totalsize is not equal, loop back
			beq $0, $11, Flag	    # If the current index equals zero, loop back
			beq $0, $22, Flag	    # If number of closed squares nearby equals 0, loop back
			beq $11, $21, Flag	    # If number of nearby flagged bombs equals the current index, loop back
			bne $10, $13, Flag		# Keep looping until all known values are run through

			# ASSIGNS FLAGS
			add $14, $14, $0	    # (Re-)Initialize index-er
			addi $24, $0, 1		    # Make conditional true
flagger:	lbu $12, nearArr($14)	# Load the value of the neighbor into $12
			addi $14, $14, 1	    # Add 1 to the nearArr index-er
			bne $14, $8, flagger    # Loop until Run through all indexes
			beq $12, $9 flagger     # Check if the neighbor is flagged, if not skip to next neighbor
			addi $13, $13, 1		# Add 1 to number of known values
			addi $5, $5, 1		    # If neighbor is not closed, add 1 to number of flagged squares
			lbu $13 indexArr($14)   # Load the neighbor index value into $13
			add  $2, $0, $13	    # Mine field position 25
            addi  $3, $0, 1         # Flag
            swi   568               # returns result in $4 (9)
			sb $4, mainArr($13)     # Store the value of a flagged square in the mainArr
endif:		addi $10, $0, 1
			bne $20, $13, Flag	    # Loop Flag until run through all squares availables
			jr $30

Guess:		addi $23, $23, 1
			lbu $24, mainArr($23)
			bne $24, $16, Guess		# If the index of mainArr at $23 isnt FF, then loop until it does
			add  $2, $0, $23		# Mine field position 0
            addi  $3, $0, -1        # Guess
            swi   568               # returns result in $4 (-1: mine; 0-8: count)
			bne $4, $7 skip		    # If the guess did not return a bomb, run skip
			addi $5, $5, 1		    # Adds 1 to the total number of flags
			addi $4, $0, 9
			j skip


NoNW:		jal E
			jal S
			jal SE
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO

NoNE:		jal W
			jal SW
			jal S
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO


NoSW:		jal N
			jal NE
			jal E
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO
			


NoSE:		jal NW
			jal N
			jal W
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO


NoN:		jal W
			jal E
			jal SW
			jal S
			jal SE
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO


NoW:		jal N
			jal NE
			jal E
			jal S
			jal SE
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO


NoE:		jal NW
			jal N
			jal W
			jal SW
			jal S
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO


NoS:		jal NW
			jal N
			jal NE
			jal W
			jal E
			add $20, $0, $0
			beq $21, $0 nearBombs
			j nearBombsO



	 
			 # Value and index of northwest neighbor
neighbors:  jal NW
			jal N
			jal NE
			jal W
			jal E
			jal SW
			jal S
			jal SE
			beq $21, $0 nearBombs
			add $20, $0, $0
			j nearBombsO


NW:			addi $28, $10, -9
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of north neighbor
N:			addi $28, $10, -8
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of northeast neighbor
NE: 		addi $28, $10, -7
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of west neighbor
W:			addi $28, $10, -1
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of east neighbor
E:			addi $28, $10, +1
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of southwest neighbor
SW:			addi $28, $10, +7
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of south neighbor
S:			addi $28, $10, +8
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

			# Value and index of southeast neighbor
SE:			addi $28, $10, +9
			sb $28, indexArr($20)
			lbu $18, mainArr($28)
			sb $18, nearArr($20)
			addi $20, $20, 1
			jr $31

    # Index at first neighbor value
			    # addi $14, $14, 1	    # Add 1 to the nearArr index-er
			    # bne $12, $13 flagger    # Check if the neighbor is closed, if not skip to next neighbor
			    # addi $5, $5, 1		    # If so, add 1 to number of flagged squares
			    # lbu $13 indexArr($14)
			    # sb $13, mainArr($13)    # Store the value of a flagged square in the mainArr
			    # add  $2, $0, $13	    # Mine field position 25
                # addi  $3, $0, 1         # Flag
                # swi   568               # returns result in $4 (9)
			    # bne $14, $8, flagger    # Loop until Run through all indexes

    # upLeftF:	addi $24, $0, 1		    # Make conditional true
    # 			lbu $12, nearArr($0)    # Index at first neighbor value
    # 			bne $12, $13 upF	    # Check if the neighbor is closed, if not skip to next neighbor
    # 			addi $5, $5, 1		    # If so, add 1 to number of flagged squares
    # 			sb $13, mainArr()	    # Store the value of a flagged square in the mainArr
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # upF:		addi $14, $0, 1		    # Add 1 to the nearArr index-er
    # 			lbu $12, nearArr($14)
    # 			bne $12, $13 upRightF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr()
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # upRightF:	addi $14, $0, 1
    # 			lbu $12, nearArr($14)
    # 			bne $12, $13 rightF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr()
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # rightF:		addi $14, $0, 1
    # 			lbu $12, nearArr($14)
    # 			bne $12, $13 leftF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr()
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # leftF:		addi $14, $0, 1
    # 			lbu $12, nearArr($14)
    # 			bne $12, $13 botRightF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr()
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # botRightF:	addi $14, $0, 1
    # 			lbu $12, nearArr($14)
    # 			bne $12, $13 botF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr()
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # botF:		addi $14, $0, 1
    # 			lbu $12, nearArr($14)
    # 			bne $12, $13 botLeftF
    # 			addi $5, $5, 1
    # 			sb $13, mainArr()
    # 			addi  $2, $0, 25	    # Mine field position 25
    #             addi  $3, $0, 1         # Flag
    #             swi   568               # returns result in $4 (9)

    # botLeftF:	addi $14, $0, 1
			    # lbu $12, nearArr($14)
			    # bne $12, $13 end
			    # addi $5, $5, 1
			    # sb $13, mainArr()
			    # addi  $2, $0, 25	    # Mine field position 25
                # addi  $3, $0, 1         # Flag
                # swi   568               # returns result in $4 (9)

			    #addi $26, $0, $0	    # Creates value for number of flagged and/or opened squares