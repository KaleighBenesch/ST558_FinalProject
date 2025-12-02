# Run myAPI.R

library(plumber)
r <- plumb("myAPI/myAPI.R")

# Run it on the port in the Dockerfile
r$run(port = 7575)

