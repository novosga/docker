# NovoSGA 2.0

Compose file

```yaml
version: '2'

services:
  novosga:
    image: novosga/novosga:2.0.0-BETA2
    restart: always
    depends_on:
      - mysqldb
    ports:
      - "80:80"
    environment:
      APP_ENV: 'prod'
      # database connection
      DATABASE_URL: 'mysql://novosga@mysqldb:3306/novosga2?charset=utf8mb4&serverVersion=5.7'
      DATABASE_PASS: 'MySQL_App_P@ssW0rd!'
      # default admin user
      NOVOSGA_ADMIN_USERNAME: 'admin'
      NOVOSGA_ADMIN_PASSWORD: '123456'
      NOVOSGA_ADMIN_FIRSTNAME: 'Administrator'
      NOVOSGA_ADMIN_LASTNAME: 'Global'
      # default unity
      NOVOSGA_UNITY_NAME: 'My Unity'
      NOVOSGA_UNITY_CODE: 'U01'
      # default no-priority
      NOVOSGA_NOPRIORITY_NAME: 'Normal'
      NOVOSGA_NOPRIORITY_DESCRIPTION: 'Normal service'
      # default priority
      NOVOSGA_PRIORITY_NAME: 'Priority'
      NOVOSGA_PRIORITY_DESCRIPTION: 'Priority service'
      # default place
      NOVOSGA_PLACE_NAME: 'Box'
  mysqldb:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_USER: 'novosga'
      MYSQL_DATABASE: 'novosga2'
      MYSQL_ROOT_PASSWORD: 'MySQL_r00t_P@ssW0rd!'
```

Running docker-compose

```
docker-compose up -d
```

Log in on MySQL database as root:

```
docker-compose exec mysqldb sh -c  'mysql -uroot -p'
```

Grant access to application user:

```sql
GRANT ALL ON novosga2.* TO 'novosga'@'%' IDENTIFIED BY 'MySQL_App_P@ssW0rd!';
quit
```

Run Novo SGA install

```
docker-compose exec novosga sh -c 'bin/console novosga:install'
```
