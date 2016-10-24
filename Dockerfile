FROM python:2.7

RUN apt-get update && \
    apt-get install -y \
            libldap2-dev \
            libsasl2-dev \
            libssl-dev \
            python-dev \
            python-dns \
            python-excelerator \
            python-imaging \
            python-ipaddr \
            python-ldap \
            python-netaddr \
            python-m2crypto \
            python-paramiko \
            python-pip \
            python-pyasn1 \
            python-pyasn1-modules

ENV PYTHONPATH "/usr/local/lib/python2.7/site-packages"

RUN pip install --no-cache-dir pyweblib==1.3.12

RUN useradd web2ldap

ENV WEB2LDAP_VERSION "1.2.74"

RUN wget "http://www.web2ldap.de/download/web2ldap-$WEB2LDAP_VERSION.tar.gz" && \
    tar -zxvf "web2ldap-$WEB2LDAP_VERSION.tar.gz" && \
    mv "web2ldap-$WEB2LDAP_VERSION" /opt/web2ldap && \
    rm -f "web2ldap-$WEB2LDAP_VERSION.tar.gz"

WORKDIR /opt/web2ldap

RUN sed -i s/127.0.0.1:1760/0.0.0.0:1760/g etc/web2ldap/web2ldapcnf/standalone.py && \
    sed -i s/"'127.0.0.0\/255.0.0.0'"/"'0.0.0.0\/0.0.0.0','::0'"/g etc/web2ldap/web2ldapcnf/standalone.py

USER web2ldap

EXPOSE 1760

CMD sbin/web2ldap.py && tail -F var/log/web2ldap_error_log
