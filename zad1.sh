#!/bin/zsh

while [[ 1 ]]
	do

let INTERNET_in_VALUE=$(cat /proc/net/dev | sed '3!d' | awk '{print $2}');
let INTERNET_in_POSTFIX;

if [[ $INTERNET_in_VALUE -gt 1024 ]] 
	then
	INTERNET_in_POSTFIX=$(echo "KB");
	INTERNET_in_VALUE=$INTERNET_in_VALUE/1024;
fi
if [[ $INTERNET_in_VALUE -gt 1024 ]] 
	then
	INTERNET_in_POSTFIX=MB
	INTERNET_in_VALUE=$INTERNET_in_VALUE/1024;
fi
if [[ $INTERNET_in_VALUE -gt 1024 ]] 
	then
	INTERNET_in_POSTFIX==$(echo "GB");
	INTERNET_in_VALUE=$INTERNET_in_VALUE/1024;
fi
INTERNET_in=$INTERNET_in_VALUE" "$INTERNET_in_POSTFIX;

let INTERNET_out_VALUE=$(cat /proc/net/dev | sed '3!d' | awk '{print $10}');
let INTERNET_out_POSTFIX;
if [[ $INTERNET_out_VALUE -gt 1024 ]] 
	then
	INTERNET_out_POSTFIX=$(echo "KB");
	INTERNET_out_VALUE=$INTERNET_out_VALUE/1024;
fi
if [[ $INTERNET_out_VALUE -gt 1024 ]] 
	then
	INTERNET_out_POSTFIX==$(echo "MB");
	INTERNET_out_VALUE=$INTERNET_out_VALUE/1024;
fi
if [[ $INTERNET_in_VALUE -gt 1024 ]] 
	then
	INTERNET_out_POSTFIX==$(echo "GB");
	INTERNET_out_VALUE=$INTERNET_out_VALUE/1024;
fi
INTERNET_out=$INTERNET_out_VALUE" "$INTERNET_out_POSTFIX;



let up_time=$(cat /proc/uptime | awk '{print $1}');

integer sec=$(( ($up_time%60)));
integer min=$(( ($up_time/60%60)));
integer hour=$((($up_time/60/60%24)));
integer day=$(( ($up_time/60/60/24)));
uptime_format="days: "$day" hour: "$hour" min: "$min" sec: "$sec;


let bat_max=$(cat /sys/class/power_supply/BAT0/energy_full);
let bat_now=$(cat /sys/class/power_supply/BAT0/energy_now);

let bat_proc=$((100.0*$bat_now/$bat_max));

load_avg=$(cat /proc/loadavg);

echo "========================="
echo "Net Send : "$INTERNET_in;
echo "Net Recv : "$INTERNET_out;
echo "Uptime   : "$uptime_format;
echo "Battery  : "$bat_proc;
echo "Load AVG : "$load_avg;
echo "========================="
sleep 1

done