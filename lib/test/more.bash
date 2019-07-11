# test/more.bash - Complete TAP test framework for Bash
#
# Copyright (c) 2013-2016. Ingy döt Net.

set -e

Test__More_VERSION=0.0.3

source bash+ :std
use Test::Tap

Test::More:import() { Test::Tap:init "$@"; }

plan() { Test::Tap:plan "$@"; }
pass() { Test::Tap:pass "$@"; }
fail() { Test::Tap:fail "$@"; }
diag() { Test::Tap:diag "$@"; }
note() { Test::Tap:note "$@"; }
done_testing() { Test::Tap:done_testing "$@"; }
BAIL_OUT() { Test::Tap:BAIL_OUT "$@"; }
BAIL_ON_FAIL() { Test::Tap:BAIL_ON_FAIL "$@"; }

is() {
  local got="$1" want="$2" label="$3"
  if [[ $got == "$want" ]]; then
    Test::Tap:pass "$label"
  else
    Test::Tap:fail "$label" Test::More:is-fail
  fi
}

Test::More:is-fail() {
  local Test__Tap_CALL_STACK_LEVEL=
  Test__Tap_CALL_STACK_LEVEL=$(( Test__Tap_CALL_STACK_LEVEL + 1 ))
  if [[ $want =~ $'\n' ]]; then
    echo "$got" > /tmp/got-$$
    echo "$want" > /tmp/want-$$
    diff -u /tmp/{want,got}-$$ >&2
    wc /tmp/{want,got}-$$ >&2
    rm -f /tmp/{got,want}-$$
  else
    Test::Tap:diag "\
    got: '$got'
  expected: '$want'"
  fi
}

isnt() {
  local Test__Tap_CALL_STACK_LEVEL=
  Test__Tap_CALL_STACK_LEVEL=$(( Test__Tap_CALL_STACK_LEVEL + 1 ))
  local got="$1" dontwant="$2" label="$3"
  if [[ $got != "$dontwant" ]]; then
    Test::Tap:pass "$label"
  else
    Test::Tap:fail "$label" Test::More:isnt-fail
  fi
}

Test::More:isnt-fail() {
    Test::Tap:diag "\
      got: '$got'
   expected: anything else"
}

ok() {
  (exit ${1:-$?}) &&
    Test::Tap:pass "$2" ||
    Test::Tap:fail "$2"
}

like() {
  local got=$1 regex=$2 label=$3
  if [[ $got =~ "$regex" ]]; then
    Test::Tap:pass "$label"
  else
    Test::Tap:fail "$label" Test::More:like-fail
  fi
}

Test::More:like-fail() {
    Test::Tap:diag "Got: '$got'"
}

unlike() {
  local got=$1 regex=$2 label=$3
  if [[ ! $got =~ "$regex" ]]; then
    Test::Tap:pass "$label"
  else
    Test::Tap:fail "$label" Test::More:unlike-fail
  fi
}

Test::More:unlike-fail() {
    Test::Tap:diag "Got: '$got'"
}

cmp-array() {
    if [[ $# -lt 2 ]]; then
        echo 'usage: cmp-array "message" ${array[@]}'
        exit 1
    fi
    local label="$1"
    shift
    local array=($@)
    local result=true
    local message=

    if [[ ${#array[@]} -lt ${#expected[@]} ]]; then
        Test::Tap:fail "$label"
        Test::Tap:diag "Array has less elements (${#array[@]}) than expected (${#expected[@]})"
        Test::Tap:note ${array[@]}
        return
    fi

    for i in ${!expected[@]}; do
        if [[ "${array[$i]}" == "${expected[$i]}" ]]; then
            true
        else
            message="array[$i]: >>${array[$i]}<< does not match >>${expected[$i]}<<"
            result=false
        fi
    done

    if [[ ${#array[@]} -gt ${#expected[@]} ]]; then
        Test::Tap:fail "$label"
        Test::Tap:diag "Array has more elements (${#array[@]}) than expected (${#expected[@]})"
        Test::Tap:note ${array[@]}
        return
    fi

    if $result; then
        Test::Tap:pass "$label"
    else
        Test::Tap:fail "$label"
    fi
    [[ -n "$message" ]] && Test::Tap:diag $message
}
