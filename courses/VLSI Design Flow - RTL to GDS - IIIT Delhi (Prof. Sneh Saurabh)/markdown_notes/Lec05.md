**VLSI Design Flow: RTL to GDS**



**Dr. Sneh Saurabh**
**Department of Electronics and Communication Engineering**



**IIIT-Delhi**



**Tutorial 1**
**Lecture - 5**
**Unix Commands**


Hello everyone. My name is Jasmine Kaur. I am a Ph.D. student at IIIT Delhi, and I will be your
TA for the course VLSI Design Flow: RTL to GDS. In this tutorial, I will provide you with a
head start on Unix commands, which is an important skill set in VLSI design. For this, you will
require a Unix system, but if you don't have one, you can easily install WSL, which is a
Windows Subsystem for Linux, and this will provide you with a compatible environment for
Unix. So, let us see how we can install Unix on your systems.


So, firstly, we will open Windows PowerShell in administrator mode. Here, you can type: wsl -install
Now, this will start installing WSL. This might take a few seconds. Now, after it is installed, it is
installing Windows Subsystem for Linux. Now, the WSL kernel is being installed. Now, Ubuntu
will be installed. This will take a few seconds. So, it is almost done. So, Ubuntu is successfully
downloaded. Now, the system is asking for a reboot. So, you need to reboot your system. After
you will reboot, it will ask for a username and password. So, after setting up your password and
username, you can easily work on WSL.


Now, we can open the WSL window and directly run Unix commands on that. Firstly, we will go
to the home directory using the cd command. I will discuss this command in more detail after the
next command. So, the first command is ls. This command lists all files and directories in this
current working directory.


The next command is cd command. This refers to change directory. So, we can move to any
directory using this command. So, let us say we go to the lab directory. Now we are in the lab
directory.


Using pwd command, we can check the path of the current working directory. So, pwd enter, we
can see we are in this home/jasminek/lab. So, next, we can check what are the different files in
this directory using ls. So, these are the files and directories that are there.


The next command is mkdir command. So, this command is used to make new directories. Let us
try to make directory tutorial1. We can check if this directory has been created. So, we can see
that tutorial1 has been created here.


The next command is mv command, which is used to move files and directories from one
location to another. Let us try moving Unix commands to tutorial 1. Using ls command, we can
check that this has been moved to tutorial1 and is no longer in this lab directory.


cp command, which is used to copy files and directories. So, let us make a copy of a.txt file as
a_copy.txt. So, using ls command, we can see that copy has been created.


The next command is touch command. This command is used to create empty files. Let us create
a d.txt file. Again, we can check that this file has been created.


Moving to the next command, which is rm, using this, we can remove files and directories. So,
let us remove d.txt, and we can check that this file has been deleted.


The next command is cat command. Using this command, we can read and show the contents of
any file. So, for the a.txt file, we can see the contents are being shown in the terminal.


The next command is which command. This is used to show the path of the executable file of
any command. So, let us check for cat, which cat is there at usr/bin. For ls, we can see it is also
there at usr/bin.


The next command is man command. This command is used to show the man page or user
manual of any command. Let us check for ls. So, here we can see the complete description of the
command ls with the different options.


The next command is sudo command. This command provides the user with privileges that only
the root user can have. Let's say we want to update the system. We can do that using apt-get
update command and see that permission is denied. So, for this, we will need sudo access. So, we
type sudo apt-get update. It will ask for a password, and after that, we can see it is installing. So,
the update is done.


The next command is du command, which stands for disk usage. So, this command is used to see
disk space used by different files and directories. Using -h option, we can change the sizes to a
human-readable form. So, du -h. Here, we can see the sizes are now in human-readable form in
kilobytes.


The next command is df, which is disk-free. This command tells us about the file system space
available on the system. So, here, we can see the different file systems and the space being used.
Using -h again, we can change it to human-readable form. So, df -h here, we can see the total
size, the amount of space that is used, and the amount of space that is available on the different
file systems.


The next command is ps, which stands for process status. So, we can see all the processes that
are running currently using this command. So, here we can see that.


The next command is top command. This command tells us about the dynamic real-time view of
the running system. So, here we can see the resources being used by different processes, the CPU
and memory usage and it is changing dynamically.


The next command is bg command. This command is used to move any jobs running to the
background. First, let us check the different jobs running using the jobs command. We can see
no jobs are running currently. Let us create a dummy job using sleep command. Sleep for 100
seconds. Now, the system is in sleep mode. Let us stop this using control+z. Now, let us see
again using the jobs command. We can see that the sleep 100 is there, but this is stopped
currently. So, we can move it to the background using bg command and bg %1. 1 here is the
process's id. So, we can see using jobs command that sleep 100 is running, and & here means
that it is running in the background.


The next command is fg command, which is used to bring the background jobs to the foreground.
So, let us move this command back to the foreground. So, now, this is again in the foreground.


Moving on to the next command, which is history command. So, this command gives the history
of all the commands that were run in the terminal. So, here we can see the list, complete list.


The last command for today is whoami. This command is used to tell the user name of the
current user.
These are a few of the most commonly used UNIX commands. You can have a look at them in
the tutorial sheet that we will be providing. Thank you.


