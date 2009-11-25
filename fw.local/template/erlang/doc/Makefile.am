templatedocdir = $(prefix)/share/fw/template/@FW_TEMPLATE_TEMPLATE_TYPE@/doc

dist_templatedoc_DATA =                 \
  Makefile_dot_am                       \
  Makefile.am.local                     \
  overview.edoc

install-data-hook:
	find "$(DESTDIR)$(templatedocdir)" -type f | xargs chmod -w

CLEANFILES =

MAINTAINERCLEANFILES =                  \
  Makefile.in

include $(top_srcdir)/fw/build/automake/check-shell.am
include $(top_srcdir)/fw/build/automake/gnu-make-check.am
