**VLSI Design Flow: RTL to GDS**



**Dr. Sneh Saurabh**
**Department of Electronics and Communication Engineering**



**IIIT-Delhi**



**Lecture 1**
**Basic Concepts of Integrated Circuit: I**


Hello everybody, welcome to the course VLSI Design Flow: RTL to GDS. This is the
first lecture. In this lecture, we will be looking at some basic concepts related to
integrated circuits. Specifically, in this lecture, we will be discussing the historical
perspective of integrated circuits. Then, we will be looking into the structure of integrated
circuits. We will look into some terminologies related to the fabrication of integrated
circuits, and then, finally, we will discuss the basic differences and relationship between
designing and fabrication.


Now, before moving to integrated circuits, let us look into a statement that Charles
Babbage made. So, as you might know, Charles Babbage is considered the father of
computers. In his book “On the Economy of Machinery and Manufactures”, there is an
interesting statement. So, the statement is "…sources of excellence in the work produced
by machinery depend on a principle…, and is one upon which the cheapness of the article
produced seems greatly to depend on." So, what is this principle? “This principle alluded
to is that of COPYING taken in the most extensive sense”.


So what this statement means is that the articles or the products or the work produced by
machines are excellent, and they are also cheap, and the reason for that is a principle,
which is copying. This statement is very much true for the Industrial Revolution when we
started using machines to make products, and it is also relevant to the digital revolution
that we are seeing today. So, the digital revolution is enabled by chips or integrated
circuits and how we can manufacture such complicated or complex integrated circuits
and also keep their cost very low. The reason for that is that we have mastered the
technique of copying an integrated circuit. Now, what do we mean by copying an
integrated circuit? We will see in today's lecture.


So, let us first take a historical perspective of VLSI. Now, if we consider any electronic
circuit, it consists of some active components and some passive components. Active
components like transistors and diodes, and passive components like resistance,
capacitance, and inductors. So, any given circuit consists of these kind of circuit elements
or components. So, in earlier days, we used to create a system or electronic system by
adding discrete components or connecting discrete components over the boards. We used


to have transistors as discrete components and resistors as discrete components, and we
used to realize the system by connecting them at the top level.


Now, as the complexity of this electronic circuit increases, this method of putting
together discrete components and realizing a system becomes very expensive. It also
becomes time-consuming, unreliable, and error-prone. So, to handle this situation or the
problem of integrating (putting together) discrete components and realizing a system, a
new technology was invented in the 1960s. And what was that new technology? The new
technology was Integrated Circuit. What is an integrated circuit, and how is it different
from putting together discrete components? An integrated circuit is a monolithic silicon
chip which contains several components. And what do we mean by a monolithic silicon
chip? It means that the silicon chip or the substrate or the silicon that we use consists of
only a single crystal of silicon.


And over that single crystal of silicon, we are integrating multiple components like
transistors, diodes, resistors, etc. It is not that we are putting together different
components and putting them, combining or adding them together. On the silicon
substrate, using some technology, we are growing transistors or making transistors,
diodes, and resistors. As a result, the complete system is one piece of monolithic silicon
chip. And that is what is known as an integrated circuit.


Furthermore, how can we fabricate or make this integrated circuit? We can make this
integrated circuit with the help of a technology which is known as IC technology. So this
IC technology was invented in the 1960s, and at that time, lots of inventions were made
and discoveries of, say, good properties of silicon dioxide and the interface of silicon and
silicon dioxide were discovered, and those things were utilized in the integrated circuit.
Over the last 50 years or so, a lot of inventions and discoveries have been made in IC
technology, as a result of which we can realize very complicated chips.


Among these IC technologies or the various inventions and discoveries, one of the
techniques is what is known as photolithography. This is the basic technique that allows
us to copy integrated circuits. So, we will look into photolithography in more detail in
subsequent slides. This is a key thing that we should understand. Photolithography is the
key technology that has enabled IC technology, and this IC technology has enabled
making complicated circuits, and that has spurred the digital revolution that we are
witnessing.


Now, when IC technology was invented in the 1960s, a few components could be put
together on a monolithic silicon chip, say, tens of them, and that was small-scale
integration. And with time, this technology matured, and we could add more components,
say, thousands of components, and we moved into large-scale integration. And then we
moved to, very large-scale integration where we can have millions or billions of


