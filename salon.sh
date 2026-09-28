#! /bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"

PSQL="psql --username=freecodecamp --dbname=salon -t -A -c"

echo "Welcome to My Salon!"

echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"

echo -e "\nWhat service would you like? "
read SERVICE_ID_SELECTED

SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

while [[ -z $SERVICE_EXISTS ]]
do
  echo -e "\nThat service is not available. Please choose a service:"
  echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
  read SERVICE_ID_SELECTED
  SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\nI don't have a record for that phone number. What's your name?"
  read CUSTOMER_NAME

  $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
fi

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo -e "\nWhat time would you like your appointment?"
read SERVICE_TIME

$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
