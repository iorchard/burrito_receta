Burrito Receta
================

Burrito receta is a tool to build openstack-helm images using loci.

It depends on loci and openstack-helm-images project.

* loci: https://git.openstack.org/openstack/loci.git
* openstack-helm-images: https://opendev.org/openstack/openstack-helm-images/

Get
----

Get burrito_receta source.::

    $ git clone --recursive https://github.com/iorchard/burrito_receta.git

Prepare
--------

`Install Docker Engine <https://docs.docker.com/engine/install/>`.

Install parallel package.::

    $ sudo apt -y install parallel # for debian-based distribution
    $ sudo dnf -y install parallel # for rhel-based distribution

Patch the upstream sources.::

    $ cd burrito_receta
    $ ./patch.sh

Build openstack-helm image
---------------------------

To build an openstack-helm image,
run receta.sh script at openstack-helm-images.::

    $ ./receta.sh
    USAGE: receta.sh [-h] [-b] [-r] [-v] <openstack_project_name>
    
     -h --help      Display this help message.
     -b --branch    OpenStack project branch name (default: stable/yoga)
     -r --repo      OpenStack project repo
                    (default: https://opendev.org/openstack/<project>)
     -v --version   Version in image tag.
     <openstack_project_name>
     keystone glance cinder neutron nova horizon

Examples
+++++++++

To build a glance image with version 1.0.0 from stable/yoga branch 
on the default openstack glance source repo::

    $ ./receta.sh -v 1.0.0 glance
    ...
    Complete to build jijisa/glance:1.0.0-yoga-ubuntu_jammy.

If you want to build a nova image from stable/yoga-ovspatch branch
on https://github.com/jijisa/openstack-nova.git::

    $ ./receta.sh -v 1.0.0 -b stable/yoga-ovspatch \
        -r https://github.com/jijisa/openstack-nova.git \
        nova
    ...
    Complete to build jijisa/nova:1.0.0-yoga-ovspatch-ubuntu_jammy.

You can push the image to your local registry.::

    $ docker tag jijisa/glance:1.0.0-yoga-ubuntu_jammy \
        <your_repo>/glance:1.0.0-yoga-ubuntu_jammy
    $ docker push <your_repo>/glance:1.0.0-yoga-ubuntu_jammy


Build mariadb image
--------------------

Go to openstack-helm-images/mariadb and run build.sh script.::

    $ cd openstack-helm-images/mariadb
    $ ./build.sh
    ...
    Successfully built 1ae9a15427f6
    Successfully tagged jijisa/mariadb:10.6.16-ubuntu_focal

Push the image to your local registry.::

    $ docker tag jijisa/mariadb:10.6.16-ubuntu_focal \
        <your_repo>/mariadb:10.6.16-ubuntu_focal
    $ docker push <your_repo>/mariadb:10.6.16-ubuntu_focal


