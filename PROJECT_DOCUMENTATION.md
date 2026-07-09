# Product Inventory Management System — Complete Project Documentation

> Use this document to generate a comprehensive project report. Every class, method, JSP page, SQL query, UI component, and business rule is documented below. Feed this entire file to ChatGPT and ask it to produce a formatted report (PDF/Word/Markdown).

---

## 1. Project Overview

A full-stack web application for managing product inventory. Built with Jakarta EE 10 (servlets, JSP, JSTL) on Apache Tomcat 11, backed by MySQL 8 via raw JDBC. The UI uses Bootstrap 5.3 with Bootstrap Icons. Users can create, read, update, delete, search, sort, filter, clone, and sell products. Categories have their own CRUD with product-count awareness. Sales are tracked in a dedicated history. The dashboard provides stats, latest products, and a quick-sell card grid.

---

## 2. Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Language | Java | 17 |
| Web Framework | Jakarta EE (Servlets, JSP, JSTL) | 10 |
| App Server | Apache Tomcat | 11 |
| Database | MySQL | 8.0 |
| DB Connectivity | JDBC (raw, no ORM) | — |
| Build | Maven | 3.x |
| Frontend | Bootstrap | 5.3.2 |
| Icons | Bootstrap Icons | 1.11.3 |
| JDBC Driver | MySQL Connector/J | 8.0.33 |

---

## 3. Project Structure (Full Tree)

```
inventory-system/
├── pom.xml
├── database.sql
├── PROJECT_DOCUMENTATION.md
├── README.md
├── src/
│   ├── main/
│   │   ├── java/com/inventory/
│   │   │   ├── controller/
│   │   │   │   ├── DashboardServlet.java
│   │   │   │   ├── ProductServlet.java
│   │   │   │   └── CategoryServlet.java
│   │   │   ├── dao/
│   │   │   │   ├── ProductDAO.java
│   │   │   │   ├── CategoryDAO.java
│   │   │   │   └── SaleDAO.java
│   │   │   ├── model/
│   │   │   │   ├── Product.java
│   │   │   │   ├── Category.java
│   │   │   │   └── Sale.java
│   │   │   └── util/
│   │   │       └── DatabaseConnection.java
│   │   ├── resources/
│   │   │   └── database.properties
│   │   └── webapp/
│   │       ├── index.jsp
│   │       ├── assets/css/style.css
│   │       └── WEB-INF/views/
│   │           ├── dashboard.jsp
│   │           ├── product-list.jsp
│   │           ├── product-form.jsp
│   │           ├── product-detail.jsp
│   │           ├── product-sell.jsp
│   │           ├── sales-history.jsp
│   │           ├── category-list.jsp
│   │           └── category-form.jsp
│   └── test/
└── target/
```

---

## 4. Database Schema (Full DDL)

### 4.1 Table: `categories`

```sql
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);
```

### 4.2 Table: `products`

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    minimum_stock_level INT NOT NULL DEFAULT 5,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

### 4.3 Table: `sales`

