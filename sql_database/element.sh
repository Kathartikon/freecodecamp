PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ELEMENTS=$($PSQL "select name from elements")
SYMBOLS=$($PSQL "select symbol from elements")


if [[ -z $1 ]] 
  then
  echo -e "Please provide an element as an argument."
  #input number
  elif [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 1 ] && [ "$1" -le 10 ]
  then
  ELEMENT=$($PSQL "select name from elements where atomic_number=$1")
  SYMBOL=$($PSQL "select symbol from elements where atomic_number=$1")
  TYPE=$($PSQL "select type from types full join properties using(type_id) where atomic_number=$1;")
  MASS=$($PSQL "select atomic_mass from types full join properties using(type_id) where atomic_number=$1;")
  MELT=$($PSQL "select properties.melting_point_celsius from properties full join types using(type_id) where atomic_number=$1;")
  BOIL=$($PSQL "select properties.boiling_point_celsius from properties full join types using(type_id) where atomic_number=$1;")
  echo -e "The element with atomic number $1 is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  #input letter
  elif [[ $(echo ${SYMBOLS[@]} | fgrep -w $1) ]]
  then
  ELEMENT=$($PSQL "select name from elements where symbol='$1'")
  ATOM_NR=$($PSQL "select atomic_number from elements where symbol='$1'")
  TYPE=$($PSQL "select type from types full join properties using(type_id) full join elements using(atomic_number)  where symbol='$1';")
  MASS=$($PSQL "select atomic_mass from types full join properties using(type_id) full join elements using(atomic_number)  where symbol='$1';")
  MELT=$($PSQL "select properties.melting_point_celsius from properties full join types using(type_id) full join elements using(atomic_number) where symbol='$1';")
  BOIL=$($PSQL "select properties.boiling_point_celsius from properties full join types using(type_id) full join elements using(atomic_number) where symbol='$1';")
  echo -e "The element with atomic number $ATOM_NR is $ELEMENT ($1). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  #input element
  elif [[ $(echo ${ELEMENTS[@]} | fgrep -w $1) ]]
  then
    SYMBOL=$($PSQL "select symbol from elements where name='$1'")
    ATOM_NR=$($PSQL "select atomic_number from elements where name='$1'")
    TYPE=$($PSQL "select type from types full join properties using(type_id) full join elements using(atomic_number)  where name='$1';")
    MASS=$($PSQL "select atomic_mass from types full join properties using(type_id) full join elements using(atomic_number)  where name='$1';")
    MELT=$($PSQL "select properties.melting_point_celsius from properties full join types using(type_id) full join elements using(atomic_number)  where name='$1';")
    BOIL=$($PSQL "select properties.boiling_point_celsius from properties full join types using(type_id) full join elements using(atomic_number)  where name='$1';")
    echo -e "The element with atomic number $ATOM_NR is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

  #alternative input
  else
  echo -e "I could not find that element in the database."
fi




