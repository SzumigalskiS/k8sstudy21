FROM ubuntu:latest
RUN apt-get -y update && apt-get install -y fortune

ADD fortuneloop.sh /bin
RUN chmod +x "/bin/fortuneloop.sh"
ENTRYPOINT ["/bin/fortuneloop.sh"]
CMD ["10"]