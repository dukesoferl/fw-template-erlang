-module (myapp).
-behaviour (application).

-export ([start/2, stop/1, test/0]).

%-=====================================================================-
%-                        application callbacks                        -
%-=====================================================================-

start (_Type, _Args) ->
  true = register (hello_world, spawn_link (fun hello/0)),
  case whereis (hello_world) of
    undefined -> {error, failed_to_start};
    P -> { ok, P }
  end.

stop (_State) ->
  ok.

%-=====================================================================-
%-                               Private                               -
%-=====================================================================-

hello () ->
  hello (3).

hello (0) ->
  ok;
hello (N) ->
  receive
  after 1000 ->
    io:format ("hello world~n", []),
    hello (N - 1)
  end.

test () ->
  process_flag (trap_exit, true),
  start (void, void),
  receive
    { 'EXIT', _Why, _Pid } -> 
      ok
  after 4000 ->
    throw (flass)
  end.
