#!/bin/bash

# replace the second occurance of a string to the new string

awk '/58.71/{c+=1}{if(c==2){sub("58.71","26.982")}; print}' $1 > ${1}2
