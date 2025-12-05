**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 41**
**Power Analysis using OpenSTA**


Hello everybody. Welcome to the course VLSI Design Flow RTL to GDS. This is the
tutorial for the 9th week. In this tutorial, we will be looking into power analysis.
Specifically, the objective of this tutorial is to gain hands-on experience on power
analysis using open source tool OpenSTA. So the requirements for this tutorial is that
first we should have OpenSTA installed on our system.


So the installation and how to run OpenSTA was described in tutorial 7. So if you have
not yet installed OpenSTA, please install it by taking help of tutorial 7. Then we will be
needing the following files, the design file test.v script file test.


tcl, the sdc file test.sdc and the technology library toy.library. So all these files are
available on the NPTEL website as study material for week 9. So you can download
these files and use them for your experiments.


Now in this tutorial, we will be covering the concepts of power analysis. So power
analysis was discussed in lecture 29. So let us first recap the concepts of power analysis.
Then we will be carrying out the experiments. Now given a CMOS circuit, there are two
major components of power dissipation.


The first is the dynamic power dissipation and the second is leakage power dissipation
or static power dissipation. Now that power analysis tool basically divides the dynamic
power dissipation into two components and what are they? The first is the internal
power component and the second one is the external power component. So the internal
power dissipation is basically the power dissipated within a cell. So the internal power
dissipation can occur because of internal capacitances within the cell which are charging


and discharging and also due to the short circuit current that flows during when a cell
switches its state. And the external power dissipation is basically decided by the external

capacitances which are
charged and discharged when
a logic gate transitions.


So these external
capacitances can be wired
load or the pin load which are
being driven by a particular
cell. And the internal power
dissipation component that is
modeled in the technology
library as a non-linear power
model. So we have seen a
non-linear power model that
models internal power as that
in terms of or as a function of
input slew or input transition
and the output load and output load or the load capacitance. So it is modeled as a two
dimensional table as we will be seeing in today's tutorial. Now let us run OpenSTA and
examine how power analysis is done by the two.


So let us first check whether we have all the necessary files. So we have the SDC file,
the TCL file, the Verilog file and the library. So we have all the necessary files. Now let
us see the design file, test.


v. So in the design file we have one module, the top and it has got two ports, one input
port A and output port out. And it has got only one instance and that of an inverter. So
the inv is the name of the cell which will be present in the technology library and i1 is
the name of the instance. So we have taken a very simple design so that we can
understand the various components of power dissipation. Now let us look at the SDC
file and what constraints are we applying to our design.


So we are applying a clock and its period is 1000 picoseconds and then we are
specifying input and output delay of 5 picoseconds at the input ports A and the output
port out. And we are specifying the input transition or input slew as 0.1 at input port A.
And we are specifying load or output capacitance at the output port out and its value is
0.1 library units that is 0.


1 in this case. Now let us look into the script file or TCL file that we are going to run.
So in this tutorial what we will first do is that we read the library toy.lib then we read the
design test.v and then link the instances of the design that is i1 or inverter to the cell in
the library toy.


lib. Then we will read the SDC file test.sdc then we set the power activity. So when the
dynamic power dissipation depends on how frequent the switching is occurring in our
circuit. So to compute a dynamic power dissipation tool will need to know the activity of
the signals. So if we do not specify a tool can assume default activity in this case we are
saying that the activity is 0.


1. And then we ask the tool to report the power. Now let us run the tool open sta tool.
So since the tool is already installed on my machine I can run simply as sta. So the tool
open sta is run and now we say source test.tcl so we are running the script file.


So when we do source test.tcl all the commands that I have shown reading the verilog
file, reading the library, linking and reading the SDC file all will be done. And finally it
is reporting the power. We had written the command report power and the power is being
reported here. Now the tool has reported four columns related to power.


The first one is internal power, the second one is switching power and third one is
leakage power and then the total power. Now let us understand how the tool computes
the internal power as 1.5 into 10 to the power minus 7 and the unit is what. So this
information of internal power as I said comes from the library. So we need to open the
library and exit the tool and open the library toy.


lib to get the information that was derived from the library by the tool to report the
internal power. So we open the file toy.lib. So now I go to the cell I and V. So I and V
this is the cell that was instantiated in our design and we see that there is a pin output pin
Zn and for this Zn there is an internal power arc here.


So there is an internal power arc and the related pin is I. So the power arc is between I
and Zn and what are the values of the power dissipation. So fall power and rise power
are specified separately and there the values are specified here and at what slew and load
these powers are these numbers are reported that is defined in the power template. So
now we have to go to this power template which is at the top of this file. So I go to the
top of this file and see the template power template.


So in the power template it is written that input transition time is there and its value is
0.1 and 100 library units and total output net capacitance or output load is 0.1 and 100.


