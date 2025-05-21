
/* The plans below illustrate the reading of integer values and the writing to ros topics */
+value1(V) : V>10000.


+value1(V)
   <- .wait(500);
      //execute "update_topic2" upon "sample_roscore". Such action is translated to a rostopic pub
      .update_value1(V+1).
      

// docker run -it --rm --name ros2 -p9090:9090 -v ~/temp/docker:/temp maiquelb/embedded-mas-ros2:latest bash