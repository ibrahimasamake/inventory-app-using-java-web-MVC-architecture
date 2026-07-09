<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Inventory Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/products">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/categories">Categories</a>
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
            <h2>Products</h2>
            <div>
                <a href="${pageContext.request.contextPath}/products?action=export" class="btn btn-success me-2">Export CSV</a>
                <a href="${pageContext.request.contextPath}/products?action=new" class="btn btn-primary">Add Product</a>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/products" method="get" class="row mt-4">
            <div class="col-md-5">
                <div class="input-group">
                    <input type="text" class="form-control" name="search" placeholder="Search by name or code..." value="${param.search}">
                    <button type="submit" class="btn btn-outline-primary">Search</button>
                </div>
            </div>
            <div class="col-md-4">
                <select class="form-select" name="categoryId">
                    <option value="">All Categories</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" ${param.categoryId == c.id.toString() ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <div class="d-flex">
                    <select class="form-select me-2" name="stockStatus">
                        <option value="">All Stock</option>
                        <option value="low" ${param.stockStatus == 'low' ? 'selected' : ''}>Low Stock Only</option>
                    </select>
                    <button type="submit" class="btn btn-outline-primary">Filter</button>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary ms-2">Clear</a>
                </div>
            </div>
        </form>

        <c:if test="${not empty param.search}">
            <p class="mt-3">Search results for: <strong>${param.search}</strong></p>
        </c:if>

        <c:if test="${empty products}">
            <div class="alert alert-info mt-4">No products found.</div>
        </c:if>

        <c:if test="${not empty products}">
            <div class="table-responsive mt-4">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th style="width:60px;">Image</th>
                            <th><a href="${pageContext.request.contextPath}/products?sort=product_code&order=${currentSort == 'product_code' && currentOrder == 'ASC' ? 'DESC' : 'ASC'}&search=${param.search}&categoryId=${param.categoryId}&stockStatus=${param.stockStatus}" class="text-decoration-none text-dark">Code ${currentSort == 'product_code' ? (currentOrder == 'ASC' ? '▲' : '▼') : ''}</a></th>
                            <th><a href="${pageContext.request.contextPath}/products?sort=name&order=${currentSort == 'name' && currentOrder == 'ASC' ? 'DESC' : 'ASC'}&search=${param.search}&categoryId=${param.categoryId}&stockStatus=${param.stockStatus}" class="text-decoration-none text-dark">Name ${currentSort == 'name' ? (currentOrder == 'ASC' ? '▲' : '▼') : ''}</a></th>
                            <th><a href="${pageContext.request.contextPath}/products?sort=category_name&order=${currentSort == 'category_name' && currentOrder == 'ASC' ? 'DESC' : 'ASC'}&search=${param.search}&categoryId=${param.categoryId}&stockStatus=${param.stockStatus}" class="text-decoration-none text-dark">Category ${currentSort == 'category_name' ? (currentOrder == 'ASC' ? '▲' : '▼') : ''}</a></th>
                            <th><a href="${pageContext.request.contextPath}/products?sort=price&order=${currentSort == 'price' && currentOrder == 'ASC' ? 'DESC' : 'ASC'}&search=${param.search}&categoryId=${param.categoryId}&stockStatus=${param.stockStatus}" class="text-decoration-none text-dark">Price ${currentSort == 'price' ? (currentOrder == 'ASC' ? '▲' : '▼') : ''}</a></th>
                            <th><a href="${pageContext.request.contextPath}/products?sort=stock_quantity&order=${currentSort == 'stock_quantity' && currentOrder == 'ASC' ? 'DESC' : 'ASC'}&search=${param.search}&categoryId=${param.categoryId}&stockStatus=${param.stockStatus}" class="text-decoration-none text-dark">Stock ${currentSort == 'stock_quantity' ? (currentOrder == 'ASC' ? '▲' : '▼') : ''}</a></th>
                            <th>Min Stock</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="${p.imageUrl}" alt="${p.name}" style="width:50px;height:50px;object-fit:cover;border-radius:4px;">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${p.productCode}</td>
                            <td><a href="${pageContext.request.contextPath}/products?action=view&id=${p.id}" class="text-decoration-none fw-medium">${p.name}</a></td>
                                <td>${p.categoryName}</td>
                                <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/></td>
                                <td>${p.stockQuantity}</td>
                                <td>${p.minimumStockLevel}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stockStatus == 'IN STOCK'}">
                                            <span class="badge bg-success">IN STOCK</span>
                                        </c:when>
                                        <c:when test="${p.stockStatus == 'LOW STOCK'}">
                                            <span class="badge bg-warning text-dark">LOW STOCK</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">OUT OF STOCK</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/products?action=view&id=${p.id}" class="btn btn-sm btn-outline-primary" title="View"><i class="bi bi-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/products?action=edit&id=${p.id}" class="btn btn-sm btn-warning" title="Edit"><i class="bi bi-pencil"></i></a>
                                    <a href="${pageContext.request.contextPath}/products?action=clone&id=${p.id}" class="btn btn-sm btn-info text-white" title="Clone"><i class="bi bi-copy"></i></a>
                                    <a href="${pageContext.request.contextPath}/products?action=delete&id=${p.id}" class="btn btn-sm btn-danger" title="Delete" onclick="return confirm('Delete this product?')"><i class="bi bi-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>

    <div class="container mt-4 mb-4">
        <p class="text-muted text-center">&copy; 2026 Inventory Management System</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
