#!/bin/bash

sudo apt-get install bc

requests()
{

# Specify the number of iterations for the loop
ITERATIONS=5
# Loop through the specified number of iterations
for ((i=1; i<=$ITERATIONS; i++))
do
  echo "Making request $1"

  # Make the curl request and save the response
  response=$(curl -s -w %{time_total}\\n -o /dev/null $1)

  # Append the response to the file
  echo "$response" >> "$RESPONSE_FILE"

  echo "Response time $i recorded."
done
}

# Specify the file to record the responses
RESPONSE_FILE="results.txt"

# Remove the existing response file if it exists
if [ -f "$RESPONSE_FILE" ]; then
  rm "$RESPONSE_FILE"
fi

requests "https://api.bybit.com/v5/market/kline?category=spot&symbol=BTCUSDT&interval=5"
requests "https://api.bybit.com/v5/market/orderbook?category=spot&symbol=BTCUSDT"
requests "https://api.bybit.com/v5/market/instruments-info?category=spot"
requests "https://api.bybit.com/v5/market/tickers?category=spot"
requests "https://api.bybit.com/v5/market/funding/history?category=spot"

echo "Requests test completed."


NUMBERS_FILE="results.txt"

sum=0
count=0

# Read the file line by line
while IFS= read -r number
do
  if [[ -n $number ]]; then
    count=$((count + 1))
    sum=$(echo "$sum + $number" | bc)
  fi
done < "$NUMBERS_FILE"

average=$(echo "scale=6; $sum / $count" | bc)

echo "The average response time is: $average seconds!"
