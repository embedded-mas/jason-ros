# Example of ROS-Based agent

## Scenario
This example considers a scenario where two robots identified as <em>turtle1</em> and <em>>turtle2</em>. Both of them have two goals: (i) to clean the entire environment and (ii) to maintain their energy level above a critical threshold. They have different strategies to navigate the environment: <em>turtle1</em> starts at the leftmost-bottom position of the environment, while <em>turtle2</em> starts at the rightmost-top. The <em>>turtle1</em> continuously follows a north-east-south-east sequence, where the east traversing is smaller than the other ones. <em>turtle2</em>, in turn, continuously follows a south-west-north-west sequence, where the west traversing is smaller than the other ones

The robots need to coordinate their navigation to be efficient to avoid going through a zone that has been already cleaned. Each robot may also have different strategies for saving energy when necessary. In this example, <em>turtle1</em> slows the navigation velocity down while the <em>turtle2</em> decreases the cleaning effort. The robots work in an uncertain environment whose security level that may fall down to a critical level which requires the robots to act to stay safe. This critical security level may be perceived by a single robot. It must share this information so that the other one be aware of this situation and can act to handle it. To facilitate the observation of the security level, the simulator background is red when the security level is critical and blue otherwise.




## Running the example

<!--
=== Requirements
1. ROS 1 (recommended [ROS Noetic](http://wiki.ros.org/noetic)) or ROS 2 (recommended [ROS Humble](http://wiki.ros.org/humble)) 
2. [Rosbridge](http://wiki.ros.org/rosbridge_suite/Tutorials/RunningRosbridge)
3. [Turtlesim](http://wiki.ros.org/turtlesim)

-->

### 1. Simulator setup:
<!--


The easiest way to set up the ROS requirements is using docker containers.

First of all, make sure that there is no container named ```novnc``` or ```turtles_example```. Use the following commands to stop and remove these containers if needed:
```
sudo docker stop novnc turtles_example
sudo docker rm novnc turtles_example
```

Then, use the following commands to launch the nodes:
   ```
sudo docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest  && \
sleep 2 &&\
sudo docker run -it --name turtles_example --rm --net=ros --env="DISPLAY=novnc:0.0" --env="ROS_MASTER_URI=http://localhost:11311" -p11311:11311 -p9090:9090 maiquelb/embedded-mas-ros:0.7 /bin/bash -c 'source /opt/ros/noetic/setup.bash && cd /embedded_mas_ros_example_package/ && git pull && cp -r /embedded_mas_ros_example_package/src/embedded_mas_examples/ /catkin_wsp/src && roscore & (sleep 2 && source /opt/ros/noetic/setup.bash && roslaunch rosbridge_server rosbridge_websocket.launch) & (sleep 2 && source /opt/ros/noetic/setup.bash && (rostopic pub /turtle1/energy std_msgs/Int32 100 & rostopic pub /turtle2/energy std_msgs/Int32 100)) & (sleep 2 && (source /opt/ros/noetic/setup.bash && . /catkin_wsp/devel/setup.bash && rosrun embedded_mas_examples energy_turtle1.py & (sleep 6 && source /opt/ros/noetic/setup.bash && rosservice call /turtle1/consume_energy )) ) & (sleep 1 && source /catkin_wsp/devel/setup.bash && rosrun turtlesim turtlesim_node) & (sleep 2 && source /opt/ros/noetic/setup.bash && rosservice call /turtle1/teleport_absolute 0.5 0.5 0 && rosservice call /clear && rosservice call /spawn 10.4 10 0 "turtle2" && rosservice call /turtle1/set_pen 255 255 255 12 0 && rosservice call /turtle2/set_pen 255 255 255 12 0) && wait'

   ```
-->

This application uses an extended version of the link:http://wiki.ros.org/turtlesim[turtlesim simulator], where two turtle shaped robots move around a square environment. The robots are controlled by ROS nodes. 

To set up this infrastructure, launch a Docker container with all the requirements using the following command:
```
./ros-launch.sh
```
If Docker requires sudo permissions, precede the command above with `sudo`.

The simulator can then be accessed at http://localhost:8080/vnc.html

<!--
##### 1.1.2 ROS 2:
```
sudo docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest  && \
sudo docker run -d --net=ros --name roscore --rm osrf/ros:noetic-desktop-full roscore && \
sudo docker run -it --net=ros --env="DISPLAY=novnc:0.0" --env="ROS_MASTER_URI=http://roscore:11311" --rm --name embedded-mas-example -p9090:9090 maiquelb/embedded-mas-ros2:0.5 /bin/bash -c "source /opt/ros/humble/setup.bash && ros2 run turtlesim turtlesim_node" & \
(until sudo docker exec embedded-mas-example /bin/bash -c "echo '***** ROS container is ready *****'" 2>/dev/null; do echo "waiting for ROS container to start..."; sleep 1; done  && \
sudo docker exec  embedded-mas-example /bin/bash -c "source /opt/ros/humble/setup.bash && ros2 launch rosbridge_server rosbridge_websocket_launch.xml")
```

#### 1.2 Local setup: 
Requirements
1. ROS 1 (recommended [ROS Noetic](http://wiki.ros.org/noetic)) or ROS 2 (recommended [ROS Humble](http://wiki.ros.org/humble))
2. [Rosbridge](http://wiki.ros.org/rosbridge_suite/Tutorials/RunningRosbridge)

To run the ROS node in your computer, run the following steps:

##### 1.2.1  Start the roscore:
ROS 1: ``` roscore ```

ROS 2: this step is not requred.

##### 1.1.2. Launch the bridge between ROS and Java
ROS 1:
```
roslaunch rosbridge_server rosbridge_websocket.launch
```

ROS 2:
```
ros2 launch rosbridge_server rosbridge_websocket_launch.xml
```

##### 1.1.3. Launch the turtlesim simulation
ROS 1: 
```
(rosrun turtlesim turtlesim_node &\ 
 (sleep 1 && rosservice call /turtle1/teleport_absolute 0.5 0.5 0 &&\ 
 rosservice call /clear )) &\
(sleep 2 && rosservice call /spawn 10.4 10 0 "turtle2")
```
ROS 2:
```
ros2 run turtlesim turtlesim_node &\
 (sleep 1 &&\ 
  ros2 service call /turtle1/teleport_absolute turtlesim/srv/TeleportAbsolute "{x: 0.5, y: 0.5, theta: 0}" &&\ 
  ros2 service call /clear std_srvs/srv/Empty) &\
(sleep 1 && ros2 service call /spawn turtlesim/srv/Spawn "{x: 10.4, y: 10.0, theta: 0.0, name: 'turtle2'}")
```

<!--
rosservice call /turtle1/teleport_absolute 0.5 0.5 0
rosservice call /clear
rostopic pub /turtle1/energy std_msgs/Int32 100

rosservice call /spawn 10.4 10 0 "turtle2"


rosrun turtlesim turtlesim_node && \
rosservice call /turtle1/teleport_absolute 0.5 0.5 0

rosrun turtlesim turtlesim_node & (sleep 2 && rosservice call /turtle1/teleport_absolute 0.5 0.5 0 && rosservice call /clear) & (sleep 2 && rosservice call /spawn 10.4 10 0 "turtle2" ) & python3 src/python/energy.py 

-->


### 2. Launch the Multi-Agent System:

Linux:
```
./gradlew run
```
Windows:
```
gradlew run 
```

## Some notes on the ROS-Jason integration
This integration is part of a broader integration framework available [here](https://github.com/embedded-mas/embedded-mas)

Agents are configured in the jcm file (in this example, [perception_action.jcm](perception_action.jcm)). This example has what we call a <em>cyber-physical agent</em>, which is a software agent that includes physical elements. It may get perceptions from sensors while its actions' repertory may include those enabled by physical actuators. Cyber-physical agents are implemented by the class [`CyberPhysicalAgent`](https://github.com/embedded-mas/embedded-mas/blob/master/src/main/java/embedded/mas/bridges/jacamo/CyberPhysicalAgent.java), that extends [Jason Agents](https://github.com/jason-lang/jason/blob/master/src/main/java/jason/asSemantics/Agent.java). The physical portion of cyber-physical agents is set up in a yaml file with the same name and placed in the same folder as the asl file where the agent is specified. In this example, this file is placed [here](src/agt/sample_agent.yaml).


A cyber-physical agent can be composed of one to many <em>devices</em>, which are defined in the yaml configuration file. A <em>device</em> is any external element which sensors and actuators are connected to. A device that may be either physical (e.g. an Arduino board), or virtual (e.g. a ROS core). Each device has a unique identifier, which is set in the ```device_id``` key of the yaml file. In this example, the agent is composed of a single device, that is a ROS core identified as <em>sample_roscore</em>. An agent can connect with multiple ROS core, if necessary (it is not the case in this example). Besides, an agent can connect with non-ros devices (not shown in this example). Any device is implemented by a Java class that provides interfaces between the parception/action systems of the agent and the real device, according to the [IDevice interface](https://github.com/embedded-mas/embedded-mas/blob/master/src/main/java/embedded/mas/bridges/jacamo/IDevice.java). In this example, it is implemented by the class [RosMaster](https://github.com/embedded-mas/embedded-mas/blob/master/src/main/java/embedded/mas/bridges/ros/RosMaster.java). The device implementing class is defined in the ```className``` key of the configuration file. In addition, a <em>device</em> has three essential configuration items: <em>microcontrollers</em>, <em>perception sources</em>, and <em>enabled actions</em>. These items are explained below.


### Microcontrolers configuration
A device has a <em>microcontroller</em>, which is a Java interface that enables reading from and writing in the physical/virtual device. This interface is set up under the ```microcontroller``` key in the yaml file. Any microcontroller has an identifier, defined in the key ```id```. Any microcontroller implementation must implement the [IExternalInterface](https://github.com/embedded-mas/embedded-mas/blob/master/src/main/java/embedded/mas/bridges/jacamo/IExternalInterface.java). In this example, it is implemented by the class [DefaultRos4EmbeddedMas](https://github.com/embedded-mas/embedded-mas/blob/master/src/main/java/embedded/mas/bridges/ros/DefaultRos4EmbeddedMas.java). The device implementing class is defined in the ```microcontroller/className``` key of the configuration file. In addition, different microcontrollers may have some parameters that are depending on their nature. For example, serial devices like Arduino require configuring serial ports and baud rates. In this example, the microcontroller is a ROS-Java interface. It has a ROS specific parameter, whose key is ```connectionString```. It sets the connection string to the ROS core (e.g. ws://localhost:9090).


### Perception configuration
The sensors connected to a <em>device</em> may be source of perceptions of the agent. If the device is a ROS core, then these sensors are abstracted through topics. The list of topics that produce perceptions is configured in the ```perceptionTopics``` item in the yaml file.  Each topic requires to define its name and its type, through the keys ```topicName``` and ```topicType```, respectively. The key ```beliefName``` defines the belief identifier (or <em>functor</em>) corresponding belief. For instance in this example, the topic ```turtle1/pose``` produces the belief ```turtle_position```. The ```beliefName``` configuration is optional. If it is omitted, the belief has the same identifier as the topic.

### Action configuration   
The actions enabled by the actuators connected to a <em>device</em> may be included in the agent's action repertory. If the device is a ROS core, then these actions may be realized both through topic writings and service requests, configured in the keys ```topicWritingActions``` and ```serviceRequestActions``` of the yaml file, respectively. In this example, the agent performs only service request actions, that require the following configurations:
    
   - ```actionName```: the name of the action performed by the agent;

   - ```serviceName```: the name of the service to be called;

   - ```params```: a list of the names of parameters required by the service.



