/*    This program solves a minesweeper game.

PLEASE FILL IN THESE FIELDS:
Your Name: James Lehman
Date: 09/22/18
 */

#include "minefield.h"

int initial, i, j, k, q, w, e, r, newGuess, p1, p2, foundFlag, getOut, v1, v2;
int foundBombs = 0;
int masterArray[8][8];
int closedSquares[8];
//int valueArr[8];


int checkFlags(int *foundBombs, int (*masterArray)[8]) {
    foundFlag = 0;
    // Scan across grid to see if coord has q neighbors, if true call "flag" on all neighbors
    // if you ever find one update foundFlag

    for (i = 0; i < 8; i++) {
        for (j = 0; j < 8; j++) { // Index through all points in the array 
            
            // Create array of neighboring values
            int valueArr[] = {masterArray[i + 1][j - 1], masterArray[i + 1][j], masterArray[i + 1][j + 1], 
            masterArray[i][j - 1], masterArray[i][j + 1], masterArray[i - 1][j - 1], masterArray[i - 1][j], masterArray[i - 1][j + 1]};
            size_t arrSize = sizeof(valueArr) / sizeof(valueArr[0]);
            
            // If square is an edge, modify the array
            if ((i == 0) && (j == 0)) {
                valueArr[0] = -3;
                valueArr[3] = -3;
                valueArr[5] = -3;
                valueArr[6] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            } else if ((i==0) && (j==7)) {
                valueArr[2] = -3;
                valueArr[4] = -3;
                valueArr[5] = -3;
                valueArr[6] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            } else if ((i==7) && (j==0)) {
                valueArr[0] = -3;
                valueArr[1] = -3;
                valueArr[2] = -3;
                valueArr[3] = -3;
                valueArr[5] = -3;
                arrSize = arrSize - 5;
            } else if ((i==7) && (j==7)) {
                valueArr[0] = -3;
                valueArr[1] = -3;
                valueArr[2] = -3;
                valueArr[4] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            } else if (i == 0) {
                valueArr[5] = -3;
                valueArr[6] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 3;
            } else if (i == 7) {
                valueArr[0] = -3;
                valueArr[1] = -3;
                valueArr[2] = -3;
                arrSize = arrSize - 5;
            } else if (j == 0) {
                valueArr[0] = -3;
                valueArr[3] = -3;
                valueArr[5] = -3;
                arrSize = arrSize - 5;
            } else if (j == 7) {
                valueArr[2] = -3;
                valueArr[4] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            };

            // Initialize variables for number of closed neighbors and bombs
            int numOfClosedArrays = 0; 
            int numOfNearbyBombs = 0;

            for (e = 0; e < 8; e++) {
                closedSquares[e] = 0;
            }; // Create empty array of zeroes

            for (w = 0; w < arrSize; w++) {
                if (valueArr[w] <= -1)
                {
                    closedSquares[w] = w;
                }
            }; // find how many unopened neighbors there are
        
            for (w = 0; w < 8; w++) {
                if (valueArr[w] == -2) {
                    numOfClosedArrays++;
                };
            }; // find how many unopened neighbors there are

            for (w = 0; w < 8; w++) {
                if (valueArr[w] == -1) {
                    numOfNearbyBombs++;
                };
            }; // find how many bomb neighbors there are

            int totalSize = numOfClosedArrays + numOfNearbyBombs; // Total number of bombs and closed neighbors

            // if number of closed neighbors is equal to the square's value and no bombs are discovered, flag them. Also flag combinations of bombs and flags
            if ((totalSize == masterArray[i][j]) && (0 != masterArray[i][j]) && (0 != numOfClosedArrays) && (numOfNearbyBombs != masterArray[i][j])) {

                foundFlag = 1; // half of guessing condition is set
                if (valueArr[0] == -2) {
                    flag(i + 1, j - 1);
                    (*foundBombs)++;
                    masterArray[i + 1][j - 1] = -1;
                };
                if (valueArr[1] == -2) {
                    flag(i + 1, j);
                    (*foundBombs)++;
                    masterArray[i + 1][j] = -1;
                };
                if (valueArr[2] == -2) {
                    flag(i + 1, j + 1);
                    (*foundBombs)++;
                    masterArray[i + 1][j + 1] = -1;
                };
                if (valueArr[3] == -2) {
                    flag(i, j - 1);
                    (*foundBombs)++;
                    masterArray[i][j - 1] = -1;
                };
                if (valueArr[4] == -2) {
                    flag(i, j + 1);
                    (*foundBombs)++;
                    masterArray[i][j + 1] = -1;
                };
                if (valueArr[5] == -2) {
                    flag(i - 1, j - 1);
                    (*foundBombs)++;
                    masterArray[i - 1][j - 1] = -1;
                };
                if (valueArr[6] == -2) {
                    flag(i - 1, j);
                    (*foundBombs)++;
                    masterArray[i - 1][j] = -1;
                };
                if (valueArr[7] == -2) {
                    flag(i - 1, j + 1);
                    (*foundBombs)++;
                    masterArray[i - 1][j + 1] = -1;

                };
                // Flag the bomb at correct position and update flag count
            };  // Run through length of closed array
        };// Only run if the number of closed + flagged neighbors = the square's value; return function value as true.
    };
    return foundFlag; // return the half guessing condition
}; // This function checks all previous values to make sure no numOfNearbyBombs can be discovered next to previous blocks after new blocks are opened.


int guessFunc(int (*masterArray)[8]) {

    for (i = 0; i < 8; i++) {
        for (j = 0; j < 8; j++) { // Index through the values and guess the next value that is not known
            if (masterArray[i][j] == -2) {
                getOut = 1;
                break; // break if next value is found
            };
        };
        if(getOut)break;
    };

    getOut = 0;

    newGuess = guess(i, j);
    masterArray[i][j] = newGuess;
    return newGuess;
};


