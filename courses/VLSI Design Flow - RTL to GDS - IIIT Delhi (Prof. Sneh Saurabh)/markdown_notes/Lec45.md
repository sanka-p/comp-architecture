**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 45**
**Basic Concepts for Physical Design - II**


Hello everybody. Welcome to the course VLSI design flow RTL to GDS. This is the
36th lecture. In this lecture, we will be continuing with the concepts which are important
for physical design. Specifically, in this lecture, we will be looking at signal integrity,
antenna effect and library exchange format or L-E-F lef files. So in the previous lecture,
we had looked into the fact that the interconnect is lying and there are many
interconnects in close vicinity of a given interconnect and that gives rise to coupling
capacitance.


So there is coupling, there are capacitances between interconnects and there exists
coupling capacitance and because of coupling capacitance what happens is that the
voltage in one interconnect can impact the voltage in the other interconnect. Meaning
that if there are two interconnects lying in close vicinity, if there is a change in voltage in
one of the interconnects, then there is some impact in the voltage in the other
interconnect also. Ideally there should not be any impact, but because they are sharing
the dielectric and they are coupled electrostatically, therefore they are the voltages of one
interconnect in impact with the voltage of another interconnect. And this creates what is
known as signal integrity issues.


Now signal integrity issues are of two types. The first is related to dynamic delay
variations, meaning that the delay of the interconnect delay associated with one
interconnect is impacted by what is happening in the neighboring interconnect. Ideally
that should not happen. So the delay of one interconnect should not be dependent on
what is happening in the other interconnects. But because of coupling and signal
integrity issues, the delay associated with one interconnect becomes a function of what is
happening in the other interconnect.


And also sometimes the activity on the neighboring lines can create functional issues in
our circuit. So we will be discussing these two manifestations of signal integrity issues
in subsequent slides. Now to understand dynamic delay variations, let us first understand
that what is the delay which is base delay, meaning that if we do not consider activities


in the neighboring wire, what is the delay value that we expect? That is known as base
delay. Now to understand base delay, consider this circuit. There is one inverter driving
another inverter through an interconnect.


And there is another inverter driving another inverter which is through another
interconnect. But these interconnects are lying in vicinity and therefore there is some
coupling capacitance Cc and with the line A, there is a ground capacitance also which
we say Cg. Now whenever we want to study signal integrity issues, then the line where
we are observing the effect of signal integrity, we say that that is the victim line. And the
line which is causing the effect on the victim line, that is known as the aggressor line.
So let us assume that A is the victim and B is the aggressor line.


Now if we assume that, then let us assume that the gate G1 makes a 0 to 1 transition,
meaning that initially the voltage of this point A was 0 volt and later on it rose to say
Vdd. Initially it was 0 and it rose to Vdd. So there is a 0 to 1 transition on the victim
line. Now the driver G1 provides a charge from the ground capacitor, charge for the
ground capacitor Cg to change from 0 to Vdd. Now this point was initially when the
line, victim line was 0, this point was 0.


So the voltage across this capacitor Cg was 0 and this point is grounded, so 0 minus 0 is
0 volt. So initially it was 0 and later on when A line changed to Vdd, then this point
became Vdd. Now voltage across this capacitor becomes Vdd because the other end is


grounded. So the capacitor Cg got charged from 0 to Vdd voltage. So the capacitance
Cg gets charged because of the transition in the line A.


When line A changes from 0 to Vdd, the capacitor Cg gets charged. Now what about
the capacitor Cc? Now capacitor Cc whether it will be charged or not, let us see. Now
the line B is having no activity meaning that it is not changing, but it can be either held
to constant 0 or constant 1. So let us understand what will be the behavior when the line
B is held constant at 0. Suppose B was held constant at 0.


So initially this capacitor voltage was, initially the line A was 0 and B is held to 0. So
initially the capacitor Cc was 0 and what is the value of the voltage across this
capacitance between VA and VB. So we can say the voltage across this capacitor Cc is
VA minus VB. Initially it was 0 and finally VA points changed to Vdd while VB
remained constant to 0. So the VA minus VB is equal to Vdd.


