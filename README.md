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
   of the interpreter (except poke() and call())
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
 - Floppy load/save uses object graph serialization e.g. 
   - save("big.obj", big_obj)
   - big_obj = load("big.obj")

<h6>Examples</h6>

Classic Hello World in Admiral.

<pre>
>print 'Hello World'
Hello World
</pre>

..or as a function call:

<pre>
>output='print text'          # assign string to variable
>output(text='Hello World')   # call 'output' as function
Hello World                   # function output
</pre>

In Admiral - ANY and ALL strings can be called as functions! You could even write:

<pre>
>'print text'(text='Hello World')   # crazy way to call constant string as function
Hello World                         # function output
</pre>

Here is another example of Admiral code. A function that calculates square Root for integers and floats:

<pre>
>sqrt=edit()                  # start integrated editor
'p=0                          # define variable
x=argv[0]                     # assign first unnamed function argument to x
while not x==p:               # loop to calculate sqrt
 p=x
 x=(x**2+argv[0])/(2*x)
return x                      # return value
'
>sqrt(81.0)                   # function call with float argument
9.00000000
>sqrt(81)                     # function call with integer argument
9
</pre>

Couple of more examples:
<pre>
# python's variable swap
>a=1
>b=2
>a,b=b,a
# dictionary printing
>d={'a':1,'b':2}
>for k,v in d: print k, v
a 1
b 2
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
 - Integrated code editor with gap buffer
 - Object serialization for floppy
 - Dict implementation with binary search
 - Nice starting set of built-in functions
 - Interactive command prompt with line editing
 - Functions: poke(), peek() and call() for low level access
 - Functions: hwn(), hwq() and hwi() for low level hardware access
 
<h6>Next in development</h6>
 - Github issue tracker contains a list of development items, but development is not currently active.

--

<h4>Special Thanks</h4>

Following sources were proven to be invaluable sources for information:
 - Let's Build a Compiler, by Jack Crenshaw: http://compilers.iecc.com/crenshaw/
 - Top Down Operator Precedence, by Douglas Crockford: http://javascript.crockford.com/tdop/tdop.html
 - Simple Top-Down Parsing in Python, by Fredrik Lundh: http://effbot.org/zone/simple-top-down-parsing.html
 - The Art of Assembly Language Programming, by Randall Hyde: http://cs.smith.edu/~thiebaut/ArtOfAssembly/artofasm.html
 - Data Structures and Algorithms with Object-Oriented Design Patterns in Java, by Bruno R. Preiss: http://www.brpreiss.com/books/opus5/html/book.html

--

<h4>INSTALLATION</h4>

<h5>Usage</h5>

Easies way to try Admiral is with Admiral-emulator:

    https://github.com/orlof/admiral-emu/releases

<h5>Development</h5>

All source code is available in Github:

    https://github.com/orlof/dcpu-admiral

Latest stable release is in /beta_release -directory. If you just want to run the binary, 
you should download admiral.bin and m35fd.bin if you want to use toolchain floppy. 
    
Currently toolchain is the preferred assembler-emulator package. It has no known issues.
    
    http://dcputoolcha.in/

Run Admiral with Toolchain dtemu

    dtemu admiral.bin

Compile Admiral with Toolchain dtasm:

    dtasm --binary admiral.dasm16 -o admiral.bin

<h5>Other tools</h5>
    
Organic + Lettuce

Organic assembler can also compile Admiral:

    organic.exe admiral.dasm16 admiral.bin

Beware, Organic compilation without --long-literals option takes about 15 minutes.

You can run admiral.bin with Lettuce (SirCmpwn/Tomato), but international (non-US?) keyboard layouts don't work with
Lettuce.

F1DE

