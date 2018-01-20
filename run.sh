#!/bin/bash
recollindex -x
DEBUG="*" pm2 start /opt/explorer/index.js -i 0 
recollindex -m -x -D
