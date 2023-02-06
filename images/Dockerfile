#============== OS LAYER ==================
# In ubuntu:20.4 the Open GL version is too old to execute in container
# Ubuntu 22.04 allows to execute glxgears in a docker container
FROM ubuntu:22.04
#==========================================
# METADATA OF THE IMAGE
LABEL description "Build env" version="1.0" maintainer="Meshing team <lihpccg@gmail.com>"
#==========================================
ARG SPACK_VERSION=0.19.0
# Do not use /dev as the HOME if you use containers in vscode
# /dev is too small to store .vscode-server directory containing user preferences
# ENV HOME /dev
#==========================================
SHELL ["/bin/bash", "-c"]
#==========================================
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#==========================================
# 01/23: libxt-dev has been added to compile VTK.
#        Error msg without libxt-dev: "X11_Xt_LIB could not be found. Required for VTK X lib."
# 02/23: autoconf added. Used by gmds during build.

RUN apt update &&\
    apt install -y build-essential cmake python3 python3-distutils python3-venv unzip zip curl git libxt-dev libgl-dev gfortran autoconf &&\
    apt clean &&\
    rm -rf /var/lib/apt/lists/*
#==========================================
RUN git clone --depth=1 -b v${SPACK_VERSION} https://github.com/spack/spack.git &&\
    git clone --depth=1 https://github.com/LIHPC-Computational-Geometry/spack_recipes_meshing.git &&\
    cp spack_recipes_meshing/config/packages.yaml /spack/etc/spack/ &&\
    cp spack_recipes_meshing/supersede_repo/packages/petsc/*.* /spack/var/spack/repos/builtin/packages/petsc &&\
    cp spack_recipes_meshing/supersede_repo/packages/opencascade/*.* /spack/var/spack/repos/builtin/packages/opencascade &&\
    cp -r spack_recipes_meshing/supersede_repo/packages/vtk-maillage /spack/var/spack/repos/builtin/packages

# spack config without mpi should be possible
RUN source /spack/share/spack/setup-env.sh &&\
    spack config --scope site add 'packages:all:target:[x86_64]' &&\
# 02/23: mgx does not compile MPI
#    spack config --scope site add 'packages:all:variants:~mpi' &&\
    spack compiler find &&\
    spack external find cmake

RUN sed -i 's#"${ARCHITECTURE}/${COMPILERNAME}-${COMPILERVER}/${PACKAGE}-${VERSION}-${HASH}"#"${PACKAGE}-${VERSION}"#g' spack/etc/spack/defaults/config.yaml
#==========================================
# 2023/02/01-BL: qwt must be installed early due to its qt@5.14 dependency (5.15 otherwise)
# 2023/02/03-BL: @7.1.0+foundationclasses+dataexchange added on opencascade for mgx
RUN source /spack/share/spack/setup-env.sh &&\
    spack env create meshing-env &&\
    spack env activate meshing-env &&\
    spack add python@3 &&\
    spack add qt+opengl~examples &&\
    spack add hdf5+cxx &&\
    spack add opencascade@7.1.0+foundationclasses+dataexchange &&\
    spack add vtk-maillage~opengl2+qt &&\
    spack add cgns &&\
    spack add swig &&\
    spack add qwt &&\
    spack add doxygen &&\
    spack add openmpi &&\
    spack concretize &&\
    spack install &&\
    rm -rf /spack/var/spack/cache/*
#==========================================
