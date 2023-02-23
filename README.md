# lihpccg-ci

This repository contains common tools for Continuous Integration (CI):
- CI workflows called by all projects of the mgx: [cmake-reusable.yml](./.github/workflows/cmake-reusable.yml) and [spack-reusable.yml](./.github/workflows/spack-reusable.yml),
- CI workflows to create docker images: [image-creator.yml](./.github/workflows/image-creator.yml) and [nightly.yml](./.github/workflows/nightly.yml).

Docker images are used to provide:
- a development environment for mgx and all dependent projects,
- an executable mgx product.

**If you want to use Docker images for mgx, you can read [this document](./CONTAINERS.md).**

The following graph shows the dependencies between mgx and other LIHPC-CG projects. It is built from the explicit Cmake dependencies specified in the `ci` presets of each project (see `CMakePresets.json` file).

The red square nodes are external products not installed with `apt install`: they are downloaded and installed in `cmake-cgcore` docker image.
The black round nodes are LIHPC-CG projects.

![Dependencies Graph Image](cg-dependencies.png)

## Docker images

This repository contains 6 docker images available in the Packages section on the right of the lihpccg-ci main page:
- `spack-mgx`: image based on Ubuntu and built with Spack. It contains last mgx release and its dependencies.
- `spack-cgcore`: LIHPC-CG core image based on Ubuntu and built with Spack. It contains Qwt, CGNS, VTK, Open Cascade...
- `spack-cgcore-mgx`: mgx image based on `spack-cgcore` and built with Spack. It contains last mgx release and all its dependencies.
- `cmake-cgcore`: LIHPC-CG core image based on Ubuntu and built with Cmake. It contains Qwt, Mesquite, CGNS, VTK and Open Cascade.
- `cmake-cgcore-mgx`: mgx image based on `cmake-cgcore` and built with Cmake. It contains last mgx release and all its dependencies.
- `nightly`: mgx image based on `cmake-cgcore` and built with Cmake. It contains mgx mainline (`git clone`) and all its dependencies' mainlines.

**Software versions used in images: Ubuntu 22.04 (g++ 11.3.0, cmake 3.22.1) and Spack 0.19.**

The dockerfiles used to create those images are available in the [images](./images) directory. The dockerfile in charge of creating a `xxx` image is named `Dockerfile.xxx`, for example `Dockerfile.cmake-cgcore` for `cmake-cgcore` image.

The `nightly`image is created automatically everyday at midnight. The `spack-mgx` image is "handmade": it takes more than 6 hours to create (exceeds the maximum possible free time on GitHub). The others images can be created through github menus:
- Actions menu on the top,
- Image Creator on the left,
- "Run workflow" button on the right and select the desired image.

## Mirrors

If you need to use mgx on sites that do not have an internet connection and do not allow the use of containers, we recommend using [Spack mirrors](https://spack.readthedocs.io/en/latest/mirrors.html).

### Build the mirror

*Step 1*

Open a bash terminal on the [spack-mgx](https://github.com/LIHPC-Computational-Geometry/lihpccg-ci/pkgs/container/spack-mgx) image and mount a volume of the container to your local file system, for example `/mgx-mirror` on the container points to `/tmp/mgx-mirror` on your local machine.

    podman run -v /tmp/mgx-mirror:/mgx-mirror --rm -it ghcr.io/lihpc-computational-geometry/spack-mgx bash

*Step 2*

Activate the Spack environment used to build the image and create the mirror.

    source /spack/share/spack/setup-env.sh
    spack env activate meshing-env
    spack mirror create -a

*Step 3*

Go to the `/spack/var/spack`, tar the cache directory of the previously created mirror in your local file system through the mounting point, `/mgx-mirror`in this example.

    cd /spack/var/spack
    tar cvfz /mgx-mirror/cache.tar.gz cache

Then, you can exit from the container and go the previously mounted directory on your computer, `/tmp/mgx-mirror`in this example.
Do not forget to download the last release of [spack LIHPC-CG recipes](https://github.com/LIHPC-Computational-Geometry/spack_recipes_meshing/releases) in the same directory.

### Use the mirror

On the site with no internet connection, you need to import the `cache.tar.gz` file created above and the last release of spack LIHPC-CG recipes.
Untar the 2 files in a directory and add the mirror and the recipes to Spack. If your site has predefined Spack configurations, you can not add the mirror and the recipes in using `spack mirror add` and `spack repo add` as they will be added at the end of the previously configured mirror and repo lists. Instead you need to directly edit the configuration files. To know the place of the configuration files, use the following commands:

    spack config blame repos    # for recipes
    spack config blame mirrors  # for mirrors

Edit the repos and mirrors configuration files and add the LIHPC-CG repositories and mirror.




