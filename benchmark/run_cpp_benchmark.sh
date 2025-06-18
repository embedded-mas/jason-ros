( docker ps -q --filter "name=novnc" | grep -q . &&  docker stop novnc || true) && \
( docker ps -q --filter "name=noetic" | grep -q . &&  docker stop noetic || true) && \
 docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest && \
 docker run -it -p11311:11311 -p9090:9090 --rm --net=ros --env="DISPLAY=novnc:0.0" --name noetic maiquelb/embedded-mas-ros:0.8a \
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
