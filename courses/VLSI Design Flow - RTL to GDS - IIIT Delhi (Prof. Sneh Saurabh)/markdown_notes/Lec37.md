**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 37**
**Power Analysis**


Hello everybody, welcome to the course VLSI design flow RTL to GDS. This is the 29th
lecture. In this lecture, we will be discussing power analysis. In the earlier lectures, we
have discussed various design tasks and these tasks were related primarily to the area
and the timing of the circuit. However, a third figure of merit is power is also very
important for our circuit and we need to consider that in VLSI design flow. So, the tasks
that we carried out in VLSI design flow that are related to power can be broadly
classified into two categories.


The first one is related to power analysis and the second one is related to power
optimization. So, in this lecture, we will be discussing power analysis and in the next
lecture, we will be discussing power optimization. Specifically, in this lecture, we will
be discussing various components of power dissipation, power models which are there in
the technology libraries and the techniques to estimate power dissipation. So, the power
dissipation in a CMOS circuit can be broadly classified into two types.


The first one is dynamic power dissipation. So, dynamic power dissipation occurs when
a circuit performs computation actively, meaning that in a circuit the signals are basically
changing. So, it may be say a signal or a net whose value is changing from 0 to 1 or 1 to
0 or there is some gate a logic gate and its output is toggling may be from 0 to 1 or 1 to
0. So, whenever there are changes in the signal values or the output of the gate is
changing, then we say that our circuit is performing computation actively and the power
that is dissipated during this active computation is known as dynamic power dissipation.
The second type of power dissipation is known as static power dissipation and static
power dissipation occurs when the circuit is powered on means that the circuit is
connected to VDD and ground rails, but it does not perform active computation meaning
that the value of the signal is not changing.


For example, suppose there is an inverter. Now, this inverter is connected to the VDD
line and the ground line. So, we are connecting this inverter to the power supply, but


suppose the value of the input net and the output net these are not toggling it was held
constant suppose the input was held constant at 0 and the output was held was the
inverter will produce an output 1 in this case and these signals are not changing the input
and the output values are not changing. Then the power which will be dissipated by this
inverter is the static power dissipation while if there is an inverter it is of course
connected to VDD and ground and suppose the input is making a transition from 0 to 1.
So, if the input is changing the output will change input is changing from 0 to 1 output
will change from 1 to 0.


So, the power which will be dissipated in this case will be known as the dynamic
power. Dynamic power dissipation. Now, let us discuss this or let us look into this
dynamic power dissipation and static power dissipation in more detail.


So, let us consider an inverter. This is an inverter which is a CMOS inverter which is
driving say M loads right. So, we have the loads defined as C. This load is another load
pin and so on and there are M load pins and each load pin is showing an input
capacitance as C i.


So, this is C 1 this is C 2 these are input capacitances of the pins right which are driven
by this inverter right. And suppose that it is driving these loads through a wire and wire
also has a capacitance, a ground capacitance which is we say that C w is the ground
capacitance. Similarly let us assume that this inverter, the CMOS inverter that is here
right, has also got some internal capacitances for example, drain diffusion capacitances
which can be considered as connected to the output node Z right. So, that is represented

as C d right. So, these are the various
components of the capacitances which
will be charged and discharged as the
input of the inverter is changing.


Suppose say the input changes from 0 to
1 right then the output will change from 1
to 0 right the output at this point will
change to 1 to 0. And while this 1 to this
transition is happening the capacitance C1
C2 Ci to C m all these capacitances will
be getting discharged right because when
it was 1 it was charged to V d d now it is
coming to 0 so it will be discharged.
Similarly Cw will be discharged and Cd


will be discharged right. And if the transition is from say input at the input the transition
is from 1 to 0 then the output will transition from 0 to 1 right. So in this case all these
capacitance Cd Cw and all the pin loads right pin load capacitances will be charged from
charged to Vdd right.


So when the inverter is this blue inverter which is shown here if it is making a transition
all the capacitors will be charged and discharged. And during this charging discharging
there will be some power dissipation which will be dissipated by the by in this process
and that power dissipation is known as switching power dissipation right. Now let us
understand how to quantify this switching power dissipation. Now to quantify this
switching power dissipation we need to consider the internal details of this inverter right.


So if it is a CMOS inverter, this CMOS inverter will internally consist of a p MOSFET
which is shown here and an n MOSFET right.


