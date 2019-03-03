import os

a = open("output.txt", "w")
for path, subdirs, files in os.walk(r'/home/ubuntu/monodepth/Images/Raw'):
   for filename in files:
     f = os.path.join(path, filename)
     a.write(str(f) + os.linesep) 
