
//export TURTLEBOT3_MODEL=burger && roslaunch turtlebot3_gazebo turtlebot3_world.launch

max_actuations(20000). //set a value X>0 to finish the application after X actuations
actuations(0).



!walk.


+!walk : obstacle_distance(ranges(L)) &
         //.length(L,S) & 
         .nth(0,L,F) & F<0.5
   <- 
      .move_robot([-0.2,0,0],[0,0,0.0]);
      ?actuations(A);
      -+actuations(A+1);
      .wait(100);
      !walk. 


+!walk : .random(X) & .random(Z)
   <- .move_robot([X,0,0],[0,0,Z]);
      ?actuations(A);
      -+actuations(A+1);
      .wait(100);
      !walk.   

//-------------------------------------------------------------    

+actuations(A) : max_actuations(M) & M>-1 & A>M 
   <- .move_robot([0,0,0],[0,0,0.0]);
      .print("Finishing system after ", A, " actuations."); 
      .stopMAS.

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