And these are the pMOS and nMOS acts as a switch right. So whenever the input is say
0 right then the p MOS will be turned on and this one will be the n MOS will be
switched off. Similarly if the input is held at 1 right the p MOS will be turned off while
the n MOS will be turned off right. So if we consider all the load capacitances right so
there are three components one is CD then CW and all the pins load right. So we let us
assume that the combined effect of all these pin loads is Ci.


So let us define Ci is equal to summation of Ci, i is equal to 1 to m there are m m m
loads so i to m let us define this. Then we can say that CL is equal to CD that is internal
capacitance drain diffusion capacitances or capacitances associated at with the output
node z right CD plus CW that is a wire capacitance or interconnect capacitance and Ci


that is the combined effect of all the pin loads. So we can represent this circuit using this
transistor level circuit right. So we have replaced this inverter with the pMOS and
nMOS implementation and we have replaced all the load capacitances with a load
capacitance CL which is the sum of CD plus CW and Ci right. Now in this circuit that
we are considering, whenever a transition happens, say from 0 to 1 right, suppose the
transition happens from 0 to 1 or 1 to 0 the CL will be charged and discharged right.


_**Esw**_ _**= CLV**_ _**[2]**_ _**DD**_


So suppose if the transition was happening from 1 to 0 at the input right in 1 to 0 at the
input the transition at the output z will be from 0 to 1 right 0 to 1. So whenever a 0 to 1
transition happens this node v z that will be charging to VDD right through this path
right this through this through this through this this transition whenever the input v a is
equal to 0 this p MOS will be turned on and that will charge it to that will charge the CL
to VDD right. So in this process when the current is drawn through the p MOS this p
MOS the there are some resistances associated with the transistors and the interconnects
and those will be basically responsible for the power dissipation. So remember that a
capacitor stand alone can never dissipate power; it can only be charged or discharged but
the resistances associated with this circuit are actually dissipating power. So when a
charge when when when when this C L is being charged then the then then the energy
the so this capacitor C L will store some energy while storing that energy while storing
this energy that energy some power will be dissipated by this n MOS and the power lines
and the internal resistances of the battery and so on and that will lead to a power
dissipation of half CL


VDD square right.


And in the next cycle when the transition happens from from 0 to 1 this stored energy in
the C L in the load C L that gets dissipated through the n MOS. So whenever a transition
happens from 0 to 1 1 is the input is 1 the n MOS gets switched on right. So there is a
path from V Z to the ground and through that path whatever the charge is on C L that
will be dissipated. So whenever and in this way the half the in a half CL VDD square
which was stored in the capacitor that will get discharged in the second half of the cycle.
So whenever a transition happens from 0 to 1 2 1 to 0 one complete cycle in this for this
inverter then a total of half CL VDD square plus half CL VDD square that is CL VDD
square that much energy is dissipated right.


So this is the amount of energy that will be dissipated in the process of making a
transition from 0 to 1 and 1 to 0 at the input of the transistor right. Now from this and
from this energy how do we compute the power right. So we know that the energy and
power are related by the power is energy energy divided by time right. So to get the
power dissipation we need to understand that in what time this switching happens right


in what time the switching from or complete cycle of switching from 0 to 1 and 1 to 0
happen. If it happens very quickly then power dissipation will be higher.


If it happens slowly over a long period of time right from 0 stays long for 0 and then
switches again from 0 to 1 in the after a long time then the power dissipation will be
lesser though the energy dissipation will be thus will be equal to CL VDD square in one
cycle of the transition. Now how do we quantify power? To quantify power typically in a
synchronous circuit what we do is that we compute power as CL VDD square alpha
times fCLk. Now we multiply it by a factor alpha fCLk to denote that in what time
duration this energy was dissipated in and what is f CLk? fCLk is the frequency of the
clock in the circuit and alpha is known as the activity of the signal.


_**Psw = CLV**_ _**[2]**_ _**DD**_ _**[ɑf]**_ _**clk**_


_**fclk = frequency of the clock in the circuit**_


_**ɑ = activity of the signal**_


Now we have defined alpha such that the time is the time needed for this energy
dissipation or the time interval in this energy dissipation is captured correctly by the
suitable definition of alpha. And how do we define alpha? We define alpha is equal to 1
when the output completes one cycle of transition in one clock period right meaning that
suppose let us say that the the this power dissipation was happening in one clock cycle
right which in this f suppose there is a clock signal right there is a clock signal whose
time period is t right and the fCLk is equal to 1 by t right.


