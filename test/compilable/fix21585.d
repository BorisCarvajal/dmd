/* TEST_OUTPUT:
---
i int
d double
Pi int*
---
*/

pragma(msg, 1.mangleof, " ", __traits(toType, 1.mangleof));
pragma(msg, (1.0).mangleof, " ", __traits(toType, (1.0).mangleof));
pragma(msg, (int*).mangleof, " ", __traits(toType, (int*).mangleof));

template Type(T) { alias Type = T; }

Type!(__traits(toType, 1.mangleof)) j = 3;

alias T = Type!(__traits(toType, 1.mangleof));
static assert(is(T == int));
alias T2 = __traits(toType, 1.mangleof);
static assert(is(T2 == int));

static assert(is(Type!(__traits(toType, 1.mangleof)) == int));
static assert(is(Type!(__traits(toType, (1.0).mangleof)) == double));
static assert(is(Type!(__traits(toType, (int*).mangleof)) == int*));
static assert(is(__traits(toType, 1.mangleof) == int));
static assert(is(__traits(toType, (1.0).mangleof) == double));
static assert(is(__traits(toType, (int*).mangleof) == int*));
