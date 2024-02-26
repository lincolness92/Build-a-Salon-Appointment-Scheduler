#! /bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you??\n"

FIRST_PROMPT(){

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT * FROM services")
  IFS='|'
  echo "$SERVICES" | while read S_ID S_NAME
  do
    S_IDF=$(echo "$S_ID" | sed -r 's/^ *| *$//g')
    S_NAMEF=$(echo "$S_NAME" | sed -r 's/^ *| *$//g')
    echo "$S_IDF) $S_NAMEF"
  done
  read SERVICE_ID_SELECTED
  if [[ ! ($SERVICE_ID_SELECTED =~ ^[1-5]$) ]]
  then
    FIRST_PROMPT "I could not find that service. What would you like today?" 
  fi
}

MAIN_MENU() {

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  PHONE_TEST=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $PHONE_TEST ]]
  then
    # ask for name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # add to customers
    INSERT_NEW_CUSTOMER=$(psql -X --username=freecodecamp --dbname=salon -t -c "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | sed -r 's/^ *| *$//g')
    SERVICE_NAME=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    SERVICE_NAME=$(echo "$SERVICE_NAME" | sed -r 's/^ *| *$//g')
    CUSTOMER_ID=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$(psql -X --username=freecodecamp --dbname=salon -t -c "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    CUSTOMER_NAME=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | sed -r 's/^ *| *$//g')
    SERVICE_NAME=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    SERVICE_NAME=$(echo "$SERVICE_NAME" | sed -r 's/^ *| *$//g')
    CUSTOMER_ID=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$(psql -X --username=freecodecamp --dbname=salon -t -c "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

FIRST_PROMPT
MAIN_MENU