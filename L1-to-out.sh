#!/bin/bash
racket compiler-L1.rkt $1 > prog.S
as --32 -o prog.o prog.S
gcc -m32 -o a.out prog.o runtime.o
./a.out