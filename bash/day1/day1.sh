#!/usr/bin/env bash

# Bash modulus doesn't wrap on negatives so create one that does
mod() {
    echo $(( (($1 % $2) + $2) % $2 ))
}

pw1=0
pw2=0
dial=50

while read line; do
    curr=$dial
    dir=$(cut -c 1 <<< $line)
    val=$(cut -c 2- <<< $line)

    pw2=$(( pw2 + (val / 100) ))
    if [[ "$dir" == "L" ]]; then
	val=$((val*-1))
    fi

    # Get the new val using regular modulus to detect wraps
    v=$((dial + (val % 100)))
    dial=$(mod "$v" 100)

    if [[ $dial -eq 0 ]]; then
	((pw1++))
    fi

    # Check if the new val v is wrapped. But only if not starting at 0
    if [[ $curr -ne 0 ]]; then
	if [[ "$v" -le 0 ]] || [[ "$v" -ge 100 ]]; then
	    ((pw2++))
	fi
    fi    
    
#    echo "Dial: $dial, Val: $val, v: $v, pw1: $pw1, pw2: $pw2";
done < "$1"

echo "Result Part 1: '$pw1'"
echo "Result Part 2: '$pw2'"
