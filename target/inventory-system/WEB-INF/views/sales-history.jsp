<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales History - Inventory Management</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products?action=sell">Sell</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/products?action=sales-history">Sales History</a>
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

        <h2><i class="bi bi-clock-history"></i> Sales History</h2>

        <c:if test="${empty sales}">
            <div class="text-center py-5">
                <i class="bi bi-receipt text-muted" style="font-size:3rem;"></i>
                <p class="text-muted mt-2">No sales recorded yet.</p>
            </div>
        </c:if>

        <c:if test="${not empty sales}">
            <c:set var="grandTotal" value="0" />
            <c:forEach var="s" items="${sales}">
                <c:set var="grandTotal" value="${grandTotal + s.totalPrice}" />
            </c:forEach>

            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="card text-bg-success">
                        <div class="card-body py-2">
                            <small class="card-title">Total Sales</small>
                            <p class="card-text fs-4 fw-bold mb-0">${sales.size()}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-bg-info">
                        <div class="card-body py-2">
                            <small class="card-title">Total Revenue</small>
                            <p class="card-text fs-4 fw-bold mb-0">₹ <fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Product</th>
                            <th>Code</th>
                            <th>Qty</th>
                            <th>Unit Price</th>
                            <th>Total</th>
                            <th>Date & Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${sales}" varStatus="vs">
                            <tr>
                                <td>${vs.count}</td>
                                <td>${s.productName}</td>
                                <td>${s.productCode}</td>
                                <td>${s.quantity}</td>
                                <td><fmt:formatNumber value="${s.unitPrice}" type="currency" currencySymbol="₹"/></td>
                                <td><fmt:formatNumber value="${s.totalPrice}" type="currency" currencySymbol="₹"/></td>
                                <td>${s.soldAt}</td>
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
