#!/usr/bin/env bash
set -e
mvn clean test package
java -jar target/employee-management.jar
