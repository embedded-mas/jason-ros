FROM osrf/ros:humble-desktop-full

RUN apt-get update && sudo apt-get dist-upgrade -y && apt-get install -y git wget python3-pip vim ros-humble-rosbridge-suite nano && echo "source opt/ros/humble/setup.bash" >> ~/.bashrc && cd / && git clone https://github.com/embedded-mas/embedded_mas_ros_example_package.git && cd /embedded_mas_ros_example_package && git pull && cd / && mkdir ros2_ws && cd ros2_ws && mkdir src && cd src &&   /bin/bash -c "source /opt/ros/humble/setup.bash && ros2 pkg create --build-type ament_python embedded_mas_examples" && cp -r /embedded_mas_ros_example_package/ros2/embedded_mas_examples/ /ros2_ws/src/embedded_mas_examples/ && cp /embedded_mas_ros_example_package/ros2/*.* /ros2_ws/src/embedded_mas_examples/ && cd /ros2_ws && colcon build && /bin/bash -c "source install/local_setup.bash" && echo "source /ros2_ws/install/local_setup.bash" >> ~/.bashrc


RUN pip3 install setuptools==58.2.0




#EXPOSE 11311

ENV DISPLAY=novnc:0.0

#CMD source opt/ros/humble/setup.bash
#CMD echo "source opt/ros/humble/setup.bash" >> ~/.bashrc

#CMD cd /ros2_ws/src
#CMD ros2 pkg create --build-type ament_python embedded_mas_examples 
#CMD cp -r /embedded_mas_ros_example_package/ros2/embedded_mas_examples/ /ros2_ws/src/embedded_mas_examples/ 
#CMD cp /embedded_mas_ros_example_package/ros2/*.* /ros2_ws/src/embedded_mas_examples/ 
#CMD cd /ros2_ws 
#CMD colcon build 
#CMD source install/local_setup.bash 
#CMD echo "source /ros2_ws/install/local_setup.bash" >> ~/.bashrc

CMD ros2 launch rosbridge_server rosbridge_websocket_launch.xml


# build da imagem: sudo docker build -t maiquelb/embedded-mas-ros2:versao .

# iniciar o container:  sudo docker run -it --rm -p9090:9090 --net=ros maiquelb/embedded-mas-ros2

# iniciar o turtlesim: ros2 run turtlesim turtlesim_node

# para mover a tartaruga: ros2 topic pub /turtle1/cmd_vel geometry_msgs/msg/Twist '{linear: {x: 2.0}}' -1
 