So G1 needs to provide a charge for coupling capacitance Cc to change from 0 to Vdd.
So the capacitance, sorry the voltage across Cc was initially 0 whenever the ground,
when the victim line was 0, the voltage across the capacitor Cc was initially 0 and later
on it became Vdd. So it means that Cc is being charged in addition to Cg. So when B is
held constant to 0 then G1 that is this driver needs to provide the charge and how much
charge it will be providing? It will provide charge sufficient to charge the capacitor Cg
plus Cc. Next let us consider that B is held constant to value of 1.


So let us see that B is held to constant 1 or Vdd. So this VB is Vdd and A is changing
from 0 volt to Vdd. So what is VAB initially? VAB initially is 0 minus Vdd is equal to
minus Vdd. And what is VB finally? VAB final is the voltage across the capacitor Cc
after A has transitioned to Vdd. So in that case the VAB that is voltage across the
capacitor is equal to Vdd, VA is Vdd minus VB, VB is also Vdd.


So VAB is equal to 0. So what is the change in voltage across the capacitor? It is 0, the
final value is 0 and the initial value is minus Vdd. So 0 minus minus Vdd and that comes
out to be plus Vdd. So what happens is that the capacitor Cc also needs to be charged by
the voltage Vdd. So what it means is that if line B is held to constant 1 then also G1
needs to provide a charge to charge the capacitor Cg and also the capacitor Cc.


So it means that the delay computed by assuming aggressors are held constant logic is
known as Bayes delay. And it is the same for the case when it is when the other line is at
0 or 1. So the Bayes delay is the same whether the aggressor is 0 or 1. So whenever we
look at delayed computation for example when you are doing static timing analysis
internally it will do delay computation. Now during delay computation what will be the


what will be the delay what will the delay calculator do? So if we do not consider signal
integrity effect then the delay calculator will compute what is known as Bayes delay.


And the Bayes delay will correspond to charging of capacitor Cg plus Cc. So this will
be what the delay calculator will do. Now let us take the now let us understand what will
happen if the line or the aggressor line was also changing. So assume that G1 is G1 that
is the driver of victim line A makes a 0 to 1 transition the same as earlier it is making 0 to
VDD transition. And let us assume that B also makes a 0 to 1 transition 0 to VDD
transition the B lines.


So in this case what is the initial VAB voltage across the coupling capacitor? VAB is
equal to 0 minus 0 is equal to 0. And what is the final voltage across the capacitor?
Again it is VAB is equal to VDD minus VDD again it is 0. So the coupling capacitor is
the initial voltage is also 0 and final voltage is also 0. Meaning that the capacitor, the
coupling capacitor, is not being charged. Hence less charge is to be provided by G1 for
charging Cc compared to the Bayes delay.


In the Bayes delay Cg plus Cc was being charged. But when both are transitioning in
the same direction then Cc need not be charged because that voltage is not changing .
And therefore the driver of G1 or the driver G1 must supply only less charge . And
therefore the delay of G1 will decrease. So if we look into the exact simulation we will
get a waveform something like this.


So if this line G1 was the victim line A initially it was transitioning like this . After we
incorporate the SI effect it will show a transition something like this. And if we say take
for 50 percent mark as delay that will shift towards left on in the time domain. And we
will understand that the delay has actually decreased . So this effect is modeled as a
negative incremental delay over the Bayes delay .


So this is the Bayes delay . This point corresponds to Bayes delay and this point
corresponds to the delay that will occur if both the victim and aggressor are transitioning
in the same direction. Now let us take the situation when G1 is again transitioning from 0
to VDD . But line B is transitioning in the opposite direction meaning that it is
transitioning from VDD to 0 simultaneously . These two transitions are happening
simultaneously.


So in this case what was the initial charge across CC is VA minus VB is equal to 0
minus VDD that is minus VDD . And what is the final VAB that is VA minus VB that is
the charge? Sorry the voltage across the coupling capacitor CC is VDD minus 0 is equal
to VDD. So what is the change in voltage across CC? The change is VDD minus VDD .


