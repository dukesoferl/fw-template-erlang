templatesrcdir = $(prefix)/share/fw/template/@FW_TEMPLATE_TEMPLATE_TYPE@/src

dist_templatesrc_DATA =                 \
  Makefile_dot_am                       \
  Makefile.am.local                     \
  fw-erl-app-template.app.in		\
  myapp.erl

install-data-hook:
	find "$(DESTDIR)$(templatesrcdir)" -type f | xargs chmod -w

CLEANFILES =

MAINTAINERCLEANFILES =                  \
  Makefile.in

include $(top_srcdir)/fw/build/automake/check-shell.am
include $(top_srcdir)/fw/build/automake/gnu-make-check.am
