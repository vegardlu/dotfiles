#!/usr/bin/env bash

rm -rv ~/jetty/template
mkdir -pv ~/jetty
mkdir -pv ~/jetty/template
cp -vf jetty/srv-adm-jetty.sh ~/jetty/template/srv-adm.sh
cp -vf jetty/start-jetty.ini ~/jetty/template/start.ini
