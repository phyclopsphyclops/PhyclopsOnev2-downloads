
# Read Voltages and time from *.CSV file 

filename = 'TMHMPRL.CSV'

import pandas as pd
dat = pd.read_csv(filename)


Vout_ch1 = dat['E1']/1000   # to mV
Vout_ch2 = dat['E2']/1000   # to mV
tsorigin = pd.to_datetime('2025-03-29 13:00:00 +0200',  utc=True)  # using tz = utc+2
tsec  = tsorigin + pd.to_timedelta(dat['Seconds'], unit='s') # timestamps absolute


# At this point we have:
# Vout_ch1   channel 1  in millivolt (mV)
# Vout_ch2   channel 2  in millivolt (mV)
# tsec       timestamp in seconds 


