FROM python:3.7

# Install locust
RUN pip install --default-timeout=100 pyzmq locustio==0.14.6 faker -i http://mirrors.aliyun.com/pypi/simple/  --trusted-host mirrors.aliyun.com

ADD locustfile.py /config/locustfile.py
ADD runLocust.sh /usr/local/bin/runLocust.sh

ENV LOCUST_FILE /config/locustfile.py

EXPOSE 8089

ENTRYPOINT ["/usr/local/bin/runLocust.sh"]
CMD [ "edge-router" ]
