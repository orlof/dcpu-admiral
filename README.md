---

<h1>ADMIRAL programming language for DCPU-16</h1>
<h5><i>"PURE INTERPRETED LANGUAGE FOR THE FRINGE COLONIES"</i></h5>

---

<h4>Summary</h4>

<h6>Design Philosophy</h6>
 - DCPU must provide a self sufficient environment for developing and running software
 - Capability is more important than capacity 
 - Users shouldn't be bothered with details that the machine can handle
 - A bug in the user’s Admiral-code should not be allowed to lead to undefined behavior 
   of the interpreter
 - Should there be no limit on the range of numbers, the length of strings, or the size 
   of collections (other than the total memory available)

<h6>Implementation Principles</h6>
 - "First make it work. Then make it right. Then make it fast."
 - Memory allocation targets:
   - 40960 words for heap
   - 8 192 words for stack
   - 16 384 words for admiral core (including static memory buffers)
 - Memory is conserved by using direct one-pass interpreter
 - Pratt’s algorithm for efficient expression parsing
 - Mark and sweep garbage collector for memory conservation and detecting trash even with reference loops
 - Floppy load/save uses object graph serialization e.g. save("big.obj", big_obj) and big_obj = load("big.obj")

<h6>Examples</h6>

Classic Hello World in Admiral.

<pre>
>print 'Hello World'
Hello World
</pre>

..or as a function call:

<pre>
>output='print text'          # assign string to variable
'print text'                  # interpreter returns assigned value
>output(text='Hello World')   # call output-string as function
Hello World                   # function output
</pre>

Square Root that supports both integers and floats:

<pre>
>sqrt=edit()                  # start integrated editor
'p=0                          # define variable
x=$0                          # assign first unnamed function argument to x
while not x==p:               # loop to calculate sqrt
 p=x
 x=(x**2+$0)/(2*x)
return x                      # return value
'
>sqrt(81.0)                   # function call with float argument
9.00000000
>sqrt(81)                     # function call with integer argument
9
</pre>

Couple of other code examples:
<pre>
# variable swap
>a=1
>b=2
>a,b=b,a
(2,1)
</pre>

--

<h4>Development status</h4>

<h6>Current features</h6>
 - Pure interpreted language
   - Python inspired grammar
   - Garbage collection
   - Dynamic typing
   - Prototype based inheritance
   - Data types
     - Variable length integers (only limited by available heap space)
     - Floats with compile time precision selection (1+ words for mantissa)
     - Booleans, strings, lists, tuples and dicts
 - Interactive command prompt
 - Integrated code editor with gap buffer
 - Object serialization for floppy
 
<h6>Next in development</h6>
 - Improved error reporting
 - Example code
 - Misc built-in functions
 - BETA RELEASE (est. 1/2013)

<h6>Later plans</h6>
 - 200-400% speed improvements
   - different concepts (code/algo optimization, number cache)
 - Support for 3D
 - Command line editor
 - Screen library
 - More built-in functions
 - Exception handling
 - Trigonometric functions
 - Dict implementation with TST
 - Embedded assembler (editor + assembler)

--

<h4>INSTALLATION</h4>

https://github.com/orlof/dcpu-admiral

To build from source, run the following with the DCPU Toolchain (DCPUTeam/DCPUToolchain)

    dtasm --binary admiral.dasm16 -o admiral.bin
    
You can run the .bin provided with the following command with the Toolchain:

    dtemu admiral.bin

You can also run admiral.bin with Lettuce (SirCmpwn/Tomato) (keyboard layouts are not working with Lettuce).

To work with devkit, leave the admiral.dasm16 out of the project and specify interpreter.dasm16 as 
the starting point for execution. Devkit 1.7.6 is badly broken and it's current state cannot run Admiral. 
Previous Devkit version 1.7.5 can compile and run Admiral, but does not support floppy.

<h4>USAGE</h4>