F1DE (http://fasm.elasticbeanstalk.com/) is currently the only web emulator that has been tested with Admiral. 
Admiral sources do not compile in F1DE without modifications, as F1DE requires non-Notchian label and define
syntax.

To use F1DE you should download admiral_dat.dasm16 and use it to run Admiral.

NOTE: You may need to split admiral_dat.dasm16 file in two to get F1DE accept it.

<h4>USAGE</h4>

NOTE: Latest Admiral interpreter does not output return value automatically to screen. Instead 'print' statement 
must be used.

When Admiral starts, it will show an interactive prompt '>' and wait for input. It can evaluate one line statements.
<pre>
>print 1+2**32
4294967297 
>for a in range(5): print a 
0 
1 
2 
3 
4
</pre>

Admiral also has a built-in text editor to facilitate software development in deep space colonies. It is 
started by calling edit(). edit() returns the edited text as string that can be assigned to a variable.
To exit the editor type CTRL (press AND release) followed by x. If you want to discard your editing, 
use CTRL followed by c, which will return the original string instead of the edited version.

    result=edit()

If you need to edit an existing text, you can give a string argument for edit():

    result=edit(result)

Since Admiral is pure interpreter all strings are callable (i.e. can be used as functions):

<pre>
>'print "Hello World"'()
Hello World
>'print msg'(msg='Hello World again!') 
Hello World again!
</pre>

Function calls can have positional and keyword arguments in any order:
<pre>
# keywords: type='Monster', size='XXXL'
get_danger_level(type='Monster", size='XXXL')

# positional: argv[0]='Monster', argv[1]='XXXL'
get_danger_level('Monster', 'XXXL')

# mixed: type='Monster', argv[0]='XXXL'
get_danger_level(type='Monster', 'XXXL')
</pre>

Positional arguments are automatically assigned to argv[] array from left to right order.

You can set default value for keyword argument with the following line:

<pre>
if "type" not in locals(): type='Gigalosaurus'
</pre>

Dicts and prototype assignment operator provide "poor mans" objects :-)
<pre>
>ship={}                  # create prototype object (i.e. dict)
>ship.spd=0               # assign value to prototype
>ship.accelerate=edit()   # define function in prototype
--------------------------
me.spd+=me.acceleration  # function modifies object field
-------------------------- 
>shuttle=ship.create()    # create new object from prototype
>shuttle.acceleration=8   # set value in new object
>shuttle.accelerate()     # call new object's method (that is defined in prototype)
>print shuttle.spd
8                         # new objects field has changed...
>print ship.spd 
0                         # and prototype's fields are intact
</pre>

Admiral has three different types of built-in functionalities:  statements, global functions 
and class functions. E.g. print and run are stetements, len() and mem() are global functions, 
and str.encrypt() is a class functions.

Admiral programmer can write global functions and dict class functions. New statements or
functions to other class types cannot be added. Global functions are variables that have 
string value and class functions can be defined for dicts by adding function with str key.

<pre>
# global function example
>a="print argv[0]"
>a("Hello")
Hello

# class fuction example
>a={}
>a.x="print argv[0]"
>a.x("Hello")
Hello
</pre>

<h4>DATA TYPES</h4>

Admiral provides some built-in data types i.e. dict, list, tuple, str, int, float and boolean.

<h5>NUMBERS</h5>

The Admiral interpreter acts as a simple calculator: you can type 'print' and an expression at it and it 
will write the value. Expression syntax is straightforward: the operators +, -, * and / work just like 
in most other languages (for example, Pascal or C); parentheses can be used for grouping. For example:

<pre>
>print 2+2
4
># This is a comment
>print 2+2 # and a comment on the same line as code
4
>print (50-5*6)/4
5
># Integer division returns the number closer to 0:
>print 7/3
2
>print 7/-3
-2
</pre>

The equal sign ('=') is used to assign a value to a variable.
<pre>
>width=20
>height=5*9
>width*height
</pre>

Admiral treats an assignment as both an expression and as a statement. As an expression, its 
value is the value assigned to the variable. This is done to allow multiple assignments in a 
single statement, such as 
<pre>
>x=y=z=0  # Zero x, y and z
>print x,y,z
0 0 0
</pre>

Variables must be “defined” (assigned a value) before they can be used, or an error will occur:
<pre>
>n  # try to access an undefined variable
ERROR:2846
n
 ^
</pre>

Error codes are not yet documented and will change in every release.

There is full support for floating point; operators with mixed type operands convert the integer operand 
to floating point:

<pre>
>print 3 * 3.75 / 1.5
7.5
>print 7.0 / 2
3.5
</pre>

Floating point precision can be set during compilation time in defs.dasm16 file:
<pre>
#define FLOAT_MANTISSA_WORDS 2
</pre>

Recommended values are in range 1-4. NOTE currently only value 2 has been tested.

<h5>STR</h5>

Besides numbers, Admiral can also manipulate strings, which can be expressed in several ways. They can be 
enclosed in single quotes or double quotes:

<pre>
>'spam eggs'
>"doesn't"
>'"Yes," he said.'
</pre>

repr() function generates strings in single quotes. 

String literals cannot span multiple lines.

The str class can be used to handle 16-bit binary data and DCPU 7-bit text. Some str functions such as 
replace or split will not work with binary data. (That will be addressed in later releases)

Strings can be concatenated (glued together) with the + operator, and repeated with *:
<pre>
>word = 'Help' + 'A'
>print word
HelpA
>print '*' + word*5 + '*'
*HelpAHelpAHelpAHelpAHelpA*
</pre>

Strings can be subscripted (indexed); like in C, the first character of a string has subscript (index) 0. 
There is no separate character type; a character is simply a string of size one. Like in Python, substrings can 
be specified with the slice notation: two indices separated by a colon.

<pre>
>print word[4]
A
>print word[0:2]
He
>print word[2:4]
lp
</pre>

Slice indices have useful defaults; an omitted first index defaults to zero, an omitted second index defaults 
to the size of the string being sliced.
<pre>
>print word[:2]    # The first two characters
He
>print word[2:]    # Everything except the first two characters
lpA
</pre>

Unlike a C string, Admiral strings cannot be changed. Assigning to an indexed position in the string results 
in an error.

However, creating a new string with the combined content is easy:
<pre>
>print 'x' + word[1:]
xelpA
>print 'Splat' + word[4]
SplatA
</pre>

Here’s a useful invariant of slice operations: s[:i] + s[i:] equals s.
<pre>
>print word[:2] + word[2:]
HelpA
>print word[:3] + word[3:]
HelpA
</pre>

Degenerate slice indices are handled gracefully: an index that is too large is replaced by the string size, 
an upper bound smaller than the lower bound returns an empty string.

<pre>
>print word[1:100]
elpA
>print repr(word[10:])
''
>print repr(word[2:1])
''
</pre>

Indices may be negative numbers, to start counting from the right. For example:
<pre>
>print word[-1]     # The last character
A
>print word[-2]     # The last-but-one character
p
>print word[-2:]    # The last two characters
pA
>print word[:-2]    # Everything except the last two characters
Hel
</pre>

But note that -0 is really the same as 0, so it does not count from the right!

Out-of-range negative slice indices are truncated, but don’t try this for single-element (non-slice) indices:

The built-in function len() returns the length of a string:
<pre>
>s = 'supercalifragilisticexpialidocious'
>len(s)
34
</pre>

Current strings do not support escape characters or output formatting. That will be fixed to future releases.

<h5>DICT</h5>

TODO

<h5>LIST</h5>

TODO

<h5>TUPLE</h5>

TODO

<h5>BOOLEAN</h5>

TODO

<h5>NONE</h5>

TODO

<h4>STATEMENTS</h4>

Here is a complete list of all the Admiral's statements.

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
print_stmt ::=  "print" [expression ([","] expression)* ]
</pre>

print evaluates each expression in turn and writes the resulting object to LEM screen. If an object is not 
a string, it is first converted to a string using the rules for string conversions. A space is written 
between each object separated by comma. You can also leave out the comma, but then items are written without 
separator.

e.g.
<pre>
>print "Hello", "World"
Hello World
>print "Hello" "World"
HelloWorld
>name="Orlof"
'Orlof'
>print "My name is " name "."
My name is Orlof.
</pre>

Usage of plus operator to concatenate string in print statement is not recommended as it is much slower 
than using comma or implicit concatenation.

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

Deletion removes the binding of that name from the local or global namespace. If the name is unbound, 
an error will be raised.

Deletion of attribute reference removes the attribute from the primary object involved

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

FLOPPY FUNCTIONS
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
  str getc()                     blocking get next typed key 
  int key()                      non-blocking which key is down
  bool key(int)                  non-blocking is key down
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

HARDWARE FUNCTIONS (CAN CRASH ADMIRAL AND DCPU)
  void call([int address])
  int peek(int address)
  str peek(int address, int length)
  void poke(int address, (int|str) value)
  int hwn()
  int hardware_id, int hardware_version, int manufacturer = hwq(int n)
  void hwi(int n)
</pre>

<h5>TYPE CONVERSION FUNCTIONS</h5>

<h6>bool(x)</h6>
Convert a value to a Boolean, using the standard truth testing procedure.

The following values are interpreted as false: false, numeric zero of all types, 
and empty strings and containers (including tuples, lists and dictionaries). All 
other values are interpreted as true.

<h6>int(x)</h6>
Convert a number or string x to an integer. If x is a number, it can be a boolean, 
a plain integer, or a floating point number. If x is floating point, the conversion 
truncates towards zero.

<h6>float(x)</h6>
Convert a string or a number to floating point. If the argument is a string, it must 
contain a possibly signed decimal or floating point number. The argument may also be 
[+|-]nan or [+|-]inf. Otherwise, the argument may be a plain integer or a floating 
point number, and a floating point number with the same value is returned.

<h6>str(x)</h6>
Return a string containing an object representation of an object. For strings, this 
returns the string itself.

<h5>GENERIC FUNCTIONS</h5>

<h6>id(object)</h6>
Return the “identity” of an object. This is an integer which is guaranteed to be unique and constant for this object during its lifetime. Two objects with non-overlapping lifetimes may have the same id() value.

<h6>len(S)</h6>
Return the length (the number of items) of an object. The argument may be a sequence (string, tuple or list) or a mapping (dictionary).

<h6>mem()</h6>
Runs the garbage collector and returns the amount of free heap space in words.

Calling the gc method makes Admiral expend effort to recycling unused objects in order to make the memory they currently occupy available for quick reuse. When control returns from the method call, the Admiral has made a best effort to reclaim space from all discarded objects.

<h6>globals()</h6>
Return a dictionary representing the current global symbol table.

<h6>locals()</h6>
Return a dictionary representing the current local symbol table.

<h5>FLOPPY FUNCTIONS</h5>

<h6>format()</h6>
Format is used to initialize a DCPU M35FD floppy for use. It erases all information off the floppy.

<h6>dir()</h6>
The dir command returns a dictionary containing the available files in DCPU M35FD floppy.

<h6>load(filename)</h6>
The load command returns the object stored in DCPU M35FD floppy with the given filename.

<h6>save(filename, object)</h6>
The save command serializes the defined with given filename to DCPU M35FD floppy.

<h6>rm(filename)</h6>
Removes serialized object with given filename from DCPU M35FD floppy and frees the reserved disk space.

<h5>NUMERICAL FUNCTIONS</h5>

<h6>abs(x)</h6>
Return the absolute value of a number. The argument may be a plain integer or a floating point number.

<h6>rnd([[start, ]end])</h6>
Return the next pseudorandom number. TODO

<h6>cmp(x, y)</h6>
Compare the two objects x and y and return an integer according to the outcome. The return value is negative if x < y, zero if x == y and strictly positive if x > y.

 - Numbers are compared arithmetically.
 - Strings are compared lexicographically using the numeric equivalents (the result of the built-in function ord()) of their characters.
 - Tuples and lists are compared lexicographically using comparison of corresponding elements. This means that to compare equal, each element must compare equal and the two sequences must be of the same type and have the same length.
 - If not equal, the sequences are ordered the same as their first differing elements. For example, cmp([1,2,x], [1,2,y]) returns the same as cmp(x,y). If the corresponding element does not exist, the shorter sequence is ordered first (for example, [1,2] < [1,2,3]).
 - Other objects of built-in types compare unequal unless they are the same object; the choice whether one object is considered smaller or larger than another one is made arbitrarily but consistently within one execution of a program.

<h6>range(stop) or range(start, stop[, step])</h6>
This is a versatile function to create lists containing arithmetic progressions. It is most often used in for loops. 
The arguments must be plain integers. If the step argument is omitted, it defaults to 1. If the start argument is 
omitted, it defaults to 0. The full form returns a list of plain integers [start, start + step, start + 2 * step, ...]. 
If step is positive, the last element is the largest start + i * step less than stop; if step is negative, the last 
element is the smallest start + i * step greater than stop. step must not be zero.

<h5>CHARACTER FUNCTIONS</h5>

<h6>ord(c)</h6>
Given a string of length one, return the value of the byte. For example, ord('a') returns the integer 97. This is the
inverse of chr().

<h6>chr(i)</h6>
Return a string of one character whose ASCII code is the integer i. For example, chr(97) returns the string 'a'. This is the inverse of ord().

<h6>getc()</h6>
Blocks until user types a key and return the key typed as a string of one character.

<h6>key([i])</h6>
Without argument return immediately the next key typed from keyboard buffer, or 0 if the buffer is empty. If i is
specified return true if the specified key is down or false otherwise.

<h6>input([prompt])</h6>
If the prompt argument is present, it is written to standard output without a trailing newline. The function 
then reads a line from input, converts it to a string (stripping a trailing newline), and returns that.

<h6>edit([input])</h6>
Function opens a text editor. If the input argument is present, editor is initialized with input string.
Editor can be used to modify the contents. Editing can be canceled by typing (press and release) CTRL followed
by typing 'c', or confirmed by typing CTRL and 'x'. The function then converts editor contents (confirm) or the
original input string (cancel) to a string, and returns that.

<h6>repr(object)</h6>
Return a string containing a printable representation of an object. This is similar to str funtion, but surrounds
string type values in quotes.

<h6>sort(iterable[, reverse])</h6>
Return a sorted version from the items in iterable. 

Strings and tuples are sorted by creating a new sorted iterable and lists are sorted in place.

Reverse is a boolean value. If set to True, then the list elements are sorted as if each comparison were reversed.

<h5>HARDWARE FUNCTIONS</h5>

<h6>void call([int address])</h6>
Hands the CPU over to a the machine language subroutine at a specific address. If address is not specified then 
start of the floppy drive buffer is used as a default. Floppy drive buffer provides 512 words of space that is
used only when Admiral executes floppy commands. Floppy commands will overwrite the buffer area completely.

Given address should be in the range 0 thru 65535, or $0000 thru $FFFF. If the given address is outside these 
limits, Admiral will use LSW as address.

Parameters can be passed between Admiral and subroutine via registers. Before calling the specified address 
Admiral “loads” a, b, c, x, y, z, i and j registers with the words stored at addresses 0xdb78 - 0xdb7f.

If or when the routine at the specified address returns control to Admiral (via an RTS instruction), Admiral 
immediately saves the contents of the registers back into the 0xdb78 - 0xdb7f memory range: This can be used 
to transfer results from the machine language routine to Admiral for further processing. 
  
<pre>
a: 0xdb78
b: 0xdb79
c: 0xdb7a
x: 0xdb7b
y: 0xdb7c
z: 0xdb7d
i: 0xdb7e
j: 0xdb7f
</pre>

Subroutine can pollute registers a-j, but must return with rts.

<h6>int peek(int address)</h6>
<h6>str peek(int address, int length)</h6>

Returns the memory contents of the specified address, which must be in the range 0x0000 through 0xffff. 
The int value returned will be in the range from 0x0000 thru 0xffff. If the address given exceeds the limits 
of the memory map, Admiral will use the LSW of the address.

The second form with 'length' argument returns a string that contains 'length' words copied from the memory 
area that starts from the given address. 

<h6>void poke(int address, (int|str) value)</h6>

Changes the content of any memory address, ranging from 0x0000 to 0xffff, to the given byte value in the range 
0x0000 through 0xffff. If either number is outside these limits, Admiral will use the LSW of the value.

The second form with str value copies the contents of the string to memory area starting at 'address'.

Caution: A misplaced POKE may cause the DCPU to lock up, or garble or delete the program currently in memory. 
To restore a locked-up DCPU one has to reboot the DCPU, thereby losing any program or data in RAM! 

<h6>int hwn()</h6>

Returns the number of connected hardware devices.

<h6>int hardware_id, int hardware_version, int manufacturer = hwq(int n)</h6>

Returns a tuple containing information about hardware n.

<pre>
for n in range(hwn()):
 hw=hwq(n)
 print hex(hw[0]), hex(hw[1]), hex(hw[2])
</pre>

<h6>void hwi(int n)</h6>

Sends the interrupt to hardware n.

Parameters can be passed between Admiral and interrupt via registers. Before interrupt Admiral “loads” 
a, b, c, x, y, z, i and j registers with the words stored at addresses 0xdb78 - 0xdb7f.

If or when the interrupt returns control, Admiral immediately saves the contents of the registers back 
into the 0xdb78 - 0xdb7f memory range: This can be used to transfer results from the interrupt to 
Admiral for further processing. 

<h5>DICT API</h5>

<h6>dict.create()</h6>

Return a new dict object that has the object set as prototype.

<h5>LIST API</h5>

<h6>list.append(x)</h6>

Add an item to the end of the list.

<h6>list.insert(i, x)</h6>

Insert an item at a given position. The first argument is the index of the element before which to insert, 
so a.insert(0, x) inserts at the front of the list, and a.insert(len(a), x) is equivalent to a.append(x).

<h5>STRING API</h5>

<h6>str.encrypt(key)</h6>

Encrypts the string with given key using hummingbird2 codec.

<h6>str.decrypt(key)</h6>

Decrypts encrypted string with given key and hummingbird2 codec.

<h6>str.lower()</h6>

Return a copy of the string with all the cased characters converted to lowercase.

<h6>str.upper()</h6>

Return a copy of the string with all the cased characters converted to uppercase.

<h6>str.find(sub[, start[, end]])</h6>

Return the lowest index in the string where substring sub is found, such that sub is contained in the slice 
s[start:end]. Optional arguments start and end are interpreted as in slice notation. Return -1 if sub is not found.

The find() method should be used only if you need to know the position of sub. To check if sub is a substring 
or not, use the in operator:

    >"mi" in "Admiral"
    True

<h6>str.replace(old, new)</h6>

Return a copy of the string with all occurrences of substring old replaced by new.

<h6>str.split([sep])</h6>

Return a list of the words in the string, using sep as the delimiter string. Consecutive delimiters are not 
grouped together and are deemed to delimit empty strings:
    >'1,,2'.split(',')
    ['1','','2'])

