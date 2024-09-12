# Inception tests

## Test if containers run main executable for PID 1

The PID 1 executable should be a main process

```
docker exec -it mariadb ps aux
```
```
docker exec -it wordpress ps aux
```

## Check root user password in mariadb

### Access the MariaDB Container
```
docker exec -it mariadb /bin/sh
```

### Login as the Root User
```
mysql -u root -p
```