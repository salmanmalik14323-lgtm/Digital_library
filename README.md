# Digital Library and Recommendation System

An enterprise-grade, responsive, full-stack academic web application designed and built for **SY BSc IT (SEC: Java Programming)**. The system provides comprehensive library inventory management, student catalog exploration, real-time activity tracking, and a transparent **content-based book recommendation engine**.

---

## 🎓 Academic Project Information
- **Project Title:** Digital Library and Recommendation System
- **Student Name:** Salman Murtuja Malik
- **Roll Number:** 17034
- **Class:** SY BSc IT (Second Year Bachelor of Science in Information Technology)
- **Subject:** SEC (Java Programming)
- **Academic Year:** 2026–2027

---

## 🛠️ Technology Stack & Architecture

| Layer | Technologies Used |
|---|---|
| **Presentation Layer (Frontend)** | HTML5, CSS3 (Custom Navy & Teal Design System), Vanilla ES6 JavaScript, JSP 3.1 |
| **Application Layer (Backend)** | Java 17, Jakarta Servlets 6.0 (`jakarta.servlet.*`), Custom Filters (RBAC & UTF-8) |
| **Persistence Layer (Data Access)** | JDBC (Java Database Connectivity), MySQL Connector/J 8.3.0, Thread-safe Connection Manager |
| **Database Layer** | MySQL 8.x (`digital_library_db`), Relational Schema with Foreign Keys & Constraints |
| **Servlet Container & Server** | Apache Tomcat 10.1 |
| **Development & Build Tools** | Eclipse IDE for Enterprise Java (EE), Maven 3.x, MySQL Workbench |

---

## 🌟 Key Application Features

1. **User Authentication & Session Management**:
   - Secure account registration and authentication.
   - Salted SHA-256 cryptographic password hashing via `PasswordUtil`.
   - Role-Based Access Control (`AuthFilter`) securing admin endpoints from unauthorized access.
   - Clean session termination and invalidation on logout.

2. **Personalized Content-Based Recommendation Engine**:
   - Computes deterministic, explainable match scores for all catalog books.
   - **50% Weight**: Direct alignment with student's declared subject interests.
   - **30% Weight**: Frequency of recent book page visits and catalog queries in that subject.
   - **20% Weight**: Normalized peer review rating and current shelf copy availability.
   - Surfaces transparent "Why Recommended" rationale pills on each book card.

3. **Academic Catalogue & Deep Search**:
   - Multi-criteria search across book titles, authors, descriptions, and ISBN-13 codes.
   - Filter by academic disciplines (Computer Science, Web Tech, AI/ML, Databases, Cyber Security, etc.).
   - Sort by Title (A-Z), Highest Rating, Publication Year, or Recent Additions.
   - Live availability indicators (`In Stock` vs `All Copies Checked Out`).

4. **Student Workspace & Profile Management**:
   - Personal reading activity history table with timestamps.
   - Interactive discipline/interest customization with instant recommendation recalculation.
   - Profile management and self-service password update.

5. **Administrator Command Center**:
   - Live telemetry dashboard with real-time counters (Books, Copies, Disciplines, Users, Interaction Events).
   - Real-time audit log of all catalog views, searches, and borrow requests.
   - Full CRUD Book Management (Add, Edit, Update Stock, Delete).
   - Subject taxonomy category management with modal dialogues.
   - User account moderation and role elevation/demotion (`USER` &harr; `ADMIN`).

---

## 🗄️ Database Setup Instructions (MySQL)

### Method 1: Using MySQL Workbench
1. Open **MySQL Workbench** and connect to your local MySQL server instance (default: `localhost:3306`).
2. Open `database/schema.sql`:
   - Click **File** &rarr; **Open SQL Script...** &rarr; select `database/schema.sql`.
   - Click the **Execute** icon (lightning bolt ⚡) to create the `digital_library_db` database and tables.
3. Open `database/seed_data.sql`:
   - Click **File** &rarr; **Open SQL Script...** &rarr; select `database/seed_data.sql`.
   - Click the **Execute** icon to populate realistic academic categories, books, and demo accounts.

### Method 2: Using MySQL Command Line Client
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed_data.sql
```

### Configure Credentials
Check `src/main/resources/db.properties` and verify your MySQL credentials:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/digital_library_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.username=root
db.password=root
```
*(Change `db.password` to match your local MySQL root password if different).*

---

## 💻 Eclipse IDE & Tomcat 10.1 Setup Guide

### Step 1: Import Project into Eclipse
1. Launch **Eclipse IDE for Enterprise Java and Web Developers**.
2. Click **File** &rarr; **Import...**
3. Select **Maven** &rarr; **Existing Maven Projects** (or **General** &rarr; **Existing Projects into Workspace**).
4. Click **Browse...** and select the folder:
   `c:\Users\salma\OneDrive\Desktop\Digital_Library`
5. Click **Finish**. Eclipse will build the workspace and configure the classpath.

### Step 2: Configure Apache Tomcat 10.1 in Eclipse
1. In Eclipse, open the **Servers** tab (window: *Window* &rarr; *Show View* &rarr; *Servers*).
2. Right-click &rarr; **New** &rarr; **Server**.
3. Expand **Apache** and select **Tomcat v10.1 Server**.
4. Point to your installed Apache Tomcat 10.1 installation directory.
5. In the **Add and Remove...** dialog, select **Digital_Library** and click **Add >** to deploy it to the server.
6. Click **Finish**.

### Step 3: Run the Application
1. In the **Project Explorer**, right-click `Digital_Library`.
2. Select **Run As** &rarr; **Run on Server**.
3. Choose **Tomcat v10.1 Server** and click **Finish**.
4. Open your browser and navigate to:
   ```
   http://localhost:8080/Digital_Library/
   ```

