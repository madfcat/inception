ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpassword';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'rootpassword' WITH GRANT OPTION;
		FLUSH PRIVILEGES;