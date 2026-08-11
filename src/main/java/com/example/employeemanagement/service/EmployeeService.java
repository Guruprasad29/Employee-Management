package com.example.employeemanagement.service;

import com.example.employeemanagement.model.Employee;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    public List<Employee> getEmployees() {
        return List.of(
            new Employee(1L, "Arun", "arun@example.com", "IT"),
            new Employee(2L, "Priya", "priya@example.com", "HR")
        );
    }

    public Employee getEmployee(Long id) {
        return getEmployees().stream()
                .filter(employee -> employee.id().equals(id))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Employee not found: " + id));
    }
}
