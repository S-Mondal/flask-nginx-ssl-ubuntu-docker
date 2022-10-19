FROM ubuntu:latest
RUN apt-get update && apt-get install -y python3 && apt-get install -y nginx && apt install -y python3-pip
 
RUN pip3 install flask 
COPY . .

RUN mv example@it.com /etc/nginx/sites-enabled/

CMD nginx && python3 app.py 
