#!/usr/bin/env bash

rm -rv ~/jetty/template
mkdir -v ~/jetty 
mkdir -v ~/jetty/template 
cp -vf srv-adm-jetty.sh ~/jetty/template/srv-adm.sh
cp -vf start-jetty.ini ~/jetty/template/start.ini
