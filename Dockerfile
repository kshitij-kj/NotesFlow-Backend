# ---------- BUILD STAGE ----------
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /workspace

# Copy wrapper and pom first (so dependencies are cached)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Convert line endings and make wrapper executable (safe cross-platform)
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw

# Fetch dependencies only (speeds up subsequent builds)
RUN ./mvnw -B dependency:go-offline

# Copy source and build the project (skip tests in CI build)
COPY src ./src
RUN ./mvnw -B clean package -DskipTests

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy built jar
COPY --from=build /workspace/target/*.jar app.jar

# Let the container know the app will listen on a port (Render sets PORT env)
EXPOSE 8080

# Use the Render-provided PORT env var (see note below)
ENTRYPOINT ["sh","-c","java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${PORT:-8080} -jar /app/app.jar"]

