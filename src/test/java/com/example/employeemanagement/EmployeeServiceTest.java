package com.example.employeemanagement;

import com.example.employeemanagement.model.Employee;
import com.example.employeemanagement.service.EmployeeService;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class EmployeeServiceTest {

    private final EmployeeService service = new EmployeeService();

    @Test
    void shouldReturnEmployees() {
        assertEquals(2, service.getEmployees().size());
    }

    @Test
    void shouldFindEmployeeById() {
        Employee employee = service.getEmployee(1L);
        assertEquals("Arun", employee.name());
    }

    @Test
    void shouldThrowWhenEmployeeDoesNotExist() {
        assertThrows(IllegalArgumentException.class, () -> service.getEmployee(999L));
    }
}
