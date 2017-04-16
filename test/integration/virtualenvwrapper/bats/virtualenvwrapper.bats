#!/usr/bin/env bats

@test "virtualenvwrapper.sh should exist" {
    [ -f "/usr/bin/virtualenvwrapper.sh" ]
}

@test "init_virtualenvwrapper.sh should exist" {
    [ -f "/usr/local/bin/init_virtualenvwrapper.sh" ]
}