FROM cassandra:latest
RUN apt-get update && apt-get install iputils-ping net-tools -y
RUN apt-get upgrade -y