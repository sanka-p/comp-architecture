**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 48**
**Chip Planning - II**


Hello everybody, welcome to the course VLSI Design Flow. In this lecture, we will be
continuing with chip planning. In the earlier lecture or in the last lecture, we had looked
into some aspects of chip planning, we had looked into hierarchical design methodology
and we had also looked into some concepts related to floor planning. So, in this lecture,
we will be continuing with some more concepts related to floor planning and then we
will be looking into power planning. So, during floor planning, one of the most
important tasks is to place large objects. So, these large objects are also known as
macros, okay.


So now what is a large object or macro? So these large objects can be blocks . So in the
last class, we had discussed that, when for a big design, we do a kind of partitioning and
after partitioning, we get blocks . So the blocks that we got, so at the top level, will be
large objects that need to be placed over the layout. So the block obtained from the
partition, then there can be some other circuit elements, for example, RAM, ROM or
analog components or larger, say large clock buffers and so on.


So these are large objects which need to be placed on the layout. So we undertake the
placement of those objects during the floor planning stage . But remember that our
design also contains, say millions of standard cells, . So the standard cells, those will be,
will be placed on the layout or in the proper rows of standard cells during the placement
stage . So during the placement stage, we are placing standard cells, standard cells, the
placement of standard cells, the word cell is missing here.


So the placement of standard cells is undertaken during the placement step or task which
will be done after the chip plan . So during the chip planning stage, we only place larger
objects . So why do we want to do this differentiation of larger objects versus smaller
objects like standard cells? So the difference lies in the scale . For example, in our
design, there can be say millions of standard cells, but macros or bigger objects can be
say tens or maximum hundreds of them . And when the number of objects are smaller,
we can manually see whether the placement of the larger object has gone wrong and


therefore a lot of manual intervention can be made during the placement of larger
objects.


But for standard cells, since there are millions thinking of doing some manual
intervention, it is more difficult or impossible for all the objects, but for some tweaking
we can . But we cannot get a global view of what the placement is for the standard cells
and then do some manual intervention that is very, very difficult . So for the placement
of larger objects, a lot of manual intervention can be made and that is why we undertake
that during the floor planning stage. Additionally, the placement of these larger objects
leads to a large or impacts the figure of merit or final figure of merit of our chip
significantly. And therefore, the placement of larger objects must be undertaken more
carefully than, say standard cell placement.


So how do we place these larger objects? So the initial macro placement or large object
placement is guided by connectivity, meaning how one block or one bigger object is
connected with other bigger objects in the, in our design. And based on that, we can
make some decisions like if two macros are connected or well connected strongly
meaning that many nets are going from one macros to another, then probably we can
place them together or in the vicinity . So the typically physical design tools have a
feature of showing the fly lines . So what are fly lines? Fly lines basically show as a
number how many nets are going from one one object to the other. For example,
suppose let us take this as just an indicative fly line for a design.


Suppose there are say objects B1, B2, B3, B4, B5. These are five macros . And then
there are IO cells . Now these fly lines are indicating how many nets go from one block
to another. For example, if we say that, consider this fly line .


So this fly line is going from the B4 object and going into the IO cell. So that means that
this IO cell, let us call it I1 and block 4 B4, these two are sharing four nets . And that is
why the weight here is shown as 4, and so on. Similarly, if we look into how many nets
are between the object B2 and B5, we see that this is the fly line corresponding to them
and there are four nets . Now using these fly lines, we can get some idea or clue of how
the macros should be placed.


For example, if we see the block B2 and the block B1, . Now between them how many
nets are there? There are 52 nets, and among all of them this is the maximum . So it
gives us a hint that B1 and B2 must be made closer to it . So this is just a heuristic and
based on that we can start with say initial floor planning and then probably modify or
improve it and get to a better solution. Similarly, we can use for that we can look into
that how many how macros are connected to IO pairs and IO cells and based on that we
can think that to which IO cell I should which IO cell I should put a or given a block or
given a macro it should be placed closer to which IO cell depending on how many nets
are there between the block and the IO cell.


