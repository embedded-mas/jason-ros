
//export TURTLEBOT3_MODEL=burger && roslaunch turtlebot3_gazebo turtlebot3_world.launch

max_actuations(10000). //set a value X>0 to finish the application after X actuations
actuations(0).


 //obstacle_distance(D) :- obstacle_distance(ranges(D)).

// obstacle(front,X) :- obstacle_distance(L) &
//                      .length(L,S) & 
//                      .nth(0,L,X).    


// obstacle(right,X) :- obstacle_distance(L) &
//                      .length(L,S) & 
//                      .nth(40,L,X).    


// obstacle(left,X) :- obstacle_distance(L) &
//                     .length(L,S) & 
//                     .nth(300,L,X).    


// !walk. //goal to move around the environment

// +!walk : obstacle(front,F) & F < 1 
//    <- .print("Obstacle front") ;
//       .move_robot([-0.1,0,0],[0,0,0.0]);
//       ?actuations(A);
//       -+actuations(A+1);
//       .wait(100);
//       .move_robot([0,0,0],[0,0,-0.2]); //turn right
//       ?actuations(A2);
//       -+actuations(A2+1);
//       .wait(100);
//       !walk.   

// +!walk : obstacle(left,L) & L < 0.2 &
//          (not obstacle(right,_) | obstacle(right,R) & R > L)
//    <- .print("Obstacle left") ;
//       .move_robot([0,0,0],[0,0,-0.2]);
//       ?actuations(A);
//       -+actuations(A+1);
//       .wait(100);
//       !walk.

// +!walk : obstacle(right,R) & R < 0.2 &
//          (not obstacle(left,_) | obstacle(left,L) & L > R)
//    <- .print("Obstacle right") ;
//       .move_robot([0,0,0],[0,0,0.2]);
//       ?actuations(A);
//       -+actuations(A+1);
//       .wait(100);
//       !walk.


   

// +!walk 
//    <- .print("no obstacle") ;
//       .move_robot([0.2,0,0],[0,0,0.0]);
//       ?actuations(A);
//       -+actuations(A+1);
//       .wait(100);
//       !walk.      




!walk. //goal to move around the environment

+!walk : obstacle_distance(ranges(L)) &
         //.length(L,S) & 
         .nth(0,L,F) & F<0.75
   <- .print("Obstacle front") ;
      .move_robot([-0.08,0,0],[0,0,0.0]);
      ?actuations(A);
      -+actuations(A+1);
      .wait(100);
      .move_robot([0,0,0],[0,0,-0.2]); //turn right
      ?actuations(A2);
      -+actuations(A2+1);
      .wait(100);
      !walk.   

+!walk : obstacle_distance(ranges(D)) & //.length(D,S) &  
         .nth(300,D,L) & L<0.2 &
         not(obstacle_distance(ranges(K)) & .nth(40,K,R) &  R<L)
   <- .print("Obstacle left") ;
      .move_robot([0,0,0],[0,0,-0.2]);
      ?actuations(A);
      -+actuations(A+1);
      .wait(100);
      !walk.

+!walk : obstacle_distance(ranges(D)) & 
         //.length(D,S) &  
         .nth(40,D,R) & R<0.2 &
         not(obstacle_distance(ranges(K)) & .nth(300,K,R) &  L<R)
   <- .print("Obstacle right") ;
      .move_robot([0,0,0],[0,0,0.2]);
      ?actuations(A);
      -+actuations(A+1);
      .wait(100);
      !walk.


   

+!walk 
   <- .print("no obstacle") ;
      .move_robot([0.3,0,0],[0,0,0.0]);
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
