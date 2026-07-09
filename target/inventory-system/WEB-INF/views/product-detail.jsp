<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - Inventory Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .product-image-wrapper {
            background: #f8f9fa;
            border-radius: 16px;
            min-height: 350px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .product-image-wrapper img {
            max-width: 100%;
            max-height: 400px;
            object-fit: contain;
        }
        .product-image-placeholder {
            color: #adb5bd;
            font-size: 4rem;
        }
        .detail-label {
            color: #6c757d;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        .detail-value {
            font-size: 1.05rem;
            font-weight: 500;
        }
        .stock-badge-lg {
            font-size: 0.9rem;
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
        }
        .price-display {
            font-size: 2rem;
            font-weight: 700;
            color: #0d6efd;
        }
        .desc-box {
            max-height: 200px;
            overflow-y: auto;
            font-size: 0.95rem;
            line-height: 1.6;
            color: #4a4a4a;
            background: #fafafa;
            border-radius: 8px;
            padding: 1rem;
            white-space: pre-line;
        }
        .desc-box::-webkit-scrollbar { width: 4px; }
        .desc-box::-webkit-scrollbar-thumb { background: #ccc; border-radius: 4px; }
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

        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Products</a></li>
                <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="row g-4">
            <div class="col-lg-5">
                <div class="product-image-wrapper shadow-sm">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img src="${product.imageUrl}" alt="${product.name}" class="p-3">
                        </c:when>
                        <c:otherwise>
                            <div class="product-image-placeholder text-center">
                                <i class="bi bi-box-seam"></i>
                                <p class="mt-2 text-muted" style="font-size:1rem;">No Image</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <a href="${pageContext.request.contextPath}/products?action=edit&id=${product.id}" class="btn btn-warning flex-fill">
                        <i class="bi bi-pencil"></i> Edit
                    </a>
                    <a href="${pageContext.request.contextPath}/products?action=clone&id=${product.id}" class="btn btn-info text-white flex-fill">
                        <i class="bi bi-copy"></i> Clone
                    </a>
                    <a href="${pageContext.request.contextPath}/products?action=delete&id=${product.id}" class="btn btn-danger flex-fill" onclick="return confirm('Delete this product?')">
                        <i class="bi bi-trash"></i> Delete
                    </a>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h2 class="card-title mb-1">${product.name}</h2>
                                <span class="text-muted">${product.productCode}</span>
                            </div>
                            <c:choose>
                                <c:when test="${product.stockStatus == 'IN STOCK'}">
                                    <span class="badge bg-success stock-badge-lg">IN STOCK</span>
                                </c:when>
                                <c:when test="${product.stockStatus == 'LOW STOCK'}">
                                    <span class="badge bg-warning text-dark stock-badge-lg">LOW STOCK</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger stock-badge-lg">OUT OF STOCK</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="price-display mb-4">
                            ₹ ${product.price}
                        </div>

                        <hr>

                        <div class="row g-3">
                            <div class="col-sm-6">
                                <div class="detail-label">Category</div>
                                <div class="detail-value">
                                    <span class="badge bg-secondary bg-opacity-25 text-dark px-3 py-2">
                                        ${product.categoryName}
                                    </span>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="detail-label">Stock Quantity</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${product.stockQuantity == 0}">
                                            <span class="text-danger fw-bold">${product.stockQuantity}</span>
                                        </c:when>
                                        <c:when test="${product.stockQuantity <= product.minimumStockLevel}">
                                            <span class="text-warning fw-bold">${product.stockQuantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${product.stockQuantity}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="detail-label">Minimum Stock Level</div>
                                <div class="detail-value">${product.minimumStockLevel}</div>
                            </div>
                            <div class="col-sm-6">
                                <div class="detail-label">Category ID</div>
                                <div class="detail-value">${product.categoryId}</div>
                            </div>
                        </div>

                        <c:if test="${not empty product.description}">
                            <hr>
                            <div>
                                <div class="detail-label mb-2">Description</div>
                                <div class="desc-box">${product.description}</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Back to Products
            </a>
        </div>
    </div>

    <div class="container mt-4 mb-4">
        <p class="text-muted text-center">&copy; 2026 Inventory Management System</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
