#!/bin/bash

gcc movacg.c -o movavg -lm

echo "export PATH="$PATH:$(pwd)"" >> ~/.bashrc
