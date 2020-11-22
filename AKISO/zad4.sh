#@/bin/zsh

url=$1
timestamp=$2

if [ ! -d "history" ]; then
	mkdir -p "history";
fi

cd "history";

if [ ! -d ".git" ]; then
	git init;
fi

if [[ ! -f "index" ]];then
	wget -O index -q $url;
fi

while [[ true ]]; do 
	wget -O new_index -q $url;
	diff index new_index -s > /dev/null;
	diff_code=$?;
	if [[ $diff_code -eq 1 ]]; then
		echo "something chenged";
		rm -f index;
		mv new_index index;
		git add index;
		git commit -m  'date';
	fi
	sleep $timestamp;
done;