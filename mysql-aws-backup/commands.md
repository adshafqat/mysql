ALTER USER 'yourusername'@'localhost' IDENTIFIED WITH mysql_native_password BY 'youpassword';
FLUSH PRIVILEGES;

kubectl create job --from=cronjob/mysql-backup-aws manual-006

docker build -t docker.io/ashafqat/mysql-backup-aws:v1.3 .
docker push docker.io/ashafqat/mysql-backup-aws:v1.3