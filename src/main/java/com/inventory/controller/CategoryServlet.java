package com.inventory.controller;

import com.inventory.dao.CategoryDAO;
import com.inventory.model.Category;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("new".equals(action)) {
                request.setAttribute("category", new Category());
                request.setAttribute("action", "insert");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/category-form.jsp");
                dispatcher.forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Category category = categoryDAO.getById(id);
                request.setAttribute("category", category);
                request.setAttribute("action", "update");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/category-form.jsp");
                dispatcher.forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int productCount = categoryDAO.getProductCount(id);
                if (productCount > 0) {
                    request.getSession().setAttribute("flashError",
                        "Cannot delete category with " + productCount + " product(s). Remove products first.");
                } else {
                    categoryDAO.delete(id);
                    request.getSession().setAttribute("flashSuccess", "Category deleted successfully.");
                }
                response.sendRedirect(request.getContextPath() + "/categories");
            } else {
                String search = request.getParameter("search");
                List<Category> categories;
                if (search != null && !search.trim().isEmpty()) {
                    categories = categoryDAO.search(search.trim());
                } else {
                    categories = categoryDAO.getAll();
                }
                request.setAttribute("categories", categories);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/category-list.jsp");
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
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Category name is required");
            Category category = new Category();
            category.setName(name);
            category.setDescription(description);
            request.setAttribute("category", category);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/category-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Category category = new Category();
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");

        try {
            if ("insert".equals(action)) {
                categoryDAO.insert(category);
                request.getSession().setAttribute("flashSuccess", "Category added successfully.");
                response.sendRedirect(request.getContextPath() + "/categories");
            } else if ("update".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.isEmpty()) {
                    throw new ServletException("Category ID is required for update");
                }
                category.setId(Integer.parseInt(idParam));
                categoryDAO.update(category);
                request.getSession().setAttribute("flashSuccess", "Category updated successfully.");
                response.sendRedirect(request.getContextPath() + "/categories");
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                request.setAttribute("error", "Category name already exists");
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
            request.setAttribute("category", category);
            request.setAttribute("action", action);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/category-form.jsp");
            dispatcher.forward(request, response);
        }
    }
}
