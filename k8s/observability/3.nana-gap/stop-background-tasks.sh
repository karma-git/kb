#!/bin/bash

for i in $(ps | grep kubectl | head -n5 | awk '{print $1}')
    do kill ${i}
done