int openFunc(int (*masterArray)[8], int *foundBombs) {
    for (i = 0; i < 8; i++) {
        for (j = 0; j < 8; j++) { // Index through all the values 

            int v2 = 0; // initialize 2nd half of guessing condition

            // create array of all neighboring values and the size of the array
            int valueArr[] = {masterArray[i + 1][j - 1], masterArray[i + 1][j], masterArray[i + 1][j + 1], 
            masterArray[i][j - 1], masterArray[i][j + 1], masterArray[i - 1][j - 1], masterArray[i - 1][j], masterArray[i - 1][j + 1]};
            size_t arrSize = sizeof(valueArr) / sizeof(valueArr[0]);

            // Again, changes the values if the square is an edge case
            if ((i == 0) && (j == 0)) {
                valueArr[0] = -3;
                valueArr[3] = -3;
                valueArr[5] = -3;
                valueArr[6] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            } else if ((i==0) && (j==7)) {
                valueArr[2] = -3;
                valueArr[4] = -3;
                valueArr[5] = -3;
                valueArr[6] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            } else if ((i==7) && (j==0)) {
                valueArr[0] = -3;
                valueArr[1] = -3;
                valueArr[2] = -3;
                valueArr[3] = -3;
                valueArr[5] = -3;
                arrSize = arrSize - 5;
            } else if ((i==7) && (j==7)) {
                valueArr[0] = -3;
                valueArr[1] = -3;
                valueArr[2] = -3;
                valueArr[4] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            } else if (i == 0) {
                valueArr[5] = -3;
                valueArr[6] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 3;
            } else if (i == 7) {
                valueArr[0] = -3;
                valueArr[1] = -3;
                valueArr[2] = -3;
                arrSize = arrSize - 5;
            } else if (j == 0) {
                valueArr[0] = -3;
                valueArr[3] = -3;
                valueArr[5] = -3;
                arrSize = arrSize - 5;
            } else if (j == 7) {
                valueArr[2] = -3;
                valueArr[4] = -3;
                valueArr[7] = -3;
                arrSize = arrSize - 5;
            };

            // Initialize variables
            int numOfClosedArrays = 0; 
            int numOfNearbyBombs = 0;
            

            for (e = 0; e < 8; e++) {
                closedSquares[e] = 0;
            }; // Create empty array of zeroes

            for (w = 0; w < arrSize; w++) {
                if (valueArr[w] <= -1)
                {
                    closedSquares[w] = w;
                }
            }; // find how many unopened neighbors there are
        
            for (w = 0; w < 8; w++) {
                if (valueArr[w] == -2) {
                    numOfClosedArrays++;
                };
            }; // find how many unopened neighbors there are
            for (w = 0; w < 8; w++) {
                if (valueArr[w] == -1) {
                    numOfNearbyBombs++;
                };
            };

            // If the number of nearby known bombs is equal the the square value, open all other neighboring squares
            int valueOfSquare = masterArray[i][j];
            if (numOfNearbyBombs == valueOfSquare) {
                
                v2 = 1;
                if ((masterArray[i + 1][j - 1] != -1) && (i < 7) && (j > 0)) {
                    masterArray[i + 1][j - 1] = open(i + 1, j - 1);   
                };
                if ((masterArray[i + 1][j] != -1)  && (i < 7)) {
                    masterArray[i + 1][j] = open(i + 1, j);   
                };
                if ((masterArray[i + 1][j + 1] != -1) && (i < 7) && (j < 7)) {
                    masterArray[i + 1][j + 1] = open(i + 1, j + 1);  
                };
                if ((masterArray[i][j - 1] != -1) && (j > 0)) {
                    masterArray[i][j - 1] = open(i, j - 1);   
                };
                if ((masterArray[i][j + 1] != -1) && (j < 7)) {
                    masterArray[i][j + 1] = open(i, j + 1);
                };
                if ((masterArray[i - 1][j - 1] != -1) && (i > 0) && (j > 0)) {
                    masterArray[i - 1][j - 1] = open(i - 1, j - 1);
                };
                if ((masterArray[i - 1][j] != -1) && (i > 0)) {
                    masterArray[i - 1][j] = open(i - 1, j);   
                };
                if ((masterArray[i - 1][j + 1] != -1) && (i > 0) && (j < 7)) {
                    masterArray[i - 1][j + 1] = open(i - 1, j + 1);
                };
            };  
        };
    };
    return v2;
}; // This function opens any squares deemed safe;


void solver(int numBombs) {
    for (i = 0; i < 8; i++) {
        for (j = 0; j < 8; j++)
        {
            masterArray[i][j] = -2;
        };
    }; // Generates an array with -2's because it's a unique value that will always be overwritten

    // This runs the initial guess - decides how game will run from then on. 
    p1 = 0;
    p2 = 0;
    initial = guess(p1, p2);
    masterArray[0][0] = initial;

    // Main loop - loops until all bombs are flagged
    while (foundBombs < numBombs) {

        
        v1 = checkFlags(&foundBombs, masterArray);
        v2 = openFunc(masterArray, &foundBombs);

        // Runs again to double-check
        v1 = checkFlags(&foundBombs, masterArray);
        v2 = openFunc(masterArray, &foundBombs);

        if ((v1 + v2) == 0) { // If the two guessing conditions are correct, then the next move must be to guess. 

            newGuess = guessFunc(masterArray); // Make necessary guess
            if (newGuess == -1) {
                foundBombs++;
            }; 
        };

    };
}; // Main solving function