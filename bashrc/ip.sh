ipp() {
  printf "Public IP: " >&2
  curl ipinfo.io/ip
}
ipl() {
  printf "Local IP: " >&2
  ifconfig | grep "inet " | grep -v 127.0.0.1 | head -n1 | cut -d' ' -f2
}
alias ip="ipl; ipp"