When Admiral starts, it will show an interactive prompt '>' and wait for input. It can evaluate one line statements.
<pre>
>1+2**32 
4294967297 
>for a in range(5): print a 
0 
1 
2 
3 
4
</pre>

Admiral also has a built-in text editor to facilitate software development in deep space colonies. It is 
started by calling:

    result=edit()

To exit the editor press CTRL (press AND release) followed by x. If you want to discard your editing, use CTRL followed by c.

If you later need to edit your text, it can be done by specifying a string argument for edit():

    result=edit(result)

Since Admiral is pure interpreter all strings are callable (i.e. can be used as functions):

<pre>
>'print arg1'(arg1='Hello World again!') 
Hello World again!
</pre>

Function scope can be seed by specifying variables in function call. Unnamed variables are automatically named 
as $0, $1, $2 etc.

<pre>
get_danger_level(type='Monster", 'XXXL', 'hungry')
</pre>
 
Would produce variables
<pre>
type='Monster'
$0='XXXL'
$1='hungry'
</pre>

Function can also define default values by using conditional assignment operator '?=':

<pre>
>next_number=edit()
'$0 ?= 0                      # set value for autonamed variable if value is not defined in function call
return $0 + 1
'
>next_number()
1
>next_number(next_number())
2
</pre>

Conditional assignment takes place only if left operand is without value in current scope.

Dicts and prototype assignment operator provide "poor mans" objects :-)
<pre>
>ship={}                  # create prototype object (i.e. dict)
{} 
>ship.spd=0               # assign value to prototype
0 
>ship.accelerate=edit()   # define function in prototype
'me.spd+=me.acceleration  # function modifies object field
' 
>shuttle:=ship            # create new object from prototype
...                       # new object "inherits" prototype's fields
>shuttle.acceleration=8   # set value in new object
8 
>shuttle.accelerate()     # call new object's method (that is defined in prototype)
>shuttle.spd 8            # new objects field has changed...
>ship.spd 0               # and prototype's fields are intact
</pre>

<h4>STATEMENTS</h4>

Here is a complete list of all te Admiral statements.

<h5>SIMPLE STATEMENTS</h5>

Simple statements are comprised within a single line.

<h6>pass</h6>
<pre>
pass_stmt ::=  "pass"
</pre>

pass is a null operation — when it is executed, nothing happens. It is useful as a placeholder when 
a statement is required syntactically, but no code needs to be executed, for example:

<pre>
while not getchar()=='y': pass
</pre>

<h6>return</h6>
<pre>
return_stmt ::=  "return" [expression]
</pre>

return may only occur in a function. If an expression is present, it is evaluated, else None is substituted.
return leaves the current function call with the expression (or None) as return value.

<h6>break</h6>
<pre>
break_stmt ::=  "break"
</pre>

break may only occur syntactically nested in a for or while loop. break terminates the nearest enclosing loop.

<h6>continue</h6>
<pre>
continue_stmt ::=  "continue"
</pre>

continue may only occur syntactically nested in a for or while loop. It continues with the next cycle of 
the nearest enclosing loop.

<h6>print</h6>
<pre>
print_stmt ::=  "print" [expression ("," expression)* ]
</pre>

print evaluates each expression in turn and writes the resulting object to LEM screen. If an object is not 
a string, it is first converted to a string using the rules for string conversions. A space is written 
between each object.

Concatenating prints with comma is much faster than using "+".

<pre>
>print "This", "is", "good"
This is good
>print "This" + " " + "is" + " " + "BAD!"
This is BAD!
</pre>

<h6>del</h6>
<pre>
del_stmt ::=  "del" target_list
</pre>

TODO

<h6>cls</h6>
<pre>
cls_stmt ::=  "cls"
</pre>

cls (for clear screen) is a command used by the command line interpreter to clear the LEM1802 
screen and restore cursor to top left -corner position.

<h6>reset</h6>
<pre>
reset_stmt ::=  "reset"
</pre>

routine that resets the Admiral interpreter and peripheral devices (as if it were turned off and then 
on again). This command retains the data that is stored into global scope!

