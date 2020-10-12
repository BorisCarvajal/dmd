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

template staticMap(alias F, T...)
{
    alias A = AliasSeq!();
    static foreach (t; T)
        A = A ~ F!t; // what's tested
    //static foreach (t; 0..T.length) // A little faster
    //	A = A ~ F!(T[t]);
    alias staticMap = A;
}

alias Test = AliasSeq!(int, const uint, immutable float, double, const char);
alias TestResult = AliasSeq!(int, uint, float, double, char);
//pragma(msg, Test.length);
//pragma(msg, "generate 5120 tuple elements");
static foreach (i; 0..10)
{
    Test = Test ~ Test;
    TestResult = TestResult ~ TestResult;
    //static assert(is(staticMap!(Unqual, Test) == TestResult));
}

//pragma(msg, "Test: ", Test);
pragma(msg, "Test.length: ", Test.length);
//pragma(msg, "TestResult: ", TestResult);
pragma(msg, "TestResult.length: ", TestResult.length);
static assert(Test.length == TestResult.length && TestResult.length == 5120);
static assert(is(Test[$-1] == const char) && is(TestResult[$-1] == char));
static assert(is(staticMap!(Unqual, Test) == TestResult));
