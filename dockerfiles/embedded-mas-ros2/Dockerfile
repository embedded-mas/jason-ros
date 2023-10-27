FROM osrf/ros:humble-desktop-full

RUN apt-get update && sudo apt-get dist-upgrade -y && apt-get install -y git wget python3-pip vim
RUN pip3 install setuptools==58.2.0
RUN source /opt/ros/humble/setup.bash
RUN ros2 launch rosbridge_server rosbridge_websocket_launch.xml



#EXPOSE 11311

ENV DISPLAY=novnc:0.0

# build da imagem: sudo docker build -t maiquelb/embedded-mas-ros2 .

# iniciar o container:  sudo docker run -it --rm -p11311:11311 --net=ros maiquelb/embedded-mas-ros2

# iniciar o turtlesim: ros2 run turtlesim turtlesim_node

# para mover a tartaruga: ros2 topic pub /turtle1/cmd_vel geometry_msgs/msg/Twist '{linear: {x: 2.0}}' -1

