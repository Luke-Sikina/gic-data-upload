FROM maven:3-amazoncorretto-21 as build

COPY pom.xml .

RUN mvn -B dependency:go-offline

COPY src src

RUN mvn -B package -DskipTests

FROM amazoncorretto:21.0.1-alpine3.18

# Copy jar and access token from maven build
COPY --from=build target/dataupload-0.0.1-SNAPSHOT.jar /dataupload.jar

# Time zone
ENV TZ="US/Eastern"

EXPOSE 8080
ENTRYPOINT ["java", "-Xmx8192m", "-jar", "/dataupload.jar"]
