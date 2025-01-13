#!/usr/bin/env bash

home=~
dt=$(date '+%Y%m%dT%H%M')
LogFile="$home/tmp/logs/NicReg_${dt}.log"
touch $LogFile

echo "******** Start `date` ********" >> $LogFile

pushd ~/Projects/Programming/BashScript/CigeRegiC/
echo >> $LogFile
. nuke-and-sync main >> $LogFile
echo >> $LogFile
echo "***Open NicReg Spreadsheet***" | tee -a $LogFile
echo >> $LogFile
if [ "`uname`" = 'Linux' ]
then
  xdg-open NicReg.ods 2>/dev/null&
  sleep 10
  echo "***Waiting for spreadsheet to close..." | tee -a $LogFile
  until [ `ps a | grep -c -e "[N]icReg.ods"` -eq 0 ];
  do
    sleep 2
  done
else
  /c/Program\ Files/LibreOffice/program/soffice.exe /c/Users/mike/Projects/Programming/BashScript/CigeRegiC/NicReg.ods
fi
echo "***Continuing***" | tee -a $LogFile
sleep 3 
echo >> $LogFile
echo "***git status***" | tee -a $LogFile
git status >> $LogFile
echo >> $LogFile
echo "***git commit -a -m \"Update `date`\"***" | tee -a $LogFile
git commit -a -m "Update `date`" >> $LogFile

# Keep pushing until successful
while :
do
  echo >> $LogFile
  echo "***git status***" | tee -a $LogFile
  git status >> $LogFile
  echo >> $LogFile
  echo "***git push***" | tee -a $LogFile
  git push >> $LogFile
  echo >> $LogFile
  echo "***git log***" | tee -a $LogFile
  git log --decorate --oneline -1 | tee -a $LogFile
  read -n 1 -p "Press any key to CONTINUE..." -t 10
  echo >> $LogFile
  if [ $REPLY ]
  then
    exit 1
  fi
  echo >> $LogFile
  echo "*** Checking for successful push***" | tee -a $LogFile
  git log --decorate --oneline -1 | grep '(HEAD -> main, origin/main, origin/HEAD)' >> $LogFile
  if [ $? == 0 ]
  then
    break
  fi
done
echo >> $LogFile
echo >> $LogFile

echo "******** End `date` ********" >> $LogFile
