#!/env/bash

# connect the docker container to the local server via ssh
ssh -N -f -L localhost:8888:localhost:8888 bmrc@10.13.102.33

# run jupyter notebook
jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
