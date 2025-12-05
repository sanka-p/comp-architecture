**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 44**
**Basic Concepts for Physical Design - I**


Hello everybody. Welcome to the course VLSI design flow RTL to GDS. This is the
35th lecture. In this lecture, we will be looking at basic concepts for physical design. In
the earlier lectures, we have discussed logic synthesis and at the end of logic synthesis,
we get a net list. And then we have looked into DFT techniques and we have inserted
some features in the net list for example, scan cells which help us improve the testability
of our design.


So, after doing logic synthesis and carrying out a DFT task, we get a net list of our
design. So next, the next task is to carry out physical design. So to recap, what we do in
physical design is that we take the net list and create a layout for it which will finally go
to the foundry for fabrication. So, the primary task involved in physical design is to place
all the entities that are in our design at appropriate places on the layout and then make
interconnections using metal layers .


So the placement and making connections or routing is the primary job of physical
design. Now, to understand the physical design task, we need to understand we need to
be familiar with some basic concepts. So, we will be looking at some basic concepts
which are related to physical design. In particular, we will be looking at fabrication of IC
and then we will be looking at interconnects and we will be discussing parasitics in
interconnects in this lecture. And in the next lecture, we will be continuing with some
more basic concepts related to physical design.


And then we will be actually starting or in the rest of this lectures or rest of the lectures
of this course, we will be discussing various physical design tasks. So let us first start
with some basic concepts related to IC fabrication. In our earlier lectures, we had seen
that photolithography is the key step in fabrication. And just to recap in
photolithography, what we do is that we have features on masks. On the mask is a
transparent material and the features are marked using some opaque materials such as
chromium.


And then with the help of light and optical instruments and using some materials which
are sensitive to light, those materials are known as photoresist, we get patterns on the
substrate as we have on the mask. So photolithography is the most important or the most
critical step in IC fabrication and it is carried out multiple times. Multiple times for
various layers, we carry out photolithography. So in general, we divide the IC fabrication
task into two types of processes. So the first type of process is known as front end of line
processes.


So in this, what we do is that we create active elements like transistors, diodes and
capacitors. And in the second group of processes of fabrication are known as back end of
line processes. In these processes, we create layers of wires. So just to recap the
structure of an integrated circuit, if we draw a crude structure of a crude cross section of
an IC. So in IC, there are two kinds of layers.


The bottom layers are where the transistors and devices are there. So these are the
bottom layers and over these layers, so these are device layers, we can say that these are
device layers. And these structures or these transistors and devices and other things are
built within the semiconductor. This is silicon substrate, silicon substrate. And over
these device layers, there are multiple interconnect layers.


So these interconnect layers are typically metal layers, which are used to interconnect
or make connections between devices. So the lower device layers are fabricated in the
FEOL processes or front end of line processes. And then the back end of line processes
are carried out in which the metal layers are made on the top of the device layers. Now
let us look into these FEOL processes and back BEOL processes in some more detail.
Now let us understand how devices are made.


So in devices, when we make say transistors, we use MOSFETs in our device as
devices. Now if we want to make MOSFET or a transistor, then what we need is that we
need to have p-n junctions. We have say drain, source and these drain and source are
made by doping into the semiconductor. And also the MOSFETs are typically built in
say n-well or p-well, which are again doped semiconductors. So basically we need to
dope a semiconductor that is silicon multiple times during the IC fabrication.


And how do we do it? So we dope it using a process known as ion implantation. So
doping basically means that if our original substrate is silicon, then dope doping means
we are adding impurities to the silicon crystal. For example, the dopant can be an
acceptor, and the acceptor impurities are say boron and aluminum, and the donor
impurities are phosphorus. So these, so we are using these dopant materials, the dopant
ions which go into the silicon which goes into the silicon. If we dope the pure silicon


with the dopant of acceptor and donor, then the properties of the silicon changes. For
example, its conductivity increases and so on.


