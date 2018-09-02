FROM ubuntu:16.04

MAINTAINER "bala2289@gmail.com"

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

CMD [ "mkdir /opt/myapp" ]

CMD [ "touch /opt/myapp/healthcheck" ]

WORKDIR /opt/myapp/

COPY ./requirements.txt /opt/myapp/requirements.txt

RUN pip install -r requirements.txt

COPY app.py /opt/myapp

COPY tasks.csv /opt/myapp

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
