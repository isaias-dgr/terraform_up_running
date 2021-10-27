#!/bin/bash

echo "Hola Mundo" > index.html
nohup busybox httpd -f -p 8080 &