FROM eyra/comic:latest
USER root
COPY initialize-db.sh /app
RUN apt-get update && apt-get -y install postgresql-client
RUN chmod +x /app/initialize-db.sh
RUN chown 2001:2001 /app/initialize-db.sh
USER 2001:2001
CMD ["sh", "-c", "./initialize-db.sh"] 