#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

LIST_OF_SERVICES=$($PSQL "SELECT * FROM services;")
echo "$LIST_OF_SERVICES"

MAIN_MENU()
{
if [[ $1 ]]
then
	echo -e "\n$1\n"
fi

echo -e "\n~~~~~~Welcome to our salon~~~~~\n"
echo -e "\n Here are our differents services\n Would you like to have a :\n"
echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
	echo -e "$SERVICE_ID) $SERVICE_NAME\n"
done
echo -e "4) EXIT"

read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
	1|2|3) APPOINTMENT_MENU ;;
	4) EXIT ;;
	*) MAIN_MENU "Please enter a number corresponding to one of the options" ;;
esac
}

APPOINTMENT_MENU()
{
echo -e "What's your phone number ?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

if [[ -z $CUSTOMER_NAME ]]
then
	echo -e " \nWhat's your name ?\n"
	read CUSTOMER_NAME
	INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
fi


CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$(echo $CUSTOMER_NAME | sed 's/ //g')';")
echo $CUSTOMER_ID

echo -e "\nHappy to see you $CUSTOMER_NAME at what time would you like your appointment ?\n"
read SERVICE_TIME

APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"

}

EXIT()
{
	echo -e "\nThank you for stoping by :)\n"
}

MAIN_MENU