And using this modulation
of conductivity and the
properties of silicon
material, we are able to
create various kinds of
devices. And to dope these
impurities into the silicon,
we use the process which is
known as ion implantation.
So what do we do in ion
implantation In ion
implantation, the first thing
is that we need to create
ions, The ions of appropriate material for example, boron or phosphorus depending on
what kind of material we want to implant into our silicon substrate, we will use
appropriate materials and using those materials, we create ions using arc discharge, So
once these ions are created, we accelerate them and or take the ions to appropriate energy,
And then and also we need to apply the ions at appropriate places on the substrate, And
therefore, we use electric and magnetic fields to accelerate those ions and also filter out
unwanted ions so that the impurities do not get implanted into our substrate, So once we
have the ions of the required energy and in pure form, we bombard the substrate through
a thin layer of screening silicon dioxide, So what we do is that we suppose there are
donor ions, Donor ions, for example, donor ions can be phosphorus, So we bombard
the substrate with the phosphorus ions and we use a thin layer of screening silicon
dioxide so that our substrate does not get damaged excessively by these ions. And when
we bombard the silicon substrate with the ions, then those ions get lost inside our silicon
substrate, Now we want this implantation to happen only in specific areas of the silicon
substrate and not everywhere. And we use photoresist, So we have discussed what a
photoresist is.


So we can pattern the photoresist using optical techniques. So on the substrate, we
apply photoresist uniformly and then pattern it and we get a required pattern where we
want the dopant to go and where we do not want to go, where we want the dopant to not
penetrate and so the required pattern is created using photoresist and we implant through


the photoresist, So the area where there is no photoresist, there the ions will penetrate
and get lost, But once the ions have lost into the, once the ions have penetrated and
have taken place into the substrate, the next task that we need to do is annealing, So in
annealing what we do is that we take this substrate to a higher temperature and then
allow it to cool. What it does is that the ions that get lost into our substrate occupy
random locations in the lattice.


But what we want is that the dopant atom
occupy the place of silicon in the lattice and
as a result, we will get electrons and holes
in the material where we have doped it, So
to activate those dopants, meaning that we
want the dopant to sit on the site where
silicon was there in the lattice and as a
result of that extra electrons or extra holes
will be created inside or will be available in
the silicon substrate, that phenomenon
occurs, So we activate the dopant using
annealing and also annealing also it reduces
or it heals the defects which were, which
are introduced by bombarding the silicon substrate with the ions, So now this kind of
ion implantation is done many times in our FEOL processes to make devices and it is
also used to adjust the threshold voltage, So typically we make MOSFETs in say
N-well, N-well as it is shown here or P-well, So we can make N-well by doping donor
ions and we can make N-well, sorry P-well by doping acceptor ions So we are, the
photoresist here is stopping acceptor ions to go and therefore P-well is created only in
the required location, Now the threshold voltage of the transistor depends on what is the
electron hole concentration in the channel And to adjust those threshold voltage we can
use another threshold adjustment implant at the required position, So suppose there are
say 1 million transistors, out of them say we want say, say 500 k transistors to have
different kinds of threshold voltage. Then we can use, we can, what we can do is that we
can implant, we can, we can do ion implantation at the required, required transistors
where we want to adjust the threshold voltage and as such the threshold voltage of some
of the transistors will change as per our requirement.


Another thing to note is that all these, all these devices are created on a single crystal of
silicon, So there is a single crystal of silicon that is shown here, Now if we create
multiple devices on a single, single crystal of silicon then these devices can interact
among themselves through the substrate, For example, this and this, these both can
interact, But what we want is that devices interact through the interconnect and not
through the, through the substrate, And to stop that what we need to do is that we need


to isolate, we need to isolate transistors, So there are various techniques to isolate
transistors. One of the common techniques is to use shallow trench isolation,


Now in shallow trench isolation what we do is that we create a, create a kind of trench in

the, or create a hollow
space at the required
places where we want
to have a, have an
isolating ox, isolating
insulator material
which is typically
silicon dioxide. So we
create hollow structures
and then fill those
hollow, hollow places with the insulator for example, silicon dioxide and then plenarize
it, So we get the, so the devices for example, this n-well and this p-well get, they both
get isolated through this silicon dioxide. So this is a silicon dioxide and silicon dioxide is
an insulator and therefore if the current or there is an interaction between n-well and
p-well through the substrate it will get inhibited, Now once we have created say n-well
and p-well in our, in our substrate,, the next thing is to create the transistors, And so
typically we use CMOS technology and in CMOS technology the MOSFETs are the
active elements or active transistors that we use, Now in MOSFETs there are three main
terminals, So those are gate, source and drain. So we need to now fabricate or make
MOSFETs in these n-wells, So to make the MOSFET first we need to have the gate
structure, Now for the MOSFET let me just recap what is a MOSFET.