components put together inside our integrated circuit. So, in the 1960s, when this
technology was still being developed, Moore made a famous prediction at that point of
time in the 1960s, when only tens of components could be combined together. At that
time, Moore could observe the trend of increasing integration, and he made a famous
prediction, now known as Moore's law.


And what was that prediction? So, the prediction was that the number of components in
an IC realized at minimum cost would double every year. So it doubles every year, and
later on, seeing on that basis or observing the trends, he modified his statement in 1975
and said that it would double every two years. This is an exponential relationship; with
time, things are doubling. Surprisingly, this prediction, which was made in the 1960s, has
been true till now. We are seeing an increasing integration of integrated circuits, meaning
that we can pack more components and still maintain the cost or the cheapness of the
article to a level where a common man can afford these mobiles, laptops, and other
sophisticated equipment. Now, how can we pack so many transistors in our integrated
circuit? So, the basic reason is that with time, as the technology has advanced, we can
shrink the size of the transistors. We can make smaller and smaller transistors.


For example, in the earlier days, there was, say, 90 nanometer technology, and then it
gradually advanced to, say, 65 nanometer, 45 nanometer, 32 nanometer, and so on. So
these technology names basically, in some manner, denote the size of the transistors.
When these names have smaller numbers, it means that the sizes of the transistors are
becoming smaller and smaller. And when we make the sizes of the transistor smaller,
what gain do we get? So we get gain in almost all the parameters, meaning that the speed
increases, the energy efficiency increases, which means that given a computation, how
much energy is required to do that computation, that energy is also reduced with
technology advancement, and the cost per transistor is also reduced. With time, the cost
per transistor has been reducing, and all these things are so favorable that the technology
has gradually moved in a direction that the sizes of the transistor goes on decreasing.


Now, of course, there are lots of benefits of shrinking the transistors or miniaturization
of transistors or advancement in technology. But what is the downside? The downside is
that the design becomes more complicated as we add more and more transistors in a
given area. So, the number of transistors a designer needs to handle is much larger.
Therefore, designing an IC becomes more complicated and challenging, and throughout
this course, we will be looking at this challenge and how we can address this challenge of
increasing design complexities as technology advances.


Now, let us look into the structure of an integrated circuit, like what an integrated circuit
looks like. So first, let us take a simple electronic circuit, say a CMOS inverter. This is a
very simple integrated circuit. We have a say PMOS or PMOSFET and NMOSFET,
which are connected in a complementary manner, and this is nothing but an inverter or


NOT gate. So when we apply 0, we get 1 at the output. If you apply 1 at input, we get 0 at
the output. See, this is a very simple circuit.


Now, corresponding to this, how will the integrated circuit look like? So, I am giving
you one of the ways in which this integrated circuit can be realized. So, this is a simple
inverter. Now, it looks very complicated, so do not worry about the complicacy of this
integrated circuit. This course will not go into details of the fabrication of this integrated
circuit.


But, there are some salient features of the integrated circuit that we must understand
because that is very much relevant to the designing of an integrated circuit, which is the
primary focus of this course. So, what are some of the salient features of the integrated
circuit? So, the first thing is that this integrated circuit comprises multiple layers. So, the
figure that I have shown here is a vertical cross-section of the integrated circuit. Now, in
this integrated circuit, there are many layers of entities.


For example, at the bottom, there is a diffusion layer, then there is an implant layer, and
there are metal layers. So here we have shown only two metal layers, metal 1 and metal 2.
There can be more than two layers of metals. So, at the bottom of this integrated circuit,
we have devices, meaning transistors, diodes, etc. For example, this is a PMOS, and this
is an NMOS.


So, devices sit on the lower layer of the integrated circuit, and above the devices, we
have the interconnects. Interconnects are the metal layers which are connecting say, one
device to another. For example, PMOS and NMOS are connected together and this
connection can be made using interconnect metals or some other kind of interconnects


like poly-silicon. So, on the bottom, we have the devices. Above this, we have layers of
metals, and it can be more than ten layers of metal. In this figure, I am just showing two
layers of metal, metal 1 and metal 2.


In the advanced integrated circuit that we currently use, we typically have more than ten
layers of metals. These metal layers are connected with each other using another kind of
metal layer, which is known as the VIA layer. So, if you are not able to understand this
figure, it is perfectly fine. We are not going into the structure of integrated circuits in
detail in this course. However, a few important things that we can extract or understand
from this figure is that an integrated circuit consists of multiple layers of entities. For
example, there will be layers of devices composed of, say, diffusion layer, implant layer,
etc.


