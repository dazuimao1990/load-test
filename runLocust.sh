#!/bin/bash
#
# Run locust load test
#
#####################################################################
ARGS="$@"
HOST="${TARGET_HOST}"
SCRIPT_NAME=`basename "$0"`
INITIAL_DELAY=1
#TARGET_HOST="$HOST"
#REQUESTS=100
if [ -z $RUNTIME ]; then
  RUNTIME=50s
fi
INTERVAL=${INTERVAL:-80}

# -d 60 -r 200 -c 2 -h edge-router

do_check() {

  # check hostname is not empty
  if [ "${TARGET_HOST}x" == "x" ]; then
    echo "TARGET_HOST is not set; now set default 'localhost:5000'"
    TARGET_HOST="127.0.0.1:5000"
  fi

  # check for locust
  if [ ! `command -v locust` ]; then
    echo "Python 'locust' package is not found!"
    exit 1
  fi

  # check locust file is present
  if [ -n "${LOCUST_FILE:+1}" ]; then
        echo "Locust file: $LOCUST_FILE"
  else
        LOCUST_FILE="locustfile.py" 
        echo "Default Locust file: $LOCUST_FILE" 
  fi
}

do_exec() {
  sleep $INITIAL_DELAY

  # check if host is running
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${TARGET_HOST}) 
  if [ $STATUS -ne 200 ]; then
      echo "${TARGET_HOST} is not accessible"
      exit 1
  fi

  echo "Will run $LOCUST_FILE against $TARGET_HOST. Spawning ${CLIENTS:-2} clients stop after ${RUNTIME:-50s} ."
  locust --host=http://$TARGET_HOST -f $LOCUST_FILE --clients=${CLIENTS:-2} --hatch-rate=${HATCH_RATE:-5} --run-time=${RUNTIME:-50s} --no-web --only-summary
  echo "done"
}

do_usage() {
    cat >&2 <<EOF
Usage:
  ${SCRIPT_NAME} [ hostname ] OPTIONS

Options:
  -d  Delay before starting
  -h  Target host url, e.g. http://localhost/
  -c  Number of clients (default 2)
  -r  Number of requests (default 10)

Description:
  Runs a Locust load simulation against specified host.

EOF
  exit 1
}



while getopts ":d:h:c:r:" o; do
  case "${o}" in
    d)
        INITIAL_DELAY=${OPTARG}
        #echo $INITIAL_DELAY
        ;;
    h)
        TARGET_HOST=${OPTARG}
        #echo $TARGET_HOST
        ;;
    c)
        CLIENTS=${OPTARG:-2}
        #echo $CLIENTS
        ;;
    r)
        REQUESTS=${OPTARG:-10}
        #echo $REQUESTS
        ;;
    *)
        do_usage
        ;;
  esac
done

do_check
while true
do
  echo " --------- starting load test --------- "
  do_exec
  echo "------ load test finished ! sleep $INTERVAL seconds and do next ! ------"
  sleep $INTERVAL
done
