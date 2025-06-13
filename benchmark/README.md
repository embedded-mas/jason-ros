### Raw data

- [read/write performance](results/cmd_vel_log_ros_perception_corrigido_unified.ods): analysis of time taken to read values from a topic and update it.
- [memory/CPU usage](results/random_rosnode_memlog_ros_with_perception_unified.ods): analysis of memory and CPU consumption


## Running the experiments

### Experiments with C++ ROS node
```
(docker ps -q --filter "name=novnc" | grep -q . && docker stop novnc || true) &&\
(docker ps -q --filter "name=noetic" | grep -q . && docker stop noetic || true) &&\
sudo docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest &&\
sudo docker run -it -p11311:11311 -p9090:9090 --rm --net=ros --env="DISPLAY=novnc:0.0" --name noetic maiquelb/embedded-mas-ros:0.8a \
/bin/bash -c "source /opt/ros/noetic/setup.bash && \
(export TURTLEBOT3_MODEL=burger && roslaunch turtlebot3_gazebo turtlebot3_world.launch > /dev/null 2>&1 &) && \
(sleep 5 && roslaunch rosbridge_server rosbridge_websocket.launch > /dev/null 2>&1 &) && \
cd /embedded_mas_ros_example_package &&\ 
git pull &&\ 
cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src &&\ 
source /opt/ros/noetic/setup.bash &&\ 
cd /catkin_wsp && catkin_make && 
sleep 5 && \
cd / && git clone https://github.com/embedded-mas/jason-ros.git &&\ 
chmod +x /jason-ros/benchmark/memory_monitor_ros_random_c.sh &&\
sleep 5 && \
source /opt/ros/noetic/setup.bash && source /catkin_wsp/devel/setup.bash && ./jason-ros/benchmark/memory_monitor_ros_random_c.sh &&
echo -e '\e[1;33m**** Docker container is ready. Start the JaCaMo application ****\e[0m' && \
tail -f /dev/null"
```

