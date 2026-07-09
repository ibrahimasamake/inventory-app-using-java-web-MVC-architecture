<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${action == 'update' ? 'Edit' : 'Add'} Product - Inventory Management</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/products">Products</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2>${action == 'update' ? 'Edit' : 'Add'} Product</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/products?action=${action}" method="post" class="mt-4">
            <c:if test="${action == 'update'}">
                <input type="hidden" name="id" value="${product.id}">
            </c:if>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="productCode" class="form-label">Product Code <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="productCode" name="productCode" value="${product.productCode}" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="name" class="form-label">Product Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="name" name="name" value="${product.name}" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3">${product.description}</textarea>
            </div>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="categoryId" class="form-label">Category <span class="text-danger">*</span></label>
                    <select class="form-select" id="categoryId" name="categoryId" required>
                        <option value="">Select Category</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.id}" ${product.categoryId == c.id ? 'selected' : ''}>${c.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4 mb-3">
                    <label for="price" class="form-label">Price</label>
                    <input type="number" step="0.01" class="form-control" id="price" name="price" value="${product.price}">
                </div>
                <div class="col-md-4 mb-3">
                    <label for="imageUrl" class="form-label">Image URL</label>
                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" value="${product.imageUrl}" placeholder="https://...">
                </div>
            </div>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="stockQuantity" class="form-label">Stock Quantity</label>
                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="${product.stockQuantity}">
                </div>
                <div class="col-md-4 mb-3">
                    <label for="minimumStockLevel" class="form-label">Minimum Stock Level</label>
                    <input type="number" class="form-control" id="minimumStockLevel" name="minimumStockLevel" value="${product.minimumStockLevel}">
                </div>
            </div>

            <button type="submit" class="btn btn-primary">${action == 'update' ? 'Update' : 'Save'}</button>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Cancel</a>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