So it is 2 times VDD . So what is happening is the polarity of the voltage for this
capacitor CC is changing therefore 2 times the voltage change we have seen .


So voltage across CC is minus VDD initially and plus VDD finally hence in effect 2 CC
needs to be charged by G1. So if we consider charge, charge is voltage time Q is equal to
CV . So voltage times capacitance. So if we are considering charge in a sense we can
think that instead of making 2 times voltage change we can think that it is charging twice
the capacitor . So we can think of it as 2 CC is being charged .


So now in the base delay case CG plus CC was charged . Now in this case when the
transition is happening in the opposite direction CG plus 2 CC is being charged . So
more charge needs to be supplied by G1 and therefore we expect that the delay will
increase and if we do the simulation then we will see that in the time domain the curve
will shift towards and the 50 percent point will appear later and therefore the delay will
increase in this case. So this effect is modeled as positive incremental delay over base t .
So what happens is that the tool that uses so when we do static timing analysis by default
the tools assume that there is no activity in the neighboring lines and they compute
delays based on base delay and they report the numbers based on it .


But there are some tools which do analysis based on or take into account signal integrity
issues also . In those tools the base delay is adjusted by positive or negative incremental
delay so that the effect of signal integrity is accounted for and therefore the slags the
setup slack and the and the hold slack those numbers will change after we are doing
signal taking into account signal integrity effects. Now let us look into what is a noise or
glitch that gets introduced because of activity in the neighboring lines. So a glitch can
occur in a victim line victim net held at a constant logic value due to transition in the
aggressor net. So glitches are also known as crosstalk noises.


Now depending on the value of the victim net and the type of transition of the aggressor
net, four types of glitches are possible . So what are the four types of glitches? So the
logic 0 has a rise glitch. Suppose there was a signal which was a line a victim net which
was held at constant 0 logic 0. Then there can be a rise glitch like it can be the 0 volt
there will be some voltage above 0 volt it can go or it can show an undershoot also it
goes into the negative direction . So and also if there is if the victim line was held at
constant 1 then it can come down because of the glitch for some time duration . So this
is known as fall glitch or it can overshoot it can go even above VDD .


Sometimes it can go because of feedback and other elements in the transistor . So
sometimes it can go because of Miller effect and other coupling between input and output
nodes. Sometimes the voltage can go above VDD that is overshoot and sometimes it can
go below ground also those are undershoot. Now how are glitches created? So again let
us consider a circuit in this case we are not showing the ground capacitance just for
simplicity. Now let us assume that A is the victim line. This is the victim line and
assumes that A is held at cost at a steady state at logic at logic 1 .


So this VA is basically initially VDD . Now assume that line B is also held steady at
VDD . Now voltage across this coupling capacitor is VAB VA minus VB is equal to
VDD minus VDD is equal to 0 . Now assume that the neighboring line makes a quick
transition from VDD to 0 . Now this is making a transition from VDD to 0 .


So in this case the coupling capacitor now gets charged to what will be the VAB VA


minus VB will be VDD minus 0 . So after the transition the VB line becomes 0 so we
have VDD . So the coupling capacitor now gets charged to VDD due to voltage
difference in the lines A and B . Then the driver of line A is the driver of this line A so
there is a driver so this is connected to VDD . So internally this inverter will have a
PMOS and an NMOS and this line is at VDD and this is line A and this is the point
VDD .


Now this line is A . Now this line this coupling capacitor CC needs to be charged. So
to charge that some current will be drawn from the VDD from VDD through this PMOS
to the line A and then if the charge CC will be or the coupling capacitor CC will be
charged . Now whenever the current is drawn this PMOS is switched on but still it will
have some resistance it will have some resistance and because of that resistance there
will be and the current flowing so you can consider that there is a resistance R and the
current is flowing . So there will be an IR drop and because of that drop there will be a
drop in the voltage in the in the line A . So the driver of line A will supply this charge
and it will cause a temporary dip in the voltage of the line A because the PMOS that is
showing some resistance there will be some voltage drop through it when it is supplying
current from the or drawing current from the power power power line .


