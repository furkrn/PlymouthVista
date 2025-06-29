#!/bin/bash
FONT_SIZE=18
FONT="Segoe-UI"
SCRIPT_FILE="PlymouthVista.script"  

config_keys=("ShutdownText" "UpdateTextMTL" "RebootText" "LogoffText")
declare -A config_values

if ! [ -f $SCRIPT_FILE ] ; then
    echo "No PlymouthVista.script found! Make sure to run this after compilation."
    exit 1
fi

if [[ ! -f "pv_conf.sh" ]]; then
    echo "No pv_conf.sh found! Stopping!"
    exit 1
fi

for key in ${config_keys[@]}; do
    config_values[$key]=$(./pv_conf.sh -g $key)
done

unformattedText=${config_values["UpdateTextMTL"]}

for i in {0..100}; do
    key="Update$i"
    value=$(echo $unformattedText | sed "s/"%i"/$i/g")
    config_values["$key"]="$value"
done

unset config_values["UpdateTextMTL"]

echo "Generating blur effects..."

for key in "${!config_values[@]}"; do
    value=${config_values[$key]}

    dimensions=$(magick -density 96 -font "$FONT" -pointsize "$FONT_SIZE" label:"$value" \
    -format "%[fx:w+27]x%[fx:h+27]" info:)

    [[ $key == *"Update"* ]] && pos="center" || pos="northwest"
    [[ $key == *"Update"* ]] && ofs="+0+0" || ofs="+0+1"

    magick -density 96 -size "$dimensions" xc:none \
      -font "$FONT" -pointsize "$FONT_SIZE" \
      -fill "rgba(0,0,0,0.8)" \
      -gravity $pos \
      -annotate $ofs "$value" \
      -blur 0x2 \
      -channel A -evaluate multiply 0.8 +channel \
      -trim +repage "./images/blur$key.png"
done

echo "Done."