( sudo docker ps -q --filter "name=turtles_example" | grep -q . && sudo docker stop turtles_example || true) &&\
sleep 2 &&\
sudo docker run -d --name turtles_example --rm --net=ros \
  --env="DISPLAY=novnc:0.0" \
  --env="ROS_MASTER_URI=http://localhost:11311" \
  -p11311:11311 -p9090:9090 \
  maiquelb/embedded-mas-ros2:latest sleep infinity  


sudo docker exec -d turtles_example /bin/bash -c 'sleep 1 && source /opt/ros/humble/setup.bash && ros2 run turtlesim turtlesim_node' 

(sleep 5 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 service call /spawn turtlesim/srv/Spawn "{x: 10.4, y: 10, theta: 0, name: \"turtle2\"}"') 

(sleep 1 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 topic pub -t 1 /turtle1/energy std_msgs/msg/Int32 "{data: 1000}"') 
(sleep 1 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 topic pub -t 1 /turtle2/energy std_msgs/msg/Int32 "{data: 1000}"') 
(sleep 1 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 service call /turtle1/set_pen turtlesim/srv/SetPen "{\"r\": 255, \"g\": 255, \"b\": 255, \"width\": 12, \"off\": 0}"')
(sleep 1 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 service call /turtle2/set_pen turtlesim/srv/SetPen "{\"r\": 255, \"g\": 255, \"b\": 255, \"width\": 12, \"off\": 0}"') 
(sleep 1 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 service call /turtle1/teleport_absolute turtlesim/srv/TeleportAbsolute "{x: 0.5, y: 0.5, theta: 0}"') 
(sleep 1 &&  sudo docker exec -d turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && service call /clear std_srvs/srv/Empty') 


sudo docker exec turtles_example /bin/bash -c 'echo "source /opt/ros/humble/setup.bash && cd ~/ &&\
    mkdir -p ~/ros2_ws/src &&\
    cd ~/ros2_ws/src &&\
    ros2 pkg create --build-type ament_python embedded_mas_examples --dependencies std_msgs rclpy &&\
    mkdir -p ~/ros2_ws/src/embedded_mas_examples/embedded_mas_examples/ && \
    cd ~/ &&\
    git clone https://github.com/embedded-mas/jason-ros-course-wesaac2024.git &&\
    cd ~/ros2_ws/src/embedded_mas_examples/embedded_mas_examples/ &&\
    cp ~/jason-ros-course-wesaac2024/resources/turtlesim-extension/setup.py ~/ros2_ws/src/embedded_mas_examples/ &&\
    cp ~/jason-ros-course-wesaac2024/resources/turtlesim-extension/energy_turtle.py ~/ros2_ws/src/embedded_mas_examples/embedded_mas_examples/ &&\
    cd ~/ros2_ws/ &&\
    colcon build &&\
    source install/setup.bash &&\
    echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc  &&\
    ros2 run embedded_mas_examples service " >> /test.sh &&\
    chmod +x test.sh '
    
sudo docker exec -d turtles_example /bin/bash -c './test.sh'    

echo -e '\e[1;33m**** Docker container is ready. Start the JaCaMo application ****\e[0m'
