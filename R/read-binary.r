
# R script for reading binary *.DAT file into an xts multivariate timeseries
# requires R packages 'ff' and 'xts'. 
# Both can be installed with: install.packages('ff'); install.packages('xts')

require(ff)
x.in <-ff(vmode='integer' , filename="E1E2_01.DAT")  # 32-bit signed integers with NA
dim(x.in)<-c(3, length(x.in)%/%3 )  # Two channels + timestamp


PGA <- 1                 # Programmable Gain
VREF <- 2.048            # Internal reference of 2.048 V
VFSR <- VREF/PGA
FSR <- bitwShiftL(1,23)-1  # (((long int)1<<23)-1)
# Scale *signed* values to proper mV
Vout <- ((x.in[c(1,2),]*VFSR*1000)/FSR);     #In  millivolt (mV)

# At this point we have Vout as a 2xN matrix of Voltages, one row per recording channel


# Adding millisecond timestamps if available
require(xts)
if (dim(x.in)[1]>2) {
	tim<-as.POSIXct("2025-01-01 12:00:00") + cumsum(x.in[3,]/1000)   # Adapt this date/time as needed
	VoutTS<-xts(t(Vout),order.by=tim)
} else stop('No timestamps. This is not a good idea!')

# At this point we have VoutTS as a two-column xts timeseries of Voltages, one column per recording channel.

# Plot it:
# plot(VoutTS)

