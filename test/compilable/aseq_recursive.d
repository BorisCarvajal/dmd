template AliasSeq(T...) { alias AliasSeq = T; }

template Unqual(T)
{
    static if (is(T U == const U))
	 alias Unqual = U;
    else static if (is(T U == immutable U))
	 alias Unqual = U;
    else
	 alias Unqual = T;
}
/*
private enum staticMapExpandFactor = 150;
private string generateCases()
{
    string[staticMapExpandFactor] chunks;
    chunks[0] = q{};
    static foreach (enum i; 0 .. staticMapExpandFactor - 1)
        chunks[i + 1] = chunks[i] ~ `F!(Args[` ~ i.stringof ~ `]),`;
    string ret = `AliasSeq!(`;
    foreach (chunk; chunks)
        ret ~= `q{alias staticMap = AliasSeq!(` ~ chunk ~ `);},`;
    return ret ~ `)`;
}
private alias staticMapBasicCases = AliasSeq!(mixin(generateCases()));
*/
/**
Evaluates to $(D AliasSeq!(F!(T[0]), F!(T[1]), ..., F!(T[$ - 1]))).
 */
template staticMap(alias F, Args ...)
{
    //static if (Args.length < staticMapExpandFactor)
    //    mixin(staticMapBasicCases[Args.length]);
    static if (Args.length == 1)
          alias staticMap = AliasSeq!(F!(Args[0]));
    else
        alias staticMap = AliasSeq!(staticMap!(F, Args[0 .. $/2]), staticMap!(F, Args[$/2 .. $]));
}
template Repeat(size_t n, TList...)
{
    static if (n == 0)
    {
        alias Repeat = AliasSeq!();
    }
    else static if (n == 1)
    {
        alias Repeat = AliasSeq!TList;
    }
    else static if (n == 2)
    {
        alias Repeat = AliasSeq!(TList, TList);
    }
    /* Cases 3 to 8 are to speed up compilation
     */
    else static if (n == 3)
    {
        alias Repeat = AliasSeq!(TList, TList, TList);
    }
    else static if (n == 4)
    {
        alias Repeat = AliasSeq!(TList, TList, TList, TList);
    }
    else static if (n == 5)
    {
        alias Repeat = AliasSeq!(TList, TList, TList, TList, TList);
    }
    else static if (n == 6)
    {
        alias Repeat = AliasSeq!(TList, TList, TList, TList, TList, TList);
    }
    else static if (n == 7)
    {
        alias Repeat = AliasSeq!(TList, TList, TList, TList, TList, TList, TList);
    }
    else static if (n == 8)
    {
        alias Repeat = AliasSeq!(TList, TList, TList, TList, TList, TList, TList, TList);
    }
    else
    {
        alias R = Repeat!((n - 1) / 2, TList);
        static if ((n - 1) % 2 == 0)
        {
            alias Repeat = AliasSeq!(TList, R, R);
        }
        else
        {
            alias Repeat = AliasSeq!(TList, TList, R, R);
        }
    }
}


alias Test0 = AliasSeq!(int, const uint, immutable float, double, const char);
alias TestResult0 = AliasSeq!(int, uint, float, double, char);
//pragma(msg, Test.length);
alias Test = Repeat!(1024, Test0);
alias TestResult = Repeat!(1024, TestResult0);

//pragma(msg, "Test: ", Test);
pragma(msg, "Test.length: ", Test.length);
//pragma(msg, "TestResult: ", TestResult);
pragma(msg, "TestResult.length: ", TestResult.length);
static assert(Test.length == TestResult.length && TestResult.length == 5120);
static assert(is(Test[$-1] == const char) && is(TestResult[$-1] == char));
static assert(is(staticMap!(Unqual, Test) == TestResult));
