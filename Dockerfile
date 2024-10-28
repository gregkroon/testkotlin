# First stage: Build the application
FROM openjdk:24-slim-bookworm AS build
COPY --chown=gradle:gradle . /harness/gradle/src
WORKDIR /harness/gradle/src
RUN ./gradlew build
RUN pwd
RUN find . -name "spring-petclinic-kotlin-3.3.0.jar"

# Second stage: Prepare runtime image
FROM openjdk:24-slim-bookworm
EXPOSE 8080

# Copy and rename the JAR file from the build stage to the /app directory
COPY --from=build /harness/gradle/src/build/libs/spring-petclinic-kotlin-3.3.0.jar /app/spring-kotlin-petclinic.jar

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/spring-kotlin-petclinic.jar"]

