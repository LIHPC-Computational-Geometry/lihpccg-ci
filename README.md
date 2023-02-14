# lihpccg-ci
Common tools for Continuous Integration (CI) 

## Packages

This repository contains 5 docker images (Packages section - right of the main page):
- **spack-mgx**: image based on Ubuntu and built with [Spack](https://spack.io/) containing mgx.
- **spack-cgcore**: LIHPC-CG core image based on Ubuntu and built with [Spack](https://spack.io/). It mainly contains Open Cascade and VTK.
- **spack-cgcore-mgx**: image based on spack-cgcore containing mgx and all its dependencies (other repositories of [LIHPC-CG organization](https://github.com/LIHPC-Computational-Geometry/). This image is built with [Spack](https://spack.io/).
- **cmake-cgcore**: LIHPC-CG core image based on Ubuntu and built with [Cmake](https://cmake.org/). It contains Open Cascade and VTK.
- **cmake-cgcore-mgx**: image based on cmake-cgcore containing mgx and all its dependencies (other repositories of [LIHPC-CG organization](https://github.com/LIHPC-Computational-Geometry/). This image is built with [Cmake](https://cmake.org/).
