#!/bin/bash
awk '/--/{i++}{print > ("split."i)}' $1
ls | awk '/split\.[0-9]+/'
