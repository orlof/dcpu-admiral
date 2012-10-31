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
   - Variable length integers
   - Prototype based inheritance
 - Language is based on Python syntax
 - Interactive command prompt
 - Integrated text editor for editing sources

<h4>NEXT IN PRODUCTION</h4>
 - Screen library
 - Floating point numbers
 - Trigonometric functions
 - Dict implementation with TST
 - Embedded assembler (editor + assembler)
 - 200-400% speed improvements
 - Support for more HW
                     
<h4>ON PLANNING BOARD</h4>
 - Threading

--

<h4>INSTALLATION</h4>

Admiral is currently distributed as DevKit project. Download it from Github and fire it up.
Quick test also showed that Lettuce can run Admiral, but Organic failed in the compilation.

All tested web emulators failed:

    set [a-1], 1 ; which definitely is a valid command

--
<h4>USAGE</h4>
When Admiral starts, it will show interactive prompt '>' and wait for your input. 
You can use it to evaluate any one line statements.

<pre>
&gt;5+5**2
30
&gt;for a in range(5): print a
0
1
2
3
4
</pre>

To facilitate software development in deep space fringe colonies Admiral has a
built-in text editor. It is available by calling "result=edit('code here')"-function. 
Editor can take string argument that it will initially render for editing. 

You can exit the editor be pressing CTRL (press AND release) followed by x. 
(NOTE: Admiral parser requires that all functions must end with line feed)

<pre>
&gt;f=edit()
'print arg1
'
&gt;f(arg1='Hello World!')
Hello World!
</pre>

Since Admiral is pure interpreter all strings all callable:
<pre>
&gt;'print arg1'(arg1='Hello World again!')
Hello World again!
</pre>

<h4>BUILT-IN STATEMENTS</h4>

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

<h4>EXAMPLES</h4>

Simple expressions:
<pre>
>5+5
10
</pre>


Example: 'ex' reference
<pre>
>a=1
1
>f=edit()
'print a, ex.a
'
>f(a=2)
2,1
</pre>

Example: 'me' reference
<pre>
>a=3
3
>obj={}
{}
>obj.a=2
2
>obj.f=edit()
'print a, me.a, ex.a
'
>obj.f(a=1)
1,2,3
</pre>

Example: '?=' conditional assignment
<pre>
>f=edit()
'a?=1
b?=2
print a, b
'
>f(a=10)
10, 2
</pre>

Example: ':=' prototype
<pre>
>car={}
{}
>car.spd=0
0
>car.accelerate=edit()
'me.spd+=me.acceleration
'
>vw:=car
...
>vw.acceleration=8
8
>vw.accelerate()
>vw.spd
8
>car.spd
0
</pre>


