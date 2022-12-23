#! /bin/bash

#PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~ Isra's Barber Shop ~~"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWhich service would you like to schedule?"
  
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | sed 's/|/ /g' | while read SERV_ID SERV_N
  do
    echo "$SERV_ID) $SERV_N"
  done
  echo "4) Exit"
  
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) CUT ;;
  2) SHAVE ;;
  3) WASH ;;
  4) EXIT ;;
  *) MAIN_MENU "Please enter a valid option"
  esac
}

CUT() {
  CUSTOMER_DATA
  SERVICE_TIME
  INSERT_APPOINTMENT
  CONFIRMATION
}

SHAVE() {
  CUSTOMER_DATA
  SERVICE_TIME
  INSERT_APPOINTMENT
  CONFIRMATION
}

WASH() {
  CUSTOMER_DATA
  SERVICE_TIME
  INSERT_APPOINTMENT
  CONFIRMATION
}

EXIT() {
  echo -e "\nThank you for using our services."
}

NEW_CUSTOMER() {
  echo New customer
}

CUSTOMER_DATA() {
  # Ask for phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # Verify if there is a customer name for that number
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # If customer doesnt exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Get new customer's name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # Insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
}

SERVICE_TIME() {
  echo -e "\nWhat time would you like this service to be scheduled?"
  read SERVICE_TIME
}

INSERT_APPOINTMENT() {
  # Get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
}

CONFIRMATION() {
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