So the waveform that we expect will be something like this. So the A line A line is held
constant but whenever the B line is falling B line is making this transition there can be a
dip in the voltage of A line. Ideally there should not be any change neighboring line
should not impact but because of the existence of this coupling capacitor the voltage can
drop below VDD in the line A. Similarly when the aggressor line B makes a 0 to VDD
transition then there can be bump in the voltage of the victim line that was held at
constant loss it is 0 . So similarly it can happen when the A line is at 0 also because of
the current being drawn from the driver there will be a change in the voltage .


Now on what factors the magnitude of these glitches will depend. So this glitches
magnitude will depend on how quickly the transition happens in line B. If it happens very
quickly then the then the then the if this line was transitioning very quickly suppose there
is one transition and another transition is like this. So in this case when the transition is
happening very quickly then the glitches can be more. So glitch increases when the
aggressor line transitions quickly then the coupling capacitance between the aggressor
and the victim line .


If this capacitance increases if the glitch increases with the increase in the coupling
capacitance if this capacitance increases . Now if the ground capacitance of the victim
net is increased then the glitch will decrease. So glitch decreases as the ground
capacitance of the victim line increases suppose there was a ground capacitance . So
what will happen is that whenever this one is transitioning some charge will be supplied
from this capacitor also and therefore the charge needed from the victim driver will be
less and therefore the drop will be less. Now it also depends on the strength of the driver
.


If the strength of the driver is increased then what happens is that the resistance of the
PMOS will be lesser and therefore the IR drop through that driver or the PMOS
transistor will be smaller and therefore the glitch will decrease. The glitch decreases as
the strength of the driver of the victim net increases. Now when will this glitch cause
functional problems? So if the magnitude of glitch is above a threshold it can propagate
to a sequential circuit element. Now there is one line and because of the activity in the
neighboring line a glitch was created. Finally it will go to say an inverter and then
through something logic and finally it can reach a sequential circuit element D .


Now if the magnitude of this glitch is above a threshold then it can propagate to a
sequential circuit element and consequently a wrong value can be last . So suppose there
was a glitch which was of a large magnitude this D was expected to be VDD and it
dipped so low that instead of one a zero was last by this flip flop and then it can lead to


a circuit failure because a wrong state is being captured by this D flip flop . So the
height of the glitches glitch if it is above some threshold and also the width is also
important. If there is a very narrow glitch of short duration then usually it does not cause
problems in the circuit. But if the magnitude of glitch is above threshold on the clock and
reset or control signals a spurious transition can get triggered in a sequential element . If
the glitches are on the clock path and the reset part then those can be detrimental to our
circuit and we should be especially careful about the glitches in those paths of our
circuit.


And tools need to propagate the glitch . So there are models in the technology libraries
we have not looked in earlier lectures but just for take a note that technology libraries
also contains noise models and using those noise models tools can compute the effect of
the noise in the in the in a gate and then it can propagate it throughout our circuit and
using that propagation we can understand that whether there are chances of wrong state
being captured by this by our in our circuit and whether the glitch can cause circuit
failure . So once we do physical design at the end we also sign off. So during sign off
this signal taking into account signal integrity issues and noise issues are very important .
So we will be looking into this in some more detail when we discuss sign offs. Now
there is another concept of or another phenomenon which is known as antenna effect
which we must consider during physical design.


So what is the antenna effect? So consider this layout . So in this layout we have a
driver there is an inverter which is driving. So the inverters PMOS and NMOS at the
output are the drain drain drain region. So this is the driver's drain region and then it is
connected to another inverter through an interconnector . So this is another inverter
which is connected to the input of this gate .


So this is what it is showing. So this is the gate oxide. This is the gate oxide and we
want to connect this inverter which is the driver and the other . So we are just in this
figure we are not showing all the so ideally this should be like this . The first inverter


G1 and this is G2 . This is VDD, this is VDD, this is PMOS and this is NMOS . So this
is the interconnect we are talking about and this is basically the drain which is shown
here for the other we are not showing for simplicity we are showing only one drain and
only one now these are the gates these gates of these two transistors.


