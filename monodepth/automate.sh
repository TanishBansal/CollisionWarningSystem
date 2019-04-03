cd /home/ubuntu/CollisionWarningSystem/monodepth/
sudo rm  Images/Raw/*
sudo rm  ImagesNormal/Raw/*
sudo rm  VideoInput/videoN.mp4
sudo rm  Output/*
sudo rm  darknet/collisions/*
#sudo rm  /home/ubuntu/CollisionWarningSystem/monodepth/utils/filensame/list.txt
#sudo rm  /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/*
cd 
cd /home/ubuntu/CollisionWarningSystem/monodepth/ 
ffmpeg -i VideoInput/video.mp4 -vf fps=25 ImagesNormal/Raw/my_image%01d.jpg -hide_banner
ffmpeg -i VideoInput/video.mp4 -vf scale=512:256 VideoInput/videoN.mp4  -hide_banner
ffmpeg -i VideoInput/videoN.mp4 -vf fps=25 Images/Raw/my_image%01d.jpg -hide_banner
python writeToFile.py
python monodepth_main.py --mode test --data_path /home/ubuntu/CollisionWarningSystem/monodepth/ --filenames_file /home/ubuntu/CollisionWarningSystem/monodepth/utils/filenames/list.txt --output_directory /home/ubuntu/CollisionWarningSystem/monodepth/Output --checkpoint_path /home/ubuntu/CollisionWarningSystem/monodepth/model/model_city2kitti
ffmpeg -framerate 25 -i Output/image%01d_disp.png VideoOutput/video.mp4
cd /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/
m=$(ls -1 --file-type | grep -v '/$' | wc -l)
cd
mv /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/video.mp4 /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/video$m.mp4 


cd /home/ubuntu/CollisionWarningSystem/monodepth/darknet/
python writeToFile2.py
./darknet detector test obj.data yolov3.cfg yolo-obj_30800.weights -dont_show < data/t.txt > result.txt -thresh 0.2

tail -n +4 <result.txt >r.txt
#cd /home/ubuntu/CollisionWarningSystem/monodepth/Images/Raw/
#o=$(ls -1 --file-type | grep -v '/$' | wc -l)
#export bo
#echo $bo
#cd /home/ubuntu/CollisionWarningSystem/monodepth/darknet/
python3 depth.py
ffmpeg -framerate 25 -i collisions/collisions%01d.jpg VideoOutput/video.mp4
cd /home/ubuntu/CollisionWarningSystem/monodepth/darknet/VideoOutput/
m=$(ls -1 --file-type | grep -v '/$' | wc -l)
mv /home/ubuntu/CollisionWarningSystem/monodepth/darknet/VideoOutput/video.mp4 /home/ubuntu/CollisionWarningSystem/monodepth/darknet/VideoOutput/video$m.mp4 


#cd /home/ubuntu/CollisionWarningSystem/monodepth/VideoInput/
#m=$(ls -1 --file-type | grep -v '/$' | wc -l)
#cd
#mv /home/ubuntu/CollisionWarningSystem/monodepth/VideoInput/video.mp4 /home/ubuntu/CollisionWarningSystem/monodepth/VideoInput/video($(ls -l | grep ^- | wc -l)).mp4 
#sudo rm - /home/ubuntu/CollisionWarningSystem/monodepth/VideoInput/*
