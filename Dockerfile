FROM python:2.7

RUN apt-get update && \
    apt-get install -y python-dev libldap2-dev libsasl2-dev libssl-dev python-ldap

ENV PYTHONPATH "/usr/local/lib/python2.7/site-packages"

COPY requirements.txt /

RUN pip install --no-cache-dir -r requirements.txt

RUN useradd web2ldap

RUN wget http://www.web2ldap.de/download/web2ldap-1.2.31.tar.gz && \
    tar -zxvf web2ldap-1.2.31.tar.gz && \
    mv web2ldap-1.2.31 /opt/web2ldap && \
    rm -f web2ldap-1.2.31.tar.gz

WORKDIR /opt/web2ldap

RUN sed -i s/127.0.0.1:1760/0.0.0.0:1760/g etc/web2ldap/web2ldapcnf/standalone.py && \
    sed -i s/"\['127.0.0.0\/255.0.0.0','::1','fe00::0'\]"/"\['0.0.0.0\/0.0.0.0','::0'\]"/g etc/web2ldap/web2ldapcnf/standalone.py

USER web2ldap

EXPOSE 1760

CMD sbin/web2ldap.py && tail -F var/log/web2ldap_error_log