And let us assume that in this time interval this much energy SW was dissipated. So,
what will be the power in this case? The power in this case will be P is equal to energy
dissipated that is CL VDD square right divided by the time interval that is t right. Now 1
by t is fCLk right. So, C L is times VDD square into fCLk that is what the power
dissipation is if the transition if the output node z was transitioning or doing a complete
transition from 0 to 1 and 1 to 0 in one clock period right. Now what happens in a
synchronous circuit is that the output node for example, this node z will not toggle every
clock cycle right it will make toggle say 1 once in 5 clock cycles right.


So, if that happens then this alpha will scale that right. If say this 0 to 1 and 1 to 0
transition happens once every 5 clock cycle then alpha will be taken as 1 divided by 5
that is 0.2 right. So alpha is a way of capturing what is the activity of the node z,
meaning how quickly it is transitioning or how frequently it is transitioning within a


clock period right. So, this formula P S W is equal to CL VDD square alpha fCLk is
known as the switching power that is it quantifies the switching power of the inverter. For
other types of circuit for example, the other type of logic gates for example, AND gate,
OR gate and so on a similar formula can be considered where the CL can change alpha
can change and fCL k will be based on your based on the circuit right.


So, this is the general formula for a for a node that in this case z transitioning with an
activity of alpha. Now there is another type of power dissipation which is known as short
circuit power dissipation and what is short circuit power dissipation? So, short circuit
power dissipation occurs if the input is transitioning at a slower rate right which is if it if
the if the input is say rising at say from 0 to 1 at a slower rate then what will happen is
that for some small amount of time this transistor PMOS and this NMOS both will be
will be switched on and there will be some there is a path from VDD to the ground
through this switched on transistor though this time interval will be very very small still
there is some time small time intervals when there is a direct path from V D D to the
ground and when this kind of path becomes more frequent which becomes more frequent
if the if this if the transition of this if the transition or at the input is slow if we decrease
the transition if we increase the slew right then it means that the transition is happening
slowly and in that case the time interval for which the the there will be a direct path from
VDD to ground that will be increasing and during this time whenever there is a direct
path between VDD to ground that during that time the power that is dissipated that is
known as short circuit power right. So, we can quantify short circuit power as VDD into
ISC V D D is the supply voltage and I SC is the short circuit current right whatever the
short circuit current which is flowing from VDD to ground right. So, now if we look into
the dynamic power dissipation there are two components one that we saw in the previous
slide that was related to switching and the charging and discharging of the load
capacitances right and the other one due to the due to the short circuit of or short circuit
path from the VDD to the ground line and therefore, the total dynamic power dissipated
by a circuit is the sum of these two components. Now let us look into the static power
dissipation.


_**Psc = VDDISC ( Short Circuit Power Dissipation).**_


_**Pdyn**_ _**= Psw + Psc**_


So, static power dissipation occurs when the inputs and when the signal is held constant
for example, suppose this signal input was held at constant 0 and the output will be in for
an inverter the output will be 1 right. So, whenever this input is 0 right we say that the
way the p MOS will get turned on this will be switched on right and there will be a direct


path from V there will be a low resistance path from this point to this point and this
transistor will get charged to CL. Once that transition the the charging of this trans this
load capacitances CL has happened when the CL is completely charged then no more
current is drawn from this from this VDD right the from from the from the power source
and this the the current should ideally become 0 and whenever the input is 0 this n MOS
will be turned switched off right. So, in ideally if this is switched off and this current also
dies down after charging then what we expect that in the stable state in the meaning that
whenever the the input value is not changing in that case the the there is there will be no
current flowing through the through the through the through the these transistors and no
power dissipation will happen. But in reality what happens is that whenever we say that
for example, whenever the input is 0 this transistor which we assumed it to be
completely switched off they do not get it completely switched off they leak some
current between say this point to this point because of various reasons.


So, what are the reasons why there can be some current from this path to this path right
and and so whenever this is leaking current right this for example, when the input is 0
this transistor this transistor will be leaking current and its value is say I leak right. So,
whenever the input is 0 this p MOS is already turned on right. So, there is a path from
VDD to node Z through a low resistance right. So, the current that will be decided I leak
will be decided by this switched off transistor right. If this switched off transistor was an
ideal one in that case I leak would have been 0 and power static power dissipation would
have been 0.


