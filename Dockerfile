#musl-dev fortify-headers  gcc binutils
ARG BUILD_DEPENDECIES="blas clang cmake  g++ lapack libstdc++ libc-dev libexecinfo-dev make"
#not in use de to being incomplete
ARG RUNTIME_DEPENDENCIES="blas g++ gcc lapack libc-utils libexecinfo libstdc++ lua" 
FROM alpine AS build
LABEL version="1.0"

#install requirements
ARG BUILD_DEPENDECIES
RUN apk update && apk add git bash python

#ughub setup
RUN git clone https://github.com/UG4/ughub.git ughub;   
ENV PATH=$PATH:/ughub

#grab all packages
RUN mkdir ug4;\
    cd ug4;\
    ughub init;\
    ughub install ugcore ConvectionDiffusion Examples;\
    mkdir headers -p;\
    mkdir apps -p

ENV CXX_FLAGS="-lstdc++ -lexecinfo"

RUN apk add ${BUILD_DEPENDECIES}
#Build process
RUN mkdir ug4/build;\
    cd ug4/build;\
    cmake .. -DCMAKE_CXX_COMPILER=clang -DCMAKE_C_COMPILER=clang -DDIM=3 -DENABLE_ALL_PLUGINS=ON -DCPU=1 -DCOMPILE_INFO=OFF;\
    make -j3

#gather header files
RUN mkdir ug4/headers -p
    #finds weird regex is shit or i'm just too dumb
    #find /ug4 -regex "\/ug4\/(ugcore|plugins)\/.*(\.h|\.hpp)" -exec cp {} /ug4/headers +

#extract only the executable, libs, apps and headers to reduce imagesize drastically
FROM alpine AS run
VOLUME [ "/scripts" ]

ENV PATH=$PATH:/ug4/bin/
ENV UG4_ROOT="/ug4"

COPY --from=build /ug4/bin /ug4/bin
COPY --from=build /ug4/apps /ug4/apps
COPY --from=build /ug4/ugcore/scripts /ug4/scripts

COPY --from=build /ug4/lib/ /ug4/lib/
COPY --from=build /lib/*.so* /lib/
COPY --from=build /usr/lib/*.so* /usr/lib/
COPY --from=build /ug4/headers /ug4/headers
