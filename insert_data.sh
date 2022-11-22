#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#year,round,winner,opponent,winner_goals,opponent_goals
echo $($PSQL "TRUNCATE games, teams")

I=0

while IFS=, read -r YEAR ROUND WINNER OPPONENT WGOALS OPPGOALS
do
  if [[ $YEAR != "year" ]]
  then
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    if [[ -z $TEAM_NAME ]]
    then
      I=$((I+1))
      echo "INSERT INTO teams(team_id,name) VALUES($I,'$WINNER')"
      INSERT_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(team_id,name) VALUES($I,'$WINNER')")
      if [[ $INSERT_TEAM_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi
done < games.csv

# Loop through the opponent team names
while IFS=, read -r YEAR ROUND WINNER OPPONENT WGOALS OPPGOALS
do
  if [[ $YEAR != "year" ]]
  then
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    if [[ -z $TEAM_NAME ]]
    then
      I=$((I+1))
      echo "INSERT INTO teams(team_id,name) VALUES($I,'$OPPONENT')"
      INSERT_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(team_id,name) VALUES($I,'$OPPONENT')")
      if [[ $INSERT_TEAM_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
done < games.csv

I=0

while IFS=, read -r YEAR ROUND WINNER OPPONENT WGOALS OPPGOALS
do
  if [[ $YEAR != "year" ]]
  then
    #echo "$YEAR $ROUND $WINNER $OPPONENT $WGOALS $OPPGOALS"

    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #echo "WINNER_TEAM_ID: $WINNER_TEAM_ID OPPONENT_TEAM_ID: $OPPONENT_TEAM_ID"

    I=$((I+1))

    #echo "INSERT INTO games(game_id,year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($I,$YEAR,'$ROUND',$WINNER_TEAM_ID,$OPPONENT_TEAM_ID,$WGOALS,$OPPGOALS)"
    INSERT_TEAM_NAME_RESULT=$($PSQL "INSERT INTO games(game_id,year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($I,$YEAR,'$ROUND',$WINNER_TEAM_ID,$OPPONENT_TEAM_ID,$WGOALS,$OPPGOALS)")
    if [[ $INSERT_TEAM_NAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND, $WINNER, $OPPONENT, $WGOALS, $OPPGOALS
    fi
  fi
done < games.csv
