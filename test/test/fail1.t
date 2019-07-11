#!/usr/bin/env bash

source test/setup
use Test::More

fail 'fail with label'

fail

is foo bar 'is foo bar'

expected=(line1 line2)

command_output=(line1 line2 line3)
cmp-array "command output more" ${command_output[@]}

command_output=(line1)
cmp-array "command output less" ${command_output[@]}

command_output=(line1 foo)
cmp-array "command output diff" ${command_output[@]}

done_testing 6