So in a MOSFET we have n plus n, n. So this is an n-channel MOSFET. So we have n
plus source, n plus drain and over this we have oxide and over this we have metal, This
is metal, this is oxide and this is silicon and that is why we have MOS kind of structure,
metal oxide semiconductor, So MOSFET stands for metal oxide semiconductor field
effect transistor. So MOS is metal oxide semiconductor and why this name Because
there is a structure, we have a metal, then oxide and then semiconductor, So now we
have to make this kind of structure in our, on our substrate, Now typically what we use
is that instead of metal we use polysilicon, polysilicon, So polysilicon is basically
polycrystalline silicon and we dope it either with n plus impurity or p plus impurity so
that its conductivity is higher than normal silicon, And we use metal instead of
polysilicon also for making interconnects, making gates and also local interconnects So
the first thing to create, to create the gate structure we need to create the lower oxide,
Oxide layer So to create an oxide layer what we do is that we either grow oxide or
deposit oxide and this oxide should be high quality meaning that its dense, its thickness
should be very well controlled. So in typical MOSFETs the thickness of these oxides


can be as low as say 2 nanometer, 2 nanometer, 3 nanometer and if we count the number
of atoms it will be tens of atoms, That will, that is involved, that is with, that needs to
be created in this, in this layer of oxide.


So it is very, very thin, And if the thickness varies slightly even, A few layers of
atoms are different or extra or less then the threshold voltage of the transistor can change
widely, So therefore the thickness of this oxide layer must be controlled very accurately,
And then what we do is that we deposit polysilicon, As I said, instead of metal we use
polysilicon for the gate.


So we deposit first the oxide, a
high quality oxide meaning
that its thickness is very well
controlled and in advanced
technology it may not be
silicon dioxide, it may be high
key dielectric. For example,
now we use hafnium, hafnium
dioxide, HFO2 also as gate
oxide because it leads to a
better drive strength and, and,
and the, and the speed of the
transistor improves if we use high K dielectric, high K dielectric, So we can use, we can
deposit a layer of SiO2 or HFO2 and then we deposit a layer of polysilicon, Now we
deposit it using a process which is known as chemical vapor deposition or CV, Once we
have deposited polysilicon, the next thing
is to pattern it, Now again for patterning
we use the process of photolithography,
So we have a mask, on the mask we know
where we need to remove the material,
where to keep it and based on that we do
the etching and finally we get a structure
like this.


So from this region, this region, this region
the oxide and the polysilicon has been
removed. Now polysilicon can also be
used for local interconnects, So local
interconnects meaning that connecting two transistors at the lower levels, those
connections can be made using polysilicon also instead of metal And those kinds, so the,
the, in, when we are creating this gate,, when we are creating that gate and suppose two


gates are connected, This was one gate and this was another gate.


So if these two gates were connected,, and these both are shaped polysilicon, then
those connections can be made by patterning the polysilicon itself and this is a kind, this
polysilicon here is acting as a local interconnect, So there is a transistor here. So I am
showing the top level view of the IC. So we have transistors here, So this is the gate
and then these are, here also we have polysilicon which is acting as a local interconnect
connecting this gate G1 and this gate G2 of the two transistors. Now once we have
created the gate, the next task is to create the, the, the drain and source, So first we can
create the, using again ion implantation and photolithography, we can dope n plus, n plus
dopants, For example, phosphorus and we will get a kind of, of source and drain, source
and drain for p channel or p type, sorry n channel or NMOS, So we have no MOS in
this region. And then in the next step using another, another mask and your
photolithography, we can dope up plus and we will get a PMOS, So this is how we can
create transistors on the substrate.


Now the description that I gave is very, very simplistic, Just to get an intuitive feel of
what things will be done and how physical design tasks will be affected by this. We will
see later in, in, in due course, Now once we have made the devices, The next task is to
connect them and to connect them we have layers of wires over the device layer, So
layers of wires and these layers of wires are separated by interlayer dielectric or ILD and
typically this ILD material can be SiO2 on silicon dioxide. Now how do we use wires?
So typically we use copper and why do we use copper? Copper we use copper because
the copper has a very good conductivity, And also it is more resistant to a phenomenon
which is known as electromigration. So what is electromigration What is, why is it
important and other things We will discuss in later, later, later lectures where we discuss
how we can control electromigration and other things for, not just understand or just take
a note that we use copper for, because of its good conductivity and also it is fairly, fairly
resistant to electromigration effects. And how do we create this, these wires, layers of
wires So we use a process which is known as a dual damascene process. There are other
processes also to make interconnects, but this is the most popular, that is the dual
damascene process.


