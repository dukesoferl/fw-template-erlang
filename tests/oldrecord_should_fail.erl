-module (oldrecord_should_fail).
-export ([ foo/1 ]).

-oldrecord (baz).

-record (baz, { }).
-record (bazv2, { }).

foo (State = #baz{}) -> bar.
