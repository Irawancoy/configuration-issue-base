FROM maven:3.9.8-amazoncorretto-17 AS builder
ENV CI=true
WORKDIR /app

COPY . /app/
RUN mvn package -Dclassifier=exec -DskipTests

FROM openjdk:17-slim AS runner
ENV CI=true
WORKDIR /app

COPY --from=builder /app/target/example-auth-jwt-custom-0.0.0-E.jar /opt/app.jar

COPY --from=builder /app/ES512.json /opt/resources/key/ES512.json

EXPOSE 8080

CMD ["java", "-jar", "/opt/app.jar"]