For example, in this block 16 nets are between this cell and this cell between this block
and this I cell input output cell or IO pad we can call it I2, . Now this is a large number
and therefore we can think that B1 would be good if we can place it closer to I2
compared to some other IO cell. For example, the other IO cell is this 5. Now this shares
only 5 nets . So between B1 and this IO cell let us call it as I3 there are only 5 nets.


So it is okay if we keep it further apart from I3, . Now additionally what we can do is
that once we have an initial floor plan,, we can do a kind of rough routing or predictive
routing . So these physical synthesis tools or physical implementation tools have some
mechanism to do initial routing,, a rough routing, . It is not very good in the sense that
the quality of routing is not important but it is very fast and it gives some idea of where
the congestion will be in our design and so on. And based on that we can tweak the
placement of these larger objects.


Now for the macro placement there is no very good algorithm such as deterministic
algorithm and therefore as a designer we often rely on guidelines to arrive at a good floor
plan. So let us look at a few guidelines that we can use in our design to improve the
quality of our layout. So one of the guidelines is that we allot contiguous regions for
standardization . Suppose this is what these are: A, B, C, D, E, F, G, H these are the
macros and this is the layout. This is the layout which is shown here .


The spaces that are left over that have that will be finally filled by say standardization.
Now in this layout in this floor plan we see that there are blocks of regions or


non-contiguous regions or fragmented regions where we
are allocating space for the standard shares . These are
the spaces where we are saying that we will put standard
shares and it is non-contiguous or fragmented. So
compared to this floor plan if we consider another floor
plan we have just moved the blocks somewhat and created
a continuous region or contiguous region for the standard
share. So we should prefer this kind of floor plan over
this one.


Why should we prefer? Because in this case the area is same for the standard cell area
and is same for both the floor plans. But in the second one we have a continuous region.
Now the placement of standard shares is done using automatic tools, as we have


discussed. And these automatic tools use algorithms for example analytical placement
algorithms which work very well if the region is continuous. If it is fragmented then the
placement algorithm does not work well .


And therefore it is always a good idea to allot a contiguous region for the standard cell
as shown in this figure. Another guideline is that we should avoid narrow channels
between macros . So for example consider this floor plan. In this we have a narrow
channel region here, narrow channel region here and also there is a narrow channel
region between the macro and the edge of the floor plan. Now we should avoid this kind
of floor plan.


Why? Because the first thing is that if the channel is narrow, then the routing number
of routing tracks that will be there. The routing tracks are parallel tracks . So depending
on its width we can have that many tracks. Now if this width becomes very small then


the number of routing tracks that will be available in a narrow channel will be much less
. For example here the number of routing tracks will be very less .


And therefore there will be a crunch of routing resources. And therefore it is highly
probable that there will be congestion in these narrow regions, narrow channel regions
between macros or at the edge of the floor plan . Another reason why we should avoid it
is that if we keep this region empty,, if we allow any standard cell to be placed in that
region what may happen is that the placement tool might actually place cells here also,
in these narrow channels. But since these channels are very narrow later on if some
optimization is required and if these cell sizes need to be increased there is no space left
for increasing the cell size . And therefore optimizations will be hit .


Optimizations and fixing timing problems for this kind of layout can be more difficult .
So, upsizing will be difficult or if the tool wants to insert buffers in these channels that
will also become difficult and therefore it can lead to timing violations and other kinds of

problems in the design. So we must avoid these
kinds of narrow channels in our design. Then
how to make our layout in this case or how to
make the floor plan in this case.


One way is to shift this up. We shift this up, this
up and this narrow channel goes away and
whatever was the extra area available we have
here . Now this may not be that much narrow and
therefore upsizing and say congestion problems
can be solved . So, upsizing can be enabled,
insertion of buffers can be enabled and congestion
can be probably alleviated or will be less in this
kind of floor plan. Another solution could be,, if B is allowed to be, is a kind of object
whose aspect ratio can be changed . Suppose B was a macro which we call a flexible
macro, .


