#!/usr/bin/env bash
set -e

# Run this script from a clean clone after creating the initial commit.
git checkout -b develop
git push -u origin develop

# Developer A
git checkout -b developer-a
python3 - <<'PY'
from pathlib import Path
p = Path("src/main/java/com/example/employeemanagement/service/EmployeeService.java")
s = p.read_text()
s = s.replace("public List<Employee> getEmployees() {",
              "public List<Employee> getEmployees() { // Developer A: employee API implementation")
p.write_text(s)
PY
git add .
git commit -m "Developer A: add employee API implementation"

# Developer B starts from develop, then changes the same line to demonstrate conflict.
git checkout develop
git checkout -b developer-b
python3 - <<'PY'
from pathlib import Path
p = Path("src/main/java/com/example/employeemanagement/service/EmployeeService.java")
s = p.read_text()
s = s.replace("public List<Employee> getEmployees() {",
              "public List<Employee> getEmployees() { // Developer B: modify employee service")
p.write_text(s)
PY
git add .
git commit -m "Developer B: modify employee service"

# Developer C
git checkout develop
git checkout -b developer-c
python3 - <<'PY'
from pathlib import Path
p = Path("src/main/resources/application.properties")
s = p.read_text()
s += "\n# Developer C database configuration\n"
p.write_text(s)
PY
git add .
git commit -m "Developer C: update database configuration"

# Merge A first.
git checkout develop
git merge developer-a

# Merge B: this should produce a conflict because A and B changed the same line.
git merge developer-b || true

echo
echo "A merge conflict is expected."
echo "Open EmployeeService.java and resolve the conflict."
echo "Then run:"
echo "  git add ."
echo "  git commit -m 'Resolve merge conflict between developer A and B'"
echo "  git merge developer-c"
echo "  git push origin develop"
