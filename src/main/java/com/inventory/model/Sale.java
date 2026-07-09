package com.inventory.model;

import java.time.LocalDateTime;

public class Sale {
    private int id;
    private int productId;
    private String productName;
    private String productCode;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private LocalDateTime soldAt;

    public Sale() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public LocalDateTime getSoldAt() { return soldAt; }
    public void setSoldAt(LocalDateTime soldAt) { this.soldAt = soldAt; }
}
