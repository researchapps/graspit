Bootstrap: docker
From: ubuntu:14.04

%runscript
    echo "SINGULARITY RUNSCRIPT"
    echo "Arguments received: $*"
    exec /opt/anaconda3/bin/python "$@"


%post
    chmod u+x post.sh
    ./post.sh
