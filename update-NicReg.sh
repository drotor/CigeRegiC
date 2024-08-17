#!/usr/bin/env bash

dt=$(date '+%Y%m%dT%H%M')
LogFile="/home/mike/tmp/logs/NicReg_${dt}.log"
touch $LogFile

echo "******** Start `date` ********" >> $LogFile

pushd /home/mike/Projects/Programming/BashScript/CigeRegiC/
echo >> $LogFile
echo "***git stash push***" | tee -a $LogFile
git stash push >> $LogFile
echo >> $LogFile
echo "***git fetch***" | tee -a $LogFile
git fetch >> $LogFile
# need to check for success
if [ $? != 0 ]
then
  echo Fetch FAILED\!\!\! | tee -a $LogFile
  exit 1
fi
echo >> $LogFile
echo "***git status***" | tee -a $LogFile
git status >> $LogFile
echo >> $LogFile
echo "***git rebase***" | tee -a $LogFile
git rebase >> $LogFile
echo >> $LogFile
echo "***git status***" | tee -a $LogFile
git status >> $LogFile
echo >> $LogFile
echo "***git log***" | tee -a $LogFile
git log -1 >> $LogFile
echo >> $LogFile
echo "*** Checking for successful rebase***" | tee -a $LogFile
git log --decorate --oneline -1 | grep 'HEAD -> main' | grep origin
if [ $? != 0 ]
then
  echo Rebase FAILED\!\!\! | tee -a $LogFile
  exit 2
fi
echo >> $LogFile
echo "***xdg-open NicReg.ods***" | tee -a $LogFile
echo >> $LogFile
xdg-open NicReg.ods 2>/dev/null
sleep 10
echo "***Waiting for spreadsheet to close..." | tee -a $LogFile
until [ `ps a | grep -c -e "[N]icReg.ods"` -eq 0 ];
do
  sleep 2
done
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
  read -n 1 -p "Press SPACE to CONTINUE, any other letter key to QUIT..." -t 15
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
echo "***git stash list***" | tee -a $LogFile
git stash list | tee -a $LogFile
git stash list|grep 'stash@'
if [ $? == 0 ]
then
  echo >> $LogFile
  echo "***git stash show***" | tee -a $LogFile
  git stash show | tee -a $LogFile
  read -n 1 -p "Press SPACE to LEAVE stash, any other letter key to CLEAR stash..." -t 15
  echo >> $LogFile
  if [ $REPLY ]
  then
    echo >> $LogFile
    echo "***git stash clear***" | tee -a $LogFile
    git stash clear | tee -a $LogFile
  fi
fi
echo >> $LogFile
echo >> $LogFile

echo "******** End `date` ********" >> $LogFile
