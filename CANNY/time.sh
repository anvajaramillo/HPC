#!/bin/sh

# Jhonatan Barrera
# 08/09/2016

for i in 1 2 3 4 5 6 7 8 9
do
	echo "img"$i >> dtime.txt
	for b in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
	do
	./build/canny ~/Angie/HPC/CANNY/images/img$i.jpg >> dtime.txt
	done
done
