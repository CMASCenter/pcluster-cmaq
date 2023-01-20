# get IOR
mkdir -p /shared/build/ior
git clone https://github.com/hpc/ior.git
cd ior
git checkout io500-sc19

# load gcc 
module load openmpi/4.1.1

# install
./bootstrap
./configure --with-mpiio --prefix=/shared/build/ior
make -j 10
sudo make install

# set the environment
export PATH=$PATH:/shared/build/ior/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/build/ior/lib
echo 'export PATH=$PATH:/shared/ior/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/ior/lib' >> ~/.bashrc

