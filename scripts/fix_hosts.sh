#!/usr/bin/env bash

DOMAIN='cdh.hadoop'

for HOST in `cat hostlist.txt`
do
  NEW_IP=`aws ec2 describe-instances --output table --filters Name=tag:Name,Values=${HOST} | grep PublicIpAddress | awk -F'|' '{print $5}' | sed 's/ *//'`
  echo $HOST $NEW_IP
  grep -q $HOST.$DOMAIN /etc/hosts
  if [ "$?" -eq "1" ]
  then
    printf "$NEW_IP    $HOST.$DOMAIN\n" | sudo tee -a /etc/hosts
  else
    sudo sed -i -e "s/^.*$HOST.$DOMAIN/$NEW_IP    $HOST.$DOMAIN/" \
      /etc/hosts
  fi
done
