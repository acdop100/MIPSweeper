#     Minesweeper
#
#  Your Name:	James Lehman
#  Date:	10/5/18
.data

# your data allocation/initialization goes here



# $1 = number of mines buried
# $2 = mine position
# $3 = command register
# $4 = the returned value from the command
# $5 = number of bombs flagged
# $6 = master array
# $7 = -1
# 
# 
# 
# 
# $27 = 4
# $28 

Arr: .alloc []

.text

MineSweep:	swi   567	   	    # Bury mines (returns # buried in $1)
			add $5, $0, $0		# Creates initial variable to put flags in
			addi $7, $0, -1
			add $29, $31, $0	# Save memory link
			addi $27, $0, 4

			# INITIAL GUESS
			addi  $2, $0, 0		# Mine field position 0
            addi  $3, $0, -1    # Guess
            swi   568           # returns result in $4 (-1: mine; 0-8: count)
			beq $4, $7 bomb
			
			mult $2, $27
			mfhi $28
			lw $4, Arr[$28]

Loop:		j Flag				# Run the flag function
			j Open				# Run the Open function
			add $25, $24, $23	# Add both conditinoal values
			beq $26, $25 Guess	# If neither do anything, run guess function
			bne $1, $5 Loop		# If the number of flags != number of bombs, keep looping
			jr  $29  	  		# return to OS
          

bomb:		addi $5, $5, 1		# Adds 1 to the total number of flags
			jr $31



Open:		



Flag:		


Guess:		



	   # TEMP: open square 9 ($2: position, $3: command to OPEN)
           addi  $2, $0, 9		# Mine field position 9
           addi  $3, $0, 0      # Open
           swi   568            # returns result in $4 (-1: mine; 0-8: count)

	   # TEMP: flag square 25 ($2: position, $3: command to FLAG)
           addi  $2, $0, 25		# Mine field position 25
           addi  $3, $0, 1      # Flag
           swi   568            # returns result in $4 (9)

           # your code goes here