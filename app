#!/bin/bash

# This script simplifies running the docker compose configured services.

set -e

help() {
  echo "Commands for building, testing, and running a local typekit stack."
  echo
  echo "Commands:"
  echo "clean     Destroy all existing dependencies and compiled assets."
  echo "build     Build and install all dependencies from scratch."
  echo "run       Start the application stack."
  echo "stop      Stop the application stack."
  echo "console   Start an interactive console."
  echo
}

clean() {
  docker image rm \
    cppcon/cling
}

build() {
  VERSION=latest
  docker build \
    --platform linux/amd64 \
    -t cppcon/cling:$VERSION .
}

run() {
  container=$(docker run \
    -v $(pwd)/:/build/ --detach\
    --platform linux/amd64 \
    -p 8888:8888 \
    --entrypoint /build/entrypoint.sh \
    cppcon/cling)
}

console() {
  docker run \
    --rm -it --platform linux/amd64 \
    -p 8888:8888 \
    -v $(pwd)/:/build/ \
    cppcon/cling
}

stop() {
  docker stop \
    $(docker container ls | grep 'cppcon/cling' | awk '{print $1}' | xargs)
}

main() {
  if [ "$1" = clean ]; then
    clean
  elif [ "$1" = build ]; then
    build
  elif [ "$1" = run ]; then
    shift
    run "$@"
  elif [ "$1" = console ]; then
    console
  elif [ "$1" = stop ]; then
    stop
  else
    help
  fi
}

(main "${@}")