So there are two types of macros . So there are two types of macros or large objects that
we handle in the floor plan. The first one is known as hard macros, hard macros. These
hard macros we might be getting from some other vendors and in this case the aspect
ratio and the and other things are fixed. We are not allowed to make any change in the
area or the aspect ratio of the macros .


But there are some macros which are known as flexible macros, flexible macros. For
these kinds of macros what happens is that we are able, we are allowed to change its


aspect ratio keeping the area the same . So in, suppose B was the flexible macro,, in that
case we can probably resize it or change the aspect ratio. We make it longer, taller and
thinner or less wide and we can get rid of this, this, these, these narrow channels . So if
that is allowed then we should do this.


We can fix this problem of narrow channels by changing the aspect ratio of the flexible
blocks. Now let us look into some more guidelines. Now for, we can add hellos around
the corners in the floor plans. Now what are hellos? Hellos are placement blockages
where we do not allow any object to be placed. So let us understand why we want to add
hellos in the corners of our macros .


So let us understand what the problem is. So suppose this is a part of a floor plan, not a
complete floor plan but a part of the floor plan where we have highlighted the corner of
this macro. There was a macro, and this is the corner of this macro, and if we do not
add a hello what can happen? So understand that the macro is already designed. It may

be a block which has been
designed by another team, we got
it or this macro was a hard macro
and we got it from some vendor or
so on. So this macro is designed
and all the routing resources above
the macros, so above this region,
all the routing resources meaning
that 10, 8 or 10 layers of
interconnect may be there, all
might be used for routing, and
therefore no routing resources are
available over the macro .


Now suppose there are some cells which are placed around the periphery or around the
corner of this macro. Now if a routing of those objects or cells are needed then all of
them must go along this periphery. They cannot go over the macros, because the macro
routing resources are already used up. So all the routing will be done around this macro,
like this, like this and so on and therefore a condition will develop around a corner of the
macros . Now this problem gets aggravated if the cells are placed close to the corners of
the macros .


The routing of those cells then on one side, on these side of the macros those routing
resources are not available and therefore they have got restricted routing resources for
the cells which are close to the corners of the macros. And therefore we should avoid


placing the cells near the corners of the macros and to avoid that we create hello regions.
So hello regions are something we give as an instruction to the physical design tool . We
say that on the layout this is the hello region, do not place anything there . This is an
instruction to the physical design tool and then no standard cell will be actually placed in
this region and therefore the problem of congestion will not come .


So this is why the hellos are sometimes used in the floor plan. Additionally what we
can do is that we can use a lot of flexibility that is available during floor planning. Now
what are those flexibilities? The first is related to orientation . Now we are given a say
block . Now given a block what we can do is that we can either use, we can rotate it.


We can rotate it 90 degrees or we can also take its mirror image either in the x axis or y
axis. So given an object we can get different orientations . In fact we can get eight
different orientations for a given macro or say even for a standard cell . For example,
suppose this was the macro, . This was the macro, we had been a, b, c and d, .


Now if we take a reflection along the x axis, along the x
axis or let the x axis be this side, then we get another
orientation . We will get c, d, a and b, . So this was the
macro and we got another orientation of the macro by
rotating it . So this will become w,, because of rotation.
So given a macro or an object we can try out all eight
different combinations of orientation that are possible
by the rotation of this object by 90 degree clockwise or
90 degree anticlockwise or we can try out the reflection along x axis or reflection along
y axis .


And therefore we will get a different orientation and we can choose the proper
orientation. Only thing that is a warning here is that once we rotate an object the power
lines also get rotated or reflected and so on . Now whether the power lines in the object
where those are aligned, still aligned with the power grid that we had designed during
power planning or not that must be looked into,, . For example, if there is an object we
rotate it by 90 degrees. The power lines which were running horizontally now have
become vertical .


And the orientation of those power lines may not be well in line with the power grids
that we have designed. So if we change the orientation of the object we should see that


after the new orientation the power lines are also aligned. Then we said that there are
some objects which are flexible objects . Meaning that their aspect ratio can be changed.
There are many blocks whose shape can also be changed .


