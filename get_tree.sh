#!/bin/sh

tree -d $1 --charset ascii | grep -v "file_restart" | grep -v "test" > $2