<h5>COMPOUND STATEMENTS</h5>

Compound statements contain other statements; they affect or control the execution of those other 
statements in some way. In general, compound statements span multiple lines, although in simple 
incarnations a whole compound statement may be contained in one line.

The if, while and for statements implement traditional control flow constructs.

Compound statements consist of one or more ‘clauses.’ A clause consists of a header and a ‘suite.’ 
Each clause header begins with a uniquely identifying keyword and ends with a colon. A suite is a group 
of statements controlled by a clause. A suite can be one simple statements on the same line as the header, 
following the header’s colon, or it can be one or more indented statements on subsequent lines. Only
the latter form of suite can contain nested compound statements, mostly because it wouldn’t be clear 
to which if clause else clause would belong.

All compound statements are executed in a block scope. Compound statements can use the enclosing scope
(i.e. read and assign values to variables that are alrady defined in the enclosing scope) but all variables
that are defined in the compound statement are discarded when control exits the compound statement's block scope. 

NOTE: To help fitting source code into LEM 32x12 screen, INDENT and DEDENT MUST always BE a SINGLE SPACE!

<h6>if</h6>

The if statement is used for conditional execution:

<pre>
if_stmt ::=  "if" expression ":" suite
             ( "elif" expression ":" suite )*
             ["else" ":" suite]
</pre>

It selects exactly one of the suites by evaluating the expressions one by one until one is found to be 
true (see section Boolean operations for the definition of true and false); then that suite is executed
(and no other part of the if statement is executed or evaluated). If all expressions are false, the 
suite of the else clause, if present, is executed.

<h6>while</h6>

The while statement is used for repeated execution as long as an expression is true:

<pre>
while_stmt ::=  "while" expression ":" suite
</pre>

This repeatedly tests the expression and, if it is true, executes the suite; if the expression 
is false (which may be the first time it is tested) the loop terminates.

A break statement executed in the suite terminates the loop. A continue statement executed in the suite
skips the rest of the suite and goes back to testing the expression.

<h6>for</h6>

The for statement is used to iterate over the elements of a string, tuple, list or dict.

<pre>
for_stmt ::=  "for" target_list "in" expression_list ":" suite
</pre>

The expression list is evaluated once. The suite is then executed once for each item provided by the 
expression list in the order of ascending indices. Each item in turn is assigned to the target list 
using the standard rules for assignments, and then the suite is executed. When the items are exhausted 
the loop terminates.

A break statement executed in the suite terminates the loop. A continue statement executed in the suite
skips the rest of the suite and continues with the next item, or terminates if there was no next item.

The suite may assign to the variable(s) in the target list; this does not affect the next item assigned to it.

Hint: the built-in function range() returns a sequence of integers suitable to emulate the effect of Pascal’s 
for i := a to b do; e.g., range(3) returns the list [0, 1, 2].

<h4>BUILT-IN FUNCTIONS</h4>
<pre>
TYPE CONVERSION FUNCTIONS
  bool bool(bool | int | float | str)
  int int(bool | int | float | str)
  float float(bool | int | float | str)
  str str(bool | int | float | str)

GENERIC FUNTIONS
  int id(list | tuple | dict | int | bool | str | float)
  int len(list | tuple | dict | str | int)
  int mem()

FLOPPY FUNTIONS
    void format()
      {} dir()
    void save(string filename, object root)
  object load(string filename)
    void rm(string filename)

NUMERICAL FUNCTIONS
  int abs(int)
  float abs(float)
  int cmp(item, item)
  float rnd([float[, float]])    start inclusive, end exclusive in all rnd functions, negative values are not allowed
  int rnd([int[, int]])          start inclusive, end exclusive in all rnd functions, negative values are not allowed

CHARACTER FUNCTIONS
  int ord(str)
  str chr(int)
  str input([str])
  str edit([str])
  str repr(list | tuple | dict | int | bool | str | float)
  str sort(str)