Rather than a rectangular shape they can have a rectilinear shape. For example, this is a
rectangular shape, . Now this, the same thing, same area can be, may, can be same object
can be reshaped and made in the form of say a L kind of shape, . Now this is a
rectilinear shape, rectilinear shape and this is a rectangular shape. Now there are, for a
given a macro we can, it is, for many macros the, it is not required that it should be
always rectangular.


It can be rectangular, it can, rectilinear. For example, it can be L shape, it can be U
shape or any other shapes that we get by straight lines . So we can try out different
shapes and then see which one is giving us the best QR. Then, we can try out different
pin assignments . Now suppose this was a flexible macro and there are pins that A, B, C,
. Now if this is one case and the, it may happen that A is actually going to many objects
which are lying at the bottom .


And therefore it may make sense that rather than having pin assignment as A, B, C if we
make it as say B, C, A then the wire length can be reduced . Wire length can be reduced .
So, we can also try different pin assignments for, after doing floor planning to improve
the QR. For example, in this the length of the wires can be probably reduced by trying
out different pin assignments . Now during floorplanning we also need to allocate
regions for standard cell rows .


So in the earlier lectures we had discussed that standard cells have a fixed height . All
standard cells have fixed height meaning that given a library all gates for example, AND
gate, OR gate, inverter and so on all will have the same height. But their width can vary .
So if they are of the same height we can arrange them in the form of a row . Now and
what is the height of this row? The height of this row is the same as the height of the
standard cells .


Now in some libraries, in some cases what can happen is that some the standard cells
can have, cells can have, different cells can have different heights . So in that case we
can make rows of different heights . So multiple rows of different heights are created,
and can be created when there are cells of different heights in the library. Usually it does
not happen but in some cases we might have cells which are of multiple heights, maybe
height h1 and h2, . Then we will need to create two different rows, one of height h1 and
another height of h2.


Now standard cell rows are generally created by abutment. What it means is that we put
one row of standard cells and another row of standard cells sticking together,, as shown
here in close vicinity, . Just one row is there and then the other row is there. And what
another thing we do is that we create the rows such that the alternate rows are or the cells
in alternate rows are rotated by 180 degrees . So in this row, row 1 VDD is at the top and
ground is at the bottom .


So this is row 1. And in row 2 what we have done is that we have made ground at top,
this is ground, ground and the VDD at bottom. And then in the next row what we have
done is that again VDD is coming at the top and then ground is coming at the bottom.
Now what do we get a benefit out of this orientation? The benefit is that the same ground
line can be used for both row 1 and row 2, . So row 1 and row 2 both are sharing the
ground line .


And row 2 and row 3 are sharing the VDD line, and so on. And therefore, we are
saving the routing resources. Now if there is a problem of congestion then what we can
do is that between say row 1 and row 2 we can open up spaces . So we can open up
routing channels that can be created between rows to avoid congestion . So these are
some of the tasks that we carry out during floor planning.


Now let us look into the next task that is power planning. So in power planning first let
us look into what are the major components. The first component is the power pads .
The ones we had discussed in the last lecture . So now power pads basically supply VDD
and ground lines to the power delivery network.


Now these are the power pads. In this case I am showing there are 4 power pads .
These light blue ones are ground power pads and the dark blue ones are the VDD power
pads . Now from these power pads we have 2 rings, one ring for ground and another ring
for VDD, . So, the power rings carry power around the periphery of the die . Now for
these ground lines or ground rings and power rings which layers of metal do we use?
Typically we use the top layer, top most layer, .


So in the earlier lectures we had discussed that the thickness of the interconnects
typically is larger at the top and lower at the bottom . Now if the thickness of the metal
layer is more at the top layer it means that its sheet resistance will be smaller and
therefore the resistance offered in the top layers of the integrated circuit will be lower .
And we want that the voltage drop in the power lines is smaller and therefore typically
we use the higher metal layers for the power rings and also for power delivery networks.
So from these power rings there will be a power delivery network which will be created
in the core .


