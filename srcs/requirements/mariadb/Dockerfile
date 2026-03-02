FROM debian:bookworm
LABEL version="1.0"
LABEL description="MariaDB Server"

RUN apt-get update && apt-get install -y mariadb-server

COPY tools/docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]