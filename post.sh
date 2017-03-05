if [ ! -d "/om" ]; then mkdir /om; fi
if [ ! -d "/cm" ]; then mkdir /cm; fi
if [ ! -d "/opt/graspit" ]; then mkdir -p /opt/graspit; fi
if [ ! -d "/opt/planning" ]; then mkdir -p /opt/planning; fi
export LANG=C.UTF-8
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y software-properties-common
add-apt-repository universe
add-apt-repository ppa:git-core/ppa
apt-get install -y libboost-dev
apt-get install -y libqt4-dev 
apt-get install -y libblas-dev
apt-get install -y liblapack-dev libboost-system-dev libboost-thread-dev
apt-get install -y libboost-program-options-dev vim xvfb
apt-get update && apt-get install -y wget bzip2 git \
   build-essential cmake libqhull-dev qhull-bin \
   libsoqt-dev-common libsoqt4-dev libblas-dev \
   liblapack-dev libglib2.0-0 libxext6 libsm6 \
   libxrender1 doxygen 
echo "Installing python3 packages via Anaconda"
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
bash Anaconda3-4.2.0-Linux-x86_64.sh -b -p /opt/anaconda3
rm Anaconda3-4.2.0-Linux-x86_64.sh 
/opt/anaconda3/bin/pip install --upgrade pip
/opt/anaconda3/bin/conda install -y scipy numpy matplotlib \
scikit-learn joblib tk pytest
/opt/anaconda3/bin/pip install multiprocess transforms3d

echo "Installing Graspit"
apt-get update && apt-get install -y libeigen3-dev
apt-get install -y libboost-all-dev
git clone https://github.com/belledon/graspit-pkgs
git clone https://github.com/belledon/graspit
cd graspit
export GRASPIT=/opt/graspit
cmake -DBUILD_SHARED_LIBS=true -DCMAKE_INSTALL_PREFIX=/opt/graspit
make
make install
cd /graspit-pkgs/grasp_planning_graspit
git submodule update --init --recursive
cmake -DBUILD_GRASPIT=false -DCMAKE_PREFIX_PATH=/opt/graspit -DCMAKE_INSTALL_PREFIX=/opt/planning
make
make install

echo "Updating library paths"
cd /etc/ld.so.conf.d
echo "/opt/graspit/lib" | cat > graspit.conf
echo "/opt/planning/lib" | cat > graspplanning.conf
ldconfig
echo "" >> /environment
echo "export GRASPIT=/opt/graspit" >> /environment
echo "export PATH=/opt/anaconda3/bin:$PATH" >> /environment
echo "export PYTHONPATH=$PYTHONPATH:/opt/planning/include/grasp_planning_graspit" >> /environment
