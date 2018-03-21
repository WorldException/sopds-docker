FROM python:3.6-jessie

LABEL   author="Dmitry Shelepnev admin@sopds.ru" \
        devops="Evgeny Stoyanov quick.es@gmail.com" \
        name="SOPDS books catalog" \
        url_src="https://github.com/mitshel/sopds" \
        version="0.45" 

ENV SOPDS_DIR="/opt/sopds" \
    SOPDS_LANG='ru-RU' \
    SOPDS_USER='admin' \
    SOPDS_PASSWORD='admin' \
    SOPDS_EMAIL='user@user.user' \
    SOPDS_DATA='/opt/data'

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && apt update \
    && apt install -y mysql-client unzip \
    && wget -nv -O /opt/sopds.zip https://github.com/mitshel/sopds/archive/v0.45.zip \
    && unzip /opt/sopds.zip -d /opt \
    && mv /opt/sopds-0.45 ${SOPDS_DIR} \
    && ls -l /opt \
    && mkdir ${SOPDS_DATA} && chmod 777 ${SOPDS_DATA} \
    && pip3 install mysqlclient psycopg2-binary \
    && pip3 install -r /opt/sopds/requirements.txt

#COPY settings.py ${SOPDS_DIR}/sopds/settings.py
VOLUME ${SOPDS_DATA}
WORKDIR ${SOPDS_DIR}
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "server" ]