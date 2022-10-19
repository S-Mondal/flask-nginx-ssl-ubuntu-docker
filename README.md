# Using Ubuntu image, create a Flask project by configuring Nginx with SSL in Docker

* [create self-signed certificate and key] (https://major.io/2007/08/02/generate-self-signed-certificate-and-key-in-one-line/)
* place files in ssl folder 
* create your own config file with domain name to place it inside /etc/nginx/sites-enabled/
* create your project with Flask
* create .dockerignore file to skip Dockerfile at time of building the container
* Run command: sudo docker build -t flask_docker:v1 . (To create image with name tag 'flask_docker:v1')
* Run command: sudo docker run -d --name=flask-demo -p 443:443 flask_docker:v1 (To create container and run it with name 'flask-demo' in detached mode and bind machine's https port to container's https port)
* Run command: sudo docker ps -a (To check all the containers)
* Run command: sudo docker logs <container-id> (to check logs)
* Open https://172.17.0.2/hello on browser
* Run command: sudo docker logs <container-id> (to check logs)
* Run command: sudo docker rm -f <container-id> (To forcefully stop the container)


### Other Useful Commands:

sudo docker ps -a -q (To get all the container-ids)
sudo docker rmi $(sudo docker images -f dangling=true -q) (To remove by filtering all image-ids of the dangling images)
sudo docker exec -ti <container-id> bash (To open the container bash terminal in interactive mode)