Above this, there will be layers of metals that are connected. A very relevant question
arises: Why do we realize integrated circuits in terms of layers? Why not a flat thing?
Why do we have so many layers of metals, sometimes ten layers of metals? So, let me
explain this question with the help of an example. So consider this case: we have, say,
two terminals, A1 and A2, and there are other terminals, B1 and B2.


Now, we want to connect B1 to B2 and A1 to A2, where these two are separate
connections. So we need to connect B1 to B2 and A1 to A2, but these connections should
not short. Also, we are given a constraint that we cannot move out of this bounding box,
square that we have shown. The connection cannot go out, and I give you another third
constraint that connections cannot move out of the plane of the screen or the paper that
we are showing. It has to remain in the same plane. Now, given all these constraints, can
we find a connection? The answer is no. In whatever way we make a connection, it will
always short. For example, if we connect B1 to B2 and A1 to A2, there is a short circuit
at this point; therefore, it is not a valid connection. So if we are constrained to remain in
one plane, and the area is also constrained so that we cannot go out of the given area, then
finding a feasible solution is very difficult, and in this case, it is impossible.


So what happens when the constraint of wires in the same plane is removed? If we say
that okay now, you can connect in different layers of metals or if these wires can drive in


different planes. Now, can we make the connection? The answer is yes. So, let us look
into how we can make a connection. So we can make a connection as shown in this figure.


So this is the top-level view, and these two are side views. So what this side view is that
we are looking in from this side, then we can see that A1 and A2 are connected in one
plane through this connection. Then, the connection between B1 and B2 is in a different
plane. So, if we take a view on this side from this side view, then we can see that B1 and
B2 are connected above this. If we remove the constraint that the connection should be in
the same plane, we can find a feasible solution.


So, what is this feasible solution? The feasible solution is that the connection starts from
A1, moves up, goes in one plane, and then goes down to A2. And from B1, what happens
is that it goes to some other level, to a different plane, makes a connection, and then runs
parallelly and then goes down to connect to B2. So these two connections are running in
two different planes, so they are not short. So what is this problem telling us, or what we
can infer from this example? We can infer that if we remove the constraint of making
wires in the same plane or allow the wire to run in different planes, then making
connections becomes easier in a given area, which is the primary motivation for making
integrated circuits in various layers. We have, say, ten layers of metal, and very
complicated connections can also be made by running in different planes. Therefore, the
structure of the integrated circuit is in the form of layers. Now, different layers of these
interconnections and devices are made using a technology known as photolithography.


Now, how these connections need to be made is defined by something that is known as
a mask, and using that mask and the photolithography technique, we can copy that
connection into multiple integrated circuits. So now let us look into what
photolithography is and how we can make patterns on the silicon wafer using
photolithography as we design. So, what is photolithography? Photolithography is a
process of transferring geometric shapes that are defined on a mask to the surface of the
silicon. Now, what is a mask? So, photolithography transfers features from the mask to
the silicon wafer. So, before going into the details of the photolithography step, let us
understand what this mask is and its use.


So, a mask is a transparent plate. It may be of, say, glass over which there are some
opaque regions. For example, this is the top-level view of a mask. So, this mask is made


of glass, which is a transparent material, and in this transparent material, we have opaque
regions. These opaque regions may be of deposited chromium, etc. So, we have some
patterns on the glass plate, some opaque regions, and some transparent regions.


These masks are also known as photomasks or reticles. And when we fabricate an
integrated circuit, what we do is that whatever the pattern is there on the mask, that is
where there is an opaque region and there is a transparent region, we want to get a similar
pattern on the wafer. And we get it using the process known as photolithography. Now,
as I described earlier, that integrated circuit consists of multiple layers of different types.
For each layer, as we design our circuit, we have different patterns, and we will have
different masks for each layer, and we transfer the pattern on the mask onto the wafer,
layer-wise. For each layer, we will have a mask, and on each mask, we will have the
pattern to be transferred to the integrated circuit, and we do that transfer of pattern using
this task known as photolithography.


So now, let us look into how photolithography is done. Suppose we have a substrate/a
silicon wafer, over which there is a deposited film. This deposited film may be silicon
dioxide, silicon nitride, or another kind of deposited film, and if we want to pattern this
deposited film, how can we proceed? So first, what we do is that on this deposited film,
we put photoresist. What is a photoresist? A photoresist is a chemical that is sensitive to
light, meaning that wherever the light falls on the photoresist, its property changes.


