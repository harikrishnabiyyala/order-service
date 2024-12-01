# Stage 1: Build
FROM eclipse-temurin:21-jdk-jammy AS build

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (including transitive ones)
RUN ./mvnw dependency:go-offline

# Copy the source code
COPY src ./src

# Package the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy AS runtime

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar order-service.jar

# Expose the application port
EXPOSE 8081

# Define the command to run the application
ENTRYPOINT ["java", "-jar", "order-service.jar"]