            </main>
        </div>
    </div>

    <!-- JavaScript untuk Toggle Menu -->
    <script>
        const sidebar = document.getElementById('sidebar');
        const menuToggleBtn = document.getElementById('menu-toggle-btn');
        const closeSidebarBtn = document.getElementById('close-sidebar-btn');
        const sidebarOverlay = document.getElementById('sidebar-overlay');

        function toggleSidebar() {
            sidebar.classList.toggle('active');
            sidebarOverlay.classList.toggle('active');
        }

        if (menuToggleBtn) {
            menuToggleBtn.addEventListener('click', toggleSidebar);
        }

        if (closeSidebarBtn) {
            closeSidebarBtn.addEventListener('click', toggleSidebar);
        }

        if (sidebarOverlay) {
            sidebarOverlay.addEventListener('click', toggleSidebar);
        }
    </script>
</body>
</html>