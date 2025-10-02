CREATE DATABASE PayrollDB_ABC;
USE PayrollDB_ABC;

CREATE TABLE Department (
    DeptCode VARCHAR(10) PRIMARY KEY,
    DeptName NVARCHAR(50)
);

CREATE TABLE Employee (
    EmployeeCode VARCHAR(10) PRIMARY KEY,
    EmployeeName NVARCHAR(50),
    DeptCode VARCHAR(10),
    BasicSalary DECIMAL(10,2),
    FOREIGN KEY (DeptCode) REFERENCES Department(DeptCode)
);

CREATE TABLE Payroll (
    PayrollID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeCode VARCHAR(10),
    Month CHAR(7),
    WorkingDays INT,
    DaysOffWithPay INT,
    DaysOffWithoutPay INT,
    GrossSalary DECIMAL(12,2),
    NetSalary DECIMAL(12,2),
    Note NVARCHAR(100),
    FOREIGN KEY (EmployeeCode) REFERENCES Employee(EmployeeCode)
);
go

CREATE PROCEDURE sp_AddDepartment
    @DeptCode VARCHAR(10),
    @DeptName NVARCHAR(50)
AS
BEGIN
    INSERT INTO Department(DeptCode, DeptName)
    VALUES(@DeptCode, @DeptName);
END;
GO

EXEC sp_AddDepartment 'IT', N'Công nghệ thông tin';
EXEC sp_AddDepartment 'HR', N'Nhân sự';
EXEC sp_AddDepartment 'SALE', N'Kinh doanh';
go

CREATE PROCEDURE sp_AddEmployee
    @EmployeeCode VARCHAR(10),
    @EmployeeName NVARCHAR(50),
    @DeptCode VARCHAR(10),
    @BasicSalary DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Employee(EmployeeCode, EmployeeName, DeptCode, BasicSalary)
    VALUES(@EmployeeCode, @EmployeeName, @DeptCode, @BasicSalary);
END;
GO

EXEC sp_AddEmployee 'A1', N'Nguyễn Văn A', 'IT', 1000;
EXEC sp_AddEmployee 'A2', N'Lê Thị Bình', 'IT', 1200;
EXEC sp_AddEmployee 'B1', N'Nguyễn Lan', 'HR', 600;
EXEC sp_AddEmployee 'D1', N'Mai Tuấn Anh', 'HR', 500;
EXEC sp_AddEmployee 'C1', N'Hà Thị Lan', 'HR', 500;
EXEC sp_AddEmployee 'C2', N'Lê Tú Chinh', 'SALE', 1200;
EXEC sp_AddEmployee 'D2', N'Trần Văn Toàn', 'HR', 500;
EXEC sp_AddEmployee 'A3', N'Trần Văn Nam', 'IT', 1200;
EXEC sp_AddEmployee 'B2', N'Huỳnh Anh', 'SALE', 1200;
go

CREATE PROCEDURE sp_AddPayroll
    @EmployeeCode VARCHAR(10),
    @Month CHAR(7),
    @WorkingDays INT,
    @DaysOffWithPay INT,
    @DaysOffWithoutPay INT,
    @GrossSalary DECIMAL(12,2),
    @NetSalary DECIMAL(12,2),
    @Note NVARCHAR(100)
AS
BEGIN
    INSERT INTO Payroll(EmployeeCode, Month, WorkingDays, DaysOffWithPay, DaysOffWithoutPay, GrossSalary, NetSalary, Note)
    VALUES(@EmployeeCode, @Month, @WorkingDays, @DaysOffWithPay, @DaysOffWithoutPay, @GrossSalary, @NetSalary, @Note);
END;
GO

EXEC sp_AddPayroll 'A1', '2025-10', 22, 0, 0, 22000, 20000, NULL;
EXEC sp_AddPayroll 'A2', '2025-10', 21, 1, 0, 26400, 23000, NULL;
EXEC sp_AddPayroll 'B1', '2025-10', 20, 1, 1, 13200, 12000, NULL;
EXEC sp_AddPayroll 'D1', '2025-10', 20, 1, 1, 11000, 10000, NULL;
EXEC sp_AddPayroll 'C1', '2025-10', 22, 0, 0, 11000, 10000, NULL;
EXEC sp_AddPayroll 'C2', '2025-10', 22, 0, 0, 26400, 23000, NULL;
EXEC sp_AddPayroll 'D2', '2025-10', 22, 0, 0, 11000, 10000, NULL;
EXEC sp_AddPayroll 'A3', '2025-10', 22, 0, 0, 26400, 23000, NULL;
EXEC sp_AddPayroll 'B2', '2025-10', 21, 1, 0, 26400, 23000, NULL;
go

CREATE PROCEDURE sp_TotalSalaryByDept
AS
BEGIN
    SELECT d.DeptCode,
           SUM(p.NetSalary) AS TotalNetSalary
    FROM Payroll p
    INNER JOIN Employee e ON p.EmployeeCode = e.EmployeeCode
    INNER JOIN Department d ON e.DeptCode = d.DeptCode
    GROUP BY d.DeptCode
    ORDER BY d.DeptCode ASC;
END;
GO

EXEC sp_TotalSalaryByDept;

