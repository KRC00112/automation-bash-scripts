#!/bin/bash

addresses=("kaustav2038" "kaustav2138")

for addr in ${addresses[@]}
do
  echo "See attached file." | mail -s "Hi $addr" -A attachment.txt $addr@gmail.com
  sleep 5
done

echo "all mails sent"