So we have power pads . The power pads will get VDD and ground from the package
VDD and ground pins . That will come to the power pads and from power pads a ring is
created, and the ring basically carries the VDD and the ground. Now how many power
pads do we need that depends on what is the current requirement for our chip and so on, .


In this case we have shown only two, . There could be many . Now in the core area we
build a kind of power delivery network. Now let us look into what a power delivery
network is. Now the most common topology that we use for power delivery networks is
what is known as mesh grid topology which is shown here . So in this what is done is
that there are parallel lines, these are parallel lines or horizontal lines which are basically
known as rails, these are known as rails, and there are vertical lines which are known as
straps, and in between we have the connection which are vias, which connects these, .


Now these networks or this mesh basically carries the
VDD. So this may be for VDD there will be another mesh
for say ground line, and from this power delivery network
or mesh grid the power pins of the standard cells and
macros will be driven and those will be tapped from these
lines . So this is how the power delivery network is
created over the entire core area and from the core from
this power delivery networks the from appropriate tapping
points we get the we we get metal lines and then that
metal lines basically feeds to the ground and metal lines sorry ground and VDD lines of
the standard cells and the macros. Now what are the advantages of mesh grid topology?
So the first advantage is that it provides or offers low resistance. We want that the power
delivery network does not lead to a large voltage drop from the source to the end end cell
or the logic gate and therefore, we want that the resistance should be low. So, the power
delivery network which is of grid type and those of those grid type networks offer low
resistance.


Why do they offer low resistance? Because there are many parallel paths . Now if there
are two points and there are more parallel paths between them, then of course, the
resistance will go on decreasing as we create more parallel paths. Now in this top with
the mesh grid topology there are so many parallel paths that the effective resistance
between two points goes down. Another important merit of this power grid mesh grid
topology is that it offers a high reliability and why it offers high reliability again the
reason is similar . For example, given this point there are and suppose this one was the
VDD line VDD VDD power pad. So, from this point to this point there are many paths
for example, this path, this path, this path and so many paths .


Now out of this path say one of them gets snapped because of some problem, one of
them gets snapped. Then still the power will be delivered to this point through some
other alternate paths and therefore, this mesh grid topology has got a higher reliability
and it also leads to uniform current distribution because this topology is more or less
symmetrical . Now depending on whether the where the power where the the power pads


are located it may not be completely symmetrical, but if we just look at this grid
topology this is perfectly symmetrical . Other than say power variations due to PVT
power process induced variations and so on that may change its symmetric symmetric
nature otherwise the current distribution will be more or less uniform in this case. Now
as a designer when we are creating this power delivery network what should we consider
or what important things we should need to consider.


The first is that where these layers are, where this layer that this green line is one layer,
and this orange line is another layer, where these line these lines should be. So,
typically we will choose it at the higher level higher metal layer because the resistance
will be lower in those metal layers . And then we need to also choose how much width
should be there between the width of these metal lines, and how much spacing should be
there . Now these are decided by technology . So, for example, technology will say that
you must have this much spacing between two lines, that is to say design rule this design
rule that will come from the foundry .


And similarly the width cannot be less than this and so on. So, these things will be
decided by the design rules of the foundry. Additionally we should consider how much
voltage drop is tolerable in our power delivery network and based on that we can reduce
the spacing between two parallel lines or so and make those decisions . Now let us look
into some of the problems that we need to tackle or consider during designing a power
grid. The first problem is related to electromigration. Now what is electromigration?
So, what happens is that when the flow of current is unidirectional in metal then it can
actually lead to transport of metal mass in the direction opposite to the current flow .


Now if this is a metal and the current flow is in this direction what can happen that the
atoms of this metal may actually move in opposite direction and ultimately it can lead to
circuit problems like short circuiting and open circuiting. Now why does this happen?
So this happens because an electron we can also consider as a particle and it carries some
momentum . Now when these electrons are, when the current is in this direction, the
current is in this direction, the conventional current is in the direction shown. The
electrons are actually moving in the opposite direction, because the electron carries
negative charge and the electron direction movement is in the opposite direction to the
conventional current direction . So the electrons will be actually moving in this direction
and these electrons are actually carrying momentum and those are hitting the metal
atoms and as a result of that the metal atoms can actually move from the location on the
lattice from one point to the other and it will can lead to transport of metal mass and
when this happens then we say that the an electromigration has happened, . So because
of these electron migrations there can be short circuit or open circuit and this kind of
electron migration is more when the direction is unidirectional meaning that current is


