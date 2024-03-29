#!/bin/bash
set -e
SCRIPT=$(realpath $0)
SCRIPT_DIR=$(dirname ${SCRIPT})

ENVFILE="${SCRIPT_DIR}/../../../.env"
if [[ -f "${ENVFILE}" ]]; then
  . ${ENVFILE}
fi

OSNAMES=(requirements heat keystone glance placement cinder neutron nova horizon barbican)
function USAGE() {
  echo "USAGE: $(basename $0) [-h] [-b] [-r] [-v] <openstack_project_name>"
  echo 
  echo " -h --help      Display this help message."
  echo " -b --branch    OpenStack project branch name (default: stable/2023.1)"
  echo " -r --repo      OpenStack project repo"
  echo "                (default: https://opendev.org/openstack/<project>)"
  echo " -v --version   Version in image tag."
  echo " <openstack_project_name>"
  echo " ${OSNAMES[@]}"
}
function check_project_name() {
  PNAME=$1
  for n in ${OSNAMES[@]}; do
    if [[ "$n" = "$PNAME" ]]; then
        echo $n
        return 0
    fi
  done
  return 1
}
VALID_ARGS=$(getopt -o hb:p:r:v: --long help,branch:,prefix:,repo:,version: -- "$@")
if [[ $? -ne 0 ]]; then
  exit 1;
fi
eval set -- "$VALID_ARGS"
while true; do
  case "$1" in
    -h | --help)
      USAGE
      exit 0
      ;;
    -b | --branch)
      PROJECT_REF="$2"
      shift 2
      ;;
    -r | --repo)
      PROJECT_REPO="$2"
      shift 2
      ;;
    -v | --version)
      VERSION="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
  esac
done

if check_project_name $1; then
  BUILD_PROJECTS="$1"
else
  USAGE
  exit 1
fi
OPENSTACK_VERSION="stable/2023.1"
PROJECT_REF=${PROJECT_REF:-${OPENSTACK_VERSION}}
#VERSION=${VERSION:-0.0.1}
REGISTRY_URI=${REGISTRY_URI:-jijisa/}

BASE_IMAGE="ubuntu"
#WHEELS="jijisa/requirements:skb-yoga-ubuntu_jammy"
WHEELS="jijisa/requirements:2023.1-ubuntu_jammy"
#nova_project_repo="https://github.com/jijisa/openstack-nova.git"
#nova_project_ref="stable/yoga-ovspatch"
#cinder_project_repo="https://github.com/jijisa/openstack-cinder.git"
DISTRO="ubuntu_jammy"
LOCI_SRC_DIR="${SCRIPT_DIR}/../../../loci"

#pycrypto was dropped after queens so we need to override the defaults
keystone_pip_packages=${keystone_pip_packages:-"'python-openstackclient'"}
heat_pip_packages=${heat_pip_packages:-"''"}
barbican_pip_packages=${barbican_pip_packages:-"''"}
glance_pip_packages=${glance_pip_packages:-"'python-cinderclient python-swiftclient os-brick oslo.privsep oslo.rootwrap'"}
cinder_pip_packages=${cinder_pip_packages:-"'python-3parclient>=4.0,<5.0 python-swiftclient'"}
neutron_pip_packages=${neutron_pip_packages:-"''"}
nova_pip_packages=${nova_pip_packages:-"''"}
horizon_pip_packages=${horizon_pip_packages:-"''"}
senlin_pip_packages=${senlin_pip_packages:-"''"}
congress_pip_packages=${congress_pip_packages:-"'python-congressclient'"}
magnum_pip_packages=${magnum_pip_packages:-"''"}
ironic_pip_packages=${ironic_pip_packages:-"''"}
neutron_sriov_pip_packages=${neutron_sriov_pip_packages:-"'networking-baremetal'"}
placement_pip_packages=${placement_pip_packages:-"'httplib2'"}
source ${SCRIPT_DIR}/build.sh

echo "Complete to build ${tag}."