Now for simplicity we are showing only one gate and this is connected through metal .
Now note that in this case the metal line one is connected to this gate and here also the
metal line is there and then there is it going through a via to metal line two and then
coming down again through metal one . So now what happens is that during fabrication
we fabricate layer by layer. So first we will be fabricating a metal one. So during the
fabrication of metal one so in the fabrication process many times we use plasma etching
ion implantation and such techniques and by exposing these metal lines to plasma.


So plasma contains charged ions electrons and and and and positive and negative ions
and not also neutral atoms . So from this plasma what happens is that the charge can get
accumulated on the metal lines . Now note that in this case the second metal line is not
yet created, only the first metal line is created. Now if this charge gets accumulated in
this metal line one then the and this metal line one is connected directly to the gate then
the the whatever the charge is there it can get discharged through the gate and remember
from the last lecture gate is a very thin material a few nanometers two nanometers three
nanometers in that and contains only a few atoms and tens of atoms . So if that is the
case then if a charge is sufficient and a high amount of volt of charge gets discharged or
or crosses this gate oxide then gate oxide can get damaged and this is known as
basically antenna effect and the other name for this is plasma induced gate damage .


So this can happen during fabrication but why did it happen because the layout part
made such that the metal one was directly connected to the gate and there was no other
path for the charge to flow and therefore, this is not a good structure we will see how to
modify this structure so that antenna effect or the gate induced sorry plasma induced gate
damage can be restricted. So to understand what is the probability of getting damage we
define a quantity which is the antenna ratio. It is the ratio of the conductor area to the
gate oxide area. So the conductor is a conductor divided by A oxide . So that antenna
ratio basically defines that if the say a conductor area is larger then the charge
accumulated will be large and therefore, the chances of damage is larger. Now if A
oxide is large then the same charge is distributed over a larger area and therefore, it is
we expect that the and if A oxide is large then antenna ratio will be small .


So high antenna ratio implies greater chance of damage and antenna rules define so in
libraries we have the antenna rules which define what antenna ratio is permitted above
that there is a violation. If we find that violation then during physical design we need to


fix those DRC violations or antenna DRC violations and make it smaller. How we can
do this will be seen in the subsequent lectures. Now let us look into another important
aspect of physical design that is library exchange format files . So from our last two this
year two lectures or discussions from the last two lectures we can understand that the
fabrication process has a strong effect on the physical design task.


Therefore we need to capture the information of fabrication during physical design
somehow. And we capture that information using a file which is known as a library
exchange format file or lef file . Now lef files are generally divided into two parts; the
first part is known as a technology lef file and the second part is known as cell library lef
files. Now what does the technology lef file contain? So the technology lef file contains
information about the available layers, vias and their properties. It also describes the
sheet resistance and the capacitance per unit square for various layers and it also contains
some placement and routing design rules and also the antenna rules that we just
discussed.


And the cell library lef files contain information about the cell . So during physical
design we need to place the cells and route it . So we need some information from the
cell about the physical attributes . What is the bounding box, where the prints are and so
on. We do not know we do not need the exact layout of our of the cells that we are going
to use in our layout but some abstract information and that is abstract information of the
layout of the cell is there in the cell library lef files. So it contains abstract information
of the cell layout relevant to the physical design and the cell boundary list of prints and
their locations and obstructions to placement and routing .


So these are important for creating the placement and routing of our design on the
layout . So when we do physical design then we need to give these lef files. There are
other ways also to give this information but giving the information through the lef files is
one of the most popular methods. Now if you want to know more about these things you
can refer to these books. And just to summarize, in this lecture we have discussed signal
integrity issues and we looked into antenna, antenna, antenna effect and we also looked
into the lef files .


So with this lecture we have completed the basic concepts that are important or essential
for appreciating the physical design task. So from next lecture onward we will be
looking into each individual physical design task in more detail. So we will start first
with chip planning. So that is it for the lecture. Thank you very much.


