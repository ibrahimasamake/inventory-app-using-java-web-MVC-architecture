<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sell Products - Inventory Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .qty-input { width:60px !important; height:28px !important; font-size:0.8rem !important; padding:2px 6px !important; }
        .sell-btn { height:28px !important; font-size:0.8rem !important; padding:2px 10px !important; }
        .qty-col { width:160px !important; }
    </style>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/products?action=sell">Sell</a>
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
                <i class="bi bi-check-circle"></i> ${sessionScope.flashSuccess}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="flashSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle"></i> ${sessionScope.flashError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2><i class="bi bi-cart"></i> Sell Products</h2>
        </div>

        <form action="${pageContext.request.contextPath}/products?action=sell" method="get" class="row mb-4">
            <div class="col-md-6">
                <div class="input-group">
                    <input type="hidden" name="action" value="sell">
                    <input type="text" class="form-control" name="search" placeholder="Search products by name or code..." value="${param.search}">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Search</button>
                    <c:if test="${not empty param.search}">
                        <a href="${pageContext.request.contextPath}/products?action=sell" class="btn btn-outline-secondary"><i class="bi bi-x"></i> Clear</a>
                    </c:if>
                </div>
            </div>
        </form>

        <c:if test="${empty products}">
            <div class="text-center py-5">
                <i class="bi bi-box text-muted" style="font-size:3rem;"></i>
                <p class="text-muted mt-2">No products found.</p>
            </div>
        </c:if>

        <c:if test="${not empty products}">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width:50px;">Image</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Available</th>
                            <th class="qty-col">Quantity</th>
                            <th style="width:80px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.imageUrl}">
                                            <img src="${p.imageUrl}" alt="${p.name}" style="width:40px;height:40px;object-fit:cover;border-radius:4px;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-box text-muted" style="font-size:1.3rem;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${p.productCode}</td>
                                <td>${p.name}</td>
                                <td>${p.categoryName}</td>
                                <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stockQuantity == 0}">
                                            <span class="badge bg-danger">0</span>
                                        </c:when>
                                        <c:when test="${p.stockQuantity <= p.minimumStockLevel}">
                                            <span class="badge bg-warning text-dark">${p.stockQuantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">${p.stockQuantity}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/products?action=sell" method="post" class="d-flex gap-1 align-items-center" onsubmit="return confirmSell(this, '${p.name}', '${p.price}', '${p.productCode}')">
                                        <input type="hidden" name="action" value="sell">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <input type="number" name="quantity" class="form-control qty-input" value="1" min="1" max="${p.stockQuantity}" ${p.stockQuantity == 0 ? 'disabled' : ''}>
                                        <button type="submit" class="btn btn-sm btn-success sell-btn" ${p.stockQuantity == 0 ? 'disabled' : ''}>
                                            <i class="bi bi-cart-check"></i> Sell
                                        </button>
                                    </form>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/products?action=view&id=${p.id}" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-eye"></i>
                                    </a>
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

    <script>
        function confirmSell(form, productName, price, productCode) {
            const qty = parseInt(form.quantity.value);
            if (!qty || qty < 1) {
                alert('Please enter a valid quantity.');
                return false;
            }
            const total = (qty * parseFloat(price)).toFixed(2);
            return confirm(
                'Confirm Sale\n\n' +
                'Product: ' + productName + ' (' + productCode + ')\n' +
                'Quantity: ' + qty + '\n' +
                'Total: ₹' + total + '\n\n' +
                'Proceed with this sale?'
            );
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
