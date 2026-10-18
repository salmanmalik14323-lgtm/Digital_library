<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Category" %>
<%
    request.setAttribute("pageTitle", "Subject Categories - Admin Workspace");
    String cp = request.getContextPath();
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <div class="dashboard-grid">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="activeTab" value="categories" />
            </jsp:include>

            <!-- Main Panel -->
            <div>
                <div class="section-header">
                    <div>
                        <h1 class="section-title"><i class="bi bi-tags"></i> Subject Categories &amp; Tracks</h1>
                        <p class="section-subtitle">Manage academic taxonomy classifications used by cataloging and the recommendation engine.</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary" onclick="openModal('addCategoryModal')">
                            <i class="bi bi-plus-lg"></i> Add New Category
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Icon</th>
                                <th>Category Name</th>
                                <th>Description</th>
                                <th>Books Bound</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (categories != null) {
                                for (Category cat : categories) { %>
                                <tr>
                                    <td style="width: 50px;">
                                        <div class="category-icon-box" style="width: 38px; height: 38px; font-size: 1.15rem;">
                                            <i class="bi <%= cat.getIconClass() != null ? cat.getIconClass() : "bi-book" %>"></i>
                                        </div>
                                    </td>
                                    <td style="font-weight: 700; color: var(--primary-navy);">
                                        <%= cat.getName() %>
                                    </td>
                                    <td style="color: var(--text-muted); font-size: 0.88rem; max-width: 320px;">
                                        <%= cat.getDescription() != null ? cat.getDescription() : "" %>
                                    </td>
                                    <td>
                                        <span class="badge badge-teal"><%= cat.getBookCount() %> Books</span>
                                    </td>
                                    <td style="text-align: right;">
                                        <div class="action-btn-group" style="justify-content: flex-end;">
                                            <button type="button" class="btn btn-sm btn-secondary" 
                                                    onclick="editCategory(<%= cat.getCategoryId() %>, '<%= cat.getName().replace("'", "\\'") %>', '<%= (cat.getDescription() != null ? cat.getDescription().replace("'", "\\'") : "") %>', '<%= cat.getIconClass() %>')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <form action="<%= cp %>/admin/category-delete" method="POST" 
                                                  onsubmit="return confirm('Are you sure? Categories with existing books cannot be deleted.');" style="margin: 0;">
                                                <input type="hidden" name="categoryId" value="<%= cat.getCategoryId() %>">
                                                <button type="submit" class="btn btn-sm btn-danger">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%   }
                               } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Add Category Modal -->
<div id="addCategoryModal" class="modal-backdrop" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Add New Subject Category</h3>
            <button type="button" class="modal-close" onclick="closeModal('addCategoryModal')">&times;</button>
        </div>
        <form action="<%= cp %>/admin/category-add" method="POST">
            <div class="form-group">
                <label for="name">Category Name *</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="e.g. Distributed Systems" required>
            </div>
            <div class="form-group">
                <label for="iconClass">Bootstrap Icon Class</label>
                <input type="text" id="iconClass" name="iconClass" class="form-control" value="bi-book" placeholder="e.g. bi-cpu, bi-diagram-3">
            </div>
            <div class="form-group">
                <label for="description">Scope Description</label>
                <textarea id="description" name="description" class="form-control" rows="3" placeholder="Syllabus coverage and key computational domains..."></textarea>
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addCategoryModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Create Category</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Category Modal -->
<div id="editCategoryModal" class="modal-backdrop" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Edit Subject Category</h3>
            <button type="button" class="modal-close" onclick="closeModal('editCategoryModal')">&times;</button>
        </div>
        <form action="<%= cp %>/admin/category-edit" method="POST">
            <input type="hidden" id="editCategoryId" name="categoryId">
            <div class="form-group">
                <label for="editName">Category Name *</label>
                <input type="text" id="editName" name="name" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="editIconClass">Bootstrap Icon Class</label>
                <input type="text" id="editIconClass" name="iconClass" class="form-control">
            </div>
            <div class="form-group">
                <label for="editDescription">Scope Description</label>
                <textarea id="editDescription" name="description" class="form-control" rows="3"></textarea>
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem; margin-top: 1.5rem;">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editCategoryModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<style>
.modal-backdrop {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(15, 23, 42, 0.6);
    backdrop-filter: blur(4px);
    display: flex; align-items: center; justify-content: center;
    z-index: 2000;
}
.modal-content {
    background: #ffffff;
    border-radius: var(--radius-lg);
    width: 100%; max-width: 500px;
    padding: 2rem;
    box-shadow: var(--shadow-xl);
}
.modal-header {
    display: flex; justify-content: space-between; align-items: center;
    margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color);
}
.modal-header h3 { font-size: 1.25rem; font-weight: 700; color: var(--primary-navy); }
.modal-close { background: none; border: none; font-size: 1.5rem; color: var(--text-muted); cursor: pointer; }
</style>

<script>
function editCategory(id, name, desc, icon) {
    document.getElementById('editCategoryId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editDescription').value = desc;
    document.getElementById('editIconClass').value = icon;
    openModal('editCategoryModal');
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
