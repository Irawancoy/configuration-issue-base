# Stage 1: Build
FROM maven:3.9.8-amazoncorretto-17 AS builder
ENV CI=true
WORKDIR /app

# Menyalin seluruh source code dan membuild aplikasi
COPY . /app/
RUN mvn package -Dclassifier=exec -DskipTests

# Stage 2: Runner
FROM openjdk:17-slim AS runner
ENV CI=true
WORKDIR /app

# Menyalin JAR dari stage build
COPY --from=builder /app/target/example-auth-jwt-custom-0.0.0-E.jar /opt/app.jar

# Menyalin file konfigurasi ke image akhir
COPY --from=builder /app/ES512.json /opt/resources/key/ES512.json

# Expose port 8080
EXPOSE 8080

# Buat Table di Database Postgres dari file init.sql
COPY --from=builder /app/init.sql /opt/init.sql

# Menjalankan aplikasi
CMD ["java", "-Dspring.profiles.active=dev", "-jar", "/opt/app.jar"]