But because of various reasons this leak is appreciable at advanced technology nodes
this has become significantly larger and why this I leak exists there are a few reasons the
first one is sub threshold current right. So, when we say that when the transistor is when
we put the gate voltage of a transistor below say threshold voltage ideally we expect that
the transistor is completely switched off right for an nMOS case right. But however,
whenever the transistor is, whenever the gate voltage of a transistor is below threshold
voltage there are some electrons which are high and have high energy and they can go
from the drain to the source right from this drain to the source. So, those high energies
and electrons contribute to this sub threshold current. Additionally there can be some
gate leakage through the tunneling path right there can be some gate leakage.


So, between the gate and the source and drain there is an insulator and there is a
capacitor. Ideally no current should flow through that. But because of the small size of
the gate oxide some tunneling current can flow from the gate to the source and drain and
they also contribute to the leakage current. And the third reason is the junction leak. So,
there are in that within the transistor there are junctions which are reverse bias junctions
and ideally the current in a reverse bias junction should be 0 right. But in real p n p n


junction those are those whose reverse bias current is appreciable maybe in pico amperes
or say in nano amperes, but they exist right and they also contribute to the leakage
current.


Typically in advanced technology nodes the leakage current is dominated by the sub
threshold current. And how can we quantify this power dissipation which is dissipated
when the signals are held constant to 0 or 1? We can simply multiply the leakage current
I leak with the VDD right. V DD is the power supply voltage right. So, we can get the
static power dissipation. So now if we want to come get the complete view of the power
dissipation in a CMOS circuit.


So, there are two types of power dissipation: the first is the dynamic power dissipation
and the static power dissipation. And dynamic power dissipation is again of two types the
switching power and the and the short circuit power dissipation right. So, using those
from the formulas that we discussed we can compute the total power dissipated in a
CMOS circuit. Now let us look into the library models which exist in the technology
libraries for modeling the power. So, first let us look into the dynamic power dissipation.


Let us again consider that there is an inverter right, this inverter which is driving M loads
C and their pin loads are C1 to CM right. And we have already computed what is the
power energy dissipated in one cycle from 0 to 1 and 1 to 0. So, that was CL into VDD
square where CL was we have seen that we had defined CL is equal to CD that is the
drain diffusion capacitance plus C W that is the wire capacitance right the capacitance
related to the wires or interconnects plus CI which is the combined effect of all the pin


loads right. And we all and the second part of the dynamic power dissipation is the short
circuit power. So, let us assume that since the formula that we derived in the last
previous slide was VDD into ISC that is the power dissipation.


So, this is the short circuit power dissipation right VDD into ISC. Now if you want to
get the energy we have to multiply it with time. So, let us assume that the the the inverter
this inverter was in the short circuit condition for the time tau S C and during that time
interval that average current that was drawn was the short circuit current that was drawn
was I S. So, this formula I E dynamic is equal to CL VDD square plus VDD ISC tau SC.
So, tau SC is the time for which the short circuit is happening right.


So, this gives us the total energy consumed in 0 to 1 and 1 to 0 transition for this CMOS
inverter right. Now if we put the value of C L right we get this equation right that this
part remains the same and instead of C L we write C D plus C W plus C I. Now in this is
the total dynamic power dissipation in this formula we can identify two different
sections. The first one says that the components which are dissipated within this cell are
right. So, there are two components of this power. We can identify two components of
the power: the power which is dissipated within the cell that is within this blue cell and
the one which is dissipated outside right.



_**Edyn = CdV**_ _**[2]**_



_**DD**_ _**[+ V]**_ _**DD**_ _**[I]**_ _**SC**_ [𝛕] _**sc**_ _**[+ ( C]**_ _**W**_ _**[+ C]**_ _**I**_ _**[)V][2]**_



_**DD**_ _**[= E]**_ _**int**_ _**[+ E]**_ _**ext**_



So, we can segregate two components depending on this capacitance as well right. So,
we combine the we come we say that the the the energy dis energy dissipated in charging
and discharging C D that is the drain diffusion capacitance which is lying inside the
inverter that is the internal component and also the short circuit power dissipation that is
also contained completely inside the the the inverter right inside the PMOS and the
NMOS of the inverter and therefore that is an internal component. So, these two are the
component of energy dissipation which are which is dissipated within the cell right and
the other component C W plus C I that is in charging this internal current capacitances
and the charging of this pin load C 1, C 2 to Cm those are external to the external to the
to the to the inverter and we say that it is E. So, we can write E dynamic is E internal
plus E external where E internal is these two components and E external is the third this
code right. Now when we try to model a library which kind of power should be modeled
in our library.


So, the power which is dissipated inside the cell right inside the cell means that inside
this inverter that can be modeled in the library right because that is the property of that
cell right and that is that can be computed at the time of power of library characterization
right. So, the energy dissipated inside a cell is the property of the cell and is modeled in


