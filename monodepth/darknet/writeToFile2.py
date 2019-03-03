import os 
i = len([f for f in os.listdir(r"/home/ubuntu/monodepth/ImagesNormal/Raw/") if f[0] != '.'])
print(i)
os.chdir(r"/home/ubuntu/monodepth/darknet/data/")
f= open("t.txt","w+")
x = 1
for x in range(1 ,i+1):
    f.write("/home/ubuntu/monodepth/Images/Raw/my_image"+str(x)+".jpg\n")
f.close()
 