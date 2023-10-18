#!/bin/bash

set -e 

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname ${SCRIPT}`

WORKSPACE="${SCRIPT_DIR}/openstack-helm-images"
BUILD_DIR="${WORKSPACE}/openstack/loci"
BUILD_SCRIPT="${BUILD_DIR}/receta.sh"

cp build-burrito.sh ${BUILD_SCRIPT}
pushd ${WORKSPACE}
  ${BUILD_SCRIPT} $@
popd

rm -f ${BUILD_SCRIPT}
