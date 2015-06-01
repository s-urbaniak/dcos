FROM mesosphere/mesos:0.21.0-1.0.ubuntu1404
MAINTAINER Mesosphere <support@mesosphere.io>

RUN apt-get install -y curl

RUN curl \
        --location \
        --retry 3 \
        http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/spark/spark-1.3.1/spark-1.3.1-bin-cdh4.tgz \
        | gunzip \
        | tar x -C /usr/ \
        && ln -s /usr/spark-1.3.1-bin-cdh4 /usr/spark

ENV MESOS_NATIVE_JAVA_LIBRARY="/usr/local/lib/libmesos.so"

ENTRYPOINT ["/usr/spark/bin/spark-submit"]
