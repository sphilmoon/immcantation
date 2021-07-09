#!/env/bash

# running the immcantation container without saving it

docker run --network=host -it --rm -v /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation:/home/phil:z sphilmoon/immcantation:latest bash
