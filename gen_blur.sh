#!/bin/bash
font_size=18
font="Segoe-UI"
script_file="PlymouthVista.script"
declare -A config_values

if ! [ -f $script_file ] ; then
    echo "No PlymouthVista.script found! Make sure to run this after compilation."
fi

config_lines=$(sed -n '/# START_GEN_BLUR/,/# END_GEN_BLUR/p' "$script_file")

clean_lines=$(echo "$config_lines" | \
    sed -e 's/\/\/.*$//' -e 's/#.*$//' -e 's/^\s*//;s/\s*$//' | \
    grep -v '^\s*$')

while read -r line; do
    if [[ "$line" =~ global\.([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*\"(.*)\"[[:space:]]*\;? ]]; then
        key="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        config_values["$key"]="$value"
    fi
done <<< "$clean_lines"

for key in "${!config_values[@]}"; do
    value=${config_values[$key]}
    echo "Generating blur effect for $key : $value"

    dimensions=$(magick -density 96 -font "$font" -pointsize "$font_size" label:"$value" \
    -format "%[fx:w+27]x%[fx:h+27]" info:)

    magick -density 96 -size "$dimensions" xc:none \
      -font "$font" -pointsize "$font_size" \
      -fill "rgba(0,0,0,0.8)" \
      -gravity northwest \
      -annotate +0+1 "$value" \
      -blur 0x2 \
      -channel A -evaluate multiply 0.8 +channel \
      -trim +repage "./images/blur$key.png"
done
