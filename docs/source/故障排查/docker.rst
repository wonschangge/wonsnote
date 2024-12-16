docker故障
=========================

Cannot connect to the Docker daemon at unix:///home/chanj/.docker/desktop/docker.sock. Is the docker daemon running?

::

    dpkg -l | grep docker
    snap list docker
    docker context ls
    sudo docker context ls

切换docker上下文即可解决