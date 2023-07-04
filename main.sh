#!/bin/bash

#Start inclusion based system (not a part of this project)
. $(dirname "$0")/src/include.sh

include_once 'src/colors/colorize_output.sh' 'src/colors/colors.sh' 'src/colors/prompt.sh'


# folder in which all input output and zip files will be created
DESTINATION_FOLDER='build'

# Your test case generator program location (should be a c++ file)
TESTCASE_GENERATOR='generator.cpp'

# Your main program [testcases will run this program]
# NOTE: you must adjust your cpp file to direct to this stdin
# accordingly.
PROGRAM_FILE='main.cpp'

# The number of testcases you want to generate
TOTAL_CASES=30


mkdir -p "$DESTINATION_FOLDER/input"
mkdir -p "$DESTINATION_FOLDER/output"

# Compile the files only once.
prmopt -w "Compiling $PROGRAM_FILE... " 
EXEC_PROGRAM_FILE="$PROGRAM_FILE.build"
g++ -std=c++11 $PROGRAM_FILE -o "$EXEC_PROGRAM_FILE"
prmopt -s "Done.\n"


# NOTE: for randomness, this program assumes that the user takes 
# care of it using runtime randomness srand().
prmopt -w "Compiling $TESTCASE_GENERATOR... " 
EXEC_TESTCASE_GENERATOR="$TESTCASE_GENERATOR.build"
g++ -std=c++11 $TESTCASE_GENERATOR -o "$EXEC_TESTCASE_GENERATOR"
prmopt -s "Done.\n"

for (( i=1; i<=TOTAL_CASES; i++ )) {

    prompt -w "Generating input0$i... "
    # Create and generate input
    INPUT_FILE="$DESTINATION_FOLDER/input/input0$i.txt"
    touch $INPUT_FILE
    ./$EXEC_TESTCASE_GENERATOR >> $INPUT_FILE
    prompt -s "Done.\n"

    prompt -w "Generating output0$i... "
    # Create and generate output
    OUTPUT_FILE="$DESTINATION_FOLDER/output/output0$i.txt"
    touch $OUTPUT_FILE

    # Only output the actual output in the stdout, or ouptut
    # nothing at all. This program handles both of the ccases.
    ./$EXEC_PROGRAM_FILE >> $OUTPUT_FILE 

    prompt -s "Done.\n"

}

# Zip the folder
zip -r "$DESTINATION_FOLDER.zip" "$DESTINATION_FOLDER"
# the zipped file is what you submit in your hackerrank submission.


# Remote the redundant files. You can specify your needs here.
rm $EXEC_PROGRAM_FILE $EXEC_TESTCASE_GENERATOR