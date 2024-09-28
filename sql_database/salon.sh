#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
    if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

echo -e "\nWelcome to My Salon, how can I help you?\n"
SERVICE_ID=$($PSQL "select * from services;")
echo "$SERVICE_ID" | while read NUMBER BAR NAME
do
  echo -e "$NUMBER) $NAME"
done
read SERVICE_ID_SELECTED
#if no number
if [[ ! "$SERVICE_ID_SELECTED" =~ ^[1-5]$ ]]
then
  #repeat services
    echo -e "\nI could not find that service. What would you like today?"
    echo "$SERVICE_ID" | while read NUMBER BAR NAME
    do
      echo -e "$NUMBER) $NAME"
    done
    read SERVICE_ID_SELECTED
fi

#ask for phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
#if empty
if [[ -z $CUSTOMER_ID ]]
  then
  #ask for name
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  ENTER_NAME=$($PSQL "INSERT INTO customers(phone, name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
fi
#ask for time
if [[ -z $CUSTOMER_NAME ]]
  then
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
fi
echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME
SERVICE_INPUT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
#exit
SERVICE=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED';")
echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

}


MAIN_MENU