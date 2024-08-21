#!/bin/bash
env_file="secret.env"
if [ -f $env_file ]; 
then
    export $(grep -v '^#' secret.env | xargs)
else
    echo "GITLAB_SOURCE_TOKEN=''" >> $env_file
    echo "please provide credentials in a totally secure file (${env_file}) (already created)"
fi