#!/bin/bash

# INSTALL_DIR define in the container
GH_BASE=https://github.com/LIHPC-Computational-Geometry
PRJS="tkutil-5.14.0 \
	qtutil-5.7.8 \
	lima-7.7.9 \
	pythonutil-5.6.6 \
	preferences-5.6.2 \
	qualif-2.3.5 \
	qwtcharts-4.4.13 \
	gmds072-0.7.2 \
	gmdscea-2.0.0 \
	qtpython-5.1.10 \
	triton2-1.0.0 \
	vtkcontrib-4.6.4 \
	qtvtk-7.14.8 \
	qqualif-3.9.1 \
	mgx-1.0.0"

mkdir -p src
for prj in $PRJS
do
	if [[ $prj =~ ^(.*)-([0-9]+.[0-9]+.[0-9]+)$ ]]; then 
		repo=${BASH_REMATCH[1]}
		version=${BASH_REMATCH[2]}
		echo

		if [[ $1 = "mainline" ]]; then
			echo "=== Project $repo - Mainline"
			url=$GH_BASE/$repo.git
			echo Cloning $url
			srcdir=src/$repo
			git clone --depth=1 $url $srcdir || exit 1
		else
			echo "=== Project $repo - Version $version"
			url=$GH_BASE/$repo/archive/refs/tags/v$version.tar.gz
			echo Downloading $url
			curl -L $url | tar xz --directory src || exit 1
			srcdir=src/$prj
		fi

    	cmake -S $srcdir -B build/$repo --preset=ci --install-prefix=$INSTALL_DIR/$repo \
    	&& cmake --build build/$repo --target install --parallel 4 \
		|| exit 1
	fi
done

