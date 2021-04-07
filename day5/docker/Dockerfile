# Start from Ubuntu image
FROM ubuntu:latest

# Run updates and install 'Fortune' software
RUN apt-get -y update && apt-get install -y fortune

# Copy the script file into the image
ADD fortuneloop.sh /bin

# Specify what we want to the container do once started
ENTRYPOINT /bin/fortuneloop.sh