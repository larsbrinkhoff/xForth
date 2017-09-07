#!/bin/sh

a=0

word()
{
    test -z "$1" && exit 0
    printf 'd %04o %s\n' $a $1
    a=`expr $a + 1`
}

convert() {
    while read i; do
	set $i
	word $2
	word $3
	word $4
	word $5
	word $6
	word $7
	word $8
	word $9
    done
}

od -v | convert
