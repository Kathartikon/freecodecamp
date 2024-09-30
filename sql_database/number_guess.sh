#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

LIST_USERS=$($PSQL "select name from user_info")

echo -e "Enter your username:"
read USERNAME

if [[ $(echo ${LIST_USERS[@]} | fgrep -w $USERNAME) ]]
  then
  #if user already in db
  BEST_GAME=$($PSQL "select best_game from user_info where name = '$USERNAME'")
  GAMES_PLAYED=$($PSQL "select games_played from user_info where name = '$USERNAME'")
  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
           #Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.
  else  
  #if new user
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES_PLAYED=0
  BEST_GAME=0
  INSERT_GAME=$($PSQL "INSERT INTO user_info(name, games_played, best_game) values('$USERNAME',$GAMES_PLAYED, $BEST_GAME)")
fi

echo -e "Guess the secret number between 1 and 1000:"
read GUESS


SECRET_NUMBER=$((1 + $RANDOM % 1000))
#echo $SECRET_NUMBER
NUMBER_OF_GUESSES=2
until [[ "$GUESS" =~ ^[0-9]+$ ]] && [ "$GUESS" -ge 1 ] && [ "$GUESS" -le 1000 ]
do  
  echo "That is not an integer, guess again:"
  read GUESS
done

while [ $GUESS != $SECRET_NUMBER ]
do
NUMBER_OF_GUESSES=$[$NUMBER_OF_GUESSES+1]

#if lower
  if [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo -e "It's lower than that, guess again:"
    read GUESS
  #if higher
  else [[ $GUESS -lt $SECRET_NUMBER ]]
    echo -e "It's higher than that, guess again:"
    read GUESS
  fi
done


GAMES_PLAYED=$[$GAMES_PLAYED+1]
UPDATE_TABLE=$($PSQL "UPDATE user_info set games_played = $GAMES_PLAYED where name = '$USERNAME'")

if [[ $BEST_GAME = 0 ]]
  then
  UPDATE_TABLE=$($PSQL "UPDATE user_info set best_game = $NUMBER_OF_GUESSES where name = '$USERNAME'")
  elif [[ $NUMBER_OF_GUESSES -le $BEST_GAME ]]
  then
  UPDATE_TABLE=$($PSQL "UPDATE user_info set best_game = $NUMBER_OF_GUESSES where name = '$USERNAME'")
fi

echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
        #You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!







