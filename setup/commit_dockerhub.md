### First, login to your docker hub
1. 'sudo docker login'

### Second, commit the new container 

2. 'docker ps -a'
3. 'docker commit <CONAINTER_ID> <NEW_IMAGE_NAME>'

### Third, tag the local image with new repository

4. 'docker tag <LOCAL_IMAGE_ID> sphilmoon/<NEW_REPO_NAME>:tag'

### Lastly, push the tagged image to your docker hub

5. 'docker push sphilmoon/<NEW_REPO_NAME>:tag'
