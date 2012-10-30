ADMIRAL programming language for DCPU-16
========================================
INTERPRETED LANGUAGE IMPLEMENTATION FOR DCPU-16

FEATURES
========
 - Pure interpreted language
 - Based on Python syntax
 - Interactive command prompt
 - Text editor for editing sources (exit with CTRL (release) c - always prepend last line with empty line!)
 - Javascript like prototype inheritance
 - Variable length integers

INSTALLATION
============

Just create empty solution/project to Devkit and copy/paste the admiral.10c file to it. It should work. If you can ran this in some other emulator - let me know.

FUTURE
======
Lot of plans for exceptions, threading, floating point numbers, embedded assembler...
Speed and size optimizations (est. 300-500% speed improvements in the future)

However - code size will not exceed 20k to leave room for data.

Examples
========
```
>5+5
10
>a=5+5*6
35
>c={}
{}
>c.f=edit()
'me.sum?=0
me.sum+=1
'
>d:=c
...
>d.sum=10
10
>d.f()

```


=, +=, -=, *=, /=, %=, **=, >>=, <<=, &=, ^=, %= 	Assignments, augmented assignments 	Binary 	Right
, 	comma 	Binary 	Left
or 	Boolean OR 	Binary 	Left
and 	Boolean AND 	Binary 	Left 	
not x 	Boolean NOT 	Unary 	- 	
in, not in 	membership tests 	Binary 	Left 	
is, is not 	identity tests 	Binary 	Left 	
<, <=, >, >=, <>, !=, == 	Comparisons 	Binary 	Left 	
| 	Bitwise OR 	Binary 	Left 	
^ 	Bitwise XOR 	Binary 	Left 	
& 	Bitwise AND 	Binary 	Left 	
«, » 	Shifts 	Binary 	Left 	
+, - 	Addition and subtraction 	Binary 	Left 	
*, /, % 	Multiplication, division, remainder 	Binary 	Left 	
+x, -x 	Positive, negative 	Unary 	- 	
~x 	Bitwise NOT 	Unary 	- 	
** 	Exponentiation 	Binary 	Right 	
x[index] 	Subscription 	Binary 	Left 	
x[index:index] 	Slicing 	Binary 	Left 	
x(arguments…) 	Call 	Binary 	Left 	
x.attribute 	Attribute reference 	Binary 	Left 	
(expressions…) 	Binding or tuple display 	Unary 	- 	
[expressions…] 	List display 	Unary 	- 	
{key:datum…} 	Dictionary display 	Unary 	- 	