## Running the example
Requirements:
- [Docker](https://www.docker.com/)
- Java >= 21
  
### 1. Launch the simulator:

This application uses an extended version of the [Turtlebot3 simulator](https://emanual.robotis.com/docs/en/platform/turtlebot3/simulation/), in which robot moves within a walled environment containing additional obstacles. The simulator can be launched by following the instructions available on the [official website](https://emanual.robotis.com/docs/en/platform/turtlebot3/simulation/). However, the easiest and recommended option is to launch the provided Docker container, which includes all the requirements, using the following command:
```
./ros-launch.sh
```
If Docker requires sudo permissions, precede the command above with `sudo`.

The simulator can then be accessed at http://localhost:8080/vnc.html


### 2. Launch the Multi-Agent System:

Linux:
```
./gradlew run
```
Windows:
```
gradlew run 
```
