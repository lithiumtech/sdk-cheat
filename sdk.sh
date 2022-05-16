#!/bin/bash
# svn new site script with site name input
set -o nounset

# Your path to services-sdk
SSDK="/dev/services-sdk/"

# if you want to change colors, this lists their numerical codes and outputs the color
# for (( i = 0; i < 17; i++ )); do echo "$(tput setaf $i)This is ($i) $(tput sgr0)"; done
RED=$(tput setaf 9)
ROUGE=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 14)
PINK=$(tput setaf 13)
YELLOW=$(tput setaf 3)
NC=$(tput sgr0) #no color / reset

USAGE="sdk <site.phase> <PSD-xxxxx or xxxxxx>"
sitePhase=""
jiraTicket=""
prevConfig="false"
sitePattern1="^([A-z0-9])*\.stage*$"
sitePattern2="^([A-z0-9])*$"
jiraPattern1="^[0-9]*$"
jiraPattern2="^(PSD-)*[0-9]*$"
value=$(<last_sdk_cmd.txt)
q="n"

echo -e "\n${BLUE}Starting Services-SDK script"
if [ value ]; then
  while read -r line; do
    if [[ $line =~ $sitePattern1 ]]; then
      sitePhase=$line
    elif [[ $line =~ $sitePattern2 ]]; then
      sitePhase="${line}.stage"
    elif [[ $line =~ $jiraPattern1 ]]; then
      jiraTicket="PSD-$line"

    elif [[ $line =~ $jiraPattern2 ]]; then
      jiraTicket="$line"
    fi
  done <last_sdk_cmd.txt
fi

if [ $# -lt 2 ]; then
  if [ prevConfig != "false" ]; then
    read -n1 -p "Did you want to use the previous configs, ${PINK}gulp --config=\"${sitePhase}\" --jira=\"${jiraTicket}\"${NC} []y/n]? " q
    echo "Y/N = ${q}"
    case $q in
    y | Y)
      echo "${GREEN}gulp --config=\"${sitePhase}\" --jira=\"${jiraTicket}\""
      cd ~/dev/services-sdk
      gulp --config="${sitePhase}" --jira="${jiraTicket}"
      ;;
    n | n)
      echo "no"
      echo "Enter ${PINK}${USAGE}${NC}"
      read -p "?" s
      echo "${GREEN}gulp --config=\"${sitePhase}\" --jira=\"${jiraTicket}\""
      cd ~/dev/services-sdk
      gulp --config="${sitePhase}" --jira="${jiraTicket}"
      ;;
    *)
      echo "Enter ${PINK}${USAGE}${NC}"
      read -p "?" s
      echo "${GREEN}gulp --config=\"${sitePhase}\" --jira=\"${jiraTicket}\""
      cd ~/dev/services-sdk
      gulp --config="${sitePhase}" --jira="${jiraTicket}"
      ;;
    esac
  fi

  if [ $# -lt 1 ]; then
    echo "${RED}Missing arguments, usage must be ${PINK}${USAGE}"
    exit
  fi
  echo "${RED}Missing second argument: Jira ticket. Usage must be ${PINK}${USAGE}"
  exit
fi

if [[ $1 =~ $sitePattern1 ]]; then
  #echo "sitePattern1 ${1}"
  echo -e "${BLUE}Site structure has been modified to ${1}.stage${NC}"
elif [[ $1 =~ $sitePattern2 ]]; then
  #echo "sitePattern2 ${1}"
  #echo "sitePhase=${1}"
  sitePhase="${1}.stage"
  #echo "sitePhase2=${sitePhase}"
  echo -e "        ${YELLOW}Site is: ${PINK}${sitePhase}${NC}"
else
  echo -e "\n >>> ${RED}Bad site pattern, must be ${PINK}${USAGE}${NC}\n"
fi

if [[ $2 =~ $jiraPattern1 ]]; then
  jiraTicket="PSD-${2}"
  echo -e "        ${YELLOW}Jira Ticket is: ${PINK}${2} => ${jiraTicket}${NC}"
elif [[ $2 =~ $jiraPattern2 ]]; then
  jiraTicket=$2
  echo -e "        ${YELLOW}Jira TIcket is: ${PINK}${jiraTicket}${NC}"
fi

printf "gulp --config=\"${sitePhase}\" --jira=\"${jiraTicket}\"" >last_sdk_cmd.txt

cd ~/$SSDK || exit
echo -e "\nNow changing directory to ${YELLOW}$(pwd)${NC}\n"
echo -e "${BLUE}Starting Services-SDK:\n ${YELLOW}gulp --config=\"${sitePhase}\" --jira=\"${jiraTicket}\"${NC}"

# printf "The last SSDK command was ${YELLOW} gulp --config=\"${sitephase}\" --jira=\"${psd}\""
printf "${sitePhase}\n""${jiraTicket}\n" >~/dev/last_sdk_cmd.txt

gulp --config="${sitePhase}" --jira="${jiraTicket}"
