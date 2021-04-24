import serial

if __name__ == '__main__':

    ser = serial.Serial('/dev/ttyUSB1', 57600)

    # Send a test command. LED should toggle.
    ser.write(bytearray([5, 1, 2, 3, 4, 0]))
    ser.flush()
    ser.close()
