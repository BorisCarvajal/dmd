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
    	A = AliasSeq!(A, F!t); // what's tested
    alias staticMap = A;
}

//alias TK = staticMap!(Unqual, int, const uint, immutable float, double, const char);
//alias TK = staticMap!(Unqual, Test);
//static assert(is(TK == AliasSeq!(int, uint, float, double, char)));
template TestT()
{
alias Test = AliasSeq!(int, const uint, immutable float, double, const char);
alias TestResult = AliasSeq!(int, uint, float, double, char);
//pragma(msg, Test.length);
static foreach (i; 0..10)
{
    Test = AliasSeq!(Test, Test);
    TestResult = AliasSeq!(TestResult, TestResult);
    //static assert(is(staticMap!(Unqual, Test) == TestResult));
}

//pragma(msg, "Test: ", Test1);
pragma(msg, "Test.length: ", Test.length);
//pragma(msg, "TestResult: ", TestResult);
pragma(msg, "TestResult.length: ", TestResult.length);
static assert(Test.length == TestResult.length && TestResult.length == 5120);
static assert(is(Test[$-1] == const char) && is(TestResult[$-1] == char));
static assert(is(staticMap!(Unqual, Test) == TestResult));
}

alias a = TestT!();
