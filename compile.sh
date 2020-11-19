#!/usr/bin/env bash
# this script is used to compile and run *.asm 16 bit Turbo Assembly files.
# I tested it on WSL2 - Ubuntu-20.04

# this path will become 'C:>' when running dosemu  
root=$(pwd)

tasm_dir="TASM"
src_filename=$(echo $1 | sed -r "s/.*\///")
source_file_dir="projects"

# tasm.exe compile command
dos_command_compile="$tasm_dir\\TASM.EXE /zi /la $source_file_dir\\$src_filename"

# source file name without extension
basefilename=$(echo $src_filename | sed -r "s/\..+//")
# tlink.exe linking command - expected a file type basename.obj found in root
dos_command_link="$tasm_dir\\TLINK.EXE /v $basefilename.obj"



compile () {
# compile (16 bits) with dosemu and tasm.exe
dosemu -K "$root" -E "$dos_command_compile" &&
# link objects with tlink.exe
dosemu -K "$root" -E "$dos_command_link"
}

# execute in subshell and discard all messages
(compile) &> logfile &&

# now we are in GNU/linux and letters case matter
# convert to lowercase
basefilename=$(echo $basefilename | sed -r "s/(.*)/\L\1/")

# run obtained executable
emu2 "$basefilename.exe"


