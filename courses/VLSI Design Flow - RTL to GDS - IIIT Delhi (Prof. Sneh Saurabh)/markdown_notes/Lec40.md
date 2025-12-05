**VLSI Design Flow: RTL to GDS**


**Dr. Sneh Saurabh**


**Department of Electronics and Communication Engineering**

**IIIT-Delhi**


**Lecture 40**
**Scan Design Flow**


Hello everybody, welcome to the course wheel side design flow RTL to GDS. This is
the 32nd lecture. In this lecture, we will be discussing scan design flow. Specifically in
this lecture, we will be discussing the design modifications that are required to
implement scan design flow, the mechanism of testing during scan design flow and the
tasks that are required to be done to implement scan design flow. Now first let us look
into the design modifications that are needed to implement scan design flow. So in this
circuit, we are showing a schematic of the original circuit.


So this is the original net list or original design and this original design is basically
being transformed to another design in which the scan design flow is implemented.


So what are the changes required to be made in this new design or new circuit. So there
are three major modifications that need to be done over the original circuit. The first
modification is to add extra ports.


So we add an extra port that is TM or test mode, the scan enable or SE and the scan in
and scan out. So these four extra ports are added to the design. And then what is the
second modification? The second modification is to change or replace all the D flip flops
that are in our design with a scan cell. So what are the scan cells we will see? So we
replace D flip flops in our design with another kind of memory element which are known
as scan cells.


And then we connect these scan cells in such a way that a shift register is formed. A
shift register from the input port to the output port is formed using these scan cells. Once
we connect and make this a shift register, this shift register is also known as a scan chain.
So because this is a chain of scan cells and therefore it is known as a scan chain. Now
what do we gain out of these modifications? Why do we do these modifications? So
these changes dramatically improve the controllability and observability of memory
elements that are flip flops in a sequential circuit. So in the last lecture we had seen that
to apply test patterns at the internal components of our design and observe the effect of
the fault from the internal elements to the output port, we need to make our circuit
controllable and observable.


And this problem is much more complicated for a sequential circuit in which we need
where the state elements are involved and we need to traverse the states in the FSM to
reach to apply some test pattern or to observe the responses. So for those for the
sequential circuit doing this kind of modification improves the controllability and
observability drastically and how does it improve? We will see in the subsequent slides.
Now these are three major changes or modifications that are done in a design to
implement scan design flow. First to add the port, the second replacement of the D flip
flops with the scan cells and then connecting them to form the scan chains. So now we
will look into all these three modifications in more detail.


Now a scan design works in different modes and what are these different modes? So
there are three modes. The first one is the normal mode. Normal mode meaning that we
are doing the normal operation of our circuit. It is delivering the required functionality.
If we consider that there was an original net list which was delivering some functionality.


So the normal mode will deliver the same functionality. So the normal functional mode
of our chip is the normal mode. Then in addition to normal mode we have a shift mode
and in shift mode what happens is that memory elements work as shift registers. So by
making changes in our design we have transformed or replaced all the cells, all the
memory elements with scan cells and then made a shift register or scan chain of using
these scan cells. Now in the shift mode these memory elements or these scan cells work
as shift registers and using these shift registers we are able to shift the required test
pattern into our circuit and also using this shift register we can detect we can read the
value of any internal net in our circuit at the output.


So when the circuit goes into a scan mode then what happens is that the flip flops or the
scan cells that are connected in the form of shift register and using this shift register will
be transferring in the test pattern at the internal nets of our design and also reading the
values of the internal nets at the output. And the third mode is the capture mode. Now
what is the capture mode? In capture mode the response of the fabricated circuit is
captured during testing. It is so capture mode is effective only in the test mode while we
are doing a testing of our circuit. So when that circuit is we are doing a fabric we are
testing our circuit after doing manufacturing and during that testing phase we were or
during the testing of our chip where if we want to read the response of the fabricated
circuit for the nets and internals and the signals in our design then we take our circuit to
the capture mode.