```sql
CREATE TABLE sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    product_code VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    sold_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

### 4.4 Seed Data

**categories:**
| id | name | description |
|----|------|-------------|
| 1 | samsung | Good Phone |
| 2 | Tecno | China factory |
| 3 | Itel | china |

**products:**
| id | product_code | name | price | stock | min_stock | category_id | image_url |
|----|-------------|------|-------|-------|-----------|-------------|-----------|
| 1 | SKu-24325 | iphone 17 pro max | 800000.00 | 40 | 3 | 1 | https://sm.mashable.com/... |
| 2 | SKu-243267 | Samsung A22 | 90000.00 | 9 | 5 | 1 | https://etimg.etb2bimg.com/... |
| 3 | SKu-24325-COPY-1749245767787 | iphone 12 pro max (Copy) | 800000.00 | 27 | 3 | 1 | https://www.cnet.com/... |
| 5 | SKu-24326744 | Tecno Comon 20 | 90000.00 | 28 | 10 | 2 | https://images.fonearena.com/... |
| 7 | Sk-45u578 | Xperia 5 IV 5G 8/256GB Refurbished | 50000.00 | 10 | 2 | 2 | https://www.triveniworld.com/... |

---

## 5. Java Models (POJOs) — Full Details

### 5.1 `Product.java`

Fields (10):
- `int id` — Primary key
- `String productCode` — Unique product code
- `String name` — Product name
- `String description` — Product description (TEXT, long form)
- `String imageUrl` — URL to product image (nullable)
- `double price` — Selling price
- `int stockQuantity` — Current stock count
- `int minimumStockLevel` — Threshold for low-stock alert (default 5)
- `int categoryId` — FK to categories
- `String categoryName` — Denormalized category name (from JOIN in DAO)

Business logic method:
- `getStockStatus()` — Returns `"IN STOCK"` (stock > min), `"LOW STOCK"` (stock > 0 but ≤ min), or `"OUT OF STOCK"` (stock = 0)

### 5.2 `Category.java`

Fields (4):
- `int id` — Primary key
- `String name` — Category name (UNIQUE)
- `String description` — Description
- `int productCount` — Count of products in this category (from LEFT JOIN + COUNT)

Constructor: `Category(int id, String name, String description)`

### 5.3 `Sale.java`

Fields (8):
- `int id` — Primary key
- `int productId` — FK to products
- `String productName` — Snapshot of product name at sale time
- `String productCode` — Snapshot of product code at sale time
- `int quantity` — Quantity sold
- `double unitPrice` — Price per unit at sale time
- `double totalPrice` — quantity × unitPrice
- `LocalDateTime soldAt` — Timestamp of sale (from DB)

---

## 6. DAO Layer — Every Method Documented

### 6.1 `ProductDAO` (13 methods)

| Method | SQL (simplified) | Purpose |
|--------|------------------|---------|
| `getAll()` | `SELECT p.*, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id ORDER BY p.id DESC` | All products, newest first |
| `getAll(sortBy, sortOrder)` | Same + dynamic ORDER BY with whitelisted columns | All products with validated sort |
| `getById(id)` | `...WHERE p.id = ?` | Single product with category name |
| `insert(product)` | `INSERT INTO products (...) VALUES (?,?,?,?,?,?,?,?)` | Create product |
| `update(product)` | `UPDATE products SET ... WHERE id = ?` | Update product (all columns) |
| `delete(id)` | `DELETE FROM products WHERE id = ?` | Delete product |
| `searchProducts(keyword, categoryId, lowStock, sortBy, sortOrder)` | Dynamic WHERE + ORDER BY with parameterized conditions | Combined search/filter/sort |
| `getCount()` | `SELECT COUNT(*) FROM products` | Total product count |
| `getTotalStock()` | `SELECT COALESCE(SUM(stock_quantity), 0) FROM products` | Sum of all stock |
| `getTotalStockValue()` | `SELECT COALESCE(SUM(price * stock_quantity), 0) FROM products` | Total inventory value |
| `getLowStockCount()` | `SELECT COUNT(*) FROM products WHERE stock_quantity <= minimum_stock_level` | Low stock items count |
| `getLatestFive()` | Delegates to `getLatest(5)` | Last 5 products |
| `getLatest(limit)` | `...ORDER BY p.id DESC LIMIT ?` | Last N products |
| `sellProduct(id, quantity)` | `UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?` | Decrement stock atomically (safe update — no-op if insufficient stock) |

**`searchProducts` details:**
- Keyword search: `(p.name LIKE ? OR p.product_code LIKE ?)` with `%keyword%`
- Category filter: `p.category_id = ?`
- Low stock filter: `p.stock_quantity <= p.minimum_stock_level`
- All filters are AND-combined, each is optional
- Sort whitelist: `name`, `price`, `stock_quantity`, `product_code`, `category_name` (maps to `c.name`)

**`getAll(sortBy, sortOrder)` sort whitelist:**
- `name` → `p.name`
- `price` → `p.price`
- `stock_quantity` → `p.stock_quantity`
- `product_code` → `p.product_code`
- `category_name` → `c.name`
- Anything else → `p.id`
- Order: `ASC` or `DESC` (defaults to `DESC` if invalid)

### 6.2 `CategoryDAO` (7 methods)

| Method | SQL | Purpose |
|--------|-----|---------|
| `getAll()` | `SELECT c.*, COUNT(p.id) AS product_count FROM categories c LEFT JOIN products p ON c.id = p.category_id GROUP BY c.id ORDER BY c.name` | All categories with product count |
| `getById(id)` | `SELECT * FROM categories WHERE id = ?` | Single category |
| `insert(category)` | `INSERT INTO categories (name, description) VALUES (?, ?)` | Create category |
| `update(category)` | `UPDATE categories SET name = ?, description = ? WHERE id = ?` | Update category |
| `delete(id)` | `DELETE FROM categories WHERE id = ?` | Delete category |
| `getCount()` | `SELECT COUNT(*) FROM categories` | Total category count |
| `search(keyword)` | Same as getAll + `WHERE c.name LIKE ? OR c.description LIKE ?` | Search by name or description |
| `getProductCount(categoryId)` | `SELECT COUNT(*) FROM products WHERE category_id = ?` | Count products in category |

### 6.3 `SaleDAO` (2 methods)

| Method | SQL | Purpose |
|--------|-----|---------|
| `recordSale(sale)` | `INSERT INTO sales (product_id, product_name, product_code, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)` | Record a sale transaction |
| `getAllSales()` | `SELECT * FROM sales ORDER BY sold_at DESC` | All sales, most recent first (includes computed `total_price`) |

---

## 7. Controllers — Every Action Handler

### 7.1 `DashboardServlet` (`@WebServlet("/dashboard")`)

**Only doGet** — no POST handlers.

Loads and forwards these attributes to `dashboard.jsp`:

| Attribute | Type | Source |
|-----------|------|--------|
| `totalProducts` | int | `productDAO.getCount()` |
| `totalCategories` | int | `categoryDAO.getCount()` |
| `totalStock` | int | `productDAO.getTotalStock()` |
| `lowStockCount` | int | `productDAO.getLowStockCount()` |
| `totalStockValue` | double | `productDAO.getTotalStockValue()` |
| `totalStockValueFormatted` | String | `NumberFormat.getCurrencyInstance(new Locale("en", "IN"))` formats totalStockValue |
| `latestProducts` | List<Product> | `productDAO.getLatestFive()` |
| `quickSellProducts` | List<Product> | `productDAO.getLatestFive()` |

### 7.2 `ProductServlet` (`@WebServlet("/products")`)

#### doGet Actions:

| Action | Parameters | Behavior | View |
|--------|-----------|----------|------|
| *(none)* | `search`, `categoryId`, `stockStatus`, `sort`, `order` | Combined filter + sort product list | `product-list.jsp` |
| `new` | *(none)* | Show empty form with categories | `product-form.jsp` |
| `edit` | `id` | Load product + categories into form | `product-form.jsp` |
| `view` | `id` | Load single product | `product-detail.jsp` |
| `delete` | `id` | Delete product, flash success, redirect to product list | redirect → `/products` |
| `clone` | `id` | Copy product with `-COPY-timestamp` suffix on code; catches `SQLException` for duplicate key | redirect → `/products` |
| `export` | *(none)* | Stream CSV with headers: Product Code, Name, Category, Price, Stock Quantity, Min Stock Level, Status | CSV download |
| `sell` | `search`, `sort`, `order` | Show all products (filtered) with sell UI | `product-sell.jsp` |
| `sales-history` | *(none)* | Load all sales ordered by date descending | `sales-history.jsp` |

**Clone algorithm:**
1. Fetch original product by id
2. Create new Product object
3. Set productCode = originalCode + `"-COPY-"` + `System.currentTimeMillis()`
4. Set name = originalName + `" (Copy)"`
5. Copy all other fields (description, imageUrl, price, stockQuantity, minimumStockLevel, categoryId)
6. Call `productDAO.insert(clone)`
7. If `SQLException` caught (e.g., duplicate code despite timestamp), flash error
8. Redirect to `/products`

**Export CSV algorithm:**
1. Fetch all products sorted by id ASC
2. Set response content type to `text/csv` and disposition to `attachment; filename=products.csv`
3. Write header line: `Product Code,Name,Category,Price,Stock Quantity,Min Stock Level,Status`
4. For each product: escape CSV fields (comma, quote, newline wrapping), write row
5. Flush output stream

#### doPost Actions:

| Action | Parameters | Behavior |
|--------|-----------|----------|
| `insert` | productCode, name, description, imageUrl, categoryId, price, stockQuantity, minimumStockLevel | Validate → if error: forward back to form with error + filled fields; else: insert, flash success, redirect to product list |
| `update` | id + same fields as insert | Same validate pattern, then update, flash success, redirect |
| `sell` | id, quantity, redirect (optional) | Validate product exists, quantity > 0, stock sufficient → decrement stock, record sale in sales table, flash success message with total price. If `redirect=dashboard`, redirect to `/dashboard`, else redirect to `/products?action=sell` |

**Validation rules** (shared by insert and update):
- `productCode` — required, non-empty
- `name` — required, non-empty
- `categoryId` — required, non-empty
- `price` — optional, must be parseable as double, must be ≥ 0
- `stockQuantity` — optional, must be parseable as int, must be ≥ 0
- `minimumStockLevel` — optional, must be parseable as int, must be ≥ 0

**Sell validation:**
- Product not found → flashError "Product not found."
- Quantity ≤ 0 → flashError "Quantity must be positive."
- Quantity > stock → flashError "Not enough stock. Available: N"
- Success → flashSuccess "Sold N x ProductName for ₹X.XX"

### 7.3 `CategoryServlet` (`@WebServlet("/categories")`)

#### doGet Actions:

| Action | Parameters | Behavior | View |
|--------|-----------|----------|------|
| *(none)* | `search` | If search param present, search categories; else list all | `category-list.jsp` |
| `new` | *(none)* | Empty category form, sets `action=insert` attribute | `category-form.jsp` |
| `edit` | `id` | Load category into form | `category-form.jsp` |
| `delete` | `id` | Check product count → if > 0 flash error "Cannot delete category with N product(s). Remove products first."; else delete, flash success. Redirect to `/categories` | redirect → `/categories` |

#### doPost Actions:

| Action | Parameters | Behavior |
|--------|-----------|----------|
| `insert` | name, description | Validate name required → if error forward back; else insert, catch `SQLException` for duplicate name, flash success/error, redirect |
| `update` | id, name, description | Same validation, update by id, flash success/error, redirect |

**Duplicate name handling:** Catches `SQLException` with `e.getMessage().contains("Duplicate")` and displays "Category name already exists" error.

---

## 8. JSP Views — Every Page in Detail

### 8.1 `dashboard.jsp` — Dashboard

**URL:** `/dashboard`

**Sections:**
1. **Flash messages** — Success/error alerts with dismiss button (session-scoped, removed after display)
2. **Stats cards** (4-column row):
   - Total Products (primary blue)
   - Total Categories (success green)
   - Total Stock (info teal)
   - Low Stock Items (warning yellow)
3. **Inventory Value card** (dark) + Manage Products / Manage Categories buttons
4. **Latest Products** table (5 items): Code, Name, Category, Price (₹), Stock, Status (colored badge)
5. **Quick Sell** grid: 5 product cards in responsive layout (2/3/5 columns):
   - Card shows: product image (or box icon placeholder), product code, product name, price (₹), stock count, stock status badge, quantity input (compact), Sell button
   - Sell form includes hidden `redirect=dashboard` so after sale the user returns to dashboard
   - JavaScript `confirmSell()` validates quantity ≥ 1 and shows native confirm dialog with product name, quantity, total (₹)
   - Sell button and input disabled when stock = 0

**Navbar items:** Dashboard (active), Products, Categories, Sell, Sales History

### 8.2 `product-list.jsp` — Product List

**URL:** `/products`

**Features:**
1. **Flash messages**
2. **Header:** Title "Products" + Export CSV button (success) + Add Product button (primary)
3. **Filter form** (3 columns):
   - Search text input (name or code) with Search button
   - Category dropdown (populated from `categories` attribute, "All Categories" default)
   - Stock status dropdown (all / low stock only) + Filter button + Clear link
4. **Search results label** (shows when `param.search` is present)
5. **Empty state:** Alert "No products found."
6. **Sortable table:**
   - Columns: Image (50×50 thumbnail or "—"), Code (sortable ▲/▼), Name (sortable, clickable link to detail page), Category (sortable), Price (sortable, ₹), Stock (sortable), Min Stock, Status (colored badge), Actions
   - Sort links preserve current filter params (`search`, `categoryId`, `stockStatus`)
   - Sort indicators: ▲ for ASC, ▼ for DESC on the active sorted column
   - Actions: View (eye icon), Edit (pencil icon, warning), Clone (copy icon, info), Delete (trash icon, danger with JS confirm)
7. **Pagination:** None (single page — all products displayed)

**Sort order of columns:** product_code, name, category_name, price, stock_quantity

### 8.3 `product-form.jsp` — Add/Edit Product Form

**URLs:** `/products?action=new` (add mode), `/products?action=edit&id=X` (edit mode)

**Dual mode** controlled by `action` request attribute:
- Title: "Add Product" or "Edit Product"
- Form action: `?action=insert` or `?action=update`
- Hidden `id` field only in update mode
- Submit button: "Save" or "Update"

**Fields (Bootstrap form layout):**
- Product Code (text, required)
- Product Name (text, required)
- Description (textarea, 3 rows)
- Category (select dropdown, required, populated from `categories`)
- Price (number, step 0.01)
- Image URL (url, placeholder "https://...")
- Stock Quantity (number)
- Minimum Stock Level (number)

**Validation error:** Displayed as danger alert above form (set via `error` attribute)

**Cancel button:** Links back to `/products`

### 8.4 `product-detail.jsp` — Product Detail View

**URL:** `/products?action=view&id=X`

**Breadcrumb:** Dashboard > Products > ProductName

**Layout:** Two-column responsive grid

**Left column:**
- Image container (350px min-height, centered, border-radius 16px) — shows product image or box-seam icon with "No Image" text
- Action buttons (full-width, flex): Edit (warning), Clone (info), Delete (danger with confirm)

**Right column** (card, shadow-sm):
- Product name (h2) + product code (muted)
- Stock status badge (pill, large: green/yellow/red)
- Price display (2rem, bold, blue, ₹)
- Divider
- Details grid (2 columns):
  - Category (badge style)
  - Stock Quantity (color-coded: red if 0, yellow if ≤ min, normal otherwise)
  - Minimum Stock Level
  - Category ID
- Description section (if present):
  - Scrollable box (max-height 200px, thin scrollbar, pre-line whitespace, light background)
- Back to Products button

### 8.5 `product-sell.jsp` — Sell Products

**URL:** `/products?action=sell`

**Header:** "Sell Products" with cart icon

**Search bar:** Text input + Search button + Clear button (visible only when searching)

**Empty state:** Box icon + "No products found."

**Product table:**
- Image (40×40 thumbnail or box icon)
- Code
- Name
- Category
- Price (₹)
- Available stock (color-coded badge: red=0, yellow=low, green=ok)
- Quantity column (compact):
  - Form per row with hidden action=sell, hidden product id, number input (qty, 60px wide, 28px tall), Sell button
  - Min=1, max=available stock, disabled when stock=0
  - `onsubmit` calls `confirmSell()` JavaScript function
- Action (eye icon → detail page)

**ConfirmSell JavaScript:**
1. Parse quantity from input
2. Validate ≥ 1 (alert if invalid)
3. Calculate total = qty × price
4. Show `confirm()` dialog: "Confirm Sale — Product: name (code) — Quantity: N — Total: ₹X.XX — Proceed with this sale?"
5. Return true/false

### 8.6 `sales-history.jsp` — Sales History

**URL:** `/products?action=sales-history`

**Summary cards:**
- Total Sales count (success green)
- Total Revenue (₹, info teal) — computed by summing `totalPrice` across all sales in JSTL

**Empty state:** Receipt icon + "No sales recorded yet."

**Sales table:**
- # (row count via varStatus)
- Product (name)
- Code
- Qty
- Unit Price (₹)
- Total (₹)
- Date & Time (from `soldAt` LocalDateTime)

### 8.7 `category-list.jsp` — Category List

**URL:** `/categories`

**Features:**
1. Flash messages
2. Header "Categories" + Add Category button
3. Search form: text input + Search button + Clear button (visible when searching)
4. Empty state: "No categories found. Add your first category!"
5. Table: ID, Name, Description, Products (badge with count), Actions (Edit warning, Delete danger with JS confirm showing category name)
6. **Delete protection:** If category has products, servlet blocks deletion with flash error "Cannot delete category with N product(s). Remove products first."

### 8.8 `category-form.jsp` — Add/Edit Category Form

**URLs:** `/categories?action=new` (add), `/categories?action=edit&id=X` (edit)

**Dual mode** controlled by `action` attribute:
- Title: "Add Category" or "Edit Category"
- Form action: `?action=insert` or `?action=update`
- Hidden `id` only in update mode

**Fields:**
- Category Name (text, required)
- Description (textarea, 3 rows)

**Submit button:** "Save" or "Update"
**Cancel:** Links back to `/categories`

---

## 9. Navigation Structure

Every page has a consistent dark navbar with:

1. **Dashboard** — `/dashboard` (home)
2. **Products** — `/products`
3. **Categories** — `/categories`
4. **Sell** — `/products?action=sell`
5. **Sales History** — `/products?action=sales-history`

Active page gets `active` class on its nav item.

---

## 10. Flash Message System

- Flash messages are stored in **session scope** (`sessionScope.flashSuccess`, `sessionScope.flashError`)
- After a redirect, the target JSP reads and displays the message, then **removes it** with `<c:remove>`
- This ensures the message appears exactly once (survives one redirect, disappears on refresh)
- Used for: CRUD success/error notifications, sell confirmations, delete protection messages

---

## 11. Currency & Formatting

- **Currency symbol:** ₹ (Indian Rupee)
- **Formatting:** `<fmt:formatNumber type="currency" currencySymbol="₹"/>` in JSPs
- **Java formatting:** `NumberFormat.getCurrencyInstance(new Locale("en", "IN"))` in DashboardServlet for total inventory value
- **Hardcoded prices:** `₹ ${product.price}` in product detail and dashboard quick-sell cards
- **Sale flash message:** `"Sold N x ProductName for ₹X.XX"` (formatted with `String.format("%.2f")`)

---

## 12. User Interaction Flows

### 12.1 Add Product
1. Click "Add Product" → `GET /products?action=new` → `product-form.jsp` (insert mode)
2. Fill fields, click "Save" → `POST /products?action=insert`
3. Validation: if fails → same form with error + filled values; if passes → insert + redirect to product list with flash "Product added successfully."

### 12.2 Edit Product
1. Click Edit (pencil icon) → `GET /products?action=edit&id=X` → `product-form.jsp` (update mode, pre-filled)
2. Modify fields, click "Update" → `POST /products?action=update`
3. Same validation pattern as insert, then redirect with "Product updated successfully."

### 12.3 Clone Product
1. Click Clone (copy icon) → `GET /products?action=clone&id=X`
2. Servlet creates copy with `-COPY-timestamp` suffix and `(Copy)` name suffix
3. Redirect to product list with "Product cloned successfully." or error flash

### 12.4 Delete Product
1. Click Delete (trash icon) → JS confirm → `GET /products?action=delete&id=X`
2. Delete from DB, redirect with "Product deleted successfully."

### 12.5 Sell Product (from sell page)
1. Go to Sell page → browse/search products
2. Enter quantity, click "Sell" → JS confirm dialog (shows product, qty, total)
3. Confirm → `POST /products?action=sell` → validate stock → decrement → record sale → flash "Sold N x ProductName for ₹X.XX"
4. Stay on sell page

### 12.6 Sell Product (from dashboard quick-sell)
1. On dashboard, enter quantity in card, click "Sell"
2. Same JS confirm → same POST → but with `redirect=dashboard` param
3. After successful sale, redirect back to dashboard with flash message

### 12.7 Delete Category
1. Click Delete → JS confirm with category name → `GET /categories?action=delete&id=X`
2. If category has products → flash error "Cannot delete category with N product(s). Remove products first."
3. If empty → delete + flash success

### 12.8 Export CSV
1. Click "Export CSV" → `GET /products?action=export`
2. Browser downloads `products.csv` with all products

---

## 13. Database Connection

**File:** `src/main/resources/database.properties`

```properties
db.url=jdbc:mysql://localhost:3306/inventory_db?useSSL=false&serverTimezone=UTC
db.username=root
db.password=rootroot
db.driver=com.mysql.cj.jdbc.Driver
```

**Connection class:** `DatabaseConnection.java` reads from properties file via classpath, loads driver, returns `DriverManager.getConnection(url, username, password)`. Uses static initializer block.

---

## 14. Build & Deployment

### 14.1 pom.xml Dependencies

| Dependency | GroupId | Version | Scope |
|-----------|---------|---------|-------|
| Jakarta Servlet API | `jakarta.servlet` | 6.0.0 | provided |
| Jakarta JSP API | `jakarta.servlet.jsp` | 3.1.1 | provided |
| JSTL API | `jakarta.servlet.jsp.jstl` | 3.0.0 | compile |
| JSTL Implementation | `org.glassfish.web` | 3.0.1 | compile |
| MySQL Connector/J | `com.mysql` | 8.0.33 | compile |

### 14.2 Build Commands
```bash
mvn clean package -DskipTests   # Build WAR
```
Output: `target/inventory-system.war`

### 14.3 Deployment
- Copy WAR to Tomcat's `webapps/` directory
- Or import as Existing Maven Project in Eclipse → Run on Server → Tomcat 11

---

## 15. Error Handling

- **Database errors in servlets:** Caught as `SQLException`, rethrown as `ServletException("Database error", e)` → Tomcat shows 500 error page
- **Clone duplicate key:** `SQLException` caught in clone handler, flash error with message `"Failed to clone product: " + e.getMessage()`
- **Category duplicate name:** `SQLException` caught in category insert/update, checks `e.getMessage().contains("Duplicate")` → displays "Category name already exists"
- **Sell insufficient stock:** Checked in Java before SQL → flash error "Not enough stock. Available: N"
- **Sell product not found:** Checked in Java → flash error "Product not found."
- **Validation errors:** Forwarded back to form with error message and filled fields
- **Category delete with products:** Checked via `getProductCount()` → flash error, blocked

---

## 16. Responsive Design

- **Dashboard quick-sell grid:** `row-cols-2 row-cols-md-3 row-cols-lg-5` (2 cols on mobile, 3 on tablet, 5 on desktop)
- **Product detail:** Two-column on large screens (`col-lg-5` + `col-lg-7`), stacks on mobile
- **Filter form:** 3-column row on desktop, stacks on mobile
- **Tables:** Wrapped in `table-responsive` for horizontal scroll on small screens
- All pages use Bootstrap's container, grid, and responsive utilities
