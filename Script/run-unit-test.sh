#!/bin/bash -xe

#
# Start firebase emulator
#

npx firebase emulators:start --only firestore &
PID=$!

echo "🔥 Waiting Firebase emulator to launch on 8080..."

while ! nc -z localhost 8080; do
  sleep 0.5
done

echo "🔥 Firebase emulator launched"

#
# Run tests
#

bundle exec fastlane test

#
# Stop firebase emulator
#

kill "$PID"
echo "🔥 Firebase emulator stopped."
