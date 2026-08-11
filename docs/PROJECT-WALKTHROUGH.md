# Employee Management CI/CD — Project Walkthrough

## 1. Objective

Build a realistic beginner-friendly CI/CD project in which three developers work on an Employee Management application. Git branches demonstrate parallel development and conflict resolution. Jenkins automates build, test, packaging, Docker image creation, and deployment.

## 2. Git workflow

Recommended branch structure:

```text
main
  |
develop
  |---- developer-a
  |---- developer-b
  |---- developer-c
```

Developer A and Developer B intentionally edit the same service line.

### Commands

```bash
git clone <YOUR-REPOSITORY-URL>
cd employee-management-cicd

git checkout -b develop
git push -u origin develop

git checkout -b developer-a
# edit EmployeeService.java
git add .
git commit -m "Developer A: add employee API"
git push -u origin developer-a

git checkout develop
git checkout -b developer-b
# edit the same line in EmployeeService.java differently
git add .
git commit -m "Developer B: modify employee service"
git push -u origin developer-b

git checkout develop
git checkout -b developer-c
# update application.properties
git add .
git commit -m "Developer C: update database configuration"
git push -u origin developer-c
```

## 3. Resolve the merge conflict

Merge Developer A first:

```bash
git checkout develop
git merge developer-a
```

Then merge Developer B:

```bash
git merge developer-b
```

Git should report a conflict in `EmployeeService.java`.

Check:

```bash
git status
```

Open the file and look for:

```text
<<<<<<< HEAD
...
=======
...
>>>>>>> developer-b
```

Keep the final desired implementation, remove the conflict markers, then:

```bash
git add src/main/java/com/example/employeemanagement/service/EmployeeService.java
git commit -m "Resolve merge conflict between developer A and B"
```

Merge Developer C:

```bash
git merge developer-c
git push origin develop
```

## 4. Verify Maven

```bash
mvn clean test
```

Expected result:

```text
Tests run: 3, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

Create the JAR:

```bash
mvn clean package
```

Expected artifact:

```text
target/employee-management.jar
```

## 5. Test the application

```bash
java -jar target/employee-management.jar
```

In another terminal:

```bash
curl http://localhost:8080/api/employees
```

Expected response:

```json
[
  {"id":1,"name":"Arun","email":"arun@example.com","department":"IT"},
  {"id":2,"name":"Priya","email":"priya@example.com","department":"HR"}
]
```

## 6. Build and run Docker manually

```bash
docker build -t employee-management:latest .
docker run -d --name employee-management -p 8080:8080 employee-management:latest
docker ps
```

Stop it:

```bash
docker stop employee-management
docker rm employee-management
```

## 7. Jenkins setup

### Prerequisites

The Jenkins agent that executes the pipeline needs:

- Java/JDK
- Git
- Maven
- Docker
- Permission to access the Docker daemon

### Create a Pipeline job

1. Open Jenkins.
2. Select **New Item**.
3. Enter `employee-management-cicd`.
4. Select **Pipeline**.
5. In Pipeline configuration, select **Pipeline script from SCM**.
6. Select **Git**.
7. Enter your repository URL.
8. Set branch to `*/develop`.
9. Set Script Path to `Jenkinsfile`.
10. Save and build.

### Important Jenkinsfile change

Before running, replace:

```text
https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

with your real repository URL.

If using **Pipeline script from SCM**, a cleaner Jenkinsfile is to remove the explicit checkout stage because Jenkins already checks out the Jenkinsfile's revision.

For a Multibranch Pipeline, configure the repository and let Jenkins discover `develop`.

## 8. Automatic triggering after merge

For GitHub:

1. Configure the Jenkins Git/GitHub integration.
2. Add a GitHub webhook pointing to your Jenkins webhook endpoint.
3. Enable the appropriate GitHub webhook trigger in the Jenkins job.
4. Push the merged `develop` branch.
5. Jenkins starts the pipeline.

Conceptual flow:

```text
Developer A ──┐
Developer B ──┼──> develop ──> GitHub Webhook ──> Jenkins
Developer C ──┘                                  |
                                                  v
                                             Checkout
                                                  |
                                                  v
                                           Maven Test/Build
                                                  |
                                  +---------------+---------------+
                                  |                               |
                               PASS                              FAIL
                                  |                               |
                                  v                               X
                           Create JAR                            STOP
                                  |
                                  v
                           Docker Build
                                  |
                                  v
                        Stop Old Container
                                  |
                                  v
                         Deploy New Container
```

## 9. Critical failure behavior

The Jenkinsfile uses:

```groovy
stage('Maven Build, Test and Package') {
    steps {
        sh 'mvn clean test package'
    }
}
```

If a test fails, the shell command returns a non-zero exit code. Jenkins marks the stage/pipeline as failed and does not proceed to the Docker stages.

Therefore:

```text
Maven test FAIL
      |
      v
Jenkins pipeline FAIL
      |
      X
Docker build/deployment does NOT run
```

This is the key CI/CD requirement.

## 10. Evidence/screenshots to capture for your project document

Capture these screenshots:

1. Git branches:
   `git branch -a`

2. Developer A commit.

3. Developer B commit.

4. Developer C commit.

5. Merge conflict showing `<<<<<<<`, `=======`, `>>>>>>>`.

6. Resolved `EmployeeService.java`.

7. Successful `git merge` into `develop`.

8. GitHub `develop` branch containing the merged code.

9. Jenkins pipeline stages showing:
   - Checkout
   - Maven Build, Test and Package
   - Build Docker Image
   - Stop Previous Container
   - Deploy New Container

10. Maven successful test output.

11. Docker image:
   `docker images`

12. Running container:
   `docker ps`

13. API output:
   `curl http://localhost:8080/api/employees`

14. Failure demonstration: intentionally make one unit test fail and show that Docker deployment stages are skipped.

## 11. Final expected result

```text
Developer branches
       |
       v
Merge conflict
       |
       v
Resolve conflict
       |
       v
Merge into develop
       |
       v
Jenkins triggered
       |
       v
Maven build + unit tests
       |
   +---+---+
   |       |
  FAIL    PASS
   |       |
   X       v
Stop    Create JAR
        |
        v
    Docker image
        |
        v
   Stop old container
        |
        v
   Deploy new version
```
