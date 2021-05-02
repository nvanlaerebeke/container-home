FROM httpd:latest
COPY --chown=daemon ./src /usr/local/apache2/htdocs