#!/bin/bash
 
CARDS=$(pacmd list-cards | grep -e index: -e alsa.card_name  | xargs -n5 | awk '{print $2}')

if [[ ${#CARDS} != 3 ]];  # there is a space 
then
    echo "This script works only with 2 outputs, and you have ..."
    pacmd list-cards | grep -e index: -e alsa.card_name  | xargs -n5 
    exit
fi
 
i=1
for card_index in $CARDS ; 
do 
    eval CARD$i=$card_index 
    let i+=1
        
done
 
LAST_SINK_LINE=$(pacmd list-sink-inputs | grep -e index: -e sink: | xargs -n5 | tail -n1)
last_sink_app_index=$( echo $LAST_SINK_LINE | awk '{print $2}' )
last_sink_out_index=$( echo $LAST_SINK_LINE | awk '{print $4}' )
[[ ${last_sink_out_index} == ${CARD1} ]] && new_sink_out=$CARD2 || new_sink_out=$CARD1
 
#echo "$last_sink_app_index > $last_sink_out_index > ${new_sink_out}"
 
pacmd move-sink-input ${last_sink_app_index} ${new_sink_out}
