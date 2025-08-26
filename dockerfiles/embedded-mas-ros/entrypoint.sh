#!/bin/bash
set -e

# Navigate to package and update
cd /embedded_mas_ros_example_package
git pull

# Copy example package into catkin workspace
cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src

# Source ROS Noetic
source /opt/ros/noetic/setup.bash

# Build catkin workspace
cd /catkin_wsp
catkin_make
source devel/setup.bash

# Start roscore in background
roscore &
sleep 5

# Launch rosbridge in background
roslaunch rosbridge_server rosbridge_websocket.launch &


# Notify user
echo -e "\033[1;33m**** Docker container is ready. Start the JaCaMo application ****\033[0m"

# Keep container alive
tail -f /dev/null

