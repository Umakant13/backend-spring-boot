# Stage 1: Build the application using Maven and OpenJDK 17
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files (pom.xml, etc.)
COPY pom.xml .

# Download the dependencies (this will cache dependencies unless pom.xml changes)
RUN mvn dependency:go-offline

# Copy the rest of the project files
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the final image for running the application
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080 (or your configured port)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