always flowing in this.


If it was also flowing in another direction sometime then it can lead to a healing effect
that is what is observed in other kinds of signals. Whereas current sometimes goes in this
direction, in some direction sometimes in opposite direction then the atom sometimes
moves in one direction and in the other case it moves in the other direction on an average
the metal atoms do not move, and that is known as healing effect. But what happens in
the power delivery network is that the current always moves in one direction, from
VDD to the to the to the to the element where it is supplying the power, and therefore
the direction of current is is unidirectional and power delivery network are more prone to
electron migrations and therefore we must consider this that what for a given technology
given process technology what is the tolerance limit of of electron migrations and based
on that we need to take some corrective measure. For example, we can increase the size
of the conductor to ameliorate or decrease the effect of electromigration or we can we
can we can run tools which are report problems of electromigration and they show that
where there are current hot spots and if there are current hot spots then probably we can
resize the conductor size or take some other measures to to to fix the electromigration
problem.


The other problem that is associated with the power delivery network is voltage drop
problem. Now, first let us understand why there is a voltage drop in the power lines. The
reason is the parasitic resistance and capacitance of the power lines. So, the power lines
have got some resistance, or the power lines are made using metals as we have seen and
metals will have some resistance . Similarly there can be inductance also, mainly
between the package pin to the die . We have seen that in the last lecture we saw that
from the power from the package pin to the IO cells there was metal wire, metal wires
through which these things were bonded.


_**Voltage = iR + L(di/dt)**_


Now because of these packaged-to-die interconnections there can also be inductance,
and we know that because of the resistance and inductance there can be a voltage drop.
The voltage drop will be I R that is corresponding to the I current and R is the resistance
of the line and plus L di by dt. Whenever I is changing and there is an inductance then
because of L di by dt there will be some voltage drop . Now this voltage drop can be all
during the static stage meaning that when the active computation is not being done or it
can happen in the dynamic stage dynamic condition also. For example, when there is an
active computation in our circuit then a large current will be drawn from the power
supply, and when large current is drawn from the power supply this I component


increases.


So IR increases and also di by dt can be sharp because the current can go from 0 to
some value very quickly in time and therefore, di by dt can be large and therefore, in the
dynamic condition the power the in the dynamic condition meaning that when the active
computation is being done by the circuit during that time a voltage drop there can be a
significant voltage drop in in the power lines. Now what is the problem of this voltage
drop? So the first problem is the performance . Now if there is a voltage drop then the
the the standard cells for example, if there is an inverter, and it was it designed to
operate was at 1 volt, 1 volt Vdd and this is the crown, but because of the voltage
because of the voltage drop it became instead of 1 volt say 0.


8 volt. So what will happen is that the delay of this inverter will increase . If the voltage
supply voltage supply to the standard cells comes down then the delay of the standard
cells increases and therefore, the signal propagation along the path slows down and the
maximum frequency at which our circuit can operate comes down . And therefore, we
need to perform voltage drop analysis in both static and dynamic condition for example,
dynamic condition we can think of that when we subject our circuit to some simulation
or we apply test vectors to our circuit and does some active computation and we do a we
get that the value changes in the values of the nets for the design and based on that we
can understand that what is the activity in our design and using those activity we can we
can estimate that what will be the current drawn by the from the power line and
therefore, if the in some portion of our design or layout there is large activity there a
large current will be drawn and there will be a higher IR drop and L di by dt drop and
voltage will the voltage can come down drastically, . So those regions were in the layout
where there is a large deviation from the stated voltage. So, suppose the stated voltage or
the rated voltage or the nominal voltage was say 1, and the voltage drop became or the
during dynamic condition or during the working of the chip it dropped from 1 volt to 0.