So there are two characterization points for the slew and two characterization points for
the load. So this is a toy library therefore there are only two characterization points in a
typical library there will be say eight characterization points for slew and eight for load
and so on that is so there will be multiple characterization points will be there.


But since this is a toy library there are only four characterization points and what are
the values. So to know the values we have to go to the cell inv. This is the cell inv and
we see the value. So the value is 1, 2, 3, 4 for the fall case and 2, 4, 6, 10 as for the rise
case. Now corresponding to these values we can draw a table for easy understanding and
I have drawn that and the table will look something like this. So the table contains 1, 2,
3, 4 and the rows the transition or slew are all along the rows and load is loads are along
the column.


So 1, 2, 3, 4 for the fall case and 2, 4, 6, 10 for the rise case. Now which of these values
will be used? Now the values that will be used for internal power computation will come
from the circuit condition and in circuit we have specified the constraint as 0.1 slew at
the input port in the SDC file we had written that and 0.1 femto farad for the load we
had used the command set load during the specifying the constraints .


So corresponding to 0.1 slew and 0.1 load we have to see the first row and first column.
So the fall value is 1 and the rise value is 2 . Now the values that are reported in
non-linear power models correspond to energy consumed per transition; those are not the
power numbers; they are basically the energy consumed per transition that number is
reported . Now say if we take the average of these two so the average energy consumed
from each transition will be 1 plus 2 divided by 2 that is 1.


5 and the unit of energy in the library is a point of femto joule. So the average energy
consumed per transition is 1.5 into 10 to power minus 15 joules. We have converted
femto joule to joule. Then in the SDC file we had specified that the clock period is 1000
picoseconds and if we want to find the number of clock cycles per second then we will
just take the reciprocal of the clock period . So it will turn out to be 10 to the power 9 .


Now the activity we had specified in the TCL file so from the activity what is activity
is the number of transitions per clock cycle and we had defined its value to be 0.1 . So
the number of transitions per second will be 0.1 into the number of clock cycles per
second so 0.


1 into 10 to power 9. So now we can compute the internal power as energy per transition
which is 1.5 into 10 to the power minus 15 into the number of transitions per second
which is 0.1 into 10 to the power 9. So we will get 1.5 into 10 to the power minus 7


watts and this is what was reported in the 2 1.


5 into 10 to the power minus 7 watts. Now let us understand how the tool computes the
switching power as 5 into 10 to the power minus 9 watt . So the switching power
consumption is much easier so to compute the switching power computation the tool
must know the load load at the load driven by a cell . So in this case we had specified the
load using the set load command. Its value was 0.1 pham to phara and we are assuming
that there is no wire load and no other pin load because it is just driving the output port
directly . So whatever the load we have specified that is the load being driven by this
inverter and here and therefore and the voltage that was specified in the library was 1
volt for this cell .


So we can compute the energy dissipated in 1 transition when 1 change happens then
the energy dissipated is half c v square the energy that was stored in the capacitor half c
v square. So if we compute half c v square using c is equal to 0.1 pham to phara and
voltage as 1 volt will get it the value as 5 into 10 to power minus 17 joules . Now this is
the energy to get the switching power. We have to multiply it with the number of
transitions per second and we have already computed the number of transitions per
second as 0.


1 into 10 to the power 9 . So we multiply the energy per transition with the number of
transitions per second we get 5 into 10 to power minus 9 watt which was reported by the
tool 5 1.5 sorry 5 into 10 to power minus 9 . Now the third component is the leakage
power 1.5 into 10 to power minus 10 is reported by the tool how did the tool compute.
So the tool computed this by looking at the library.


So let us look into the library. So in the library there is a statement about cell leakage
power for the inverter. So there is the inverter Inv for the I n v inverter the cell leakage
power is 150 the value is 150 in library units and what is the library unit for leakage
power it is specified and the top in the header. So the library leakage power unit is 1
pico . So it is 150 pico watt that is what the leakage power is. So if we convert 1 kilowatt
sorry 150 pico watt into watt it will come out to be 1.


5 into 10 to power minus 10 watt which is reported by the tool . So and then finally, what
the tool does is that it adds all these 3 powers to get the total power dissipated in the
circuit . So this completes the tutorial. So let me summarize what we have done in this
tutorial. So in this tutorial we have used the open sa tool to compute the power power or
do the power analysis and then using various information such as information from the
library we understood how the tool did the power analysis .


Now in this tutorial we have taken a very simple circuit or a trivial circuit consisting just
of just an inverter. So we have done so so that we can easily illustrate how power
analysis is done. Now when the circuit is big the same concepts apply, but in that case
we will have more cells and the power computation will be more complicated. So I will
suggest that you play with various designs you can write test dot v yourself you can add
more instances you can change the constraints sdc file by changing the clock period and
the input transition and load and see that how the power analysis changes and and we
can also change the activity factor in the in the in the tcl file . So I will suggest that you
do those experiments so that you can understand power analysis in depth. Thank you
very much.


