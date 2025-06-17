
# R script for reading *.CSV file into an xts multivariate timeseries


# Read in the file
dat <- read.csv("TMHMPRL.CSV", header=TRUE)
dat<-dat[-1,]  # Remove first row.


# Adding timestamps for easy subsetting

# Timestamping and rectifying to periodLF time-grid (this should always be done).
# Setting a reference grid of periodLF seconds, starting at 1970-01-01 midnight. then align all other data to this!
require(xts)
periodLF <- round(mean(diff(dat$Seconds), na.rm=TRUE)) 
tmp <- as.POSIXct("2025-03-29 17:26") + periodLF*(1:nrow(dat)) # Adjust Origin time here if needed
deltat <- as.numeric( tmp[1] ) %% periodLF  # Snapping to reference grid
datTS<- xts( dat, order.by=tmp-deltat )

# Scale from microvolt to millivolt
datTS[,c('E1','E2')] <- datTS[,c('E1','E2')]/1000


# Plot it
plot(datTS[,c('E1','E2')])
# plot(datTS[,c('E1','E2')]["2025-04-02 15:00:00::"] )  # Everything after that date/time
# plot(datTS[,c('E1','E2')]["::2025-04-02 15:00:00"] )  # Everything up to that date/time
# plot(datTS[,c('E1','E2')]["2025-04-06 00:00:00::2025-04-06 04:00:00"] )  # Everything in that interval
# plot(datTS[,c('E1','E2')]['2025-04-06']) # A single day
# plot(datTS[,c('E1','E2')]['2025-04-06']['T2/T4'])  # sub-subsetting with time, same as ...['T2:00/T4:00']
# plot(datTS[,c('E1','E2')]['T2:00/T4:00'])  # Everything between 2 and 4, for all available days.

