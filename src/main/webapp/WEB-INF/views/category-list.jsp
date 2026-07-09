<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - Inventory Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">Inventory System</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products?action=sell">Sell</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products?action=sales-history">Sales History</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <c:if test="${not empty sessionScope.flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show">
                ${sessionScope.flashSuccess}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="flashSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-danger alert-dismissible fade show">
                ${sessionScope.flashError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="d-flex justify-content-between align-items-center">
            <h2>Categories</h2>
            <a href="${pageContext.request.contextPath}/categories?action=new" class="btn btn-primary">Add Category</a>
        </div>

        <form action="${pageContext.request.contextPath}/categories" method="get" class="row mt-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input type="text" class="form-control" name="search" placeholder="Search categories..." value="${param.search}">
                    <button type="submit" class="btn btn-outline-primary">Search</button>
                    <c:if test="${not empty param.search}">
                        <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline-secondary">Clear</a>
                    </c:if>
                </div>
            </div>
        </form>

        <c:if test="${empty categories}">
            <div class="alert alert-info mt-4">No categories found. Add your first category!</div>
        </c:if>

        <c:if test="${not empty categories}">
            <table class="table table-bordered table-hover mt-4">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Products</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${categories}">
                        <tr>
                            <td>${c.id}</td>
                            <td>${c.name}</td>
                            <td>${c.description}</td>
                            <td><span class="badge bg-secondary">${c.productCount}</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/categories?action=edit&id=${c.id}" class="btn btn-sm btn-warning">Edit</a>
                                <a href="${pageContext.request.contextPath}/categories?action=delete&id=${c.id}" class="btn btn-sm btn-danger" onclick="return confirm('Delete category \'${c.name}\'?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <div class="container mt-4 mb-4">
        <p class="text-muted text-center">&copy; 2026 Inventory Management System</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