the library and the energy dissipated outside a cell that is E external depends on the
environment or the external loads right it depends on the external loads and the
capacitance sorry the the interconnect capacitance C C C W and these can be computed
based on the instantiation of C of the inverter right. So, the energy dissipated outside the
cell can be computed by the tool based on the activity and the power supply and the
capacitances external capacitances at the time of power power estimation right or power
computation. However, the power mod the component of power which is lying inside the
cell that is modeled inside the library because that is the property of the of the of the of
the cell that we are characterized. So, power can be estimated using energy per
transition so these are energy numbers right.


So, using these energy numbers we can compute the power by multiplying with the
activity and the clock frequency right. So, now let us look into how this internal power is
modeled if mod is modeled in a library. So, this internal power is modeled similar to the
NLDM that we discussed earlier and the power model that we have for this is known as
non-linear power model. So, the internal power dissipation depends on the output load
and the input slew and therefore, it is modeled as a two dimensional table as we did for
say NLDM for the delay right. In the delay also it was that the delay was dependent on
output load and input slew.


Similarly, the dynamic power dissipation inside a cell depends on the output load and the
input load slew. And how do we model it? We model it using an attribute which is
known as internal power right. We have an attribute internal power in the technology
library which captures the internal power dissipated inside our cell and this model is
known as non-linear power model or NLP. So, let us have a look at how NLP looks right.
So, similar to the timing arc we have a power arc we have a start pin right and an end
pin.


So, the power arc is defined at the end pin and the and the related pin is the start point
right. And then we have an index. We are sorry the first attribute is internal power and
then we have values which can be different for rise case and the fall case and therefore,
those are captured using rise underscore power. Similarly there will be rise fall
underscore power and this rise underscore power is a 2D table which depends on the
input net transition or input slew and the total output net capacitance or the output flow
right. So, this is how the NLP model looks like and the numbers that are represented in
this table are the energy numbers right. So, the values that are shown here represent
energy dissipated per transition.


Now to get the power dissipation we have to multiply with the clock frequency and the
activity. And how is a static power dissipation model in the library? Now the static


power dissipation depends on what is the static value at the pin. For example, if there is a
NAND gate right, suppose there is a NAND gate then for the case when the input is 0 0
or the case when the input is say 0 1 the power dissipated will be different the static
power dissipated will be different.


So, we model this using a Venn condition. So, what do we mean by the Venn condition?
Let us understand with an example. So, suppose if there is a NAND gate so we will
define leakage power as a value say 20 when not A and not B what it means is that when
A takes a value of 0 and B takes a value of 0 for let us assume that these are the pins. So,
for the 0 0 case the power dissipated is 20. Similarly, we say if A is equal to 1 right if it
is A and this is B right A is equal to 1 and B is equal to 0 the power dissipated in this
case is 150 right. Now in addition to the leakage power based on the Venn condition an
average value can be defined for a cell also.


So, if the tool needs to compute it does not know the probability of a signal being 0 or 1
in that case an average value of power dissipated by a cell is also defined by the library
and that can be used by the tools. Now we have seen how to compute the power right.
So, P total is equal to the switching power right and the short circuit power and the
leakage power or static power static power dissipation these are three components right.
Now how do we estimate the so given a design or given our circuit how does a tool will


compute this total power dissipation right. So, computing power dissipation is a
challenging problem. The first first of all the challenge is because of this CL.


Now what is the value of this load capacitance right? So, when we say for example, we
are we we are writing an R T L at that time we do not have any interconnect right. So,
and and we also do not know the load capacitance of any of the pins or the signals which
will be driven right. So, in that case the C L values cannot be estimated accurately even
though we have done our say technology mapping in that after technology mapping we
know the pin loads, but we still do not know the interconnect capacitance right. So, in
that case again the C L value that we are getting is not very accurate. So, what it means
is that as the design flow progresses the value of C L becomes more and more accurate
as the abstraction decreases and details increases.


For example, C L can be computed very accurately once we have done the routing we
have and if we have done the final routing then C L can be estimated very very
accurately right. The other difficulty is related to the activity right. So, accounting for
the activity of the signal is very very difficult or very tricky. Why it is difficult or tricky
because the activity of the signal depends upon the application being run right. For
example, let us assume that there is a processor that we are designing right.


