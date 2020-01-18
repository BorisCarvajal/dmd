import std.stdio;
void foo(T)(T t) if (diagInfo!(__traits(compilesPlus, t.length)))
{
    t.length;
}
void foo(T)(T t) if (diagInfo!(__traits(compilesPlus, {static assert(t.sizeof == 2);})))
{
    auto a = t.sizeof;
}
void foo(T)(T t) if (diagInfo!(__traits(compilesPlus, {static assert(t.sizeof == 4);})))
{
    auto a = t.sizeof;
}


void main()
{
    pragma(msg, __traits(compilesPlus, {a+x;}, {a;}, {b;}));
    pragma(msg, __traits(compilesPlus, {}, a));
    pragma(msg, __traits(compilesPlus, {}, int));

    alias infoTrue = diagInfo!(__traits(compilesPlus, int));
    alias infoFalse = diagInfo!(__traits(compilesPlus, {a+x;}, s, X));
    writeln("infoTrue is: ", infoTrue);
    writeln("infoFalse is: ", infoFalse);
/*    foreach (i, e; infoFalse.errors)
    {
        writeln;
        writeln(e.filename, ":", e.line);
        writeln(e.error);
        writeln(e.context);
        char[] cur = new char[e.column];
        cur[] = ' ';
        cur[$-1] = '^';
        writeln(cur);
    }*/
    foo!int(1);
}

struct DiagInfo(size_t len, S...)
{
    bool doesCompile = S[0];
    alias doesCompile this;
    static if (len)
        enum ErrorItem[len] errors = [S[1..$]];
}
struct ErrorItem
{
    string error;
    string context;
    string filename;
    uint line;
    uint column;
}

auto diagInfo(Args...)()
{
    import std.conv;
    import std.meta : aliasSeqOf;
    pragma(msg,"_Args.length_" ~ Args.length.to!string);

    static assert((Args.length - 1) % 5 == 0);
    static if (Args.length == 1)
        return DiagInfo!(0, Args[0])();
    else
    {
        alias E = takeN!(ErrorItem, 5, Args[1..$]);
        enum di = DiagInfo!((Args.length - 1) / 5, Args[0], E)();
        pragma(msg,"_di.erros.length_" ~ aliasSeqOf!(di.errors).length.to!string);
        foreach (i, enum e; aliasSeqOf!(di.errors))
        {
            pragma(msg , e.filename ~ ":" ~ e.line.to!string);
            pragma(msg , e.error);
            pragma(msg , e.context);
            enum char[e.column-1] cur = ' ';
            pragma(msg, cur ~ '^');
        }
        return di;
    }
}
template takeN(T, size_t l, A...)
{
    import std.meta : AliasSeq;
    static assert(A.length % l == 0);
    static if (A.length == l)
        alias takeN = AliasSeq!(T(A[0..l]));
    else
        alias takeN = AliasSeq!(T(A[0..l]), takeN!(T, 5, A[l..$]));
}