So in this dual damascene process what we do is that we create vias and interconnect


layers together, So we make both of them together and that is why it is known as the
dual damascene process. Now how do we carry out the dual damascene process? So in
the dual damascene process, first we do etching, say using plasma etching technique we
create hollow space in the interlayer dielectric. So this is interlayer dielectric or SiO2.
So in the SiO2 layer we create hollow space, Using etching and photolithography and
the appropriate mask, so we want vias to be made only at appropriate locations, not
everywhere in our design or in the layout, So wherever there is a, wherever we want
vias to be made, there will be, the photoresist will be removed, Using the
photolithography step, exposing photoresist to the mask and so on. And then we carry
out etching through the photoresist and therefore we get these hollows only in the
location, only in those locations where we want vias to be made Now the next task is to,
to create hollow space for the interconnects, So now what we are doing is that we are
trying to, suppose there is one layer of wire already there, One layer of wire already
there, we want to make the next layer of wire and that is what we are showing how to
make the next layer of wire, So we want this layer, this copper layer to be connected to
the next layer using this via, So I am using this connection so that we can, we can show
how vias and the wires can be made together.


So once we have created the opening for vias, then the next step is to create the opening
for the interconnects, The interconnects. And then what we do is that we create a barrier
layer. Now the copper material, the copper material is very good from the conductivity
and electromagnetism of properties or the resistance to electromagnetism properties, but
there is a downside of copper. The downside is that it is easily soluble in silicon dioxide
and silicon. And as a result what can happen is that if we do not block this copper or
have something, some material between copper interconnect and silicon dioxide, what
can happen is that this copper material can penetrate through silicon dioxide and go to
the lower device layers and damage our transistors So when copper atoms goes into,
into the, or reaches the device layers, then those, those copper create extra defect levels
in the transistors and as such the threshold voltage and even the operation of the
MOSFET will get affected. So we want that copper to be restricted to a particular layer
only.


It does not get penetrated through the silicon dioxide and silicon to the lower layers.
And to do that we have a barrier layer, We first create a barrier layer typically of a
tentelium or titanium or say some silicide material. We deposit that over the, over this
created openings. So these barrier layers are created first, And then after that we are
using an electroplating method, we deposit copper in this, copper in this hollow space,
We deposit copper in this hollow space, So once we have deposited this copper in the
hollow space, we have got a connection, So there was one layer, one layer of copper
already there, First layer. And now we have got the second layer also.


This is the first layer and we have got the second layer and we have also got a
connection through them through the via, And then what we do is that we carry out a
process which is known as chemical mechanical polishing, Or in short it is known as
CMP So in CMP we take the wafer and put it face down on a polishing machine And
using a high pH slurry material, the complete wafer is polished and planarized, And we
get this kind of structure, So we have, so once we remove this extra material, then we
are left with this part, And that is what it is shown, So the upper part, that is this part
from here to here, gets removed by the CMP process or chemical mechanical process.
And we get two layers of interconnects, one running in this direction and the next running
in orthogonal direction. And we have a via at the place where we wanted to have an
interconnection between these two layers. Now this task of creating interconnects is
repeated multiple times. I have just shown one layer, It will be repeated many times and
many layers of interconnects will be created,


So we have just looked into IC fabrication tasks very, very briefly, So to just get an
intuitive understanding of what is done in IC fabrication so that the IC fabrication
basically must be considered even during physical design.


Why? Because when we are making a layout, we need to understand the constraints that
are imposed by the fabrication process on the physical design task and maybe carry out
some physical design task which will help solve the problem that will be encountered
during fabrication. So in subsequent lectures, we will be looking into what those tasks
are, and how we can make our designs such that we do not encounter problems during


fabrication. Now let us look into interconnects or wires, some properties of these
interconnect layers which will be very important during physical design.


So metal
layers are of
two types.
We have
already seen
that we have
one lower
metal layer
and the other
metal layer, these two metal layers are making interconnections. So these run parallel to
the surface, So we have one metal layer which is running parallel to the silicon
substrate.


