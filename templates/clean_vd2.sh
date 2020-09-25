#!/bin/bash

find {{ indexima_path }}/visualdoop2/lib -name '*\.jar' -type f -delete
find {{ indexima_path }}/visualdoop2/driver -name '*\.jar' -type f -delete
find {{ indexima_path }}/visualdoop2 -name 'visualdoop2*\.war' -type f -delete