Now these three modes of our circuit can be defined with the help of the values at the
input. Now what are these values? So if the circuit is operating in normal mode that is


we are carrying out the chip is out of the of the environment of testing that means it is
applied this is working in our system where it should be or it is in the field at that time
whenever the chip is delivering the normal function at that time we make test mode as 0
we make the signal test mode or test mode as 0. So it implies that our circuit is not being
tested, it is delivering the normal functionality. When we want to test that is in the
manufacturing environment when we have fabricated or die and we are trying to test our
IC whether it is working or not working properly or not then in that case we take test
mode to 1 we make the signal test mode is equal to 1 meaning that now we are testing
our chip and in the test mode there in the while we are testing there are two modes the
first one is shift mode and the other is the capture mode. In the shift mode what we do is
that we make this input port scan enable SE as 1 and in the capture mode we make scan
enable as 0 .


So with the help of these input ports TM and SE we are able to define three different
modes of our circuit and these modes will be useful while we are doing the testing in a
scan design flow. Now what are scan cells? We said that we replace each flip flop in our
design or D flip flop in our design with scan cells. Now what are these scan cells? So
there can be many different kinds of implementation of the scan cells. One of the most
popular is merged D scan cells. So let us look into the internal details of our internal
implementation of a merged D scan cell. In the merged D scan cell we will have a
multiplexer we will have a multiplexer 2 to 1 multiplexer and it will basically have extra
pins so what are these extra pins so the first the D pin the clock pin and the Q pin are
similar to our traditional D flip flop .


So you have a D flip flop in which we have say clock pin we have D pin and we have Q
pin . So these three pins are similar so this is the figure of the merged D scan cell so in
this merged D scan cell these three pins are similar to the D flip flop. However it has got
extra pins SI and SE. So SI stands for scan input and SE stands for scan enable . Now
what is the functionality of this scan cell? So the multiplexer basically selects data
between D and the SI using the scan enable scan enable pin .


So now what happens is that if scan enable is equal to 0 scan enable is equal to 0 then
this path will be active and this flip flop will latch whatever was there at the D input . So
basically when scan enable is equal to 0 this scan cell is working as a normal flip flop
whatever is at the D it will be getting captured when the positive clock edge appears at
the clock that is that will appear at the Q . And in the meantime when we make scan
enable as 1 when we make scan enable is as 1 so in that case what happened the value
not from D but from SI pin that will be actually going to D and that will be getting last .
So the value at SI input will be last. So the output pin the Q pin here will produce the
content of the D flip flop .


So the next state whenever the clock edge comes the flip flop the scan cell goes into the
next state and the next state will be either the value of D or the value at the SI input.
When will the value of D be captured when SE or the scan enable is equal to 0 and when
will the value at SI be captured when the scan enable is equal to 1. Now how do we form
the form scan chain in our design ok. So let us take an example, suppose we have our
design like this and in which there are say 3 flip flops F1, F2 and F3 . Now we want to
make modifications in our circuit to allow it to do the testing or scan or we want to
implement scan design flow in this circuit.


So what circuit modifications will be doing ok. So this is the modified one . So this is


the original circuit and this is the modified one . Now what modifications we have done.
The first thing we should note is that we have replaced all the D flip flops with scan cells
.


So F1 is now a scan cell, it is not a D flip flop . It is a scan cell and scan cell. These are
the circuit chains. The first circuit chain is that all the deep flip flops have been replaced
by scan cells . And then the Q pin of the scan cell and the D pin sorry and the and the D
pin of the scan cell and the clock pin of the scan cell those connections are not changed
those are made as original. So the one that is the nets for which the correct original
connection is preserved are shown by this dashed line.


So these are dashed lines for all these nets no changes have been made in the modified
net list or modified circuit. So if we see the D pin of the scan cell it is as connected to the
previous case. Similarly the D pin of this scan cell and the D pin similarly if we consider
the clock pins those connections are not changed those are the same as it was earlier .
However, for the Q pin also the original connections are preserved but some extra
connections are made. What are those extra connections we will just see?