The other metal two layers are running parallel to the silicon substrate in another
direction, So these are wiring layers. And the second type of metal layer is the via
layer, So this is the via layer. We have seen how to create via. So via connect two
wiring layers and they run perpendicular to the surface. So the current will flow in this
direction, then it will go this and this, So the direction of the current flow through the
via will be in this direction, either this direction or in this direction.


It will be orthogonal to the substrate. Now if we consider interconnect or a wiring layer,
then it is a kind of a 3D structure, It has 3D structure, it has got length, it has got width
and it has also got thickness, Now in IC technology, what do we do that we do not
allow the thickness of the metal of the wiring layer to be varying for a given layer For a
given layer, the thickness of the wiring layer that is predefined by the foundry and we are
not as a designer, we are not allowed to change the thickness of the wiring layer, So the
interconnects have uniform thickness that is the height of the metal layers in the wiring
layer that is fixed. And therefore, as a designer, we can ignore that what is the height of
the interconnects and we can simply consider the interconnects as 2D features 2D
structures and simply we can represent in our design as 2D, 2D structures So for
example, for this metal one, we can say that its length is this much, its width is this much
and its thickness is as defined in the foundry. As a designer, we are not allowed to
change, So as a designer, we can only control the length and the width of the wires,
Similarly for metal too, So in the layout, when we create the layout for our net list,
there will be drawing the lines on the on the or the if the tool has produced the layout, we
will see interconnects simply as a strip as a 2D strip, And therefore, the 3D in the third
dimension is typically not true. It is implied because that the third the thickness of the
interconnect is same as defined in the by the foundry and that information is there in the


library. So we will see how that information is captured by the tool and so on in later
lectures.


Now shapes of wires in the layout decide where metal needs to be deposited during
fabrication So as a designer, we are creating a layout So when will we be creating this
kind of layout in physical design Now, what is the implication of this design Sorry,
what will be the implication of creating such a layout The implication is that wherever
we have said that the metal line should run like this, it should be have a width of this
much and length of this much, the same this information will be used or that this
information will be contained in the layout and that layout will be used by the foundry
and the copper material will be will be deposited in during fabrication as per what we
have specified. Its length will be L, its width will be W. So the shapes of the wires in the
layout decide where the metal needs to be deposited during fabrication. Now, in a
typical ice or advanced fabrication technology and in high performance ICs, we can use
as many as say 15 metal layers, So in this figure, we are showing only 6 metal layers
M1, M2, M3, M4, M5 and 6, But in advanced processes, we can have as many as say 15
metal layers, Now, the metal layers are separated by dielectric. So we have say M1
layer, M2 layer, M3, M5 and between them, we have dielectric.


So here we have SiO2 or dielectric. Here we have again dielectric or ILD interlayer
dielectric, So metal layers are separated by dielectrics. Generally, it is used, generally
what we use is SiO2, silken dioxide. But we will see later that this dielectric material
impacts the capacitance and therefore, the performance of our circuit and therefore, it is
desirable that the dielectric constant of this interlayer dielectric should be small. So we
can use low K material. For example, we can dope silicon dioxide with carbon or use air
spaces to reduce the dielectric constant of the interlayer dielectric. Now, the height of the
wiring layers can be different in different layers.


We said that the height for a given layer is fixed, For example, M1 layer everywhere
on the layout, the height will be the same as defined by the boundary. But for different
layers, the height can be different. For example, the height typically increases as we go
up in the layer. So the top layer will be the thickest, then the thickness will reduce, then it
can reduce further and so on. So we can utilize these properties to use layer of metal
where we want for example, if we if we consider the top metal layer, so there the
thickness of the of the metal layer is more and therefore, the cross sectional area will be
more and therefore, the the the resistance per unit length that will be smaller for higher
metal layers, So with this observation, we can think about which nets need lower
resistance, we can route them in the upper metal layers and so on.


R =


So we will see how we can optimize our layout with the help of this information that
the thickness of the metal layers goes on increasing as we go to the top or to the upper
layers of interconnects. Another feature that we must note is that each wiring layer has a
preferred direction, vertical or horizontal. For example, the M1 layer is running only
along the y axis. So we are saying that y axis is coming out of the plane of the screen,
So in the M1 all the lines will be going, going going along or running, going out of the
screen and in the next layer, so, each successive wiring layer alternates between vertical
and horizontal direction. So meaning that if we have M1 layer which is along y axis, the
next layer M2 will be along x axis that is orthogonal or orthogonal to it, So one will be
horizontal, then vertical, then horizontal and vertical, So that is what we see in this
figure.


