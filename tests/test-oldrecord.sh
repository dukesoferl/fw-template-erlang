#! /bin/sh

{
set -e
erlc -pa ../fw.local/template/erlang/ +'{ parse_transform, oldrecord_trans }' oldrecord_ok.erl 

set +e
echo " *** the following errors are expected *** " 1>&2

erlc -pa ../fw.local/template/erlang/ +'{ parse_transform, oldrecord_trans }' oldrecord_should_fail.erl && exit 1

erlc -pa ../fw.local/template/erlang/ +'{ parse_transform, oldrecord_trans }' oldrecord_should_fail2.erl && exit 1

echo " *** subsequent errors are not expected *** " 1>&2

set -e
} > test-oldrecord.out 2>&1

exit 0
