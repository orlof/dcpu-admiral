cd dist
dtemu -d admiral.bin | sort | uniq -c -w 6 > /tmp/debug.txt
cd ..

