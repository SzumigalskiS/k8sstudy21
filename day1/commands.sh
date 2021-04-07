#Day1

# install the fortune command to show what that command is producing
sudo apt install -y fortune cowsay

fortune |cowsay

# create docker directory and Dockerfile
mkdir docker
touch Dockerfile

# copy below to the Dockerfile and save
FROM docker/whalesay:latest
RUN apt-get -y update && apt-get install -y fortunes
CMD /usr/games/fortune -a | cowsay

# optional - need docker hub account
# tag the new image <dockerhubrepo>/<name>
docker images
docker tag <image ID> szumigalskis/fortune:latest
docker push szumigalskis/fortune:latest





#docker commands exapmles
docker logs 'container ID'  	#checking logs on container
docker volume ls 	#docker create default volume when creating sql container  
docker rm -f 'container ID'  	#force stop and removal of container 
docker stop $(docker ps -q) 	#stop multiple containers in one command 
docker rm $(docker ps -aq) 	# remove multiple containers 
docker volume rm $(docker volume ls -q) 	#remove multiple volumes 
docker volume ls -q 	#list volumes ID 
docker rm -fv 'container ID' 	#remove container with volume 
docker volume ls -f dangling=true 	#list not attached volumes 
docker volume rm $(docker volume ls -qf dangling=true) 	 #remove all not attached volumes 
docker images -f dangling=true 	#search dangling images 
docker network ls 	# list host networks 

Docker run -d nginx  #start-up container in detach mode 
Docker exec -it 'container id' bash  	#attach to running container 
docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH  	#copy file to container 
docker cp .\app\. nginx:/usr/share/nginx/html  	 #example  
docker commit nginx solitaire:nginx  	 #creating new image with custom files added
