
---

<h1>ADMIRAL programming language for DCPU-16</h1>
<h6><i>"PURE INTERPRETED LANGUAGE FOR THE FRINGE COLONIES"</i></h6>

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

<h6>NEXT IN PRODUCTION</h6>
 - Screen library
 - Floating point numbers
 - Trigonometric functions
 - Dict implementation with TST
 - Embedded assembler (editor + assembler)
 - 200-400% speed improvements
 - Support for more HW
                     
<h6>ON PLANNING BOARD</h6>
 - Threading

--

<h4>INSTALLATION</h4>

Admiral is currently distributed as DevKit project. Download it from Github and fire it up.
Quick test also showed that Lettuce can run it, but for unknown reason Organic failed in the compilation.

All tested web emulators failed:

    set [a-1], 1 ; which definitely is a valid command

--

<h4>USER GUIDE</h4>

<h6>PRECEDENCE TABLE</h6>
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

<h6>EXAMPLES</h6>

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
'me.spd+=acceleration
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