8 . So, this is a large IR drop and in the portion of the design where there is a large IR
drop those are known as IR drop hotspots. So, there are tools available which help us
understand which portion of our layout is our IR drop hotspots. Then we have to take
some corrective measures to fix those IR drop hotspots and how can we fix it? We can
fix it. One of the most popular techniques is to use what is known as decoupling
capacitors or decap cells . Now what are decap cells? Decap cells are capacitors inserted
between power and ground lines. So, these are simple capacitors we have say one line V
DD and this is the ground line between this we have a capacitor . So, ideally what will
happen or in the static condition what will happen this capacitor will be charged to V
DD, .


It will be charged to supply voltage . Now, but when a circuit does an active
computation and a standard cell for example, suppose with this VDD and ground line
there was an inverter connected to, . This is the V DD line for the inverter, this is the
ground line for the inverter . Suppose this inverter was drawing a large current . So, in
that case these capacitors will act as local storage .


So, the power line is suppose the power pad is here this is the V DD pad this is the
ground pad, . So, rather than getting current from this path, if a local inverter is drawing
local decap cells, then some current will also be supplied by these decap cells . And
therefore, the power the voltage drop that is seen by the power lines will be reduced . So,
what this decap cell is doing is it is basically acting as a local charge storage . And these
charge storage supplies charge to the standard cells or in this case inverter.


So, these decap cells supply charge whenever required during dynamic operation of the
circuit. And this addition of these decap cells basically reduces the effective voltage drop
that is seen by the charge storage supply of the standard cells . Now, where should we
place these decap cells? So, we should place these decap cells at a strategic location. For
example, if we know on the layout that these are the IR drop hot spots if we put put
decap cells closer to those regions,, closer to those IR drop hot spot then these decap
cells can provide local charges local charge to those IR drop to the circuit elements
within that IR drop hot spot and the problem of voltage drop will be will be less or
reduced, . But what is the demerit of adding the decap cells? The disadvantage is that it
increases the die area, because it takes some die area. It is a capacitor and therefore, it
will consume some die area and also it will lead to leakage power dissipation, ok. So, we
said that this decap cells will be charged to VDD, in normal static condition, but it will
also have some leakage current, and that will be drawn even when the circuit is not
operating .


So, the leakage current of the circuit can go up because of decap but but still these two
merits the despite these two demerits we still use decap cells to fix IR drop hotspots
because it is very effective in solving that problem and the cost involved can be kept low
if we do it carefully, . If we choose the number of decap cells carefully and use only
when it is required, keep the size of the decap cells to the minimum that is required and
place them at the strategic location then we will be able to utilize decaps very effectively
. Now fixing IR drop problems can be actually done or tackled throughout the wheel side
design flow . So, we can even make decisions at the system level that if in our design,
there are two modules which are drawing a lot of current, . So, we should power on those
modules in a staggered manner so that the peak current of the circuit comes down and
the effective IR drops seen by the circuit is smaller or reduced .


So, even at the architectural level or at the system level also we can fix IR drop
problems . We will see how clock tree in clock tree synthesis by adding clock skew we
can solve the IR drop problem also . So, the IR drop problem can be tackled at different
stages in the wheel side design. So, if you want to know more about these topics you can
go through them and you can refer to this text book. Now, to summarize in this lecture
what we have done is that we have looked into some more aspects of floor planning and
we have also looked into power planning . An important thing to note here is that during
the chip planning stage a lot of manual intervention is made .


It is a very crucial step and where and and the decisions of the chip planning impacts the
complete physical design implementation . And therefore, we often tweak the solutions
that we get out of the tool and make manual interventions . And therefore, EDA tools or
commercial EDA tools provide many features and mechanisms which allow us to make
those manual intervention more effective and efficient . So, I will suggest that if you are
using, say, commercial EDA tools then look into the manuals and understand what
opportunities you have to get better planning or to do chip planning more efficiently .
Now, in the next lecture we will go to the next major physical design step that is
placement. Thank you very much.