The sep argument may consist of multiple characters
    >'1<>2<>3'.split('<>')
    ['1','2','3']). 

Splitting an empty string with a specified separator returns [''].

If sep is not specified, a different splitting algorithm is applied: runs of consecutive whitespace are regarded 
as a single separator, and the result will contain no empty strings at the start or end if the string has leading 
or trailing whitespace. Consequently, splitting an empty string or a string consisting of just whitespace with 
a None separator returns [].

    >' 1  2   3  '.split()
    ['1','2','3']

<h6>str.endswith(suffix)</h6>

Return True if the string ends with the specified suffix, otherwise return False. suffix can also be a tuple 
of suffixes to look for.

<h6>str.startswith(prefix)</h6>

Return True if string starts with the prefix, otherwise return False. prefix can also be a tuple of prefixes to 
look for.

<h6>str.isalpha()</h6>

Return true if all characters in the string are alphabetic and there is at least one character, false otherwise.

<h6>str.isdigit()</h6>

Return true if all characters in the string are digits and there is at least one character, false otherwise.

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
 - Admiral provides optimized integer division algorithm. Based on the divident and divisor size it select one of the three different division strategies
   - 16b / 16b -> DCPU hardware supported DIV operation
   - n bit / 8 bit -> Optimized proprietary division algorithm that divides with DIV in 8 bit chunks
   - n bit / n bit -> Standard long division is used
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

