#!/usr/bin/python
import sys

def absSub(x,y):
    return abs(x-y)

def strAdd(x,y):
    return x + " " + y

def floatToStr(x):
    return  '%.8f' % x

if len(sys.argv) != 3:
    print "Useage: python num_diff.py file1 file2"
    exit(-1)

files = []
files.append(open(sys.argv[1], 'r'))
files.append(open(sys.argv[2], 'r'))

fileArray = [[],[]]

for f in range(2):
    for line in files[f]:
        lineString = line.split(' ');
        lineNum = []
        for s in lineString:
            lineNum.append(float(s))
        fileArray[f].append(lineNum)

diff = []
for l in range(len(fileArray[0])):
    diff.append(map(absSub, fileArray[0][l], fileArray[1][l]))


for l in diff:
    print reduce(strAdd,map(floatToStr, l))

largest = 0.0
avg = 0.0
count = 0.0
zeroCount = 0.0
for l in diff:
    for i in l:
        count += 1
        avg += i
        largest = max(largest, i)
        if i == 0:
            zeroCount += 1

print "\nStats:"
print "max: " , largest
print "avg: " , avg/count
print "zero: ", 100*zeroCount/count , "%"