Now the SI pin of the first scan cell is connected to the SI port. Now we have also
added extra ports SI and SE. SI is scan input and SE is scan enabled . Now from the
scan input port that we created we take a net or wire and connect it to the SI input pin of
the scan cell. So the SI pin of the first scan cell is connected to the SI port. This
connection is made ok.


Then what is then the QSO pin of one cell is connected to the SI pin of the next cell to
form a chain. So the Q pin of this Q pin of this scan cell is connected to the next S scan
input pin of the next cell. So this connection is made extra from here to here to here.
Then again from this flip this scan cell the Q pin is taken out and it goes to the scan in
the scan pin of the next flip flop on the scan cell . And finally what happens the last one
so in this case there were only three flip flops so there are only three three disconnects
the connections from a Q to SI of them.


So to the S O SI pin of the next flip flop and so on. If there were say 10 flip flops in our
design so we would have connected first to the second second to the third third to the
fourth and so on and would have formed a chain formed a chain of 10 flip flops or 10
scan cells . So here there are only three so we have in the chain we have only three three
three three flip scan cells . Finally what we do is that the one which is at the last from
there we take the connection from the Q pin and take it and make it to the S O port . So
now after we have made this change or to make the connection a scan chain now there is
a path from SI that is scan input to the first scan cell and then to the second scan cell


then to the third scan cell and finally from scan cell to the output.


So from the scan input to scan output we have a J shift register . Now when will this
shift register be active when we make the scan enabled is equal to 1 . So what we do is
that we connect all the scan enable pins of the scan cells so this is the scan enable pin of
the first second and third we connect all of them to the scan enable port that we have
created. Now whenever this scan enabled port is equal to 1 then whatever we put the
value at the SI port that will be captured by the next flip flop and the next flip flop and so
on in different clock cycles. So as the new clock cycles called clock edges come the data
from the input SI port were transferred to the scan chain all the way up to the SO port .


So we form a scan chain consisting of N cells in this case there are only 3 therefore
there are 3 cells in the scan chain . Any test vector can be shifted in from the SI port in
the N clock cycle . Suppose for example the initial value of all these flip flops were 0 let
us assume that the Q was 0 0 0. Now if we want to make all of them as 1 1 1 how many
clock cycles we will require. So we will apply a sequence of 1 1 1 at the scan input and
make it equal to 1 and allow the clock to trigger all these flip flops .


So in the first clock cycle this will get 1 in the next clock cycle this one will go to the
next flip flop and the other other one will come to this and in the third clock cycle this
one will go to the next flip flop this one will go to this flip flop or scan cell and then final
final one will come here . So in the 3 clock cycle we will be getting any test vector we
want at this at the output of these scan cells . So any test response can be shifted out to
SO port in the N clock cycle. As we have shifted the input pattern into our circuit
similarly, whatever the response that will be received at the D pin can be transferred to
the SO port in maximum N clock cycle . So without a scan cell chain it could have taken
an exponential number of cycles .


For example suppose this these flip flops were part of a counter if this flip flops were
part of the counter and if the initial state was 0 0 0 and wanted we wanted to get 1 1 1
then how many clock cycles would have required 2 to the power in that case we would
have required 2 to the power 3 or around 8 clock cycles . So instead of an exponential
number of clock cycles what we will be requiring will be the linear number of or number
of clock cycles will be related to the number of scan cells linearly related to the number
of scan cells in the scan chain. So in this case there are 3 cells in the scan chain so in
maximum 3 clock cycle will be getting getting any value at the at this scans at the at the
at the D a queue of pin of this scan cell and also will be able to read any value at the D
pin at in in 3 clock cycle maximum . So this is how we scan by making a scan chain in
our design, how we simplify the writing of test vectors into our internal nets of our
design and reading the value from the internal nets of our design. Now after we have


