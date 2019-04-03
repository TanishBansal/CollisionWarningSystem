import os
import cv2
import numpy as np
import shutil
load_disparity=np.load(r"/home/ubuntu/CollisionWarningSystem/monodepth/image_disp.npy")
i=1
s=0
q=1
x=[]
t=[]
d=0

#Removing first three lines from file and making a new file
image_path=r"/home/ubuntu/CollisionWarningSystem/monodepth/image.jpg"
source_file = open('single_result.txt', 'r')
source_file.readline()
source_file.readline()
source_file.readline()
target_file = open('single_truncated.txt', 'w')
shutil.copyfileobj(source_file, target_file)
target_file.close()
os.system("head -n-1 single_truncated.txt  > single_truncated_lastline.txt")
#Getting Objects and their coordinates in a list 
yy=[]
single_truncated_lastline=open(r"/home/ubuntu/CollisionWarningSystem/monodepth/darknet/single_truncated_lastline.txt","r")
for line in (single_truncated_lastline):
    z=line.split("\t")
    yy.append(z)
print(yy)

j=cv2.imread(image_path)
new=j
for c in range(len(yy)):
    a=int(yy[c][1])
    b=int(yy[c][2])
    car=(721*0.54)/(load_disparity[b][a]*1242*1.762)
    new=cv2.putText(j,yy[c][0]+"="+str(car),(50,30*(c+1)),cv2.FONT_HERSHEY_TRIPLEX,.8,(0,255,255))
        
    t.append(car)
        
for element in range(len(t)):
    if t[element]<=4:
        d=373
if d==373:
    new=cv2.putText(j,"COLLISION WARNING!",(310,30),cv2.FONT_HERSHEY_COMPLEX_SMALL,1.5,(0,0,256))
    d=0
yy.clear()
t.clear()
filename="/home/ubuntu/CollisionWarningSystem/monodepth/darknet/collisions.jpg"
cv2.imwrite(filename,new)