Now, photoresist is typically a liquid kind of thing. So what we do is that over the
deposited film, we drop photoresist, and then using spinning of the wafer, we make a
uniform coating of liquid photoresist over the wafer, and then we do a kind of baking
which solidifies this photoresist. So once we have applied a uniform layer of photoresist
over the deposited film, then what do we do? Then, we expose the photoresist to the light,
and we expose this photoresist to the light through the mask. Now remember that the
mask contains a pattern with an opaque region and a transparent region. So, in the region
where it is transparent, the light will go, and it will interact with the photoresist. The
property of the photoresist will change wherever there is a transparent region, and
wherever there is an opaque region, light will be blocked by the mask, and the property of
the photoresist will not change.


So, the pattern on the mask now gets transferred to the photoresist because the light has
fallen through the mask. That light has changed the property of the photoresist wherever
it has fallen, and wherever it has not, the property remains the same. This phase is known


as the exposure phase. Then, what we do is that we go to the next task, which is known as
development. We take the wafer and put it in a developer solution. The developer
solution is a solution that interacts with a photoresist that has been exposed to the light.
So the region where the light had fallen will react with this developer solution, and that
will be removed. So now, on the photoresist, we have a pattern of hollows and regions
where the photoresist remains intact, and that pattern is defined by the mask. So, after the
development stage, we have regions where the photoresist has been removed and regions
where the photoresist is as it is. Then, what we do is that we subject this wafer to a step,
which is known as etching. So, in etching, we expose the wafer to a special type of
chemical known as the etchant, which reacts with the deposited film but does not react
with the photoresist.


So with this type of chemical, the etchant, the deposited film will be removed from the
regions where the photoresist was removed. So, we will have a pattern here on the
deposited film, and wherever there is a photoresist, that region will resist the etching.
Therefore, after etching, we will have a pattern on the deposited film. And then what we
do is that we remove the photoresist, and we have the pattern that was on the mask. We
have got that pattern on the deposited film. That is what the task was of photolithography.
So, we got the pattern on the mask to the wafer.


Now, when we design our circuit, what we finally do is that we get a pattern that should
be on the mask, and once we have created this mask, we can do photolithography using
the same mask thousands of times, and therefore, we can copy the integrated circuit. So,
how the integrated circuit should behave is defined by the mask, and that we have done
once. Once we have the mask, we replicate that or copy that integrated circuit multiple
times by carrying out photolithography separately for each of the wafers. This is what I
mean by the art of copying integrated circuits; the crux of this is the photolithography
step. Now, let us look into some terminologies related to IC fabrication.


These terminologies will be used repeatedly in the course, so you should be familiar
with them. Now, what is a silicon wafer? So, the silicon wafer is a thin slice of silicon
that serves as a substrate for an integrated circuit. So this is the picture of a wafer.


Typically, it is 300 mm in diameter, and on this silicon wafer, we create an integrated
circuit. So this silicon wafer is a single crystal of silicon and this is a thin slice of silicon
of diameter typically 300 mm size. On this, we will be creating our integrated circuit. The
basic question comes: How do we get this monolithic or crystalline silicon wafer? We get
it using what is known as silicon ingots and what are silicon ingots? Silicon ingots are
massive cylindrical single crystal of silicon.


So this figure shows what is a silicon ingot. It is a massive cylinder of silicon, and it is
just a single crystal of silicon that is almost defect-free. There are significantly fewer
defects in this kind of silicon. Using these silicon ingots, we make silicon wafers, and
then the question comes: How do we get these silicon ingots? So we get these silicon
ingots using a process known as the CZ process in which what we do is that we have a
single crystal of silicon, which is dipped inside a molten silicon at 1425 degrees Celsius.
So there is a molten silicon which is at, say, 1425 degrees Celsius, and in that, we dipped
a crystal of single crystal or seed crystal of silicon and slowly pulled it up. When it is
slowly pulled up, silicon crystallizes around that seed crystal, and this massive cylindrical
form of silicon ingots is formed. So this is a very simplistic description of how silicon
ingots are made, it describes fairly well how silicon ingots can be prepared. But the
technology is far more complicated. Now, once we have the silicon ingots, which is a
perfect or nearly perfect single crystal of silicon, we slice out silicon wafer out of it and
get silicon wafer on which we make our circuit.


