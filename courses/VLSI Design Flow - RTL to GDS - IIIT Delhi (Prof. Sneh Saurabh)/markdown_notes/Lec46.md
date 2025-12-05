**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 46**
**Installation of OpenRoad**


Hello everyone. My name is Jasmine Kaur and I am a PhD student at IIIT Delhi and I am
your TA for the course VLSI Design Flow RTL to GDS. In the previous tutorials, we
have explored different tools for the various stages of VLSI design flow from high level
synthesis to logic synthesis. Now in this tutorial, we will move on to physical design for
which we will be using an open road app which is an open source tool. And what is an
open road? It is an integrated circuit physical design tool that takes the design from logic
synthesized every log that we obtained from the logic synthesis step to the final routed
layout. So what are the different steps that will be carried out using the open road? That
is chip planning which includes floor planning, power planning, then placement, then we
will do clock tree synthesis and then finally we will do routing.


So in this tutorial, we will see the steps to build an open road locally in your machine.
So for this, we will open a WSL window and in that we will clone the repository from
GitHub. So git clone minus minus recursive and this is the link from GitHub to
download the repository. Enter.


So it is downloading the repository from GitHub. Now we will go into the directory
open road, cd open road. In this, now we need to install the dependencies for that we will
sudo dot slash etc dependency installer dot sh. So this file contains all the dependent
files and applications and programs that are required for open road. So it is downloading
these dependencies.


So it will take quite some time. So after these dependencies are downloaded, now we
will make a directory build and now moving on into this directory, now c make. So this
will take a few seconds. Then the next command is make command. So after you run
this command, it will take around two hours for installation.


So after the installation is complete, the final command is sudo make install. It will ask
for a password and it will build all the files. Now the open road is installed and we can
see that this open road folder is created after this and let us see what are the contents of
this open road folder. So in this we can see these are the different files and folders. Then
let us look at the test folder inside this open road.


So here we can see there are Nangate 45, ASAP7 and Skywater. So these are the
different libraries that are there that come as you install open road. So these are already
there. And then we have these scripts, TCL files, Verilog files and constraint files. So
we have example scripts here.


So in our tutorials we will be looking at GCD examples using Nangate 45 library. And
now we can see how we can run this open road tool. So we type open road, enter and we
can see that we can run this tool. So we will look at the various examples and various
commands and various scripts in the next tutorial. Thank you.


