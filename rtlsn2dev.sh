#sudo mkdir /opt/rtltcp

#sudo tee /opt/rtltcp/rtlsn2dev.sh << 'EOF'
#!/bin/bash
# usage: ./rtlsn2dev.sh [serial number]
# returns: device ID

#RTL SN
SN=00000999
echo Using Serial $SN

rtl_num_devices=$(rtl_eeprom 2>&1 >/dev/null | grep "Found [0-9][0-9]*" | sed -E 's/.*([0-9]+).*/\1/')
  if [ $rtl_num_devices ]
  then
    for i in $(seq 1 $rtl_num_devices);
    do
      rtl_device=$((i-1))
      rtl_serial=$(rtl_eeprom -d$rtl_device 2>&1 >/dev/null | grep "Serial number\:" | sed -E 's/Serial number:[[:blank:]]+//')
      rtl_serial_processed=$(echo $rtl_serial | sed 's/^0*//');
      if [ "$SN" == "$rtl_serial" ] || [ "$SN" == "$rtl_serial_processed" ]
      then
        echo Serial $SN is RTL-SDR Device $rtl_device
     	device_index=$rtl_device
fi
    done
  fi

#Start RTLTCP

echo Serial $SN is RTL-SDR Device $device_index
rtl_tcp -a 192.168.0.37 -p 2030 -g 0 -b 5 -n 10 -s 1024000 -d $device_index -T


#EOF
#sudo chmod +x /opt/rtltcp/rtlsn2dev.sh
#sudo chown -R pi:pi /opt/rtltcp