So the M1 layer is along y, then M2 is along x, M3 is along y and so on. So now, why
do we do this kind of allotment so that each layer has a preferred direction? So M1 all
wires will be running only along y direction. For M2 it will all be running along the x
direction and so on. So we specify preferred direction because it eases making
interconnections, It eases the task of routing, but what is the downside of it So the
downside of it is that whenever there is a change in direction, for example, if our wire is
like this, So we cannot have it in one layer, So wherever there is a turn in the wire, we
should go into, so this one will say M1 is running vertically.


So this will be M1, now M2 is running horizontally. So this one will be M2 and to
connect M1 and M2 will have vias at this place. So wherever there is a turn in the wire,
we will have to insert vias, And therefore, the via count can increase. So this is the
downside of having preferred direction for each layer, Now we use this because it eases
the task of routing, But understand that this is not a sacrosanct rule that if there is a
preferred direction for M1 is along y, we cannot run for along x that is not it is not a
sacrosanct rule, For a small distance, the wires can run for a for a for in orthogonal
direction also and tools tools make those adjustment automatic.


Now let us look into what are interconnect parasitics, So typically for interconnects, the
resistance and capacitances are more significant. The inductance for most of the nets are
insignificant.


For some they are significant. We will see that in later lectures. But in this lecture, let


us look into what are resistances and capacitances of interconnects, Because resistance
and capacitances impact the delay and performance and even power and other
characteristics of our and other figures of merit of our design. Therefore, we should be
aware of what are and from where does the resistance and capacitance appear in our
interconnects. Ideally our interconnect should be something like this. If we apply a
voltage signal here, the voltage signal should get exactly at the other end. There should
not be any resistance capacitance in this path, That is an ideal interconnect.


But we do not have ideal interconnection in physical design. They will have some
resistance and capacitance. In logic synthesis, we often assume them to be ideal. But
now in physical design, we have to consider more realistic interconnects. So let us
understand resistance and capacitances. Now suppose this is an interconnect which is
running along this direction.


So current is going in this direction and it is leaving in this direction, So the thickness
of this interconnect is T, The weight is W and length is L, Now what will be the
resistance So from elementary physics, we know that the resistance is rho L by A and in
this case the area of this cross section is T, T multiplied by width, So T into W is the
area of this cross section,

# **_R = pL/ TW_**


So the resistance will be rho into L divided by A that is T into W, Now this is if we say
that the thickness is fixed, For a given layer, the thickness is fixed. So in that case, it is
better to represent resistance R is equal to R S L by W where R S is rho by T. So what
we have done is that we have just taken rho divided by T as a constant R S and we call
this constant as sheet resistance. Now why rho by T constant Because the thickness of
this layer is fixed, It is T everywhere in the layer, For a given layer, For a given layer,
the thickness is fixed and therefore the sheet resistance will be fixed,


_**R = Rs (L/W), Rs = ( p/ T)**_


So this sheet resistance typically will come from the foundry and these are there in the
library and the tools will use this sheet resistance value in delay computation and other
computation wherever resistance is required. So however, note that this is a very
simplistic model of resistance. In some situations, for example, when there is a high
frequency, when the conductor is carrying a signal of high frequency, the resistance of an
interconnect tends to increase.


Why does it tend to increase? Because of an effect which is known as skin effect. So
suppose this is our semiconductor, this is our interconnect, so cross sectional area of
interconnect, So if we look into the cross sectional area of the interconnect, when the
frequency is high, when the frequency is high, then the current tends to flow primarily on
the surface of the conductor Along this. And in effect, the inner part of the
semiconductor of the conductor that is this area typically remains unused. So ineffective
the cross section area of the conductor reduces and therefore the resistance goes on
increasing. This skin effect becomes important for wider and thicker wire at the top
metal layers where clock lines work at high frequency.


