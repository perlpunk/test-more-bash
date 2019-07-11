#!/usr/bin/env bash

source test/setup

use Test::More

output=$(prove -v test/test/fail1.t 2>&1) || true

like "$output" 'not ok 1 - fail with label' \
  'fail with label'
like "$output" 'not ok 2' \
  'fail with no label'
like "$output" 'not ok 3 - is foo bar' \
  'fail output is correct'
like "$output" 'not ok 4 - command output more' \
  'fail output is correct'
like "$output" 'not ok 5 - command output less' \
  'fail output is correct'
like "$output" 'not ok 6 - command output diff' \
  'fail output is correct'
like "$output" "#     got: 'foo'" \
  'difference reporting - got'
like "$output" "#   expected: 'bar'" \
  'difference reporting - want'

like "$output" "# Array has more elements \(3\) than expected \(2\)" \
  'array comparison (more)'
like "$output" "# Array has less elements \(1\) than expected \(2\)" \
  'array comparison (less)'
like "$output" "# array\[1\]: >>foo<< does not match >>line2<<" \
  'array comparison (diff)'


done_testing 11