Now depending on what application is running on this with the help of this processor
right the switching activity can be higher or lower. For example, if we are doing, say,
video rendering right in that case the activity can be much higher, but if we are just
editing a document in that case the activity may be lower right. So, for a given chip or
an integrated circuit estimating the activity is very difficult because it depends on the
application and we need to understand the details and the loads that the application will
need to apply on our circuit to estimate the activity of the signal. Another thing is that


even if we know the activity right we know that ok this program will run on our
integrated circuit right. Even in that case the logical structure and the circuit topology
will decide the activity of the signal right and then accounting for those logical structures
and the circuit topology that may also be tricky right.


So, how does the tool estimate the activity and compute the power dissipation right. So,
there are two types of techniques: the first one is simulation based techniques or vector
based techniques. So, in this technique what we do is that we perform the simulation
using the test bench right. So, we have seen that when we designed our RTL we did
functional verification and for functional verification we wrote our test bench and ran the
simulator right. So, we can use the same test bench to run the simulation simulation and
then using the simulation result we can record the output response and save them in say
VCD file right.


So, we have discussed earlier that there is a value-changed dump file or VCD file in
which the values can be written right. So, in some sense this VCD file will be recording
the activity of the signals right. Now using the VCD file we can convert into a format
from which activity measures can be easily extracted by the tool and what is that format?
That format is typically switching activity interchange format or safe format right. So,
we did simulation and after simulation we got VCD file and from VCD file we get a safe
file which which is in a format from which the activity can be easily extracted by power
analysis tool and using these activities the tool will compute the compute the compute
the power dissipation or in our circuit right. And for some signals or sometimes we may
not have the activity file in that case the power analysis tool will typically assume some
default activity for example, 0.


2 for the signals and based on that the computation power estimation can be done right.
So, this is this technique which is based on say simulation is known as simulation based
technique or vector based techniques. The other type of technique to estimate power
dissipation is probabilistic technique and those techniques are also known as vectorless
technique. In probabilistic technique what we do is that we propagate the activity through
the circuit by considering the logic function of the gauge encountered in the path. We
assume certain activity at the inputs of our design or circuit and propagate that activity
throughout our circuit using the logical structure of our design right.


So, let us assume for example, to illustrate this let us assume that there is a there are
two signals A and B there are two signals A and B and the probability of being 1 is 0.5
for A. So, there is a signal A whose probability of being 1 is 0.5 and there is another
signal P a P B whose probability of being 1 is 0.


3 right. Now, if these two signals were going to an AND gate right. So, AND gate. So,
what will be the probability of being 1 at this output right. So, we can easily compute in
this case that the output will be 1 only when both the inputs are 1 right.


So, therefore, if we multiply 0.5 and 0.3 we get 0.15 right, that is the probability of
being 1 at the output of the AND gate right. So, this is so if we know the probability of
the signal at the input we can use the logical structure we can compute the probability of
being 1 at the output of the output of the gate right. Now, if these two same signals were
propagating or going to an OR gate for example, there is an OR gate. Now, what will be
the probability of being 1 in this case. So, in this case it will be easy to compute the
probability of being 0 right and then from there if we subtract that probability from 1
then we get the probability of being 1 right right.


So, for the signal a the probability of being 1 is 0.5 so probability of being 0 is also 0.5
right that is probability of being 0 probability of being 0 right for the signal a. Now,
what is the probability of being 0 for the signal B it is the probability of being 1 was 0.


3 so the probability of being 0 for signal B will be 0.7 right. Now, output of an OR gate
will have a value 0 only if both the inputs are 0 right. So, what will be the probability of
being 0 at the output output of the OR gate probability of 0 at the output of OR gate will
be 0.


5 into 0.7 that is 0.35 right. Now, we can compute the probability of being 1 at the output
of A plus B as 1 minus 0.35 that is 0.65 right that is what is shown right. So, in this case
it was easy to compute because we are assuming that A and B are totally uncorrelated
signals right, those are independent signals right. But in real designs what happens is that
the signals diverge and they converge and therefore there are correlations right there can
be correlations and then computing the probabilities and other things will not be that
easy right.


So, the exact computation of the or estimation of the power dissipation is not the part of
this course. However, if you want to look into more detail you can refer to this book.
Now, to summarize what we have done in this lecture we have looked into power analysis
of a CMOS circuit and then we looked into various components of power analysis and we
also looked into the library models which are used for power analysis and how activities
can be estimated correctly. So, in the next lecture we will be looking into how we can
change our design or how we can make modifications in our design to reduce the power
dissipation. Thank you very much. .


