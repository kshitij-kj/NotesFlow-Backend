# ---------- BUILD STAGE ----------
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /workspace

# copy wrapper and pom first (caches dependencies)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# ensure wrapper is executable (works even if committed from Windows)
RUN chmod +x mvnw

# fetch dependencies (offline) to speed subsequent builds
RUN ./mvnw -B dependency:go-offline

# copy source and build
COPY src ./src
RUN ./mvnw -B clean package -DskipTests

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# copy built jar (pattern may match your artifact)
COPY --from=build /workspace/target/*.jar app.jar

# expose default port (Render will assign actual port via $PORT)
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app/app.jar"]
