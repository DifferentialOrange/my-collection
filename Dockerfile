FROM tarantool/tarantool:1.x-centos7

COPY ./collection /opt/collection/collection
COPY ./init.lua /opt/collection/init.lua
WORKDIR /opt/collection/

RUN yum -y install unzip make git gcc gcc-c++
RUN tarantoolctl rocks install http 1.0.6
RUN tarantoolctl rocks install checks 3.0.1

CMD ["tarantool", "./init.lua"]
