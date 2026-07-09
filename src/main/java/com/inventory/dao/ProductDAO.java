package com.inventory.dao;

import com.inventory.model.Product;
import com.inventory.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAll() throws SQLException {
        return getAll("id", "DESC");
    }

    public List<Product> getAll(String sortBy, String sortOrder) throws SQLException {
        List<Product> products = new ArrayList<>();
        String validSortBy;
        if (sortBy == null) {
            validSortBy = "p.id";
        } else {
            validSortBy = switch (sortBy) {
                case "name", "price", "stock_quantity", "product_code" -> "p." + sortBy;
                case "category_name" -> "c.name";
                default -> "p.id";
            };
        }
        String validSortOrder = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                   + "JOIN categories c ON p.category_id = c.id "
                   + "ORDER BY " + validSortBy + " " + validSortOrder;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }
        return products;
    }

    public Product getById(int id) throws SQLException {
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                   + "JOIN categories c ON p.category_id = c.id WHERE p.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        }
        return null;
    }

    public void insert(Product product) throws SQLException {
        String sql = "INSERT INTO products (product_code, name, description, image_url, price, "
                   + "stock_quantity, minimum_stock_level, category_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getProductCode());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setString(4, product.getImageUrl());
            stmt.setDouble(5, product.getPrice());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setInt(7, product.getMinimumStockLevel());
            stmt.setInt(8, product.getCategoryId());
            stmt.executeUpdate();
        }
    }

    public void update(Product product) throws SQLException {
        String sql = "UPDATE products SET product_code = ?, name = ?, description = ?, "
                   + "image_url = ?, price = ?, stock_quantity = ?, minimum_stock_level = ?, "
                   + "category_id = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getProductCode());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setString(4, product.getImageUrl());
            stmt.setDouble(5, product.getPrice());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setInt(7, product.getMinimumStockLevel());
            stmt.setInt(8, product.getCategoryId());
            stmt.setInt(9, product.getId());
            stmt.executeUpdate();
        }
    }

    public void sellProduct(int id, int quantity) throws SQLException {
        String sql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, id);
            stmt.setInt(3, quantity);
            int updated = stmt.executeUpdate();
            if (updated == 0) {
                throw new SQLException("Not enough stock available for product ID " + id);
            }
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Product> searchProducts(String keyword, Integer categoryId, Boolean lowStock, String sortBy, String sortOrder) throws SQLException {
        List<Product> products = new ArrayList<>();
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            conditions.add("(p.name LIKE ? OR p.product_code LIKE ?)");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }
        if (categoryId != null) {
            conditions.add("p.category_id = ?");
            params.add(categoryId);
        }
        if (lowStock != null && lowStock) {
            conditions.add("p.stock_quantity <= p.minimum_stock_level");
        }

        String whereClause = conditions.isEmpty() ? "" : " WHERE " + String.join(" AND ", conditions);

        String validSortBy;
        if (sortBy == null) {
            validSortBy = "p.id";
        } else {
            validSortBy = switch (sortBy) {
                case "name", "price", "stock_quantity", "product_code" -> "p." + sortBy;
                case "category_name" -> "c.name";
                default -> "p.id";
            };
        }
        String validSortOrder = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                   + "JOIN categories c ON p.category_id = c.id"
                   + whereClause
                   + " ORDER BY " + validSortBy + " " + validSortOrder;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                }
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        }
        return products;
    }

    public int getCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTotalStock() throws SQLException {
        String sql = "SELECT COALESCE(SUM(stock_quantity), 0) FROM products";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double getTotalStockValue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(price * stock_quantity), 0) FROM products";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public int getLowStockCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM products WHERE stock_quantity <= minimum_stock_level";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Product> getLatestFive() throws SQLException {
        return getLatest(5);
    }

    public List<Product> getLatest(int limit) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p "
                   + "JOIN categories c ON p.category_id = c.id "
                   + "ORDER BY p.id DESC LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        }
        return products;
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setProductCode(rs.getString("product_code"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("image_url"));
        p.setPrice(rs.getDouble("price"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setMinimumStockLevel(rs.getInt("minimum_stock_level"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }
}
