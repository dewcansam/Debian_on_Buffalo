
depmod -a
modprobe leds-gpio
sleep 1
udevadm trigger
sleep 5

##make sure it's executable
chmod +x /source/micro-evtd

###try a few times since this has been failing
###not sure if we're waiting for devices to be created or what
###only started when I added micro-evtd autosetect logic, may need to revisit
sleep 10
/source/micro-evtd -s 0003
/source/micro-evtd -s 0003
sleep 10
/source/micro-evtd -s 8083
##special stuff for terastations with mcu
if [ $? -eq 0 ]; then
echo "debug: found micon"
   micon_version="$(/source/micro-evtd -s 8083)"
   ## diable startup watchdog
   /source/micro-evtd -s 0003

   ##clear alert leds if any set power led
   /source/micro-evtd -s 0250090f96,02520000ac,02510d00a0

   ## set lcd display to installer message
   /source/micro-evtd -s 20905465726173746174696f6e2061726d2044656269616e20496e7374616c6c657231,0025,013220,013aff

   ##clear alert leds if any set power led
   /source/micro-evtd -s 0250090f96,02520000ac,02510d00a0

  ## if not a ts2pro try changing the lcd color
  echo $micon_version | grep HTGL
  if [ $? -ne 0 ]; then
     /source/micro-evtd -s 02500007,02510002
  fi

  ##enable serial console where possible.
  ##on ts2pro converts rear serial port to RW serial console.
  ##on Terastation III and TS3000 enables RW on front serial port.
  /source/micro-evtd -s 000f,000f,000f
  #fi

  ##if device is rack mount set fan to medium (still loud) otherwise set high
  echo $micon_version | grep 'TS-RXL\|RHTGL\|TS-MR\|TS1400R'
  if [ $? -ne 0 ]; then
    /source/micro-evtd -s 013303
  else
    /source/micro-evtd -s 013302
  fi

fi

exit 0
