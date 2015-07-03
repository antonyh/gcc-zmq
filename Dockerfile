FROM gcc:4.9.2

RUN mkdir /zmq
WORKDIR /zmq

RUN curl -o zmq.tgz http://download.zeromq.org/zeromq-4.1.2.tar.gz
RUN curl -o libsodium.tgz https://download.libsodium.org/libsodium/releases/libsodium-1.0.3.tar.gz
RUN curl -L -o czmq.tgz https://github.com/zeromq/czmq/archive/v3.0.2.tar.gz

RUN tar -zxf zmq.tgz
RUN tar -zxf libsodium.tgz
RUN tar -zxf czmq.tgz
RUN rm -f /zmq/*.tgz

WORKDIR /zmq/libsodium-1.0.3
RUN ./configure
RUN make
RUN make check
RUN make install
RUN ldconfig || true

WORKDIR /zmq/zeromq-4.1.2
RUN apt-get upgrade -y libstdc++6
RUN ./configure
RUN make install
RUN ldconfig || true

WORKDIR /zmq/czmq-3.0.2
RUN ./autogen.sh
RUN ./configure
RUN make -j 4
RUN make check
RUN make install
RUN ldconfig || true
