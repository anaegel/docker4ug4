

ARG BUILD_DEPENDECIES="libexecinfo-dev clang libstdc++ blas lapack libc-dev build-base musl-dev gcc"
FROM alpine AS build
LABEL version="1.0"

#install requirements
ARG BUILD_DEPENDECIES
RUN apk update && apk add bash make python cmake git ${BUILD_DEPENDECIES}

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

ENV CXX_FLAGS="-lstdc++ -lexecinfo -std=c++11"
#Build process
RUN mkdir ug4/build;\
    cd ug4/build;\
    cmake .. -DCMAKE_CXX_COMPILER=clang -DCMAKE_C_COMPILER=clang -DDIM=2 -DENABLE_ALL_PLUGINS=ON -DCPU=1 -DCOMPILE_INFO=OFF;\
    make -j4

#extract only the executable, libs, apps and headers to reduce imagesize drastically
FROM alpine AS run
ARG BUILD_DEPENDECIES
LABEL version="1.0"
LABEL name="ugshell"
LABEL description="the ugshell essentials"

RUN apk update && apk install git bash ${BUILD_DEPENDECIES}
ENV PATH=$PATH:/ug4/bin/

COPY --from=build /ug4/bin /ug4/bin
COPY --from=build /ug4/lib /ug4/lib
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /ug4/apps /ug4/apps
#COPY --from=builder /ug4/headers /ug/*4/headersuga
