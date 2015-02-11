FROM rancher/docker-dind-base:latest
MAINTAINER James Harris "<james@rancher.com>"
COPY ./ /source
EXPOSE 8000

CMD [ "/source/run.sh" ]
