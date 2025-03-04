#!/bin/bash

# .sp extension = "script part"
# basically, we're breaking PlymouthXP into several parts
# for ease of development

SCRIPT_PARTS_DIR="./src"
FILES="boot.sp bootmgr.sp stringutils.sp shutdown.sp main.sp"
OUTPUT="PlymouthVista.script"

rm $OUTPUT
cd $SCRIPT_PARTS_DIR
cat $FILES > ../$OUTPUT

echo "Done compilation"
