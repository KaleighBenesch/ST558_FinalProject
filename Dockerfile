# Use base image
FROM rstudio/plumber

# Linux commands
RUN apt-get update -qq && apt-get install -y libssl-dev libcurl4-gnutls-dev libpng-dev libpng-dev pandoc

# Install packages
RUN R -e "install.packages(c('tidyverse', 'tidymodels', 'janitor', 'yardstick', 'ranger', 'plumber'))"

# Copy API file and data set into container
COPY myAPI/myAPI.R /myAPI.R

COPY diabetes_binary_health_indicators_BRFSS2015.csv /diabetes_binary_health_indicators_BRFSS2015.csv

# Expose port for API
EXPOSE 7575

# Start Plumber API
ENTRYPOINT ["R", "-e", \
"pr <- plumber::plumb('/myAPI.R'); pr$run(host='0.0.0.0', port=7575)"]
