package com.inventory.dao;

import com.inventory.model.Sale;
import com.inventory.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {

    public void recordSale(Sale sale) throws SQLException {
        String sql = "INSERT INTO sales (product_id, product_name, product_code, quantity, unit_price, total_price) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sale.getProductId());
            stmt.setString(2, sale.getProductName());
            stmt.setString(3, sale.getProductCode());
            stmt.setInt(4, sale.getQuantity());
            stmt.setDouble(5, sale.getUnitPrice());
            stmt.setDouble(6, sale.getTotalPrice());
            stmt.executeUpdate();
        }
    }

    public List<Sale> getAllSales() throws SQLException {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT * FROM sales ORDER BY sold_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                sales.add(mapSale(rs));
            }
        }
        return sales;
    }

    private Sale mapSale(ResultSet rs) throws SQLException {
        Sale s = new Sale();
        s.setId(rs.getInt("id"));
        s.setProductId(rs.getInt("product_id"));
        s.setProductName(rs.getString("product_name"));
        s.setProductCode(rs.getString("product_code"));
        s.setQuantity(rs.getInt("quantity"));
        s.setUnitPrice(rs.getDouble("unit_price"));
        s.setTotalPrice(rs.getDouble("total_price"));
        Timestamp ts = rs.getTimestamp("sold_at");
        if (ts != null) {
            s.setSoldAt(ts.toLocalDateTime());
        }
        return s;
    }
}
