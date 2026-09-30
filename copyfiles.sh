#!/usr/bin/env bash

mkdir -p ~/.config/micro/

cp /etc/micro.bindings.json ~/.config/micro/bindings.json.bckp
cp /etc/micro.settings.json ~/.config/micro/settings.json.bckp
cp /etc/inputrc.local ~/.inputrc.bckp

chmod 644 ~/.config/micro/*
