# Defined in - @ line 1
function localip
  set IP_DEV (ip route | grep default | awk '{print $5}')
  ip address show dev $IP_DEV scope global | grep inet | awk '{print $2}' | cut -d '/' -f1
end
