// Programming Languages, Dan Grossman
// Section 3: Optional: Closure Idioms Without Closures in C

// Note: This code compiles but has not been carefully tested.
//       Bug reports welcome.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

/*
  Function pointers
  Functions are first-class, values that we can pass to other functions,
  put in data structures, but they are just function pointers.
  While closures in ML have code and environment, function pointers in C
  are only the code (function body), code pointers. So when passing a function
  with some arguments, it can only use those arguments and global variables.
  Functions have to be defined at top-level, can not define one function inside
  another one
  Rather than create structs for closures, which would work fine,
  we follow common C practice of having higher-order functions
  take an extra argument, and that argument should be the environment. It's
  passed along with the function pointer
  -- if they don't, then only the function body is not  much less useful

  Type variables
  In C there aren't type variables, generic types 'a or 'b so we need to use
  void* which requires lots of unchecked conversions between types (type casts
  between types)
*/

// define List struct type with 2 fields
typedef struct List list_t;
struct List
{
  // generic type void*, not the value (e.g. int), but pointer to value
  void *head;
  list_t *tail; // tail is pointer to another List
};

// helper function for constructing List that takes in head and tail
list_t *makelist(void *x, list_t *xs)
{
  // mallocs allocates memory, returns pointer to struct, sets head and tail
  list_t *ans = (list_t *)malloc(sizeof(list_t));
  ans->head = x;
  ans->tail = xs;
  return ans;
}

// Use null for empty list

// as in the Java version, we show simple recursive solutions because
// the loop-based ones require mutation and previous pointers.
// But the more important point is the explicit env field passed to the
// function pointer

/*take in a pointer to a function argument (*f) and list argument xs( which
  is a pointer to a struct). Normally the function should take only 1 argument
  which is the element of the list and return 1 thing which will be the element
  in the new list. But then the function would not be a closure, it would work
  for doubleAll where we just multiply by 2, but would not work for countNs
  because f would not know the value of n.

  Idiom in C (good practice) is to add extra argument in 2 places: f takes an
  extra argument and map takes an extra argument env, so every time map is
  called with env, it passes env along when calling f.
  We do this to support clients that need private data.
  Since we don't know what type env should be we set it void*, and cast it later
  since the library implementer doesn't know what the clients need to pass as
  private data inside

  It's not conventional in C to write it recursive, it's less efficient

*/
list_t *map(void *(*f)(void *, void *), void *env, list_t *xs)
{
  if (xs == NULL) // Empty list, return Empty list
    return NULL;
  /* make new List with head resulted from calling f with head of list xs and
   env, then the tail of the list is mapping f with the same env accross xs's
   tail */
  return makelist(f(env, xs->head), map(f, env, xs->tail));
}

/*the function f should now return a bool*/
list_t *filter(bool (*f)(void *, void *), void *env, list_t *xs)
{
  if (xs == NULL)
    return NULL;
  if (f(env, xs->head))                                  // call predicate f with env and xs's head
    return makelist(xs->head, filter(f, env, xs->tail)); // make list inc. head
  return filter(f, env, xs->tail);
}

int length(list_t *xs)
{
  int ans = 0;
  while (xs != NULL)
  {
    ++ans;
    xs = xs->tail;
  }
  return ans;
}

// clients of our list implementation:
// [the clients that cast from void* to intptr_t are technically not legal C,
//  as explained in detail below if curious]

/* awful type casts to match what map expects
   doubleInt to be the type that map expects, must take 2 void* and return void*
   1st argument called ignore since not used for the environment, the 2nd for
   i, the element of the list, which is an int so we cast i to int pointer,
   multiply it by 2, then cast it back to void* */
void *doubleInt(void *ignore, void *i)
{
  return (void *)(((intptr_t)i) * 2);
}

/* takes a list assumed to be of integers, we call map with function pointer
   doubleInt, env is NULL since we don't need an environment, and list xs */
// assumes list holds intptr_t fields
list_t *doubleAll(list_t *xs)
{
  return map(doubleInt, NULL, xs);
}

/* awful type casts to match what filter expects
   takes the environment which is n (pointer to an int), both i and n are void*
   to comply with type-checker, both casts from int pointer to int withintptr_t,
   then check if equal*/
bool isN(void *n, void *i)
{
  return ((intptr_t)n) == ((intptr_t)i);
}

// assumes list hold intptr_t fields
/* uses predicate isN to check if element of list is same as n passed in the
 environment */
int countNs(list_t *xs, intptr_t n)
{
  return length(filter(isN, (void *)n, xs));
}

/*
  The promised explanation: Some of the client code above tries to use
  a number for the environment by using a number (intptr_t) where a
  pointer (void *) is expected.  This is technically not allowed: any
  pointer (including void*) can be cast to intptr_t (always) and the
  result can be cast back to the pointer type, but that is different
  than starting with an intptr_t and casting it to void* and then back
  to intptr_t.

  It appears there is no legal, portable way to create a number that
  can be cast to void* and back.  People do this sort of thing often,
  but the resulting code is not strictly portable.  So what should we
  do for our closures example besides ignore this and write
  non-portable code using int or intptr_t?

  Option 1 is to use an int* for the environment, passing a pointer to the
  value we need.  That is the most common approach and what we need to do for
  environments with more than one value in them anyway.  For the examples above,
  it would work to pass the address of a stack-allocated int, but that works
  only because the higher-order functions we are calling will not store those
  pointers in places where they might be used later after the stack variable
  is deallocated.  So it works fine for examples like map and filter, but would
  not work for callback idioms.  For those, the pointer should refer to memory
  returned by malloc or a similar library function.

  Option 2 is to change our approach to have the higher-order functions use
  intptr_t for the type of the environment instead of void*.  This works in
  general since other code can portably cast from any pointer type to
  intptr_t.  It is a less standard approach -- one commonly sees void* used
  as we have in the code above.
*/
int main(void)
{
  void *p1 = malloc(sizeof(void *)); // allocate memory for 2 pointers
  void *p2 = malloc(sizeof(void *));
  void *pn = p2; // pn is alias for p2

  list_t *l1 = malloc(sizeof(list_t)); // allocate memory for 2 structs List
  list_t *l2 = malloc(sizeof(list_t));

  l1->head = p1; // fill structs with pointer values, l1 is linked list with 2 elements
  l1->tail = l2;
  l2->head = p2;
  l2->tail = NULL;

  list_t *ld = doubleAll(l1); // ld is new linked list with doubled elements
  // print elements of initial and doubled linked list,from pointers converted to longs with (intptr_t)
  printf("%li, %li in l1 and %li, %li in ld\n", (intptr_t)(l1->head), (intptr_t)(l2->head), (intptr_t)(ld->head), (intptr_t)(ld->tail->head));
  // print times pn (alias for 1 of the elements) is inside initial list
  printf("%li in list %i times \n", (intptr_t)pn, countNs(l1, (intptr_t)pn));
}
