#!/usr/bin/env bash

IN=$(<$1)
ranges=(${IN//,/ })

score() {
    local len=${#1};
    if [[ ${1:0:$((len/2))} == ${1:$((len/2)):$len} ]]; then
	echo -n "$1"
	return
    fi
    echo -n 0
}

sum=0
for r in ${ranges[@]}; do
    IFS=- read -r start end <<< "$r"
    #    echo Range $start to $end
    #    for ((i=start; i<=end; i++)); do
    #	 echo "Adding '$res', current: '$sum'"
    #       res=$(score $i)
    #       ((sum+=$res))
    #    done

    #    nums=$(seq -f %1.0f "$start" "$end" | grep '^\(\d*\)\1$')
    nums=$(seq -f %1.0f "$start" "$end" | grep "^\(\d*\)\1\+$")
    for i in $nums; do
	((sum+=$i))
    done
    
done

echo "Result: '$sum'"
