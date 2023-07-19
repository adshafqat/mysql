FROM google/cloud-sdk:alpine
ENV GOOGLE_PROJECT fiverr

ENV GOOGLE_CLIENT_EMAIL info@zaynsolutions.com
ENV GS_BUCKET gs://mysql-backup-fiverr

ENV DB_USER \
    DB_PASS \   
    DB_NAME  \
    DB_HOST  \
    ALL_DATABASES  \
    IGNORE_DATABASES  

COPY service-account.json /root/service_key.json
COPY backup.sh /root/backup.sh
RUN chmod +x /root/backup.sh
RUN chmod 755  /root/backup.sh
RUN mkdir /mysqlbackup
RUN chmod 755  /mysqlbackup
RUN apk add --update mysql-client bash openssh-client && rm -rf /var/cache/apk/*

RUN gcloud config set project $GOOGLE_PROJECT
RUN gcloud auth activate-service-account --key-file /root/service_key.json
RUN gsutil ls $GS_BUCKET/

VOLUME ["/root/.config"]
