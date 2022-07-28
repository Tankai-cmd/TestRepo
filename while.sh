#!/bin/bash

echo "What's your name?"
read INPUT_STRING
greet()
{
if [ "$INPUT_STRING" == "bye" -o "$INPUT_STRING" == " " ]
then
	echo "bye"
else
	echo "hii $INPUT_STRING"
fi
}

greet
