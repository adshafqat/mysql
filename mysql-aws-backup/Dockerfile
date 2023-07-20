FROM infrabuilder/mysql-aws-cli:mysql-8


ENV DB_USER \
    DB_PASS \   
    DB_NAME  \
    DB_HOST  \
    ALL_DATABASES  \
    S3_BUCKET  \
    AWS_ACCESS_KEY_ID  \
    AWS_SECRET_ACCESS_KEY  \
    AWS_DEFAULT_REGION  \
    IGNORE_DATABASES 

COPY backup.sh /root/backup.sh
RUN chmod +x /root/backup.sh
RUN chmod 755  /root/backup.sh
RUN mkdir /mysqlbackup
RUN chmod 755  /mysqlbackup

VOLUME ["/root/.config"]
