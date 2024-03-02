// Programming Languages, Dan Grossman
// Section 8: Interfaces

/* Interfaces in statically-typed OOP (Java, C#)

Type-checker in OOP prevents "method missing" errors because we only pass around
objects that when we call methods on them we're sure methods are defined on them
- each class is also a type (like datatype in ML)
- methods have types for arguments and result
class A {
    Object m1(Example e, String s) {...}
    Integer m2(A foo, Boolean b, Integer i) {...}
}
- if C is a (transitive) subclass of D, then C is a subtype of D. Type-checking
allows using subtype (more specific) anywhere supertype (more general) is
expected. If expected instance of D, we can pass also an instance of C

Interface is only a type, but not a class.
- does not contain method definitions (no method body), only their signatures
(types) (unlike mixins which have method definitions)
- can not use new on an interface (like mixins)
- anything that has this type, has these methods with these types for arguments
and result
- a class can extends only one superclass, but can implement many interfaces.
To type-check a class needs to implement every method in the interface(s) with
the right types. If class type-checks it's a subtype of the interface
e.g. class B extends A implements Inter1, Inter2 {}
- interfaces make type-system more flexible (if both A and B implement Example
we can use instances of A or B where Example is expected)
*/
interface Example {
    void m1(int x, int y);
    Object m2(Example x, String y);
}

class A implements Example {
    public void m1(int x, int y) {...};
    public Object m2(Example x, String y) {...};
}

/*  Abstract methods (Java, C#) = Pure virtual methods (C++)

Often a superclass requires a subclass to override some methods. The purpose of
the superclass is to abstract common functionality, but some non-common parts
have no default. It contains some methods with their bodies and instance
variables that would be usefull to many subclasses, but there are parts the
superclass doesn't know about so other methods have only their signatures and
need to be overriden in subclasses
E.g. a GUI has common functionality about moving things around and placing them
on screen, but there is no default for size of a graphical thing, so it forces
subclasses to have methods that determine the size.
We can not create instances of classes with abstract methods.
In Ruby we can still define the superclass A where in m1 we call m2 while m2 is
not defined on A and in order to avoid method-missing error we add comments to
not instantiate A and subclass it and add m2.
Abstract methods is a way for compiler to type-check superclass which has
abstract methods and refuse to compile if superclass is instantiated and
subclass doesn't add method missing or not abstract also. Instead of waiting
for run-time error to raise exception that method not defined, we get error
earlier at compile-time if method m2 not implemented.
Abstract methods just provide method signature with abstract keyword without
method definition

OOP Abstract methods vs FP Higher order functions

= both ways to pass code to other code

Abstract methods is an OOP way for subclass to pass code to other code in
superclass: m1 in superclass C is calling m2 altough doesn't know what m2 is,
it's up to subclass to provide definition for m2, and thanks to dynamic dispatch
in an instance of D m1 found on superclass C will call m2 belonging to D

Like higher order functions in FP that take function arguments and in their body
call them. f in ML takes function g as argument, f doesn't know what g is.
h is a caller of f that provides some code (an anonymous function) for g 
fun f (g, x) = ... g e ...
fun h x = ... f((fn y => ...), ...)

Common functionality is in OOP m1 and FP f, and then subclasses in OOP and
caller h in FP provide the extra information that m1 and f need to complete
their computation.

C++ has multiple inheritance and pure virtual methods so doesn't need interfaces
Instead a class inherits multiple superclasses having all abstract methods.

*/
// abstract class C
abstract class C {
    T1 m1 (T2 x) {... m2(e); ...}
    abstract T3 m2(T4 x);//signature of method subclasses should provide
}

class D extends C {
    T3 m2(T4 x) {...};//subclass to have instances, better provide m2 definition
}

