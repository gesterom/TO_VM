#!/bin/zsh


r_joke="api.icndb.com/jokes/random"
r_kitt="https://api.thecatapi.com/v1/images/search"

curl -s $r_joke | jq -r '.value.joke';
jpg_url=$(curl -s $r_kitt | jq -r '.[0].url');

wget $jpg_url -O kitty_img -q ;

img2txt "kitty_img";

rm kitty_img;






