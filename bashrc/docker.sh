alias dx="docker exec -it"
alias dr="docker run --rm -it"
dxb() { docker exec -it "$1" bash; }
drb() { docker run --rm -it "$1" bash; }
drc() { docker run --rm -it "$1" rails console; }
