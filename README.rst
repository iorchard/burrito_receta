Burrito Receta
================

Burrito receta is a tool to build openstack-helm images using loci.

It depends on loci and openstack-helm-images project.

* loci: https://git.openstack.org/openstack/loci.git
* openstack-helm-images: https://opendev.org/openstack/openstack-helm-images/

Prepare
--------

`Install Docker Engine <https://docs.docker.com/engine/install/>`.

Install parallel package.::

    $ sudo apt -y install parallel # for debian-based distribution
    $ sudo dnf -y install parallel # for rhel-based distribution

Patch the upstream sources.::

    $ ./patch.sh

Build an openstack-helm image
-------------------------------

To build an openstack-helm image,
run receta.sh script at openstack-helm-images.::

    $ ./receta.sh
    USAGE: receta.sh [-h] [-b] [-v] <openstack_project_name>
    
     -h --help      Display this help message.
     -b --branch    OpenStack source branch name (default: stable/yoga).
     -v --version   Version in image tag.
     <openstack_project_name>
     keystone barbican glance cinder neutron nova horizon

Examples
+++++++++

To build a glance image with version 1.0.0::

    $ ./receta.sh -v 1.0.0 glance
    ...
    Complete to build jijisa/glance:1.0.0-yoga-ubuntu_jammy.

If you want to build a nova image from stable/yoga-ovspatch branch::

    $ ./receta.sh -v 1.0.0 -b stable/yoga-ovspatch nova
    ...
    Complete to build jijisa/nova:1.0.0-yoga-ovspatch-ubuntu_jammy.

Then, you can push the image to your local registry.::

    $ docker tag jijisa/glance:1.0.0-yoga-ubuntu_jammy \
        <your_repo>/glance:1.0.0-yoga-ubuntu_jammy
    $ docker push <your_repo>/glance:1.0.0-yoga-ubuntu_jammy


