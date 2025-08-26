FROM maiquelb/embedded-mas-ros:0.8

# Baixar e adicionar a nova chave pública GPG do ROS
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg

# Atualizar o source list para usar o signed-by
RUN echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu focal main" | tee /etc/apt/sources.list.d/ros-latest.list


RUN sudo apt-get update && sudo apt-get install -y wget nano git ros-noetic-turtlesim unzip make build-essential g++ ros-noetic-gazebo-ros ros-noetic-gazebo-ros-pkgs ros-noetic-gazebo-ros-control gazebo11 ros-noetic-turtlebot3-gazebo libgl1-mesa-glx libgl1-mesa-dri powerstat


RUN cd / &&\ 
    rm -rf catkin_wsp &&\  
    mkdir catkin_wsp &&\ 
    cd /catkin_wsp &&\
    mkdir src &&\ 
    cd src &&\
    /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_create_pkg embedded_mas_examples std_msgs rospy roscpp  && cd /catkin_wsp && catkin_make && source /catkin_wsp/devel/setup.bash " &&\ 
    echo "source /catkin_wsp/devel/setup.bash" >> ~/.bashrc &&\
    cd / &&\ 
    #git clone  https://github.com/embedded-mas/embedded_mas_ros_example_package.git &&\ 
    cd /embedded_mas_ros_example_package &&\
    git pull &&\
    cd / &&\
    cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src &&\
    /bin/bash -c "source /opt/ros/noetic/setup.bash" &&\
    cd /



#CMD ["/install.sh"]
#CMD . /catkin_wsp/devel/setup.bash
#CMD rosrun embedded_mas_examples sum_array_server.py 

#CMD cd /embedded_mas_ros_example_package && git pull && cd / && cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src && bin/bash -c "source /opt/ros/noetic/setup.bash" && cd /
 
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
#CMD ["/bin/bash"]

#CMD ["/bin/bash", "-c", "cd /embedded_mas_ros_example_package && git pull && cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src && source /opt/ros/noetic/setup.bash && cd /catkin_wsp && catkin_make && source devel/setup.bash && cd / && mkdir teste && exec roslaunch rosbridge_server rosbridge_websocket.launch" ]



# Copy entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use the script as the container entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to keep container alive if no other command is provided
CMD ["bash"]






# Build da imagem: sudo docker build -t maiquelb/embedded-mas-ros:version - < Dockerfile

