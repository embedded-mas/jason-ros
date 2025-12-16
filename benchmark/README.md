### Raw data

- [read/write performance](results/cmd_vel_log_ros_perception_corrigido_unified.ods): analysis of time taken to read values from a topic and update it.
- [memory/CPU usage](results/random_rosnode_memlog_ros_with_perception_unified.ods): analysis of memory and CPU consumption


## Running the experiments
First of all, clone this repository:
```
git clone https://github.com/embedded-mas/jason-ros.git
```

The experiments are based on a simplified version of the Turtlebot3 controlling application, where the robot robot continuously moves randomly when no obstacle is detected within 1 meter; otherwise it moves backward for a short period before resuming its random movement.

The easiest way to run the experiments is using Docker containers. Instructions for launching them are detailed below. The Turtlebot can be inspected through a web browser at http://localhost:8080/vnc.html. 

At the end of the execution, the following log files are available:
- `cmd_vel_log.csv`: lists the timestamp of each writing in the `cmd_vel` topic;
- `random_rosnode_memlog_ros.csv`: lists the memory and cpu consumption during the application running.



### Experiments with C++ ROS node
Run the command below to evaluate the memory and CPU consumption of a C++ ROS node. 

```
./run_cpp_benchmark.sh
```

<!--
```
(sudo docker ps -q --filter "name=novnc" | grep -q . && sudo docker stop novnc || true) && \
(sudo docker ps -q --filter "name=noetic" | grep -q . && sudo docker stop noetic || true) && \
sudo docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest && \
sudo docker run -it -p11311:11311 -p9090:9090 --rm --net=ros --env="DISPLAY=novnc:0.0" --name noetic maiquelb/embedded-mas-ros:0.8a \
/bin/bash -c "
set -e
source /opt/ros/noetic/setup.bash || { echo 'Error: Failed to source ROS Noetic'; exit 1; }

export TURTLEBOT3_MODEL=burger
roslaunch turtlebot3_gazebo turtlebot3_world.launch &
sleep 5

roslaunch rosbridge_server rosbridge_websocket.launch &
sleep 5

cd /embedded_mas_ros_example_package || { echo 'Error: Failed to access /embedded_mas_ros_example_package'; exit 1; }
git pull || { echo 'Error: git pull failed'; exit 1; }

cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src || { echo 'Error: Failed to copy example nodes'; exit 1; }

source /opt/ros/noetic/setup.bash
cd /catkin_wsp || { echo 'Error: Failed to access /catkin_wsp'; exit 1; }
catkin_make || { echo 'Error: catkin_make failed'; exit 1; }

cd /
git clone https://github.com/embedded-mas/jason-ros.git || { echo 'Error: Failed to clone jason-ros'; exit 1; }

chmod +x /jason-ros/benchmark/memory_monitor_ros_random_c.sh || { echo 'Error: chmod failed'; exit 1; }
sleep 5

source /opt/ros/noetic/setup.bash
source /catkin_wsp/devel/setup.bash
rosrun embedded_mas_examples cmd_vel_monitor.py &

source /opt/ros/noetic/setup.bash
source /catkin_wsp/devel/setup.bash
/jason-ros/benchmark/memory_monitor_ros_random_c.sh

echo -e '\e[1;33m**** Docker container is ready. Start the JaCaMo application ****\e[0m'

tail -f /dev/null
"

```
-->

### Experiments with Python node
Run the command below to evaluate the memory and CPU consumption of a Python ROS node. 
```
./run_python_benchmark.sh
```
<!--
```
(sudo docker ps -q --filter "name=novnc" | grep -q . && sudo docker stop novnc || true) && \
(sudo docker ps -q --filter "name=noetic" | grep -q . && sudo docker stop noetic || true) && \
sudo docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest && \
sudo docker run -it -p11311:11311 -p9090:9090 --rm --net=ros --env="DISPLAY=novnc:0.0" --name noetic maiquelb/embedded-mas-ros:0.8a \
/bin/bash -c "
set -e
source /opt/ros/noetic/setup.bash || { echo 'Error: Failed to source ROS Noetic'; exit 1; }

export TURTLEBOT3_MODEL=burger
roslaunch turtlebot3_gazebo turtlebot3_world.launch &
sleep 5

roslaunch rosbridge_server rosbridge_websocket.launch &
sleep 5

cd /embedded_mas_ros_example_package || { echo 'Error: Failed to access /embedded_mas_ros_example_package'; exit 1; }
git pull || { echo 'Error: git pull failed'; exit 1; }

cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src || { echo 'Error: Failed to copy example nodes'; exit 1; }

source /opt/ros/noetic/setup.bash
cd /catkin_wsp || { echo 'Error: Failed to access /catkin_wsp'; exit 1; }
catkin_make || { echo 'Error: catkin_make failed'; exit 1; }

cd /
git clone https://github.com/embedded-mas/jason-ros.git || { echo 'Error: Failed to clone jason-ros'; exit 1; }

chmod +x /jason-ros/benchmark/memory_monitor_ros_random.sh || { echo 'Error: chmod failed'; exit 1; }
sleep 5

source /opt/ros/noetic/setup.bash
source /catkin_wsp/devel/setup.bash
rosrun embedded_mas_examples cmd_vel_monitor.py &

sed -i '/\/mnt\/1C4C766F4C764414\/maiquel\/git\/embedded_mas_ros_example_package\/devel\/setup.bash/c\source /catkin_wsp/devel/setup.bash' /jason-ros/benchmark/memory_monitor_ros_random.sh
/jason-ros/benchmark/memory_monitor_ros_random.sh

echo -e '\e[1;33m**** Docker container is ready. Start the JaCaMo application ****\e[0m'

tail -f /dev/null"

```
-->


### Experiments with Jason
Run the command below to evaluate the memory and CPU consumption of a Python ROS node. 
```
./run_jason_benchmark.sh
```
