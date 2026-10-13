# ============================================================
# Stage 1: Build
# ============================================================
FROM maven:3.9.11-eclipse-temurin-17 AS builder

WORKDIR /workspace

# Copy API Gateway Maven configuration and source
COPY gwatcho-api-gateway/pom.xml /workspace/api-gateway/pom.xml
COPY gwatcho-api-gateway/src /workspace/api-gateway/src

# Build API Gateway independently
RUN mvn -B -f /workspace/api-gateway/pom.xml \
    clean package -DskipTests


# ============================================================
# Stage 2: Runtime
# ============================================================
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /workspace/api-gateway/target/*.jar app.jar

EXPOSE 8085

ENTRYPOINT ["java", "-jar", "app.jar"]