ADMIRAL MEMORY LAYOUT

Admiral reserves the whole DCPU memory for its use. Memory is divided into segments:

<table cellpadding="1">
<tr><th>Segment</th><th>Default size</th><th>Default location</th><th>Description</th></tr>
<tr><td>Stack</td><td>8.192</td><td>0xe000 - 0xffff</td><td>Admiral call stack to store registers and arguments</td></tr>
<tr><td>Video Memory</td><td>1.152</td><td>0xdb80 - 0xdfff</td><td>Video memory for LEM</td></tr>
<tr><td>Floppy Buffer</td><td>512</td><td>0xd980 - 0xdb7f</td><td>Memory buffer used by floppy operations, default memory area for machine language subroutine calls</td></tr>
<tr><td>Heap</td><td>39.296</td><td>0x4000 - 0xd97f</td><td>Admiral heap for variables and objects</td></tr>
<tr><td>System</td><td>16.384</td><td>0x0000 - 0x3fff</td><td>Admiral interpreter, data and subroutines</td></tr>
</table>

The exact location and size of each segment depends on the Admiral build.

SOME EXTRA BITS

ASSIGNMENTS

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

UNKNOWN IDENTS IN FUNCTIONS

Currently Admiral does not produce error if unknown variable name is present in function body, but it is not
evaluated. E.g.

<pre>
>f=edit()
'print "Hello"
foobar
print "The End"
</pre>

foobar would not yeld error, as it is not used for anything. However,

<pre>
>f=edit()
'print "Hello"
foobar+1
print "The End"
</pre>

will yeld error, as unknown IDENT (foobar) cannot be evaluated for addition operator.

PYTHON FEATURES MISSING (INCOMPLETE LIST)

 - 'def' function definitions
 - 'class' class definitions
 - 'lambda' functions
 - generators
 - list comprehension e.g.  [x**2 for x in range(10)]
 - '*args' and '*kwargs'
 - % string operator
 - 'yield'
 - 'try' - 'except' exception handling
 - lot of built-in functions


OTHER DCPU LANGUAGE PROJECTS

rs5s77 : goforth
CBM64 Basic