Now, once we have a silicon wafer, then on a single silicon wafer, we create multiple
integrated circuits, and it is not that only one integrated circuit is made on a single crystal
on a silicon wafer. So, we create multiple integrated circuits on the silicon wafer, and
these multiple integrated circuits are known as dies. So, the slices of a silicon wafer
containing the complete circuit are called dies. So this is a silicon wafer, and in this
silicon wafer, this is a small square, a blackened square shown here. This is a single die,
containing the complete circuit or complete integrated circuit.


So, the hundreds of rectangular-shaped integrated circuits are fabricated on a single
silicon wafer. So, when we do the fabrication on a silicon wafer. This is a silicon wafer.


This silicon wafer will have hundreds of squares, as shown in this figure, each of which is
a separate silicon die or die, and each die contains a self-contained circuit. Now, once
they are fabricated, these dies are sliced out from the silicon wafers after fabrication and
testing. One important point to note here is that when we fabricate many dies on a single
wafer of silicon, some of the dies may have defects. So, one of the important things in
manufacturing an integrated circuit is to consider the percentage of good dies, or defectfree dies among all the dies fabricated on the wafer.


So that percentage is known as yield, and typically, we try to make yield as high as
possible in a fabrication technology. So once we have fabricated the hundreds of dies on
a wafer, we test each die and then slice out these dies from the wafer. Now, each die will
contain millions of transistors depending on the functionality of the circuit or the
integrated circuit. Once we have sliced out these dies, the next step is packaging.


After the dies are sliced, they are encapsulated into a supporting case known as a
package. These packages are used for protection against physical and chemical damage.
So once these dies are sliced out from the wafer, they are encapsulated inside the package,
and once these are encapsulated and ready, we get a chip. So we get a chip that goes to
the market or gets integrated into a system and then goes to the end user.


To summarize, in the fabrication of an integrated circuit, we start with a silicon ingot,
the massive cylinder of a single crystal of silicon. From the silicon ingot, we slice out and
get silicon wafers. On a silicon wafer, we have hundreds of dies, each containing millions
of transistors. Each separate die contains a self-contained circuit, and then we take the die
and package it. And once we package this die, this goes to making the system or goes to
the market for sale, and then that entity is known as a chip.


You should understand the difference between wafer, die, chip, and silicon ingot. Now,
another thing that you should understand right at the outset of this course is the difference
between designing and fabrication. There are differences, but there are also relationships.
So, let us look into what are the differences between designing and fabrication. So what
is designing? Designing is determining the parameters and composition of a circuit that
can achieve the desired functionality.


So, in the designing step, we determine the parameters of the various components and
the entities. For example, when we are designing the layout, we are saying what would be
the size of the transistor, where they should be placed on the layout, how they should be
connected, etc. That is the design aspect, so designing means determining the parameters
of our circuit. So, the designing starts with the functionality, and the designing step ends
once we get the layout. We get the layout, meaning where the transistors are, how they
are connected, etc.


This layout basically contains all the information required to make different masks for
photolithography. So, the design step ends once we have made the layout, and a mask can
be fabricated or made out of it. Then, after the designing part comes the fabrication part.
And what is fabrication? Fabrication involves the actual creation of an integrated circuit


for a given design. So, in fabrication, we are not changing the circuit parameters given to
us.


We start with the given parameter and then produce the integrated circuit or physical
integrated circuit, typically in bulk. So, this part is copying of the integrated circuit. The
designing part decides the parameters of the circuit, and then the fabrication process
replicates it for millions of entities, and we get millions of products. Over the last 50
years, we have mastered this technique of fabricating integrated circuits, and therefore,
the cost of the integrated circuit has come down. So, the cost per transistor is several
orders of magnitude lower than it was 50 years ago.


Now, where do we fabricate or do the fabrication of integrated circuits? So, we do the
fabrication in semiconductor foundries. So, a semiconductor manufacturing plant where
the fabrication of integrated circuits is done is known as a semiconductor foundry. An
important point to understand is that the setting of these semiconductor foundries is very
expensive. It requires huge capital, for example, say 5 to 10 billion dollars, to set up one
fabrication plant; that is how expensive setting up a fabrication plant or foundry is. So
why is this cost so high? The cost is so high because we need a very controlled
environment for fabrication, basically known as a clean room, and we need lots of
sophisticated equipment to manufacture these transistors and the circuits at the nanoscale
dimensions.


