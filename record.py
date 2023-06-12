import sys
import serial
import datetime
import csv

ser = serial.Serial('/dev/tty.usbmodem101',115200) #ポートの情報を記入

while(1):
    value = int(ser.readline().decode('utf-8').rstrip('\n'))
    date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(date,value)
    with open('test.csv', 'a') as f:
        print('{},{}'.format(date,value),file=f)