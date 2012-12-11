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
   - Garbage collection
   - Variable length integers, booleans, strings, lists, tuples and dicts
   - Prototype based inheritance
 - Grammar is based on Python grammar
 - Interactive command prompt
 - Integrated code editor for

<h4>NEXT IN PRODUCTION</h4>
 - Screen library
 - Exception handling (error handling is now poor)
 - More built-in functions
 - Floating point numbers
 - Trigonometric functions
 - Dict implementation with TST
 - Embedded assembler (editor + assembler)
 - 200-400% speed improvements
 - Support for more HW

--

<h4>INSTALLATION</h4>

https://github.com/orlof/dcpu-admiral

To build from source, run the following with the DCPU Toolchain (DCPUTeam/DCPUToolchain)

    dtasm --binary admiral.dasm16 -o admiral.bin
    
or this with Organic (SirCmpwn/Organic) (you have to use long literals at the moment, as Organic is very slow at optimising at the moment)

    organic admiral.dasm16 admiral.bin --long-literals

You can run the .bin provided, or the one you built as normal in Lettuce (SirCmpwn/Tomato), and with the following command with the Toolchain

    dtemu admiral.bin

<h4>USAGE</h4>

When Admiral starts, it will show interactive prompt '>' and wait for input. It can evaluate one line statements.
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
started by calling result=edit('code here')"-function. Editor can take a string argument that will be 
rendered for editing.

You can exit the editor be pressing CTRL (press AND release) followed by x. (NOTE: Admiral parser 
requires that all functions must end with line feed)
<pre>
>f=edit() 
'print arg1 
' 
>f(arg1='Hello World!') 
Hello World!
</pre>


Since Admiral is pure interpreter all strings are callable:
<pre>
>'print arg1'(arg1='Hello World again!') 
Hello World again!
</pre>


Dicts and prototypes provice "poor mans" objects :-)
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

<pre>
if &lt;expr&gt;: &lt;stmt&gt;
[elif &lt;expr&gt;: &lt;stmt&gt;]
[else: &lt;stmt&gt;]

if &lt;expr&gt;:
 &lt;stmts&gt;
[elif &lt;expr&gt;:
 &lt;stmts&gt;]
[else:
 &lt;stmts&gt;]

while &lt;expr&gt;: &lt;stmt&gt;

while &lt;expr&gt;:
 &lt;stmts&gt;

for &lt;id_list&gt; in &lt;expr&gt;: &lt;stmt&gt;

for &lt;id_list&gt; in &lt;expr&gt;:
 &lt;stmts&gt;

break
continue
return [expr]
pass
del &lt;id&gt;
print &lt;expr&gt;
cls
reset
</pre>

<h4>BUILT-IN FUNCTIONS</h4>
<pre>
int id(<id>)
int int(item)
str str(item)
int len(item)
int abs(int)
int ord(str)
str chr(int)
int cmp(item, item)
bool bool(item)
str edit([str])
str repr(item)
[] range(int start, int end, int step)
str input(str prompt)
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


