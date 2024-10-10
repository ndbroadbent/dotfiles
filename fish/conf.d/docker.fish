alias dx="docker exec -it"
alias dr="docker run --rm -it"
function dxb
  docker exec -it "$1" bash
end
function drb
  docker run --rm -it "$1" bash
end
function drc
  docker run --rm -it "$1" rails console
end

# References:
# * http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html
# * https://docs.docker.com/engine/reference/commandline/system_prune/
# * https://forums.docker.com/t/no-space-left-on-device-error/10894/17
# * https://stackoverflow.com/questions/30604846/docker-error-no-space-left-on-device
function docker_clean
  echo "Removing all untagged Docker images..."
  docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
  echo "Removing all stopped Docker containers..."
  docker rm $(docker ps -a -q)
  echo "Removing all dangling Docker volumes..."
  docker volume rm $(docker volume ls -qf dangling=true)
  # echo "Running 'docker system prune -a --volumes -f'"
  # docker system prune -a --volumes -f
end

