-module (oldrecord_ok).
-export ([ foo/1, code_change/3 ]).

-oldrecord (baz).

-record (baz, { }).
-record (bazv2, { }).

foo (#bazv2{}) -> bar.

code_change (_OldVsn, _State = #baz{}, _Extra) ->
  { ok, #bazv2{} }.
