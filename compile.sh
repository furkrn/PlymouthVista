#!/bin/bash

# .sp extension = "script part"
# basically, we're breaking PlymouthXP into several parts
# for ease of development

SCRIPT_PARTS_DIR="./src"
FILES="bootlegacy.sp boot7.sp bootmgr.sp plymouth_config.sp stringutils.sp wupdate.sp shutdown.sp vistaresume.sp main.sp"
OUTPUT="PlymouthVista.script"

if [[ -f $OUTPUT ]]; then
    rm $OUTPUT
fi


cd $SCRIPT_PARTS_DIR
cat $FILES > ../$OUTPUT

echo "Done compilation"
