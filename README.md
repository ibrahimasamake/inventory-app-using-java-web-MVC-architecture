# Product Inventory Management System

A simple Java Enterprise inventory management web application built with Jakarta Servlets, JSP, JSTL, JDBC, MySQL, and Bootstrap 5.

## Prerequisites

- Java 17 or later
- Apache Maven
- Apache Tomcat 10 or later
- MySQL 8 or later

## Setup Instructions

### 1. Database Setup

1. Start your MySQL server.
2. Run the SQL script to create the database and tables:

```bash
mysql -u root -p < database.sql
```

### 2. Configure Database Connection

Edit `src/main/resources/database.properties` with your MySQL credentials:

```properties
db.url=jdbc:mysql://localhost:3306/inventory_db?useSSL=false&serverTimezone=UTC
db.username=root
db.password=your_password
db.driver=com.mysql.cj.jdbc.Driver
```

### 3. Build the Application

```bash
mvn clean package
```

This generates `target/inventory-system.war`.

### 4. Deploy to Tomcat

1. Copy `target/inventory-system.war` to your Tomcat `webapps` directory.
2. Start Tomcat.
3. Open your browser to: `http://localhost:8080/inventory-system/`

## Usage Flow

1. Open the dashboard to view summary statistics.
2. Add categories via the Categories page.
3. Add products via the Products page.
4. View, search, filter, edit, and delete products.
5. Use the low-stock filter to identify products needing restocking.

## Project Structure

```
inventory-system/
├── pom.xml
├── database.sql
├── README.md
├── src/main/java/com/inventory/
│   ├── controller/     # Servlets
│   ├── dao/            # Data Access Objects
│   ├── model/          # JavaBeans
│   └── util/           # Database connection
├── src/main/resources/ # Properties files
└── src/main/webapp/    # JSP views and assets
```
# inventory-app-using-java-web-MVC-architecture
