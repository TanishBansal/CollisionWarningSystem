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

#Getting Objects and their coordinates in a list 
yy=[]
single_truncated=open(r"/home/ubuntu/CollisionWarningSystem/monodepth/darknet/single_truncated.txt","r")
for line in (single_truncated):
    z=line.split("\t")
    yy.append(z)
print(yy)