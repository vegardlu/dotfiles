#!/usr/bin/env bash

rm -rv ~/.compiled-exports
echo "export JETTY_HOME=$(brew --cellar jetty)/$( brew list --versions jetty | tr ' ' '\n' | tail -1)/libexec" >> ~/.compiled-exports
