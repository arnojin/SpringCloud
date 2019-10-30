@echo off

:: 设置 活动代码页
chcp 65001

net session >nul 2>&1
if %errorLevel% == 0 (
    rem 判断是否使用管理员权限执行脚本
) else (
    echo 错误：请使用管理员权限执行脚本
    pause
    exit
)

set WORK_PATH=D:\github\SpringCloud\docker-stack-deploy

:: 部署 MySQL
cd /d %WORK_PATH%\mysql
docker build -t mysql-win:5.7.27 .

cd /d %WORK_PATH%
docker stack deploy --with-registry-auth -c docker-compose.mysql.yml sc
for /F %%i in ('docker ps -q -f "name=sc_mysql"') do (set CONTAINER_ID=%%i)
docker exec -it %CONTAINER_ID% mysql -uroot -proot123 -e "show databases;"

:: 部署 nginx
cd /d %WORK_PATH%
docker stack deploy --with-registry-auth -c docker-compose.nginx.yml sc
curl -L localhost
copy /y conf.d\www.conf.example conf.d\www.conf
echo 需要增加 127.0.0.1 www.springcloud.cn 到 C:\Windows\System32\drivers\etc\hosts
pause
echo 127.0.0.1 www.springcloud.cn >> C:\Windows\System32\drivers\etc\hosts
for /F %%i in ('docker ps -q -f "name=sc_nginx"') do (set CONTAINER_ID=%%i)
docker exec -it %CONTAINER_ID% nginx -t
docker exec -it %CONTAINER_ID% nginx -s reload
curl -L www.springcloud.cn

:: 部署 Rabbit MQ
cd /d %WORK_PATH%
docker stack deploy --with-registry-auth -c docker-compose.rabbitmq.yml sc
for /F %%i in ('docker ps -q -f "name=sc_rabbitmq"') do (set CONTAINER_ID=%%i)
docker exec -it %CONTAINER_ID% rabbitmqctl status
curl -L --output - localhost:5672

:: 部署 Redis
cd /d %WORK_PATH%
docker stack deploy --with-registry-auth -c docker-compose.redis.yml sc
for /F %%i in ('docker ps -q -f "name=sc_redis"') do (set CONTAINER_ID=%%i)
docker exec -it %CONTAINER_ID% redis-cli info

:: 还原 活动代码页
pause
chcp 936