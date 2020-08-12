#!/bin/bash

# Clear the screen
clear

echo "Hi there!"
# Read from standard input (https://en.wikipedia.org/wiki/Standard_streams)
read -p "May I ask what your name is? " name
echo "Hello $name, nice to meet you"
read -p "What is your favorite programming language? " favorite_language
echo "That's awesome! I like $favorite_language too!"
