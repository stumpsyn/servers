#!/bin/bash
# Run this script on a new instance of the etherpad-lite server, with the old IP as an argument.

host=$1

ssh ${host} "sudo -u postgres pg_dump -C -c etherpad | bzip2" | bunzip2 | sudo -u postgres psql etherpad
