FROM maiquelb/embedded-mas-ros:0.4

RUN sudo apt-get update && sudo apt-get install -y wget nano git ros-noetic-turtlesim unzip make build-essential g++ 


RUN cd / &&\ 
    mkdir catkin_wsp &&\ 
    cd /catkin_wsp &&\
    mkdir src &&\ 
    cd src &&\
    /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_create_pkg embedded_mas_examples std_msgs rospy roscpp  && cd /catkin_wsp && catkin_make && source /catkin_wsp/devel/setup.bash " &&\ 
    echo "source /catkin_wsp/devel/setup.bash" >> ~/.bashrc &&\
    cd / &&\ 
    git clone  https://github.com/embedded-mas/embedded_mas_ros_example_package.git &&\ 
    cd embedded_mas_ros_example_package &&\
    git pull &&\
    cd / &&\
    cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src &&\
    cd /catkin_wsp &&\
    /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"



#CMD ["/install.sh"]
#CMD . /catkin_wsp/devel/setup.bash
#CMD rosrun embedded_mas_examples sum_array_server.py 




# Build da imagem: sudo docker build -t maiquelb/embedded-mas-ros:version - < Dockerfile

