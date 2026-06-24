#!/bin/bash

function mb_to_gb(){
  gb=$( echo "scale=2; $1/1024" | bc -l )
  echo $gb
}

function memory_usage(){
  memory_used=$( free -m | awk -F' ' '/Mem:/ {print $3}')
  echo Memory Used: $( mb_to_gb $memory_used ) GB

  memory_available=$( free -m | awk -F' ' '/Mem:/ {print $7}')
  echo Memory Available: $( mb_to_gb $memory_available ) GB

  memory_total=$( free -m | awk -F' ' '/Mem:/ {print $2}')
  memory_used_pct=$( echo "scale=2; ($memory_used/$memory_total)  * 100" | bc -l )
  echo Memory Usage: $memory_used_pct%

}

function cpu_usage(){
  cpu_usage_idle=$( top -bn1 | awk -F',' '/%Cpu/ {print $4}')
  idle_cpu_cleaned=${cpu_usage_idle:0:-3}
  cpu_used=$( echo "scale=2; 100 - $idle_cpu_cleaned" | bc -l )
  echo CPU Usage: $cpu_used%
}

function uptime(){
  load_average=$( command uptime | awk -F',  ' '{print $3}' | sed 's/,/ /g; s/l/L/; s/a/A/2')
  sys_uptime=$( command uptime | awk -F',  ' '{print $1}')
  echo $load_average
  echo Uptime: $sys_uptime
}

function active_services(){
  service_arr=("nginx" "postgresql")

  for service in ${service_arr[@]}
  do
    if systemctl is-active --quiet $service
    then
       echo -n "✓ "
    else
       echo -n "✗ "
    fi
   echo $service
  done
}

function main(){
  echo "SYSTEM MONITOR REPORT" 
  echo "=============================="
  echo User: $( whoami )
  echo Hostname: $( hostname )
  echo "=============================="
  echo "Active Services: "
  active_services
  echo "=============================="
#  while true
 # do
    cpu_usage
    memory_usage
    uptime
    echo "=============================="
  #  sleep 1
 # done
}

report_date=$( date )
main | mail -s "System Monitor Report - $report_date"  kaustav2038@gmail.com

