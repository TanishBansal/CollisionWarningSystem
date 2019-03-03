import os

with open('list2.txt') as f:
    lines = [line.split(' ') for line in f]
output = open("list2(sorted).txt", 'w')

for line in sorted(lines, key=itemgetter(3)):
    output.write(' '.join(line))

output.close()
