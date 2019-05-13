#!/usr/bin/env bash

rm -rv ~/jetty/template 
mkdir -v ~/jetty/template 
cp -vf srv-adm-jetty.exclude.sh ~/jetty/template/srv-adm.sh
cp -vf start-jetty.exclude.ini ~/jetty/template/start.ini