Therefore, the investment required to set up a semiconductor foundry is high in billions
of dollars and added to that, there is another downside of the semiconductor foundries.
The downside is that a semiconductor foundry has a shelf life, meaning it gets outdated
after 5 to 10 years. Therefore, as an entrepreneur, if you want to set up a semiconductor
foundry, it means that you have to recover the cost of the investment in 5 to 10 billion
dollars in a limited span of time, say 5 to 10 years, and also as an entrepreneur, you will
want to make profit out of it. So, to make a profit in a limited time frame, we need this
foundry to run at maximum capacity or full potential most of the time. So, the
semiconductor foundry business is sustainable only when the facilities of foundries are
utilized close to their full potential. Because of this constraint, various forms of the
semiconductor ecosystem have evolved in the last 20-25 years. So let us look into these
ecosystems because when we go into designing you will be working in that ecosystem. If
you understand this ecosystem, you can appreciate how things are being designed,
manufactured, and so on.


Let's look into this semiconductor ecosystem very briefly. So, in the semiconductor
industry, a business model has developed known as fabless design companies. So, many
design companies are just doing designing; they are not doing fabrication. They are
outsourcing the fabrication to some other companies. For example, companies like
Qualcomm, NVIDIA, etc., only do designing and fabrication is outsourced. This business
model is very lucrative because these companies need not set up expensive fabs. They
need not make high investments; therefore, they do not require a huge amount of money
to set up and maintain costly foundries; therefore, this business model is sustainable.


There is another business model, which is of merchant foundries, which only do
fabrication. They do fabrication for different design houses, and as a result, they can draw
a lot of business from multiple entities. So, these are merchant foundries, for example,
TSMC, UMC, and Global Foundries. These are doing the fabrication for other companies,
for example, the fabless design companies, and since there are lots of fabless design
companies, business comes to merchant foundries regularly, and these merchant
foundries can run to the full potential, and therefore it can make profit in its foundry
business.


Another business model is integrated device manufacturers. So, in these companies,
what happens is that designing and fabrication are done in the same company, and they
become more efficient and cost-effective due to control over the entire design step and
fabrication step, and therefore, they can also succeed. So, examples of integrated device
manufacturers are Intel and Samsung.


Now we see that typically, what we do is that the designing part is segregated from the
fabrication part. However, are these two tasks independent? The answer is no because
while designing, we must finally know what the attributes of the transistor will be, for
example, delay because we need to take into consideration the properties or attributes of
the transistor during the design phase, and these properties are decided by how we
fabricate things. It will be different for different foundries, and therefore, designing and
fabrication, though we do it separately, they are not separate processes. They need to take
information from each other. So, the design and fabrication are related tasks, and to
maintain consistency between designing and fabrication, we must share information.


The foundry, depending on how it is fabricating the transistor, what material it is using,
what are the process parameters, etc., does some characterization, and they share what is
known as PDK or process design kit with the design team. So, the foundry shares the
PDK with the design team, and this PDK contains information on the attributes of the
transistor with the current, the given circuit condition, and so on. So, the properties of the
transistors and devices will be defined in this PDK. Also, there will be some rules that the
foundry enforces for the design, and those rules are encoded and kept inside this PDK. As
a designer, when we do designing, we must be aware of those design rules. While
designing our circuit, we must adhere to them or follow those rules. If we follow those
rules, the foundry will guarantee us that the yield of the manufacture of the integrated
circuit, meaning that the percentage of the circuit that will be good or defect-free, will be
such that this designing and making of the chip will become profitable. So, the
fabrication and the designing are separate processes, but to make them consistent, we
have some entities like the process design kit, where the foundry shares the information
with the design team.


The design team follows the information or adheres to the rules defined by the foundry
and makes the circuit. Then, the circuit goes to the foundry, and the foundry can fabricate
that circuit with a good yield, and this venture can be successful.


So, if you want to look into these topics more deeply, you can refer to textbooks
mentioned in the lecture slides. Now, to summarize this lecture, what we have done is
that we have taken a historical perspective of VLSI. We looked into the structure of VLSI,
and then we looked into a task known as photolithography and how photolithography can
be used to replicate the features on the mask to the wafer. Thus, this is the key step that
allows us to copy integrated circuits and make very complicated integrated circuits and
make it available to the consumer very cheaply. So, in the next lecture, we will be
looking into some more basic concepts related to integrated circuits. Thank you very
much.


