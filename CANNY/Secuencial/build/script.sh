#!/bin/sh
for i in 1 2 3
do
	for b in 1 2 3 4 5
	do
	echo $i $b >> time2.txt
	./canny ~/Angie/HPC/CANNY/images/img$b.jpg >> time2.txt
	done
done
