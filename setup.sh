#Steps To Set Up Cloud Based Gpu Instance To Run This Project (Tested on AWS EC2 but shoul work on any other platform as well)

#Upgrade the linux-aws package to receive the latest version
sudo apt-get upgrade -y linux-aws 
sudo reboot

#Install the gcc compiler and the kernel headers package for the version of the kernel you are currently running.
sudo apt-get install -y gcc make linux-headers-$(uname -r)

#Disable the nouveau open source driver for NVIDIA graphics cards.

#Add nouveau to the /etc/modprobe.d/blacklist.conf blacklist file. Copy the following code block and paste it into a terminal.
cat << EOF | sudo tee --append /etc/modprobe.d/blacklist.conf
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
EOF

#Edit the /etc/default/grub file and add the following line:
GRUB_CMDLINE_LINUX="rdblacklist=nouveau"

#Rebuild the Grub configuration.
sudo update-grub

#Installing Nvidia Driver 

#Download the driver package 
wget http://us.download.nvidia.com/tesla/381.81/NVIDIA-Linux-x86_64-381.81.run

#Run the self-install script to install the NVIDIA driver that you downloaded in the previous step.
sudo /bin/sh ./NVIDIA-Linux-x86_64*.run
sudo reboot

Confirm that the driver is functional
nvidia-smi -q | head

#Configure the GPU settings to be persistent.
sudo nvidia-persistenced

#Disable the autoboost feature for all GPUs on the instance.
sudo nvidia-smi --auto-boost-default=0

#Set all GPU clock speeds to their maximum frequency.
sudo nvidia-smi -ac 2505,875 #For Tesla K80  

#Installing CUDA
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run

chmod +x cuda_9.0.176_384.81_linux-run
./cuda_9.0.176_384.81_linux-run --extract=$HOME

sudo ./cuda-linux.9.0.176-22781540.run

sudo ./cuda-samples.9.0.176-22781540-linux.run

sudo bash -c "echo /usr/local/cuda/lib64/ > /etc/ld.so.conf.d/cuda.conf"
sudo ldconfig

sudo vim /etc/environment  #add the following line in the end "":/usr/local/cuda/bin"
sudo reboot


cd /usr/local/cuda-9.0/samples
sudo make

cd /usr/local/cuda/samples/bin/x86_64/linux/release
./deviceQuery

#Installing Cudnn


export CUPIT_LIB_PATH=${OPT_PATH}/cuda/toolkit_9.0/cuda/extras/CUPTI/lib64
export LD_LIBRARY_PATH=${CUPIT_LIB_PATH}:$LD_LIBRARY_PATH

CUDNN_PKG="libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb"
wget https://github.com/ashokpant/cudnn_archive/raw/master/v7.0/${CUDNN_PKG}
sudo dpkg -i ${CUDNN_PKG}
sudo apt-get update

#Checking Installation

nvcc --version

function lib_installed() { /sbin/ldconfig -N -v $(sed 's/:/ /' <<< $LD_LIBRARY_PATH) 2>/dev/null | grep $1; }
function check() { lib_installed $1 && echo "$1 is installed" || echo "ERROR: $1 is NOT installed"; }
check libcudnn

#Bulding Opencv with Cuda 

#Required Packages
sudo apt-get install build-essential
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

#Getting OpenCV Source Code
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

#Building OpenCV from Source Using CMake
cd ~/opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules

make -j7 # runs 7 jobs in parallel

sudo make install

#Installing Tensorflow-Gpu

sudo apt update
sudo apt install python-dev python-pip
sudo pip install -U virtualenv  # system-wide install

# Create a virtual environment
virtualenv --system-site-packages -p python2.7 ./venv
source ./venv/bin/activate  # sh, bash, ksh, or zsh
pip install --upgrade pip
pip list  # show packages installed within the virtual environment
deactivate  # don't exit until you're done using TensorFlow

#Install the TensorFlow pip package
pip install tensorflow-gpu==1.5.0

#Install other packages 
pip install scipy
pip install matplotlib 
pip install pillow 
pip3 install opencv-python
sudo apt-get install python-tk

#If ./darknet: error while loading shared libraries: libopencv_highgui.so.2.4: cannot open shared object file: No such file or directory
apt-get install libopencv-highgui-dev

