
python monodepth_simple.py --image_path /home/ubuntu/CollisionWarningSystem/monodepth/image.jpg --checkpoint_path /home/ubuntu/CollisionWarningSystem/monodepth/model/model_city2kitti 


ffmpeg -i image.jpg -vf scale=512:256 darknet/data/image_resized.jpg -y

cd darknet

./darknet detector test obj.data yolov3.cfg yolo-obj_30800.weights data/image_resized.jpg < data/single_text.txt > single_result.txt -thresh 0.2 

python3 single_depth.py
