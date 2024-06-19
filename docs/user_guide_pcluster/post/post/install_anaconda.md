## Install Anaconda on the /shared/build directory 

Follow instructions available here: <a href="https://docs.anaconda.com/free/anaconda/install/linux/">Install Anaconda on Linux</a>

```
cd /shared/build/
```

```
sudo apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
curl -O https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
bash Anaconda3-2023.09-0-Linux-x86_64.sh
```

select installation directory as /shared/build/anaconda3

add to your .cshrc

```
set path = ($path /shared/build/anaconda3/bin)
# The base environment is activated by default
conda config --set auto_activate_base True
```


Install additional packages

```
conda install netcdf4
conda install pyproj
conda install cartopy
```