done scan cell insertion in our design the pins of the flip flops meaning the D pins and
the Q pins have become easily controllable and observable from the primary input
meaning the primary input in this case S I input port and the scan enable .


Now once we we we have done the scan cell insertion we can treat the Q pin as pseudo
primary inputs why we can treat the Q pin as pseudo primary input the we can treat them
as pseudo primary input because if we want to write any value at the Q pin or we want to
get any value at the Q pin for example 0 or 1 at this at this point we can do that we can
obtain that with the help of the scan input port we apply proper proper value appropriate
value as scan input port make a scan enable as 1 and allow the clock to propagate and we
will obtain 0 or 1 at this point . So, in effect these Q pins which can be used to deliver
any it can be used to deliver any value 0 or 1 to the combination of circuit elements in its
fan out and therefore we treat the Q pin of the scan cell as pseudo primary input after
scan cell insertion. Similarly if whatever the value that is obtained at the D pin that can
be propagated to the output port S O in linear number of clock cycles and therefore the D
pin can be similar acts similar to the pseudo primary output because D is the D pin can
be considered as an observability point we it can be directly observable and whatever
the value is observed at D pin that can be propagated through the scan chain up to the
scan output port and the value at the D pin can be easily observed and therefore we can
treat D pin as pseudo primary output for our pseudo primary output for our sequential
circuit after scan cell insertion. So, how does this scan cell design ease the testing? So, it
effectively transforms the problem of sequential circuit testing to combinational circuit
testing. So, after we have done sequential after we have done scan cell insertion we we
can assume that whatever the value we want we will get at the Q pin because those are P
P P pseudo primary inputs and whatever the value is at the D pin of the flip scan cell we
can easily observe at the output and therefore there are pseudo those are pseudo primary
inputs.


So, now we need to only worry about the combinational circuit elements between this
between these scan cells and therefore the scan design as a scan insertion or
transforming or making transformations for scan design flow it effectively transforms the
problem of sequential circuit testing to combinational circuit testing and the automatic
test pattern generation the ATPG ATPG problem effectively changes from sequential to
combinational . Now with the ATPG tool or the automatic test pattern generation tool
they need to just worry about what patterns will be required to test the combinational
circuit element in the design because the combinational circuit element will either be
driven by the input port or the scan cells. So, that is the and the and the scan in the scan
cells the output will be obtained from the Q pin and Q pins are pseudo primary inputs
meaning that we can apply any pattern at the Q pin with the help of the scan chain and
therefore the testing becomes very easy or the testing problem very becomes very easy


and the test pro and generation of the test pattern for the for the ATPG tool becomes
much easy because of scan cell insertion. Now what is the mechanism of how we
proceed in doing testing for a scan inserted design. So, at the time of testing, say we have
manufactured or died, we want to do the testing now of what should be done during
testing for a design in which we have made the changes as described earlier .


So, first what we do is that we go into shift mode . So, we studied or we discussed that
when to go into the shift mode we make scan enable is equal to 1 . So, we make the scan
enable 1 shift in the desired test pattern using ports S I to the scan cells F 1 F 2 F 3 . For
example, now we will shift in the required test vector for example, if you want to say 1 0
1 whatever. So, we will apply 1 0 1 here at the scan input and then allow it to propagate
through the scan scan scan chain and then we will get these values at the Q pins of the
scan cell.


Now then we apply the required test pattern at the input port also . Now I suppose we
want to test this AND gate . So, suppose we wanted to have a test pattern of 1 1 to test
this AND gate. So, for that we will need to make Q equal to 1 and also C is equal to 1 .
So, that is why we said that we apply the required test pattern at the input port port also .


So, we shift the value at the at shift the required test pattern to through the scan input to
the scan cells in our design and also we apply the appropriate values at the other input
ports. So, in this case A B C D E and once we have done that then all the required test


