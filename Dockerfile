## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:19.1.1 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
USER root
RUN chown -R quarkus /usr/src/app
USER quarkus
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package

## Stage 2 : create the docker final image
# FROM registry.access.redhat.com/ubi8/ubi-minimal
# FROM openjdk:8-jre-alpine
# FROM debian:stable-slim AS build-env

#FROM gcr.io/distroless/base
#FROM alpine:3.7 
FROM frolvlad/alpine-glibc
WORKDIR /work/
COPY --from=build /usr/src/app/target/*-runner /work/application
#COPY --from=build-env /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
#RUN chmod 775 /work
EXPOSE 8080
CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]