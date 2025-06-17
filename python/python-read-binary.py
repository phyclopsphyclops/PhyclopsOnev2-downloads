
# Read binary *.DAT file as a python numpy array

filename = 'E1E2_01.DAT'

import struct
struct_fmt = '=3i' # Three 32-bit signed integers with NA
struct_len = struct.calcsize(struct_fmt)
struct_unpack = struct.Struct(struct_fmt).unpack_from

results = []
with open(filename, "rb") as f:
    while True:
        data = f.read(struct_len)
        if not data: break
        s = struct_unpack(data)
        results.append(s)


chan1 = tuple(map(lambda x: x[0], results))
chan2 = tuple(map(lambda x: x[1], results))
msecdiff = tuple(map(lambda x: x[2], results))


# Transform to mV 
PGA  = 1
VREF = 2.048
VFSR = VREF/PGA
FSR  = 1 << 23 - 1

import numpy
Vout_ch1 = numpy.multiply(chan1, VFSR*1000/FSR)  # Scale *signed* values to proper mV
Vout_ch2 = numpy.multiply(chan2, VFSR*1000/FSR)  # Scale *signed* values to proper mV
tsec  = numpy.multiply( numpy.cumsum(msecdiff), 0.001) # timestamps in seconds (relative to start of file)

# At this point we have:
# Vout_ch1   channel 1  in millivolt (mV)
# Vout_ch2   channel 2  in millivolt (mV)
# tsec       timestamp in seconds (relative to start of file)


