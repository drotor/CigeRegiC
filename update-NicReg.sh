#!/usr/bin/env bash

pushd /home/mike/Projects/Programming/BashScript/CigeRegiC/
echo
echo "***git stash push***"
git stash push
echo
echo "***git fetch***"
git fetch
# need to check for sucess
if [ $? != 0 ]
then
  echo Fetch FAILED\!\!\!
  exit 1
fi
echo
echo "***git status***"
git status
echo
echo "***git rebase***"
git rebase
echo
echo "***git status***"
git status
echo
echo "***git log***"
git log -1
echo
echo "*** Checking for successful rebase***"
git log --decorate --oneline -1 | grep 'HEAD -> main' | grep origin
if [ $? != 0 ]
then
  echo Rebase FAILED\!\!\!
  exit 2
fi
echo
echo "***xdg-open NicReg.ods***"
echo
xdg-open NicReg.ods 2>/dev/null
sleep 10
echo "***Waiting for spreadsheet to close..."
until [ `ps a | grep -c -e "[N]icReg.ods"` -eq 0 ];
do
  sleep 2
done
echo "***Continuing***"
sleep 3 
#read -n 1 -p "Press any key to continue..."
echo
echo "***git status***"
git status
echo
echo "***git commit -a -m \"Update `date`\"***"
git commit -a -m "Update `date`"

# Keep pushing until successful
while :
do
  echo
  echo "***git status***"
  git status
  echo
  echo "***git push***"
  git push
  echo
  echo "***git log***"
  git log --decorate --oneline -1
  read -n 1 -p "Press SPACE to CONTINUE, any other letter key to QUIT..." -t 15
  echo
  if [ $REPLY ]
  then
    exit 1
  fi
  echo
  echo "*** Checking for successful push***"
  git log --decorate --oneline -1 | grep 'HEAD -> main' | grep origin
  if [ $? == 0 ]
  then
    break
  fi
done
echo
echo "***git stash list***"
git stash list|grep 'stash@'
if [ $? == 0 ]
then
  echo
  echo "***git stash show***"
  git stash show
  read -n 1 -p "Press SPACE to LEAVE stash, any other letter key to CLEAR stash..." -t 15
  echo
  if [ $REPLY ]
  then
    echo
    echo "***git stash clear***"
    git stash clear
  fi
fi
echo
echo