So in that typically we route clock lines at the top metal layers where the thickness of
the metal wires is greater and in those lines this skin effect will be more because the
thickness is also larger and also that the clock lines work at a greater frequency. Now let
us look into interconnect capacitance. So before going to interconnect capacitance, let us
first understand why there is an interconnect capacitance, why there should be a
capacitance associated with an interconnect. So interconnected, it lies in a kind of a sea of
dielectric. So there is an interconnect in our IC and everywhere there is dielectric, Now
whenever we apply voltage and the active computation is done in our circuit then the
electric potential of interconnects change during the circuit operation So the electric
potential of the interconnect, so this is an interconnect, And the electric potential of this
can change. For example, initially it was 0 volt, now it will become VDD. Now when
this happens, the electric field and the stored charge in the surrounding dielectric
material also change, So it is not that only the electric field inside the interconnect
changes.


The electric field in the surrounding dielectric also changes and the energy that is stored
in the dielectric that is also gets changed by when the potential of the interconnect
changes, So the electric field and the stored energy in the dielectric that gets changed by
during the operation of the circuit. And consequently the interconnect exhibits
substantial capacitance. So remember that capacitance is basically a kind of ability to
store charge, So the stored charge in the dielectric gets changed as we change the
voltage in the interconnect and that leads to basically a capacitance effect or we observe
capacitance associated with the interconnects. Now what factors influence the
interconnect capacitance So it depends on the geometry of the interconnect, then the
environment, meaning the location and geometry of other interconnects which are in the
vicinity of a given interconnect and the property of the surrounding dielectric, So these
things primarily impact the capacitance of an interconnect. Now the computation of
interconnect capacitance is a non-trivial problem, So when we have an interconnect and
it is surrounded by many other interconnects, So this becomes a very complicated


system and computing the interconnect capacitance becomes very very challenging.


So typically what we do is that we take help of numerical simulation techniques, field
solvers and other sophisticated techniques to compute the interconnect capacitance.
However, for getting an intuitive understanding and the factors which influence the
capacitance, let us briefly look into some of the system and what are the basic
capacitance components for those system, so that we can understand that if you want to
say change the capacitance, increase it, decrease it and so on during physical design, how
can we accomplish it But note that the exact computation of interconnect capacitance
will be done with the help of tools that use sophisticated numerical techniques and field
solvers to compute the capacitances. So let us first consider a system in which there is
an interconnect. This interconnects, so these interconnects assume that it is coming out of
the screen and there is a substrate, Now there is a substrate which is ground, Now we
can associate two components of capacitance in this case. The first one is the parallel
plate capacitance. So there is a, there are field lines which are emanating from, coming
out from the bottom of the interconnect and ending on the substrate.


Now if we consider this part, this is nothing but a parallel plate capacitor and therefore
we can compute the capacitance simply as epsilon A by D. So this is what we have, that
we know from our class 12 physics, So for a parallel plate capacitor, the capacitance is
given by epsilon A by D. So epsilon here is epsilon D into epsilon naught. So epsilon D
is the dielectric, relative dielectric constant for the materials. For example, SiO2, if it is
the material, then that will come into this, And then what is the distance between,
distance between this epsilon A by D, that is the formula, Epsilon A by D.


So the distance between is TD, So this will be TD here, That is what the distance is,
And then the area So that area will be this W and the length of this. So this interconnect
is coming out of the plane of the screen. So what is the length along that direction? L is
coming, And W is the width of this, And TD is the, TD is the, is the thickness, is the
distance between the bottom of the dial, of the interconnect and the substrate, So that
will be the first component. The second component is because of the fringe lines, fringe
fields. So there will be some field lines that emanate from or come out from the size of
the interconnect, These are the field lines, These field lines are there, And because of
these field lines also, there will be some stored charge in the dielectric and the, and the
component of capacitance that is associated with it, we call it as fringe field capacitance.


So both these components can be added together. So if we want to get the total
capacitance of the system, then we need to add this component which is a parallel plate
component and with the fringe field component, Now one point to notice that with
advancement in technology, what we do is that we miniaturize our, our, the features,


