#!/bin/bash

DB_USER=${DB_USER:-${MYSQL_ENV_DB_USER}}
DB_PASS=${DB_PASS:-${MYSQL_ENV_DB_PASS}}
DB_NAME=${DB_NAME:-${MYSQL_ENV_DB_NAME}}
DB_HOST=${DB_HOST:-${MYSQL_ENV_DB_HOST}}
S3_BUCKET=${S3_BUCKET:-${MYSQL_ENV_S3_BUCKET}}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-${MYSQL_AWS_ACCESS_KEY_ID}}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-${MYSQL_ENV_AWS_SECRET_ACCESS_KEY}}
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-${MYSQL_ENV_AWS_DEFAULT_REGION}}


aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_DEFAULT_REGION

ALL_DATABASES=${ALL_DATABASES}
IGNORE_DATABASE=${IGNORE_DATABASE}


if [[ ${DB_USER} == "" ]]; then
    echo "Missing DB_USER env variable"
    exit 1
fi
if [[ ${DB_PASS} == "" ]]; then
    echo "Missing DB_PASS env variable"
    exit 1
fi
if [[ ${DB_HOST} == "" ]]; then
    echo "Missing DB_HOST env variable"
    exit 1
fi

if [[ ${S3_BUCKET} == "" ]]; then
    echo "Missing S3_BUCKET env variable"
    exit 1
fi

if [[ ${ALL_DATABASES} == "" ]]; then
    if [[ ${DB_NAME} == "" ]]; then
        echo "Missing DB_NAME env variable"
        exit 1
    fi
    mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "${DB_NAME}" > /mysqlbackup/"${DB_NAME}".sql
    aws s3 cp /mysqlbackup/"${DB_NAME}".sql ${S3_BUCKET} 
else
    databases=`mysql --user="${DB_USER}" --password="${DB_PASS}"  --host="${DB_HOST}" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] && [[ "$db" != "$IGNORE_DATABASE" ]]; then
        echo "Dumping database: $db"
        mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" --databases $db > /mysqlbackup/$db.sql
        aws s3 cp /mysqlbackup/"${DB_NAME}".sql ${S3_BUCKET}
    fi
done
fi