pattern is loaded into our design . Now once we have meaning that we have applied the
test vector that we needed to apply in our design . Then what we do is that we go into the
capture mode . Now in the capture mode we set scan enable to 0 for 1 clock cycle we
make scan enable is equal to 0.


Now what happens in that case is that suppose there was a stuck at fault stuck at 0 at this
point stuck at 0 at this point and we had loaded 1 1 pattern at this point or we had applied
this pattern during the shift mode . Now we want that the correct value or the correct
value for this AND gate is that its output should produce 1. Now for a faulty circuit if
there was a stuck at 0 fault at this output pin then instead of 1 we will get 0 and that 0
will come where at the D pin . Now for 1 clock cycle when we make the scan enable is
equal to 0 then remember that we had in the scan cell we had a multiplexer . We had a
multiplexer and if scan enable was equal to 0 then whatever was D that was being
captured by the flip flop and that appeared at Q .


So, when we make scan enable equal to 0 scan enable is equal to 0 the D value that is 0
will be read and that will appear at Q . And then what we do is that if there was a fault
for which the test vector was applied is cancel will now capture the result of the fault and
receive the faulted output . So, in this case the faulted output is 0 instead of 1. That was
correct, there was a stuck at 0 fault at the AND gate. So, the Q pin will have a value of
will have a value of 0 and then what we do is that we again go to the shift mode and
then switch back to the shift mode and make this scan enable is equal to 1 scan enable is
equal to 1. Now when we do that, what happens is that this 0 goes through the scan cells
or and through the scan chain and it will appear at the output port S O in maximum n
clock cycle where n is the length of the scans .


So, we switch back to the shift mode the shift the so shift out the captured result to the
S O port. So, whatever was captured by the D pin at that or what was captured is during
the capture mode that will appear at the S O port after a delay of a maximum n clock
cycle and we can read the values that we are obtaining at S O port. If we get instead of 1
we get 0 we can infer that there was a stuck at 0 fault at the input at the AND gate . So,
this is how we can detect the fault and the result is compared with the expected response
and if they mismatch we infer that there is a manufacturing defect or there is a fault.


So, when we are doing this shift mode . So, we started with shift mode . We went to the
capture mode then when we were doing the shift mode we also applied the next test
pattern. Suppose in the first test pattern was 1 1 1 1 1 1 and the next pattern was say 1 0
1. So, now we will apply 1 0 1. So, while we are shifting out the computed result through
the scan chain we are also passing in the next test vector . So, the sequence of shift
capture shift capture shift capture will be repeated as many times as there are a number of


test patterns. For example, if there are a third thousand test pattern then this has to be
repeated thousand times and if for any test pattern there is a fault and we observe a
different value at SO as than what we are expecting we infer that our chip is bad and then
we do not shift that or take that chip to the next stage .


Now, what task do we need to perform in scan design flow? So, first we need to prepare
our design . So, we need to pick a so that the design becomes testable . Now while even
writing the RTL we should be very very careful whether our design is testable or not . So,
there are tools available which help us understand that if there are any issues in the RTL
or in our design which will create problems later in the implementation of the scan
design flow then those tools will flag violations and then we need to fix those violations.
For example, suppose we have a circuit and there is an FSM there is an internal FSM
and it is generating a say reset signal and this asynchronous reset is going to our flip
flop .


This asynchronous reset is going to our flip flop and we have actually converted this flip
flop to scan cell . Now if we have done that and during the testing during this testing this
reset signal gets asserted somehow then the scan cell scan chain will be broken and our
scan design methodology will fail and therefore we while while implementing scan
design methodology we should be careful that the the internally generated reset should
be de-asserted during the scan mode or during the shift mode . So these are just an
example of one of the guidelines. There are other guidelines which are the which needs
to be which needs to be taken care of while designing or while making our design or
implementing our scan design methodology in our design. So these things must be taken
care of during the earlier stages of our design implementation while writing the RTL and
so on . Now or later on when we have the net list we do scan synthesis .


