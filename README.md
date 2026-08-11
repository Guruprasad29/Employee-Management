# Employee Management CI/CD Project

This project demonstrates the requested Git + Jenkins + Maven + Docker workflow.

## Scenario
- Developer A: adds the Employee API
- Developer B: modifies the same service, intentionally creating a Git merge conflict
- Developer C: updates database configuration
- Changes are merged into `develop`
- Jenkins automatically:
  1. Checks out `develop`
  2. Runs Maven compile/test/package
  3. Creates the JAR
  4. Builds a Docker image
  5. Stops/removes the previous container
  6. Deploys the new container
- Docker deployment only occurs when Maven tests pass.

## Project structure

```text
employee-management-cicd/
├── src/main/java/com/example/employeemanagement/
│   ├── EmployeeManagementApplication.java
│   ├── controller/EmployeeController.java
│   ├── model/Employee.java
│   └── service/EmployeeService.java
├── src/test/java/com/example/employeemanagement/
│   └── EmployeeServiceTest.java
├── Dockerfile
├── Jenkinsfile
├── pom.xml
├── .gitignore
├── docker-compose.yml
├── scripts/
│   ├── setup-git-demo.sh
│   └── run-local.sh
└── docs/
    └── PROJECT-WALKTHROUGH.md
```

## Prerequisites
- JDK 17+
- Git
- Maven 3.9+
- Docker
- Jenkins with Pipeline and Git support
- A Git repository containing this project

## Run locally

```bash
mvn clean test package
java -jar target/employee-management-1.0.0.jar
```

The API is available on port 8080.

Example:

```bash
curl http://localhost:8080/api/employees
```

## Docker

```bash
docker build -t employee-management:latest .
docker run -d --name employee-management -p 8080:8080 employee-management:latest
```

## Jenkins

Create a Jenkins Pipeline job and configure it to use the repository containing this project.

For a simple branch-based demonstration, the Jenkinsfile checks out `develop` explicitly. For a production setup, use a Multibranch Pipeline or webhook-triggered Pipeline.

The important safety rule is implemented by Jenkins stages: Docker build/deployment are reached only after the Maven test/package stage succeeds.

## Git conflict demonstration

Run `scripts/setup-git-demo.sh` from a clone of the repository if you want to create the demonstration branches. The script creates:
- `developer-a`
- `developer-b`
- `developer-c`

Developer A and B modify the same service line to create a real merge conflict. Resolve the conflict, merge the branches into `develop`, and push `develop`.

See `docs/PROJECT-WALKTHROUGH.md` for the complete procedure.
