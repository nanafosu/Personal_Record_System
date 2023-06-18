#!/bin/bash

length=12

password=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$length")

echo "Generated password: $password"