---

## 🔑 Pre-Configured Demo Accounts

| Role | Username | Password | Purpose |
|---|---|---|---|
| **System Administrator** | `admin` | `Admin@123` | Access admin dashboard, manage books, add categories, view user activities |
| **Student (Salman)** | `salman` | `User@123` | Explore personalized recommendations, search catalog, manage interests |
| **Student (Priya)** | `priya` | `User@123` | Additional scholar profile with different category interests |

---

## 📁 Project Directory Structure

```
Digital_Library/
├── database/
│   ├── schema.sql                       # MySQL DDL with foreign key constraints
│   └── seed_data.sql                    # Academic sample categories, books, and users
├── src/main/java/com/digitallibrary/
│   ├── model/
│   │   ├── Book.java                    # Book entity bean
│   │   ├── BookActivity.java            # Interaction tracking bean
│   │   ├── Category.java                # Discipline category bean
│   │   ├── Recommendation.java          # Recommendation score & reason bean
│   │   ├── User.java                    # User model with role checks
│   │   └── UserInterest.java            # User-to-category interest junction bean
│   ├── util/
│   │   ├── DBConnection.java            # Thread-safe MySQL connection utility
│   │   ├── PasswordUtil.java            # Salted SHA-256 password hashing
│   │   ├── RecommendationEngine.java    # Content-based recommendation algorithm
│   │   └── ValidationUtil.java          # XSS sanitization and regex validation
│   ├── dao/
│   │   ├── BookActivityDAO.java         # Activity tracking queries
│   │   ├── BookDAO.java                 # Catalog search & CRUD operations
│   │   ├── CategoryDAO.java             # Category queries & counts
│   │   ├── RecommendationDAO.java       # Recommendation caching & updates
│   │   ├── UserDAO.java                 # Authentication & profile management
│   │   └── UserInterestDAO.java         # User category preferences
│   ├── filter/
│   │   ├── AuthFilter.java              # RBAC security filter for /admin and /user
│   │   └── EncodingFilter.java          # UTF-8 character encoding filter
│   └── servlet/
│       ├── AdminBookServlet.java        # Book inventory CRUD controller
│       ├── AdminCategoryServlet.java    # Category taxonomy controller
│       ├── AdminDashboardServlet.java   # Admin statistics & telemetry controller
│       ├── AdminUserServlet.java        # User role moderation controller
│       ├── AuthServlet.java             # Sign In, Sign Up, & Sign Out
│       ├── BookServlet.java             # Catalog search & details controller
│       ├── HomeServlet.java             # Landing page controller
│       ├── RecommendationServlet.java   # Personalized recommendation feed
│       └── UserDashboardServlet.java    # Student dashboard & profile controller
├── src/main/resources/
│   └── db.properties                    # Configurable MySQL database credentials
├── src/main/webapp/
│   ├── css/
│   │   └── style.css                    # Master Navy & Teal design system
│   ├── js/
│   │   └── main.js                      # Client-side validation & interactivity
│   ├── WEB-INF/
│   │   ├── includes/
│   │   │   ├── admin-sidebar.jsp        # Sidebar navigation for admin workspace
│   │   │   ├── footer.jsp               # Common footer with project info
│   │   │   ├── header.jsp               # HTML head, typography, and styles
│   │   │   └── navbar.jsp               # Dynamic, role-aware top navigation
│   │   └── web.xml                      # Jakarta EE 10 deployment descriptor
│   ├── admin-book-form.jsp              # Form for adding/editing books
│   ├── admin-books.jsp                  # Admin book inventory table
│   ├── admin-categories.jsp             # Category management page
│   ├── admin-dashboard.jsp              # Admin control center
│   ├── admin-users.jsp                  # User moderation page
│   ├── book-details.jsp                 # Detailed book inspection & related picks
│   ├── books.jsp                        # Public searchable catalogue
│   ├── error.jsp                        # User-friendly error page (404/500)
│   ├── index.jsp                        # Public landing page with live stats
│   ├── login.jsp                        # User & Admin authentication
│   ├── profile.jsp                      # Profile settings & password change
│   ├── recommendations.jsp              # Dedicated recommendation feed
│   ├── register.jsp                     # Student registration with interest chips
│   └── user-dashboard.jsp               # Student dashboard & reading history
├── pom.xml                              # Maven build file with Jakarta EE 10 dependencies
└── README.md                            # Comprehensive project guide
```

---

## 🔍 How to Demonstrate During Viva / Evaluation

1. **Demonstrate Public Browsing**:
   - Open homepage, view live database statistics.
   - Search for *"Java"* or *"Database"* in catalog search bar.
   - Filter by discipline (e.g. *Web Technologies & Frameworks*).
   - View book details, notice real-time stock availability badge.

2. **Demonstrate User Experience & Recommendations**:
   - Sign in as `salman` / `User@123`.
   - Go to **For You** (`/recommendations`).
   - Highlight the calculated match percentage and transparent explainable reason (e.g., *"Matches your interest in Computer Science & Programming and high rating"*).
   - Click **Modify Interests**, check/uncheck disciplines, and click **Save & Refresh Recommendations**. Observe instant recalculation.

3. **Demonstrate Security & Role-Based Access**:
   - Attempt to navigate to `http://localhost:8080/Digital_Library/admin/dashboard` while logged in as a normal user. Observe access denied redirect.
   - Log out.

4. **Demonstrate Administrator Workspace**:
   - Sign in as `admin` / `Admin@123`.
   - Open **Admin Panel** (`/admin/dashboard`).
   - Review live counters and recent activity log (which tracks book views and searches).
   - Add a new book in **Book Inventory**, or replenish stock copies.
   - View updated statistics reflected immediately.
