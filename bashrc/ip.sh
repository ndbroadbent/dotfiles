ipp() {
  printf "Public: "
  curl ipinfo.io/ip
}
ipl() {
  printf "Local: "
  ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d' ' -f2
}
alias ip="ipl; ipp"
