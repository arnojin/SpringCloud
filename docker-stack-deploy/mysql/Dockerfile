# cd /d D:\github\SpringCloud\docker-stack-deploy\mysql
# docker build -t mysql-win:5.7.27 .
FROM mysql:5.7.27
ADD innodb_use_native_aio.cnf /etc/mysql/conf.d/innodb_use_native_aio.cnf
RUN chmod 644 /etc/mysql/conf.d/innodb_use_native_aio.cnf

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld"]