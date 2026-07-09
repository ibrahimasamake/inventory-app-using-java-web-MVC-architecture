package com.inventory.dao;

import com.inventory.model.Category;
import com.inventory.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAll() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.id) AS product_count "
                   + "FROM categories c LEFT JOIN products p ON c.id = p.category_id "
                   + "GROUP BY c.id ORDER BY c.name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setProductCount(rs.getInt("product_count"));
                categories.add(c);
            }
        }
        return categories;
    }

    public Category getById(int id) throws SQLException {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    c.setDescription(rs.getString("description"));
                    return c;
                }
            }
        }
        return null;
    }

    public void insert(Category category) throws SQLException {
        String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.executeUpdate();
        }
    }

    public void update(Category category) throws SQLException {
        String sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public int getCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Category> search(String keyword) throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.id) AS product_count "
                   + "FROM categories c LEFT JOIN products p ON c.id = p.category_id "
                   + "WHERE c.name LIKE ? OR c.description LIKE ? "
                   + "GROUP BY c.id ORDER BY c.name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword.trim() + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    c.setDescription(rs.getString("description"));
                    c.setProductCount(rs.getInt("product_count"));
                    categories.add(c);
                }
            }
        }
        return categories;
    }

    public int getProductCount(int categoryId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
