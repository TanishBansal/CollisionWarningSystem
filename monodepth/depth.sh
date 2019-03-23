cd /home/ubuntu/CollisionWarningSystem/monodepth/ 
sudo rm  Images/Raw/*
sudo rm  ImagesNormal/Raw/*
sudo rm  VideoInput/videoN.mp4
sudo rm  Output/*
ffmpeg -i VideoInput/video.mp4 -vf fps=20 ImagesNormal/Raw/my_image%01d.jpg -hide_banner
ffmpeg -i VideoInput/video.mp4 -vf scale=512:256 VideoInput/videoN.mp4  -hide_banner
ffmpeg -i VideoInput/videoN.mp4 -vf fps=20 Images/Raw/my_image%01d.jpg -hide_banner
python writeToFile.py
python monodepth_main.py --mode test --data_path /home/ubuntu/CollisionWarningSystem/monodepth/ --filenames_file /home/ubuntu/CollisionWarningSystem/monodepth/utils/filenames/list.txt --output_directory /home/ubuntu/CollisionWarningSystem/monodepth/Output --checkpoint_path /home/ubuntu/CollisionWarningSystem/monodepth/model/model_city2kitti
ffmpeg -framerate 20 -i Output/image%01d_disp.png VideoOutput/video.mp4
cd /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/
m=$(ls -1 --file-type | grep -v '/$' | wc -l)
cd
mv /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/video.mp4 /home/ubuntu/CollisionWarningSystem/monodepth/VideoOutput/video$m.mp4 