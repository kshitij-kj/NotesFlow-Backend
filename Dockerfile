# ---------- BUILD STAGE ----------
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /workspace

# Copy wrapper and pom first
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Convert line endings and make wrapper executable
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw

# Fetch dependencies
RUN ./mvnw -B dependency:go-offline

# Copy source and build
COPY src ./src
RUN ./mvnw -B clean package -DskipTests

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy built jar
COPY --from=build /workspace/target/*.jar app.jar

# Render sets $PORT (default 8080 for Spring Boot is fine)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]
