package com.inventory.controller;

import com.inventory.dao.CategoryDAO;
import com.inventory.dao.ProductDAO;
import com.inventory.dao.SaleDAO;
import com.inventory.model.Category;
import com.inventory.model.Product;
import com.inventory.model.Sale;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private SaleDAO saleDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        saleDAO = new SaleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getById(id);
                List<Category> categories = categoryDAO.getAll();
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.setAttribute("action", "update");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-form.jsp");
                dispatcher.forward(request, response);
            } else if ("export".equals(action)) {
                exportCSV(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                productDAO.delete(id);
                request.getSession().setAttribute("flashSuccess", "Product deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/products");
            } else if ("new".equals(action)) {
                List<Category> categories = categoryDAO.getAll();
                request.setAttribute("categories", categories);
                request.setAttribute("action", "insert");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-form.jsp");
                dispatcher.forward(request, response);
            } else if ("clone".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Product original = productDAO.getById(id);
                    if (original != null) {
                        Product clone = new Product();
                        String suffix = "-COPY-" + System.currentTimeMillis();
                        clone.setProductCode(original.getProductCode() + suffix);
                        clone.setName(original.getName() + " (Copy)");
                                        clone.setDescription(original.getDescription());
                        clone.setImageUrl(original.getImageUrl());
                        clone.setPrice(original.getPrice());
                        clone.setStockQuantity(original.getStockQuantity());
                        clone.setMinimumStockLevel(original.getMinimumStockLevel());
                        clone.setCategoryId(original.getCategoryId());
                        productDAO.insert(clone);
                        request.getSession().setAttribute("flashSuccess", "Product cloned successfully.");
                    }
                } catch (SQLException e) {
                    request.getSession().setAttribute("flashError",
                        "Failed to clone product: " + e.getMessage());
                }
                response.sendRedirect(request.getContextPath() + "/products");
            } else if ("view".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getById(id);
                request.setAttribute("product", product);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp");
                dispatcher.forward(request, response);
            } else if ("sell".equals(action)) {
                String search = request.getParameter("search");
                String sort = request.getParameter("sort");
                String order = request.getParameter("order");
                List<Product> products = productDAO.searchProducts(search, null, null, sort, order);
                List<Category> categories = categoryDAO.getAll();
                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.setAttribute("currentSort", sort != null ? sort : "id");
                request.setAttribute("currentOrder", order != null ? order : "DESC");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-sell.jsp");
                dispatcher.forward(request, response);
            } else if ("sales-history".equals(action)) {
                List<Sale> sales = saleDAO.getAllSales();
                request.setAttribute("sales", sales);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/sales-history.jsp");
                dispatcher.forward(request, response);
            } else {
                String search = request.getParameter("search");
                String categoryId = request.getParameter("categoryId");
                String stockStatus = request.getParameter("stockStatus");
                String sort = request.getParameter("sort");
                String order = request.getParameter("order");

                Integer catId = (categoryId != null && !categoryId.trim().isEmpty()) ? Integer.parseInt(categoryId) : null;
                Boolean low = "low".equals(stockStatus) ? Boolean.TRUE : null;
                List<Product> products = productDAO.searchProducts(search, catId, low, sort, order);

                List<Category> categories = categoryDAO.getAll();
                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.setAttribute("currentSort", sort != null ? sort : "id");
                request.setAttribute("currentOrder", order != null ? order : "DESC");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                String error = validateProduct(request);
                if (error != null) {
                    Product product = populateProduct(request);
                    List<Category> categories = categoryDAO.getAll();
                    request.setAttribute("product", product);
                    request.setAttribute("categories", categories);
                    request.setAttribute("error", error);
                    request.setAttribute("action", "insert");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-form.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                Product product = populateProduct(request);
                productDAO.insert(product);
                request.getSession().setAttribute("flashSuccess", "Product added successfully.");
                response.sendRedirect(request.getContextPath() + "/products");
            } else if ("update".equals(action)) {
                String error = validateProduct(request);
                if (error != null) {
                    Product product = populateProduct(request);
                    product.setId(Integer.parseInt(request.getParameter("id")));
                    List<Category> categories = categoryDAO.getAll();
                    request.setAttribute("product", product);
                    request.setAttribute("categories", categories);
                    request.setAttribute("error", error);
                    request.setAttribute("action", "update");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-form.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                Product product = populateProduct(request);
                product.setId(Integer.parseInt(request.getParameter("id")));
                productDAO.update(product);
                request.getSession().setAttribute("flashSuccess", "Product updated successfully.");
                response.sendRedirect(request.getContextPath() + "/products");
            } else if ("sell".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                Product product = productDAO.getById(id);
                if (product == null) {
                    request.getSession().setAttribute("flashError", "Product not found.");
                } else if (quantity <= 0) {
                    request.getSession().setAttribute("flashError", "Quantity must be positive.");
                } else if (quantity > product.getStockQuantity()) {
                    request.getSession().setAttribute("flashError",
                        "Not enough stock. Available: " + product.getStockQuantity());
                } else {
                    productDAO.sellProduct(id, quantity);
                    double total = quantity * product.getPrice();

                    Sale sale = new Sale();
                    sale.setProductId(product.getId());
                    sale.setProductName(product.getName());
                    sale.setProductCode(product.getProductCode());
                    sale.setQuantity(quantity);
                    sale.setUnitPrice(product.getPrice());
                    sale.setTotalPrice(total);
                    saleDAO.recordSale(sale);

                    request.getSession().setAttribute("flashSuccess",
                        "Sold " + quantity + " x " + product.getName()
                        + " for ₹" + String.format("%.2f", total));
                }
                String redirect = request.getParameter("redirect");
                if ("dashboard".equals(redirect)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/products?action=sell");
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private String validateProduct(HttpServletRequest request) {
        String productCode = request.getParameter("productCode");
        String name = request.getParameter("name");
        String categoryId = request.getParameter("categoryId");
        String price = request.getParameter("price");
        String stockQuantity = request.getParameter("stockQuantity");
        String minimumStockLevel = request.getParameter("minimumStockLevel");

        if (productCode == null || productCode.trim().isEmpty()) {
            return "Product code is required";
        }
        if (name == null || name.trim().isEmpty()) {
            return "Product name is required";
        }
        if (categoryId == null || categoryId.trim().isEmpty()) {
            return "Category is required";
        }
        if (price != null && !price.trim().isEmpty()) {
            try {
                if (Double.parseDouble(price) < 0) {
                    return "Price cannot be negative";
                }
            } catch (NumberFormatException e) {
                return "Price must be a valid number";
            }
        }
        if (stockQuantity != null && !stockQuantity.trim().isEmpty()) {
            try {
                if (Integer.parseInt(stockQuantity) < 0) {
                    return "Stock quantity cannot be negative";
                }
            } catch (NumberFormatException e) {
                return "Stock quantity must be a valid integer";
            }
        }
        if (minimumStockLevel != null && !minimumStockLevel.trim().isEmpty()) {
            try {
                if (Integer.parseInt(minimumStockLevel) < 0) {
                    return "Minimum stock level cannot be negative";
                }
            } catch (NumberFormatException e) {
                return "Minimum stock level must be a valid integer";
            }
        }
        return null;
    }

    private Product populateProduct(HttpServletRequest request) {
        Product product = new Product();
        product.setProductCode(request.getParameter("productCode"));
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setImageUrl(request.getParameter("imageUrl"));
        product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));

        String price = request.getParameter("price");
        product.setPrice(price != null && !price.isEmpty() ? Double.parseDouble(price) : 0.0);

        String stockQuantity = request.getParameter("stockQuantity");
        product.setStockQuantity(stockQuantity != null && !stockQuantity.isEmpty() ? Integer.parseInt(stockQuantity) : 0);

        String minimumStockLevel = request.getParameter("minimumStockLevel");
        product.setMinimumStockLevel(minimumStockLevel != null && !minimumStockLevel.isEmpty() ? Integer.parseInt(minimumStockLevel) : 5);

        return product;
    }

    private void exportCSV(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Product> products = productDAO.getAll("id", "ASC");
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=products.csv");
            PrintWriter out = response.getWriter();
            out.println("Product Code,Name,Category,Price,Stock Quantity,Min Stock Level,Status");
            for (Product p : products) {
                String status = p.getStockStatus();
                out.println(escapeCSV(p.getProductCode()) + ","
                    + escapeCSV(p.getName()) + ","
                    + escapeCSV(p.getCategoryName()) + ","
                    + p.getPrice() + ","
                    + p.getStockQuantity() + ","
                    + p.getMinimumStockLevel() + ","
                    + status);
            }
            out.flush();
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private String escapeCSV(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}
