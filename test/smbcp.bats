#!/bin/bash

# load code as function
source ../smbcp

mkconf() {
    local conf=./smbcp.conf
    echo "SMBPASS=pipo$$" > $conf
    echo $conf
}

@test "loadconf" {
  [[ "$SMBPASS" == "mypass" ]]
  conf=$(mkconf)
  [[ ! -z "$conf" ]]
  # does modify env if run with "run"
  loadconf $conf
  [[ "$SMBPASS" == "pipo$$" ]]
}

@test "mktmpdir" {
    run mktmpdir "./tmp"
    [[ -d "./tmp" ]]
    rmdir ./tmp
}

@test "readarg" {
    readarg "dir1" "myfile"
    [[ "$d" == "dir1" ]]
    [[ "$f" == "myfile" ]]

    readarg "/tmp/myfile1"
    [[ "$d" == "/tmp" ]]
    [[ "$f" == "myfile1" ]]
}

@test "smbcopy" {
    [[ -e "../smbcp.conf" ]]
    loadconf ../smbcp.conf
    [[ ! -z "$SMB_PATH" ]]
    [[ ! -z "$SMBPASS" ]]

    echo pipo$$ >> mytest

    TMPDIR=.
    run smbcopy -g $PWD mytest
    [[ -e mytest ]]

    # debug output
    regexp='r=0 g=0'
    [[ "$output" =~ $regexp ]]

    # no output at all
    run smbcopy $PWD mytest
    [[ -z "$output" ]]
    [[ "$status" -eq 0 ]]

    # test global assignment
    smbcopy $PWD mytest
    [[ "$r" -eq 0 ]]

    rm -f mytest
}

# mock notifier
notify-send() {
    echo "$@"
}

@test "notify" {
    g=0
    r=0
    run notify dir filename
    regexp="[^']+'filename' --icon=dialog-information"
    [[ "$output" =~ $regexp ]] 

    g=1
    r=0
    run notify dir filename
    regexp="[^']+'filename' --icon=dialog-error"
    [[ "$output" =~ $regexp ]] 

    g=0
    r=1
    run notify dir filename
    [[ "$output" =~ $regexp ]] 

    g=1
    r=1
    run notify dir filename
    [[ "$output" =~ $regexp ]] 

    # auto remove tmp file on success
    g=0
    r=0
    tmp=/tmp/bats_file$$
    echo "tmp$$" > $tmp
    fname=$(basename $tmp)
    run notify /tmp $fname
    regexp="[^']+'$fname' --icon=dialog-information"
    [[ "$output" =~ $regexp ]] 
    [[ ! -e $tmp ]]
}
