#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#no arg
if [[ -z $1 ]]
then
echo Please provide an element as an argument.
exit
fi

# check exist element
EXIST_ELEMENT=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1 OR symbol = '$1' OR name = '$1'")

# element not found
  if [[ -z $EXIST_ELEMENT ]]
  then
  echo I could not find that element in the database.
  else

$ARG="$1"
# get atomic_number
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ARG OR symbol = '$ARG' OR name = '$ARG'")
# get name
ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ARG OR symbol = '$ARG' OR name = '$ARG'")
# get symbol
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ARG OR symbol = '$ARG' OR name = '$ARG'")
# get type
TYPE=$($PSQL "SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
# get mass
MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
# get melting point
MELT_P=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
# get boiling point
BOIL_P=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
  # msg
echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
  fi
