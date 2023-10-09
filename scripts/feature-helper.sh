# !/bin/bash
success(){
  local GREEN='\033[0;32m'
  local NC='\033[0m' # No Color
  printf "${GREEN}${1}${NC}\n"
}
log () {
    local YELLOW='\033[0;33m'
    local NC='\033[0m' # No Color
    printf "${YELLOW}${1}${NC}\n"
}
error () {
    local RED='\033[0;31m'
    local NC='\033[0m' # No Color
    printf "${RED}${1}${NC}\n"
    exit 1
}
generateMongoPlayground () {
  local BRANCH_NAME=$1
  local MONGO_FILE=$2
  success "Creating db playground"
  success "// BRANCH  ${BRANCH_NAME}
// Select the database to use.
// use('yoobic-logs');
// use('yoobic-dev');
use('yoobic-dev');

db.getCollection('user').find({}).limit(10)
  " >> ${MONGO_FILE}
}
generateTaskFile () {
  local BRANCH_NAME=$1
  local TICKET=$2
  local NAME=$3
  local TASK_FILE=$4
  success "Creating task file"
  success "# ${TICKET} ${NAME}
## Description
### Ticket https://yoobic.atlassian.net/browse/${TICKET}

### Branch
  - ${BRANCH_NAME}
## Pull requests
  - 
### RA
  - 
  - 
" >> ${TASK_FILE}
}
generateHttpFile () {
  success "Creating http file"
  touch $HTTP_FILE 
}

success "Running feature helper script"

TICKET_NUMBER=$1
if [ -z $TICKET_NUMBER ]
then
    error "No ticket number provided"
fi

VAULT='~/Library/CloudStorage/GoogleDrive-petr.tzur.nazarov@gmail.com/My\ Drive/Obsidian/Vault'
TICKET=be-${TICKET_NUMBER}
MONGO_FILE=${VAULT}/Files/TicketFiles/${TICKET}/mongo/${TICKET}.mongodb
HTTP_FILE=${VAULT}/Files/TicketFiles/${TICKET}/curl/${TICKET}.http
GIT_BRANCH_FILE=${VAULT}/Files/TicketFiles/${TICKET}/.gitbranch
# making sure all folders exist
mkdir -p ${VAULT}/Files/TicketFiles/${TICKET}/mongo
mkdir -p ${VAULT}/Files/TicketFiles/${TICKET}/http

if [[ ! -f $GIT_BRANCH_FILE ]]
then
    success "No files found for ticket ${TICKET}. Creaticng task boilerplate"
    log "Is it a bugfix or a feature? (fix, feat)"
    read TYPE
    if [ $TYPE != "feat" ] && [ $TYPE != "fix" ]; then
      error "Invalid type. Please type feat or fix"
    fi
    log "Please provide short description for the ticket"
    read NAME
    BRANCH_NAME=${TYPE}-${TICKET}-${NAME}
    TASK_FILE=${VAULT}/Zettelkasten/Tasks/${TICKET}-${NAME}.md
    echo ${BRANCH_NAME} >> ${GIT_BRANCH_FILE}
    generateMongoPlayground ${BRANCH_NAME} ${MONGO_FILE}
    generateTaskFile ${BRANCH_NAME} ${TICKET} ${NAME} ${TASK_FILE}
    generateHttpFile ${HTTP_FILE}
else
    success "Task file found for ticket ${TICKET}. Switching context"
    BRANCH_NAME=$(cat ./feature-helper/${TICKET}/.git-branch)
fi
#git switch -c ${BRANCH_NAME}


#code ${HTTP_FILE} 
#code  ${MONGO_FILE}
