---

<h1>ADMIRAL programming language for DCPU-16</h1>
<h5><i>"PURE INTERPRETED LANGUAGE FOR THE FRINGE COLONIES"</i></h5>

---

<h4>DESIGN PRINCIPLES</h4>

 - DCPU must not be only a runtime, but it must also be the development platform 
 - Memory: 20kw for the system, 30kw for heap and 10kw for stack

--

<h4>FEATURES</h4>
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
 - Pratt’s algorithm for efficient expression parsing
 - Mark and sweep garbage collector for memory conservation and detecting trash even with reference loops
 
<h4>NEXT IN PRODUCTION</h4>
 - Disk support
   - Low level api and serialization
 - Improved error reporting
 - Example code
 - Misc built-in functions
 - BETA RELEASE

<h4>LATER PLANS</h4>
 - 200-400% speed improvements
 - Support for 3D
 - Command line editor
 - Screen library
 - More built-in functions
 - Exception handling
 - Trigonometric functions
 - Dict implementation with TST
 - Embedded assembler (editor + assembler)

<h4>EXAMPLES</h4>

Classic Hello World in Admiral:

<pre>
>output='print text'
'print text'
>output(text='Hello World')
Hello World
</pre>

Square Root that supports both integers and floats:

<pre>
>sqrt=edit()
'p=0
x=$0
while not x==p:
 p=x
 x=(x**2+$0)/(2*x)
return x
'
>sqrt(81.0)
9.00000000
>sqrt(81)
9
</pre>

--

<h4>INSTALLATION</h4>

https://github.com/orlof/dcpu-admiral

To build from source, run the following with the DCPU Toolchain (DCPUTeam/DCPUToolchain)

    dtasm --binary admiral.dasm16 -o admiral.bin
    
You can run the .bin provided, or the one you built as normal in Lettuce (SirCmpwn/Tomato), and with the following command with the Toolchain

    dtemu admiral.bin

You can also run Admiral in Devkit. Leave the admiral.dasm16 out of the project and specify interpreter.dasm16 as 
the starting point for execution.

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

To exit the editor press CTRL (press AND release) followed by x. If you want to discard your editing, use CTRL and c.

If you later need to edit your text, it can be done by specifying string argument:

    result=edit(result)

Since Admiral is pure interpreter all strings are callable i.e. functions:

<pre>
>'print arg1'(arg1='Hello World again!') 
Hello World again!
</pre>

Function scope can be seed by specifying variables in function call. Unnamed variables are automatically named 
as $0, $1, $2 etc.

Function can also define default values by using conditional assignment operator '?=':

<pre>
>next_number=edit()
'
$0 ?= 0
return $0 + 1
'
>next_number()
1
>next_number(next_number())
2
</pre>

Conditional assignment takes place only if left operand is without value in current scope.

Dicts and prototype assignment operator can provice "poor mans" objects :-)
<pre>
>ship={} 
{} 
>ship.spd=0 
0 
>ship.accelerate=edit() 
'me.spd+=me.acceleration 
' 
>shuttle:=ship 
... 
>shuttle.acceleration=8 
8 
>shuttle.accelerate() 
>shuttle.spd 8 
>ship.spd 0
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

<h6>del</h6>
<pre>
del_stmt ::=  "del" target_list
</pre>

TODO

<h6>cls</h6>
<pre>
cls_stmt ::=  "cls"
</pre>

TODO

<h6>reset</h6>
<pre>
reset_stmt ::=  "reset"
</pre>

TODO

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
to which if clause a following else clause would belong.

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

The while statement is used for repeated execution as long as an expression is true:

<pre>
while_stmt ::=  "while" expression ":" suite
</pre>

This repeatedly tests the expression and, if it is true, executes the suite; if the expression 
is false (which may be the first time it is tested) the loop terminates.

A break statement executed in the suite terminates the loop. A continue statement executed in the suite
skips the rest of the suite and goes back to testing the expression.

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
 - Assignment right side is alway evaluated before left side
 - Slicing is not supported as assignment left side
 - Boolean operators both sides are always evaluated
 - INDENT and DEDENT must be exactly one space

SOME EXTRA BITS

Positional function call parameters:

Typically you call functions by specifying the variables that you want initially to be added to the function scope.

<pre>
function_name(creature='Monster", size='XXXL')
</pre>

All nameless variables are autonamed as "$0", "$1", "$2"... in left to right order

<pre>
function_name('Monster", size='XXXL', 'angry')
</pre>
 
Would produce variables
<pre>
$0='Monster'
size='XXXL'
$1='angry'
</pre>

PRINT STATEMENT

print statement can take multiple expressions separated with comma.

<pre>
>print "This", "is", "good"
This is good
</pre>

Concatenating prints with comma is much faster than using "+".

<pre>
>print "This" + " " + "is" + " " + "BAD!"
This is BAD!
</pre>

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

Admiral has two special assigment operators: conditional assignment "?=" and prototype assignment ":=".

Conditional assignment only assigns if left side is NOT defined in the current scope. This feature is only ment for specifying default values for variables in funtions.

Prototype assignment provides "poor mans" inheritance. Right side must be a dict. Left side is assigned a new dict with prototype member set (prototype members key is underscore-string). Whenever key is accessed it is first searched from dict itself, if it is not found, search is propagated to prototype dict. Assignment never changes the value in prototype.

...clear?

BLOCK STATEMENTS

There is three block statements: if, for and while.

<pre>
if a==1: print "Yeah"
elif a=2: print "Close..."
else: print "Naah"

or

if a==1:
 print "Yeah"
elif a==":
 print "Close..."
else:
 print "Naah"
</pre>

while or for doesn't support "else" - I think that is just Python's trash.

Remember that INDENT and DEDENT must always be a single space.
...and block statements have their own scope. Maybe I should remove it?

OTHER PYTHON FEATURES MISSING

No lambda, yield, try, exception, generators, classes or function definitions.