CONTAINER FUNCTIONS
  list sort(list sort)             list is sorted 'in place'! return value is only for convenience.
  list range(int end)
  list range(int start, int end[, int step])
  {} locals()
  {} globals()
</pre>

<h4>EXPRESSION PRECEDENCE TABLE</h4>
<table cellpadding="1">
<tr><th>OPERATOR</th><th>DESCRIPTION</th><th>ASSOCIATIVITY</th></tr>
<tr><td>=, +=, -=, *=, /=, %=, **=, &gt;&gt;=, &lt;&lt;=, &=, ^=, %=, ?=, :=</td><td>Assignment, augmented assignments, conditional assignment, prototype</td><td>Right</td></tr>
<tr><td>,</td><td>Comma</td><td>Left</td></tr>
<tr><td>or</td><td>Boolean OR</td><td>Left</td></tr>
<tr><td>and</td><td>Boolean AND</td><td>Left</td></tr>
<tr><td>not x</td><td>Boolean NOT (unary)</td><td>-</td></tr>
<tr><td>in, not in</td><td>Membership test</td><td>Left</td></tr>
<tr><td>is, is not</td><td>Identity tests</td><td>Left</td></tr>
<tr><td>&lt;, &lt;=, &gt;, &gt;=, &lt;&gt;, !=, ==</td><td>Comparisons</td><td>Left</td></tr>
<tr><td>|</td><td>Bitwise OR</td><td>Left</td></tr>
<tr><td>^</td><td>Bitwise XOR</td><td>Left</td></tr>
<tr><td>&</td><td>Bitwise AND</td><td>Left</td></tr>
<tr><td>&lt;&lt;, &gt;&gt;</td><td>Shifts</td><td>Left</td></tr>
<tr><td>+, -</td><td>Addition and subtraction</td><td>Left</td></tr>
<tr><td>*, /, %</td><td>Multiplication, division, remainder</td><td>Left</td></tr>
<tr><td>+x, -x</td><td>Positive, negative (unary)</td><td>-</td></tr>
<tr><td>~x</td><td>Bitwise NOT</td><td>-</td></tr>
<tr><td>**</td><td>Exponentiation</td><td>Right</td></tr>
<tr><td>x[index]</td><td>Subscription</td><td>Left</td></tr>
<tr><td>x[start:end]</td><td>Slicing</td><td>Left</td></tr>
<tr><td>x(arguments...)</td><td>Call</td><td>Left</td></tr>
<tr><td>x.attribute</td><td>Reference</td><td>Left</td></tr>
<tr><td>(expression...)</td><td>Binding or tuple display (unary)</td><td>-</td></tr>
<tr><td>[expressions...]</td><td>List display (unary)</td><td>-</td></tr>
<tr><td>{key:datum...}</td><td>Dictionary display (unary)</td><td>-</td></tr>
</table>

NOTES
 - Assignment is an expression, not statement
   - yelds the assigned value
   - e.g. "a = (b += 1)" is a valid command 
 - Assignment right side is alway evaluated before left side
   - e.g. "for n in range(3): a += b += 1"
     - round 1: a=1, b=1
     - round 2: a=3, b=2
     - round 3: a=6, b=3
 - Slicing is not supported as assignment left side
   - e.g. "a[1:2] = 1,2" is NOT working!
 - Boolean operators both sides are always evaluated
   - e.g. "if true or (a+=1):" will increment a with every evaluation
 - INDENT and DEDENT must be exactly one space

SOME EXTRA BITS

ASSIGNMENTS

Admiral currently allows augmented assignments to be chained. I will remove that feature if someone can explain to me why it shouldn't be allowed.

<pre>
>a = b = 0
>a += b += 1
1
>a += b += 1
3
</pre>

Currently Admiral does not support assigning to slices: 
i.e. a[1:3]=(1,2,3) is not working. 
If that REALLY is a language feature that anyone would use, I will consider adding it :-)

PYTHON FEATURES MISSING (INCOMPLETE LIST)

No lambda, yield, try, exception, generators, classes or function definitions.


