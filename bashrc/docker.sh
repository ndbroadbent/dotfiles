alias dx="docker exec -it"
alias dr="docker run --rm -it"
dxb() { docker exec -it "$1" bash; }
drb() { docker run --rm -it "$1" bash; }
drc() { docker run --rm -it "$1" rails console; }

# http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html
docker_clean() {
  echo "Removing all untagged Docker images..."
  docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
  echo "Removing all stopped Docker containers..."
  docker rm $(docker ps -a -q)
}