So in scan synthesis design becomes scan design. So we are inserting your features or
making design modifications to implement the scan design methodology . So in this first
thing we need to do is to define scan configuration meaning how many scan chains we
want in our design. So if we keep one very long scan chain in our design then it may take
a long run time a long time to test and load the pattern and therefore we can partition
these scan chains into smaller scan chains and how many such a scan chain will we want
in our design that we can give give give as a parameter to the tool that is implementing
the the the scan synthesis as a configuration parameter . Then we need to say which scan
cells need to be picked from the library. So these scan cells are designed and they are
actually modeled and kept in the technology libraries.


Now in a technology library there may be say 10 different types of scan cells. Now we
may not want to use only a few types of scan cells, then we need to give instruction to


the tool which scan cells we need to use in our design. And then we can exclude certain
elements from being converted to the scan cells. For example if there is a register or flip
flop which is in a critical path and we do not want to to change it or transfer or replace it
with a scan cell then we can tell the tool that okay for this particular cell do not do scan
result replacement . So those kinds of configuration needs to be defined while in doing
scan synthesis or or doing scan cell insertion .


And then during synthesis we need to replace these flip flops with the scan cells that we
have already seen . And then there are some tasks related to scan design flow which need
to be done in physical design and these are scan reordering and stitching. So what are
these tasks we will be discussing when we will be discussing physical design? Now and
during this scan after we have done physical design and we have reordered our scan cell
then we can do test vector generation or to generate the test patterns that will be used to
test our chip. And we also do some verification for or we carry out some verification
tasks to ensure the sanity of our scan chain, the timing verification and other things.


For example once we do scan cell insertion then there are very many or there is a shift
register kind of structure . You have a Q pin of one scan cell and it is going to the SI pin
of the next scan cell and there are no circuit elements between them . And if the data
path is very very small then we have studied during the STA that there can be a hold
violation . So we have to verify timing and be careful of the hold violation. So these
types of checking or hold violation checks are typically done after we have done say
clock tree insertion because once we get the clock tree then we have a fair idea of hold
violations .


And we also do some sanity checking of the scan chains using logic simulators to see
whether we are getting whatever the value we are applying at the scan input port,
whether it is being propagated properly and so on. And we also need to ensure using say
combinational equivalence checking that after scan cell insertion whether our design is
functionally equivalent to the earlier original design in the functional mode or in the
normal mode . If there was some problem in the scan cell insertion then those problems
will be called . So we carry out combinational equivalence checking to make sure that
the functionality of our chip has not broken. Now we have seen that there are lots of
advantages of scan design flow in improving the testability of our design.


But what are the costs involved in this? So the first cost is related to the area overhead.
The area overhead will be because of the larger scan cells and also the routing resources
required for routing say scan enable signal and then making the scan chains and so on .
And then there are costs involved related to the extra input and output ports that we
create for implementing scan design flow. And then there is a degradation that can be


degradation in timing in a scan design flow. Why can there be degradation in timing? It
can happen because there is an extra multiplexer within the scan cell .


So if we see the scan cell there is an extra multiplexer and the output of the multiplexer
goes to the deep end of the internal flip-flop . So if we consider the data path in the data
path when scan enable is equal to 0 in that case that in the data path we have extra
multiplexer and that will add to the delay on the data path. And therefore the maximum
crop frequency at which our circuit can operate can come down. And then there is
significant effort or design effort to implement scan design flow . Now these are some of
the important costs that we must be considering while implementing scan design
methodology.


Now despite this cost the scan design methodology is quite popular for industrial
designs because it improves the testability of our design significantly. Now if you want
to go deeper into the topics that we have discussed you can refer to this book. And just to
summarize what we have done in or what we have covered in this lecture we have
looked into that what design changes we need to make to implement scan design flow
and what is the mechanics of scan design testing and what are the design tasks that we
must we need to carry out to implement scan design flow. So in the next lecture we will
be looking at how we can generate the test patterns to test our chips. Thank you very
much. .


