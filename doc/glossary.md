# Glossary 
 
### Compile-time words

`:` ( "name" -- )  
Start a new colon definition.

`;` ( -- )  
End a colon definition.

`[` ( -- )  
Enter interpretation state.

`]` ( -- )  
Enter compilation state.

`CONSTANT` ( n "name" -- )  
Define a constant.

`VARIABLE` ( "name" -- )  
Define a global variable.

`CODE` ( "name" -- )  
Start a new assembler definition.

`END-CODE` ( -- )  
End an assembler definition.

`[']` ( "name" -- )  
Compile the xt of a word.

`[CHAR]` ( "c" -- )  
Compile a character.

`LITERAL` ( n -- )  
Compile a literal.

`IF` ( n -- )  
...

`THEN` ( -- )

`ELSE` ( -- )

`AHEAD` ( -- )

`BEGIN` ( -- )

`AGAIN` ( -- )

`UNTIL` ( n -- )

`WHILE` ( n -- )

`REPEAT` ( -- )

### Run-time words

`COLD` ( -- )  
The very first definition to be executed.

`WARM` ( -- )  
The first colon definition to be executed.

`!` ( n a -- )  
Store the word `n` at address `a`.

`C!` ( c a -- )  
Store the character `c` at address `a`.

`@` ( a -- n )  
Fetch the word `n` from address `a`.

`C@` ( a -- c )  
Fetch the character `c` from address `a`.

`+!` ( n a -- )  
Add `n` to the word at address `a`.

`DROP` ( x -- )  
Discard the top of the data stack.

`NIP` ( x1 x2 -- x2 )  
Discard the item under the top of the data stack.

`DUP` ( x -- x x )  
Duplicate the top of the data stack.

`?DUP` ( x -- x|x x )  
Duplicate the top of the data stack if it's not zero.

`SWAP` ( x1 x2 -- x2 x1 )  
Swap the top two items of the data stack.

`OVER` ( x1 x2 -- x1 x2 x1 )  
Duplicate the item under the top of the data stack.

`>R` ( x -- ) ( R: -- x )  
Move an item from the data stack to the return stack.

`R>` ( -- x ) ( R: x -- )  
Move an item from the return stack to the data stack.

`R@` ( -- x ) ( R: x -- )  
Copy the top of the return stack to the data stack.

`+` ( n1 n2 -- n3 )  
Add the top top items of the data stack.

`-` ( n1 n2 -- n3 )  
Subtract the top of the data stack from the next item.

`2*` ( n1 -- n2 )  
Double the top of the data stack.

`2/` ( n1 -- n2 )  
Divide the top of the data stack by two.

`INVERT` ( n1 -- n2 )  
Logical invertion of the top of the data stack.

`NEGATE` ( n1 -- n2 )  
Negate the top of the data stack.

`AND` ( n1 n2 -- n3 )  
Logical conjunction of the two top items of the data stack.

`OR` ( n1 n2 -- n3 )  
Logical disjunction of the two top items of the data stack.

`XOR` ( n1 n2 -- n3 )  
Exclusive disjunction of the two top items of the data stack.

`1+` ( n1 -- n2 )  
Add one to the top of the data stack.

`1-` ( n1 -- n2 )  
Subtract one from the top of the data stack.

`CELL+` ( n1 -- n2 )  
Add the size of a cell to the top of the data stack.

`0=` ( n -- f )  
Leave true flag if `n` is zero, false otherwise.

`0<` ( n -- f )  
Leave true flag if `n` is negative, false otherwise.

`0<>` ( n -- f )  
Leave true flag if `n` is nonzero, false otherwise.

`=` ( n1 n2 -- f )  
Leave true flag if `n1` and `n2` are equal, false otherwise.

`<>` ( n1 n2 -- f )  
Leave true flag if `n1` and `n2` are idfferent, false otherwise.
