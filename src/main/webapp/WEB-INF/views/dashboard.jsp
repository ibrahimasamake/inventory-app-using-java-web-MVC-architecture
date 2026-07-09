<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Inventory Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .sell-card { transition: box-shadow .2s; }
        .sell-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,.12); }
        .sell-card .card-img-top { height:160px; object-fit:cover; background:#f8f9fa; }
        .sell-card .qty-input { width:60px !important; height:28px !important; font-size:.8rem !important; padding:2px 6px !important; }
        .sell-card .sell-btn { height:28px !important; font-size:.8rem !important; padding:2px 10px !important; }
        .img-placeholder { height:160px; display:flex; align-items:center; justify-content:center; background:#f8f9fa; color:#adb5bd; font-size:2.5rem; }
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
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

        <h2>Dashboard</h2>

        <div class="row mt-4">
            <div class="col-md-3 mb-3">
                <div class="card text-bg-primary">
                    <div class="card-body">
                        <h5 class="card-title">Total Products</h5>
                        <p class="card-text display-6">${totalProducts}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-bg-success">
                    <div class="card-body">
                        <h5 class="card-title">Total Categories</h5>
                        <p class="card-text display-6">${totalCategories}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-bg-info">
                    <div class="card-body">
                        <h5 class="card-title">Total Stock</h5>
                        <p class="card-text display-6">${totalStock}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-bg-warning">
                    <div class="card-body">
                        <h5 class="card-title">Low Stock Items</h5>
                        <p class="card-text display-6">${lowStockCount}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-2">
            <div class="col-md-6 mb-3">
                <div class="card text-bg-dark">
                    <div class="card-body">
                        <h5 class="card-title">Total Inventory Value</h5>
                        <p class="card-text display-6">${totalStockValueFormatted}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-3 d-flex align-items-center justify-content-end">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-lg">Manage Products</a>
                <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline-success btn-lg ms-2">Manage Categories</a>
            </div>
        </div>

        <div class="mt-4">
            <div class="d-flex justify-content-between align-items-center">
                <h4>Latest Products</h4>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
            <c:if test="${empty latestProducts}">
                <p class="text-muted">No products yet.</p>
            </c:if>
            <c:if test="${not empty latestProducts}">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${latestProducts}">
                            <tr>
                                <td>${p.productCode}</td>
                                <td>${p.name}</td>
                                <td>${p.categoryName}</td>
                                <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/></td>
                                <td>${p.stockQuantity}</td>
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
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <div class="mt-5">
            <h4><i class="bi bi-lightning"></i> Quick Sell</h4>
            <c:if test="${empty quickSellProducts}">
                <p class="text-muted">No products available.</p>
            </c:if>
            <c:if test="${not empty quickSellProducts}">
                <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-3 mt-2">
                    <c:forEach var="p" items="${quickSellProducts}">
                        <div class="col">
                            <div class="card h-100 sell-card border">
                                <a href="${pageContext.request.contextPath}/products?action=view&id=${p.id}" class="text-decoration-none">
                                    <c:choose>
                                        <c:when test="${not empty p.imageUrl}">
                                            <img src="${p.imageUrl}" class="card-img-top" alt="${p.name}" loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="img-placeholder"><i class="bi bi-box-seam"></i></div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="card-body p-2 d-flex flex-column">
                                    <div class="small text-muted">${p.productCode}</div>
                                    <div class="fw-semibold" style="font-size:.9rem;">${p.name}</div>
                                    <div class="d-flex justify-content-between align-items-center mt-1 mb-1">
                                        <span class="fw-bold text-primary" style="font-size:.95rem;">₹ ${p.price}</span>
                                        <span class="small">Stock: ${p.stockQuantity}</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${p.stockStatus == 'IN STOCK'}">
                                            <span class="badge bg-success mb-2 align-self-start">IN STOCK</span>
                                        </c:when>
                                        <c:when test="${p.stockStatus == 'LOW STOCK'}">
                                            <span class="badge bg-warning text-dark mb-2 align-self-start">LOW STOCK</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger mb-2 align-self-start">OUT OF STOCK</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="d-flex align-items-center gap-1 mt-auto">
                                        <form action="${pageContext.request.contextPath}/products?action=sell" method="post" class="d-flex gap-1 align-items-center" onsubmit="return confirmSell(this, '${p.name}', '${p.price}', '${p.productCode}')">
                                            <input type="hidden" name="action" value="sell">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <input type="hidden" name="redirect" value="dashboard">
                                            <input type="number" name="quantity" class="form-control qty-input" value="1" min="1" max="${p.stockQuantity}" ${p.stockQuantity == 0 ? 'disabled' : ''}>
                                            <button type="submit" class="btn btn-sm btn-success sell-btn" ${p.stockQuantity == 0 ? 'disabled' : ''}>
                                                <i class="bi bi-cart-check"></i> Sell
                                            </button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/products?action=view&id=${p.id}" class="btn btn-sm btn-outline-primary ms-auto" title="View details" style="height:28px;font-size:.8rem;padding:2px 8px;">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
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
