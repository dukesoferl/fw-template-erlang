#! /bin/sh

ERL_CRASH_DUMP=${ERL_CRASH_DUMP-"/dev/null"}
export ERL_CRASH_DUMP

command="$1"
shift

trap 'trap - EXIT; rm -f .flass; exit 1' INT QUIT TERM 
trap 'rm -f .flass' EXIT
touch .flass

case $command in
  ./module-*)
    module=${command#./module-}
    erl +A 10 -sname $$ -pa ../src -eval '
      Module = list_to_atom (hd (init:get_plain_arguments ())),
      cover:compile_beam_directory ("../src"),
      Result =
        case erlang:function_exported (Module, test, 0) of
          true ->
            io:format ("~p:test () ...", [ Module ]),
            R =
              case eunit:test(Module,[{report, {eunit_surefire,[{dir,"."}]}}]) of
                ok -> 0;
                _ -> 1
              end,
            io:format ("~n"),
            R;
          false ->
            io:format ("~p:test () ... NO TESTS", [ Module ]),
            77
        end,
      cover:analyse_to_file (Module),
      cover:analyse_to_file (Module, [html]),
      halt (Result).
    ' -noshell -s init stop -extra "$module" 2>&1 > $module.test.out || exit $?

  ;;
  ./all)
    erl +A 10 -sname $$ -pa ../src  \
      $FW_OTP_TEST_ERL_EXTRA_ARGS \
        -eval '
          cover:compile_beam_directory ("../src"),
          Result =
            lists:sum ([
              case erlang:function_exported (Module, test, 0) of
                true ->
                  io:format ("~p:test () ...", [ Module ]),
                  R =
                    case eunit:test(Module,[{report, {eunit_surefire,[{dir,"."}]}}]) of
                      ok -> 0;
                      _ -> 1
                    end,
                  io:format ("~n"),
                  R;
                false ->
                  io:format ("~p NO TESTS ...~n", [ Module ]),
                  0
              end
              || Module
              <- cover:modules()
              ]),
          [ begin
              cover:analyse_to_file (Module),
              cover:analyse_to_file (Module, [html])
            end
            || Module
            <- cover:modules()
          ],
          halt (Result).
        ' -noshell -s init stop 2>&1 > erlang-otp.test.out || exit $?
  ;;
  *)
    "$command" "$@" || exit $?
  ;;
esac

find . -name '*.COVER.out' -and -newer .flass -print | \
  perl -MIO::File -lne 'chomp;
                       my $fh = new IO::File $_, "r" or die $!;
                       my @total_lines = grep { ! / 0\.\.\|  -module \(/ } <$fh>;
                       my @covered_lines = grep {/[0-9]+\.\./} @total_lines;
                       my $bad = grep / 0\.\.\|/, @total_lines;
                       my $total = scalar @total_lines;
                       my $total_covered = scalar @covered_lines;
                       my $perc = $total_covered > 0 ? int(100 * (1.0 - ($bad / $total_covered))) : "-";
                       print "$perc% of $total lines covered in $_"'
