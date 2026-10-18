<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="site-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col">
                <div class="brand-logo" style="margin-bottom: 1rem;">
                    <i class="bi bi-journal-bookmark-fill"></i>
                    <span>Digital<span class="accent">Lib</span></span>
                </div>
                <p style="font-size: 0.9rem; line-height: 1.6; color: #94a3b8; margin-bottom: 1.25rem;">
                    A next-generation digital library platform featuring an explainable, content-based recommendation engine for academic research and study materials.
                </p>
                <div style="font-size: 0.85rem; color: #64748b;">
                    Built with Java Servlets, JSP, JDBC, MySQL &amp; Apache Tomcat 10.1.
                </div>
            </div>

            <div class="footer-col">
                <h4>Explore</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home Page</a></li>
                    <li><a href="${pageContext.request.contextPath}/books">Full Catalog</a></li>
                    <li><a href="${pageContext.request.contextPath}/recommendations">Personalized Recommendations</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Member Sign In</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Top Categories</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/books?category=1">Computer Science</a></li>
                    <li><a href="${pageContext.request.contextPath}/books?category=2">Web Technologies</a></li>
                    <li><a href="${pageContext.request.contextPath}/books?category=3">Artificial Intelligence</a></li>
                    <li><a href="${pageContext.request.contextPath}/books?category=4">Database Systems</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Academic Project</h4>
                <p style="font-size: 0.88rem; color: #94a3b8; margin-bottom: 0.5rem;">
                    <strong>Subject:</strong> SEC (Java Programming)<br>
                    <strong>Class:</strong> SY BSc IT<br>
                    <strong>Student:</strong> Salman Murtuja Malik<br>
                    <strong>Roll Number:</strong> 17034<br>
                    <strong>Academic Year:</strong> 2026–27
                </p>
            </div>
        </div>

        <div class="footer-bottom">
            <div>&copy; 2026–2027 Digital Library and Recommendation System. All rights reserved.</div>
            <div>Designed with Java EE &amp; Modern Web Standards</div>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
