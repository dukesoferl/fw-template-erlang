AC_DEFUN([FW_TEMPLATE_ERLANG],
[
  FW_ERL_APP_NAME=${FW_ERL_APP_NAME-${FW_PACKAGE_NAME}}
  FW_SUBST_PROTECT(FW_ERL_APP_NAME)

  AC_REQUIRE([FW_TEMPLATE_ERLANG_EUNIT_CHECK])
  AC_REQUIRE([FW_TEMPLATE_ERLANG_ENABLE_ERLRC])
  echo "$FW_ERL_APP_NAME" | perl -ne 'm/-/ && exit 1; exit 0'

  if test $? != 0
    then
      AC_MSG_ERROR([sorry, FW_ERL_APP_NAME ($FW_ERL_APP_NAME) cannot contain dashes, if you haven't set FW_ERL_APP_NAME its probably using the default for FW_ERL_APP_NAME which is FW_PACKAGE_NAME ($FW_PACKAGE_NAME), so modify fw-pkgin/config to set FW_ERL_APP_NAME])
      exit 1
    fi

  AC_ARG_VAR([ERLAPPDIR],
             [application directory (default: GUESSED_ERLANG_PREFIX/erlang/lib/$FW_ERL_APP_NAME-$FW_PACKAGE_VERSION)])

  if test "x$ERLAPPDIR" = x
    then
      AC_MSG_CHECKING([for erlang library prefix...])

      guessederlangprefix=`erl -noshell -noinput -eval 'io:format ("~s", [[ code:lib_dir () ]])' -s erlang halt`

      AC_MSG_RESULT([${guessederlangprefix}])

      ERLAPPDIR="${guessederlangprefix}/\$(FW_ERL_APP_NAME)-\$(FW_PACKAGE_VERSION)"
    fi

  AC_ARG_VAR([ERLDOCDIR],
             [documentation directory (default: $datadir/doc/erlang-doc-html/html/lib/$FW_ERL_APP_NAME-$FW_PACKAGE_VERSION/doc/html)])

  if test "x$ERLDOCDIR" = x
    then
      ERLDOCDIR="\$(datadir)/erlang/lib/\$(FW_ERL_APP_NAME)-\$(FW_PACKAGE_VERSION)/doc/html"
    fi

  AC_ARG_VAR([ERLRCDIR],
             [erlrc configuration directory (default: /etc/erlrc.d)])

  if test "x$ERLRCDIR" = x
    then
      ERLRCDIR="/etc/erlrc.d"
    fi

  AC_CHECK_PROG([ERLC], [erlc], [erlc])

  if test "x$ERLC" = x
    then
      AC_MSG_ERROR([cant find erlang compiler])
      exit 1
    fi

  AC_ARG_VAR(ERLC, [erlang compiler])

  AC_CONFIG_FILES([doc/Makefile
                   src/Makefile
                   tests/Makefile])

  AC_CONFIG_FILES([src/fw-erl-app-template.app])

  FW_SUBST_PROTECT([FW_EDOC_OPTIONS])
  FW_SUBST_PROTECT([FW_LEEX_OPTIONS])
  FW_SUBST_PROTECT([FW_YECC_OPTIONS])
])
