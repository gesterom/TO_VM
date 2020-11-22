#!/bin/zsh


proces_list=$(ls /proc/ -l | awk '{print $9}' | grep -o '[0-9]*');
#declare -A proces_array;
proces_array=("${(f)proces_list}");

for (( i = 1 ; i < $#proces_array;i++)) do
		let count_FB=$(ls /proc/$proces_array[i]/fd -l | wc -l);
		echo $proces_array[i] $count_FB;
done