Now what are the features So features are for example, the wire width, So we want to
decrease the width of the transits, the width of the interconnects as much as possible, so
that we can pack more interconnects in a small area, So with advancement in technology
at the transistor size reduces, the interconnects width also reduces, So we try to do that.
But when we reduce the width,, we reduce the width, the resistance of the interconnect
will increase. Why Because our cross sectional area has reduced, Now further if we
decrease, decrease the, decrease the thickness also of the interconnect, then what will
happen is that the resistance can go up drastically, So typically what we do is that with
scaling we reduce the width, but do not reduce the thickness significantly, So as in, as,
as a result what happens is that with advancement in technology, the wire width reduces
and it is, the, the height of that wire or this T that remains fairly constant or decreases by
small amount. So our wires become thinner and taller, And therefore the side wall area
goes on increasing with, with, compared to the width and therefore the fringe component
actually goes on increasing with the advancement in technology. So this point you
should note because when we try to reduce the capacitance, we should be considering
which factor is important or which component is important for an interconnect and we
should target that while reducing the interconnect capacitance and so on.


Now this is the case of a very simple situation where there is one, there is only one
interconnect and then there is a circuit. But a real, real integrated circuit will have this
kind of system, a very complicated system. So we have an interconnect, for example,
this interconnect which is coming out of the screen, And there are two similar
interconnects which are coming out of the screen and two interconnects which are


running in parallel,, in orthogonal direction and all of them will be interacting, And


So all of them will be, will be interacting and it will, it is a very complex system, It is a
complex system. So electric field lines emanating from an interconnect are modified by
neighboring interconnects in a complicated manner and to compute the, the, the
capacitance for a, for an interconnect 2 for example, is non-trivial, And tools will use
numerical techniques and other sophisticated techniques to estimate the capacitance of 2,
Nevertheless, we should understand what are the major components and if we try to
reduce the capacitance or modulate the capacitance, what things can we do So there are
three major components of capacitance if we consider this conductor 2 as our, as the
conductor for which we are computing the capacitance.


So the first one is the overlap capacitance. So the overlap capacitance is due to the
overlap between two conductors in different planes. So conductor 2 is in this plane and
conductor 3 is orthogonal to it, So there are two, two conductors running in different
planes. However, there is one space like this in this part, Where there is an overlap,
There is an overlap of these two conductors, So this will lead to an overlap capacitance.
So overlap is with conductor 3. So we have this component and we have overlap with
conductor 1 and we have this component, So this is the overlap, overlap capacitance.


Then there are lateral capacitances formed by two parallel edges of non-overlapping
conductors in the same plane. So if we consider say conductor 4 and 2, they are in the
same plane. They are running in parallel, So there is a sidewall. This is the sidewall and
this sidewall. These are working like a parallel plate capacitor, With a dielectric
between them.


So we can identify lateral capacitance with. So this is the lateral capacitance for 2 and 4
and this is lateral capacitance between 2 and 1. And the third component is fringe
capacitance. Now the fringe field lines will emanate, emanate from 2 and it will end on 3
through the sidewalls, not through the overlap. So this is the overlap part, So this is the
overlap part, And this is the sidewall part, So fringe capacitance is between two
conductors in different planes due to electric fields originating from the sidewalls. So
we can identify from 2 and 3 along the left hand side and along the hand side, So there
will be, I believe, 2 and 1 left hand side and hand side, So there will be 4 components


of fringe capacitance.


So for a given capacitor, for a given conductor, there are 3 different components, And
the tool needs to compute all of them and then, then, then it needs to combine them and
give the final capacitance value for an interconnect But to get an intuitive field, what a
few things should, can be noted from the discussion. Now if we want to reduce the
capacitance between two interconnects, then what can we do The formula of parallel
plate capacitance is epsilon A by D. So if we reduce, if we increase D, then C will come
down, So if we say make 4 and 2 further apart, then we can make, may, may, reduce the
lateral capacitance component. If we make 2 and 3 non-overlapping, then that
component will go away. Similarly, we can also consider how we can modulate epsilon,
So if we can modulate epsilon by changing the dielectric constant of the ILD, then the
capacitance will reduce. Now this decision needs to be taken at the foundry level,
meaning which material to use.


As a designer, do we not have control over the dielectric material of the interconnects?
So if you want to look into these concepts that we have discussed, you can look into
these textbooks and this paper. Now to summarize in this lecture, what we have done is
that we have looked into some basic aspects or basic concepts which are useful for
understanding physical design tasks. We looked into IC fabrication, we looked into
interconnects and we looked into interconnect capacitances. In the next lecture, we will
be discussing some more basic concepts that are essential for physical design and then
we will be moving to the various physical design tasks. Thank you very much.


