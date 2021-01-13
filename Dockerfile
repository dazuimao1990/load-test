FROM python:3.6

# Install locust
RUN pip install locust -i https://pypi.tuna.tsinghua.edu.cn/simple

ADD locustfile.py /config/locustfile.py
ADD runLocust.sh /usr/local/bin/runLocust.sh

ENV LOCUST_FILE /config/locustfile.py

ENTRYPOINT ["/usr/local/bin/runLocust.sh"]
CMD [ "edge-router" ]
