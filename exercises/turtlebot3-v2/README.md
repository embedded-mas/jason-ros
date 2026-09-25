# Problem statement

This exercise has an agent (see the agent code [here](src/agt/ros_agent.asl)) whose body is a simulated [Turtlebot3](https://emanual.robotis.com/docs/en/platform/turtlebot3/overview/).

The agent has the goal `go_to(X,Y)`, to move from its current position to the coordinates (X,Y). The objective of this exercise is to provide the agent with means to satisfy this goal. 

## Instructions

 The perceptions of the agent (and its corresponding beliefs) come from the robot's sensors. The actions of the agent are actually realized through the robot's actuators. The connection between the agent code and its body must be specified in the yaml file [here](src/agt/robot1.yaml). The essential elements of this specification are already done. You must specifcy the elements `perceptionTopics`, `actions`, and, if needed, `percption_rules`.

Informations about the robot position are available in the topic `odom`. 

To move the robot, use the service `move_robot`.

Information about the topics `odom` and `cmd_vel`are available [here](https://wiki.ros.org/turtlebot3_bringup).

The service `move_robot` is an extension of the default turtlebot3 simulation. The type of this service is `embedded_mas_examples/MoveRobot`, which requires two parameters --- linear velocity and angular velocity --- and returns *true* in case of success and *false* otherwise, as described below:
```
float64 linear_velocity
float64 angular_velocity
---
bool success
```


# 3. Requirements
- Java JRE >= 21

# 4. Running the exercise
Running the example requires two main steps:  
1. Launch the ROS infrastructure (cf. Section 4.1 below)
2. Launch the JaCaMo application (cf. Section 4.2 below)


### 4.1. Launching the ROS node:

In a shell, type ```./launch_ros.sh``` to launch the ROS infrastructure. (preceed with ```sudo``` if needed).

Then, go to [http://localhost:8080/vnc.html](http://localhost:8080/vnc.html) to inspect the simulator.

### 4.2. Launch the JaCaMo application:

#### Linux:
```
./gradlew run
```
#### Windows:
```
gradlew run 
```
