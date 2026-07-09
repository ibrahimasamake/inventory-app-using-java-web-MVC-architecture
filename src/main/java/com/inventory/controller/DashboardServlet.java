package com.inventory.controller;

import com.inventory.dao.CategoryDAO;
import com.inventory.dao.ProductDAO;
import com.inventory.model.Product;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int totalProducts = productDAO.getCount();
            int totalCategories = categoryDAO.getCount();
            int totalStock = productDAO.getTotalStock();
            int lowStockCount = productDAO.getLowStockCount();
            double totalStockValue = productDAO.getTotalStockValue();
            List<Product> latestProducts = productDAO.getLatestFive();
            List<Product> quickSellProducts = productDAO.getLatestFive();

            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalStock", totalStock);
            request.setAttribute("lowStockCount", lowStockCount);
            request.setAttribute("totalStockValue", totalStockValue);
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new java.util.Locale("en", "IN"));
            request.setAttribute("totalStockValueFormatted", currencyFormat.format(totalStockValue));
            request.setAttribute("latestProducts", latestProducts);
            request.setAttribute("quickSellProducts", quickSellProducts);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
