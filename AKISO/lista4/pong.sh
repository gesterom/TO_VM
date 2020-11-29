#!/bin/bash
board="<===========>" 
block1="===="
block2="===="
block_n=4
block_m=8
blocks1=`printf "%0.s$block1 " $(seq $block_m)`
blocks2=`printf "%0.s$block2 " $(seq $block_m)`
w=$(tput cols)
h=$(tput lines)
(( h = h > 42 ? 42 : h - 1 ))
(( w = w > 70 ? 70 : w ))
max_speed=3
whitespace=`printf "%0.s " $(seq $w)`
len=${#board}
vel_x=0
vel_y=-1
pos_x=$w/2
pos_y=$h/2
pos_A=0
pos_B=0
draw_board_A() {
    echo -en "\033[${h};${pos_A}H$whitespace"
    (( pos_A += $1 ))
    (( pos_A = pos_A < 1 ? 1 : pos_A > w - len ? w - len : pos_A ))
    echo -en "\033[${h};${pos_A}H$board"
}
draw_board_B() {
    echo -en "\033[1;${pos_B}H$whitespace"
    (( pos_B += $1 ))
    (( pos_B = pos_B < 1 ? 1 : pos_B > w - len ? w - len : pos_B ))
    echo -en "\033[1;${pos_B}H$board"
}
tput civis
tput clear
echo
(( border=w+1 ))
for index in `seq $h`; do
	echo -en "\033[${index};${border}HH"
done
draw_board_A 1
draw_board_B 1

while [[ $q != q ]]; do
    #if (( pos_y <= block_m + 1 )); then
    #    echo -en "\033[$(( pos_y / 2 * 2 + 1 ));$(( pos_x / 5 * 5 ))H    "
    #    echo -en "\033[$(( pos_y / 2 * 2 + 0 ));$(( pos_x / 5 * 5 ))H    "
    #fi
		draw_board_A 0
		draw_board_B 0

    echo -e "\033[${pos_y};${pos_x}Hx"
    read -n 1 -s -t 0.05 q
    case "$q" in 
        [aA] ) draw_board_A -2;;
        [dD] ) draw_board_A  2;; 
				[jJ] ) draw_board_B -2;;
        [lL] ) draw_board_B  2;; 
    esac
    (( pos_x >= w-2 || pos_x + vel_x <= 0 )) && (( vel_x = - vel_x ))
    (( pos_y <= 2 || pos_y > h - 2)) && (( vel_y = - vel_y ))
    echo -e "\033[${pos_y};${pos_x}H "
    if (( pos_y > h-2 )); then                  #pilka jest na dole 
        if (( pos_x >= pos_A && pos_x <= pos_A + len )); then  # pilka odbija sie od dolnej paletki
           (( vel_x = pos_x - pos_A - len / 2 ))
           (( ${vel_x//-/} > max_speed )) && vel_x=${vel_x//[0-9]*/$max_speed}
        else
            pos_x=$w/2
            pos_y=$h/2
            vel_y=1
            vel_x=$(( RANDOM % max_speed + 1 ))
        fi
    fi
		if (( pos_y <= 2 )); then                  #pilka jest na gorze 
        if (( pos_x >= pos_B && pos_x <= pos_B + len )); then  # pilka odbija sie od gornej paletki
           (( vel_x = pos_x - pos_B - len / 2 ))
           (( ${vel_x//-/} > max_speed )) && vel_x=${vel_x//[0-9]*/$max_speed}
        else
            pos_x=$w/2
            pos_y=$h/2
            vel_y=1
            vel_x=$(( RANDOM % max_speed + 1 ))
        fi
    fi
    (( pos_x += vel_x ))
    (( pos_y += vel_y ))
done
tput cnorm
