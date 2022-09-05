#!/bin/bash
for ((i=1;i<9999;i++))
do  
date
echo -e "\033[43;31m开始运行第 "$i " 次 \033[0m"


ADDRESS=$(forta account address 2>&1)
EXPIRE=0.9  # sla 低于 0.9 开始做操作

COMMAND=$(curl -s -H "content-type: application/json" \
    https://api.forta.network/stats/sla/scanner/${ADDRESS})
STARTTIME=$(echo $COMMAND | jq ".startTime")
ENDTIME=$(echo $COMMAND | jq ".endTime")
STAT=$(echo $COMMAND | jq ".statistics")
MIN=$(echo $STAT | jq ".min")
AVG=$(echo $STAT | jq ".avg")
echo "---current sla, min: $MIN, avg: $AVG------------"
if [ `echo "$EXPIRE > $AVG" | bc` -eq 1 ];
then

    # 重启命令
   echo "SLA = $AVG , Less than 0.9, restart NOW! "
   
    systemctl restart forta
else
   echo "SLA = $AVG , No need restart! "
fi

echo -e "\033[43;31m第 "$i " 次运行完毕，现在休息15分钟 \033[0m"


echo "\n100 update complete"
sleep 15m
done


