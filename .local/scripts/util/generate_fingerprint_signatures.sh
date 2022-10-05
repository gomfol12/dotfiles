#!/bin/bash

fprintd-delete "$USER"
for finger in {left,right}-{index,middle}-finger; do fprintd-enroll -f "$finger" "$USER"; done
