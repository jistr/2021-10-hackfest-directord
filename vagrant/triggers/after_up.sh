#!/bin/bash

set -eu

mkdir -p env
vagrant ssh-config > env/ssh-config
