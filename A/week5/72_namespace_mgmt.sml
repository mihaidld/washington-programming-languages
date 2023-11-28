(* Programming Languages, Dan Grossman *)
(* Section 4: Modules for Namespace Management

ML has structures to define modules
structure MyModule = struct <bindings> end
Inside  a module can use earlier bindings as usual, any kind of bindings
(val, fun, exception, datatype)
but outside the module, refer to earlier module's bindings via
ModuleName.bindingName

structure name is not a variable so there is no MyMathLib in top level
environment, altough there each binding MyMathLib.fact

To use all bindings in a module without having to type each time module's name
open ModuleName, but it's bad style. it clutters the namespace with all
bindings from module. Better to create local val-bindings for module bindings
used often e.g. val zip = ListPair.zip

 *)

structure MyMathLib =
struct

fun fact x =
    if x=0
    then 1
    else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y

end

val pi = MyMathLib.half_pi + MyMathLib.half_pi

val twenty_eight = MyMathLib.doubler 14
