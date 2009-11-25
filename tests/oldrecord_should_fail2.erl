-module (oldrecord_should_fail).
-export ([ foo/1 ]).

-oldrecord (baz).

-record (baz, { foo, bar }).

foo (State) when State#baz.foo > State#baz.bar -> 
  blorf.
