#!/bin/bash

df -a > temp.disk
less temp.disk
rm temp.disk
