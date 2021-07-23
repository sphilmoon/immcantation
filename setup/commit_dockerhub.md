### First, login to your docker hub
'sudo docker login'

### Second, commit the new container 

'docker ps -a'
'docker commit <CONAINTER_ID> <NEW_IMAGE_NAME>'

### Third, tag the local image with new repository

'docker tag <LOCAL_IMAGE_ID> sphilmoon/<NEW_REPO_NAME>:tag'

### Lastly, push the tagged image to your docker hub

'docker push sphilmoon/<NEW_REPO_NAME>:tag'
