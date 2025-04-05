# Stage 1: Build the Java application using Maven
FROM maven:3.8.7-openjdk-17-slim AS builder

# Set working directory inside container
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Package the application (creates a JAR file)
RUN mvn clean package -DskipTests

# Stage 2: Run the application using a smaller JDK image
FROM openjdk:17-slim

# Set working directory
WORKDIR /app

# Copy only the JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Command to run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
