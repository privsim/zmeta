local macros = {}

-- ============================================================
-- GUI HTML (embedded webview content)
-- ============================================================
local GUI_HTML = [[<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Macro Manager</title>
<style>
*, *::before, *::after {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --bg-primary: #0d0d0d;
    --bg-secondary: #141414;
    --bg-card: #1a1a1a;
    --bg-card-hover: #222222;
    --bg-card-selected: #1a2a3a;
    --bg-input: #111111;
    --bg-overlay: rgba(0, 0, 0, 0.6);
    --text-primary: #e0e0e0;
    --text-heading: #ffffff;
    --text-secondary: #999999;
    --text-muted: #666666;
    --accent-blue: #66b3ff;
    --accent-blue-dim: #3d6d99;
    --accent-green: #00cc66;
    --accent-green-dim: #009944;
    --accent-red: #cc4444;
    --accent-red-hover: #dd5555;
    --border-subtle: #222222;
    --border-medium: #333333;
    --border-focus: #66b3ff;
    --font-system: -apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif;
    --font-mono: "SF Mono", "Menlo", "Monaco", "Consolas", monospace;
    --radius-sm: 4px;
    --radius-md: 6px;
    --radius-lg: 8px;
    --transition-fast: 0.15s ease;
    --transition-normal: 0.25s ease;
}

html, body {
    height: 100%;
    overflow: hidden;
}

body {
    font-family: var(--font-system);
    background: var(--bg-primary);
    color: var(--text-primary);
    font-size: 13px;
    line-height: 1.5;
    display: flex;
    flex-direction: column;
}

::-webkit-scrollbar { width: 8px; height: 8px; }
::-webkit-scrollbar-track { background: #111111; }
::-webkit-scrollbar-thumb { background: #333333; border-radius: 4px; }
::-webkit-scrollbar-thumb:hover { background: #444444; }

.header {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    background: var(--bg-secondary);
    border-bottom: 1px solid var(--border-subtle);
    flex-shrink: 0;
    min-height: 52px;
}

.header-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--text-heading);
    white-space: nowrap;
    flex-shrink: 0;
}

.search-wrapper {
    position: relative;
    flex: 1;
    min-width: 120px;
}

.search-icon {
    position: absolute;
    left: 8px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--text-muted);
    font-size: 12px;
    pointer-events: none;
}

.search-input {
    width: 100%;
    padding: 6px 10px 6px 28px;
    background: var(--bg-input);
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-md);
    color: var(--text-primary);
    font-family: var(--font-system);
    font-size: 12px;
    outline: none;
    transition: border-color var(--transition-fast);
}

.search-input::placeholder { color: var(--text-muted); }
.search-input:focus { border-color: var(--border-focus); }

.btn {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 6px 12px;
    border: 1px solid var(--border-medium);
    border-radius: var(--radius-md);
    background: var(--bg-input);
    color: var(--text-primary);
    font-family: var(--font-system);
    font-size: 12px;
    cursor: pointer;
    white-space: nowrap;
    transition: all var(--transition-fast);
    flex-shrink: 0;
}

.btn:hover { background: var(--bg-card-hover); border-color: var(--text-muted); }

.btn-primary {
    background: var(--accent-blue-dim);
    border-color: var(--accent-blue);
    color: var(--text-heading);
}
.btn-primary:hover { background: var(--accent-blue); color: #000000; }

.btn-danger {
    background: transparent;
    border-color: var(--accent-red);
    color: var(--accent-red);
}
.btn-danger:hover { background: var(--accent-red); color: var(--text-heading); }

.btn-save {
    background: var(--accent-green-dim);
    border-color: var(--accent-green);
    color: var(--text-heading);
}
.btn-save:hover { background: var(--accent-green); color: #000000; }

.toggle-wrapper {
    display: flex;
    align-items: center;
    gap: 6px;
    flex-shrink: 0;
}

.toggle-label {
    font-size: 11px;
    color: var(--text-secondary);
    white-space: nowrap;
}

.toggle-switch {
    position: relative;
    width: 34px;
    height: 18px;
    cursor: pointer;
}

.toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
    position: absolute;
}

.toggle-track {
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    background: var(--border-medium);
    border-radius: 9px;
    transition: background var(--transition-fast);
}

.toggle-switch input:checked + .toggle-track {
    background: var(--accent-green-dim);
}

.toggle-knob {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 14px;
    height: 14px;
    background: var(--text-primary);
    border-radius: 50%;
    transition: transform var(--transition-fast);
    pointer-events: none;
}

.toggle-switch input:checked ~ .toggle-knob {
    transform: translateX(16px);
}

.category-bar {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    background: var(--bg-primary);
    border-bottom: 1px solid var(--border-subtle);
    flex-shrink: 0;
    overflow-x: auto;
    min-height: 38px;
}

.category-pill {
    display: inline-flex;
    align-items: center;
    padding: 3px 10px;
    border: 1px solid var(--border-subtle);
    border-radius: 12px;
    background: transparent;
    color: var(--text-secondary);
    font-family: var(--font-system);
    font-size: 11px;
    cursor: pointer;
    white-space: nowrap;
    transition: all var(--transition-fast);
    flex-shrink: 0;
}

.category-pill:hover {
    border-color: var(--border-medium);
    color: var(--text-primary);
    background: var(--bg-card);
}

.category-pill.active {
    border-color: var(--accent-blue);
    color: var(--accent-blue);
    background: rgba(102, 179, 255, 0.1);
}

.main-content {
    flex: 1;
    display: flex;
    overflow: hidden;
    position: relative;
}

.macro-list-container {
    flex: 1;
    overflow-y: auto;
    padding: 8px 16px;
}

.macro-card {
    display: flex;
    flex-direction: column;
    gap: 4px;
    padding: 10px 12px;
    margin-bottom: 4px;
    background: transparent;
    border: 1px solid transparent;
    border-radius: var(--radius-lg);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.macro-card:hover {
    background: var(--bg-card);
    border-color: var(--border-subtle);
}

.macro-card.selected {
    background: var(--bg-card-selected);
    border-color: var(--accent-blue-dim);
    border-left: 3px solid var(--accent-blue);
}

.macro-card-header {
    display: flex;
    align-items: center;
    gap: 8px;
}

.macro-name {
    font-size: 13px;
    font-weight: 500;
    color: var(--text-heading);
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.macro-abbr {
    font-family: var(--font-mono);
    font-size: 11px;
    color: var(--accent-green);
    background: rgba(0, 204, 102, 0.1);
    padding: 1px 6px;
    border-radius: var(--radius-sm);
    flex-shrink: 0;
}

.macro-category-badge {
    font-size: 10px;
    color: var(--accent-blue);
    background: rgba(102, 179, 255, 0.1);
    padding: 1px 6px;
    border-radius: var(--radius-sm);
    flex-shrink: 0;
    text-transform: lowercase;
}

.macro-preview {
    font-size: 11px;
    color: var(--text-muted);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    line-height: 1.4;
}

.macro-preview .newline-indicator {
    color: var(--text-muted);
    opacity: 0.5;
    font-family: var(--font-mono);
    font-size: 10px;
}

.empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    min-height: 200px;
    color: var(--text-muted);
    text-align: center;
    padding: 40px;
}

.empty-state-icon {
    font-size: 32px;
    margin-bottom: 12px;
    opacity: 0.3;
    color: var(--text-secondary);
}

.empty-state-title {
    font-size: 14px;
    font-weight: 500;
    color: var(--text-secondary);
    margin-bottom: 4px;
}

.empty-state-text {
    font-size: 12px;
    color: var(--text-muted);
}

.edit-overlay {
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    background: var(--bg-overlay);
    opacity: 0;
    pointer-events: none;
    transition: opacity var(--transition-normal);
    z-index: 10;
}

.edit-overlay.visible {
    opacity: 1;
    pointer-events: auto;
}

.edit-panel {
    position: absolute;
    top: 0; right: 0; bottom: 0;
    width: 380px;
    max-width: 100%;
    background: var(--bg-secondary);
    border-left: 1px solid var(--border-subtle);
    transform: translateX(100%);
    transition: transform var(--transition-normal);
    z-index: 11;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.edit-panel.visible { transform: translateX(0); }

.edit-panel-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 16px;
    border-bottom: 1px solid var(--border-subtle);
    flex-shrink: 0;
}

.edit-panel-title {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-heading);
}

.edit-panel-close {
    width: 24px; height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: transparent;
    border: none;
    color: var(--text-muted);
    cursor: pointer;
    border-radius: var(--radius-sm);
    font-size: 16px;
    transition: all var(--transition-fast);
}

.edit-panel-close:hover {
    background: var(--bg-card-hover);
    color: var(--text-primary);
}

.edit-panel-body {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
}

.form-group { margin-bottom: 14px; }

.form-label {
    display: block;
    font-size: 11px;
    font-weight: 500;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 4px;
}

.form-hint {
    font-size: 10px;
    color: var(--text-muted);
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    margin-left: 6px;
}

.form-input {
    width: 100%;
    padding: 7px 10px;
    background: var(--bg-input);
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-md);
    color: var(--text-primary);
    font-family: var(--font-system);
    font-size: 13px;
    outline: none;
    transition: border-color var(--transition-fast);
}

.form-input:focus { border-color: var(--border-focus); }
.form-input::placeholder { color: var(--text-muted); }
.form-input.mono { font-family: var(--font-mono); font-size: 13px; }

.form-textarea {
    width: 100%;
    min-height: 160px;
    padding: 8px 10px;
    background: var(--bg-input);
    border: 1px solid var(--border-subtle);
    border-radius: var(--radius-md);
    color: var(--text-primary);
    font-family: var(--font-mono);
    font-size: 12px;
    line-height: 1.5;
    outline: none;
    resize: vertical;
    transition: border-color var(--transition-fast);
}

.form-textarea:focus { border-color: var(--border-focus); }
.form-textarea::placeholder { color: var(--text-muted); }

.edit-panel-footer {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px 16px;
    border-top: 1px solid var(--border-subtle);
    flex-shrink: 0;
}

.edit-panel-footer .btn-danger { margin-left: auto; }

.footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 8px 16px;
    background: var(--bg-secondary);
    border-top: 1px solid var(--border-subtle);
    flex-shrink: 0;
    min-height: 32px;
}

.footer-hint { font-size: 11px; color: var(--text-muted); }

.footer-hint kbd {
    display: inline-block;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid var(--border-medium);
    border-radius: 3px;
    padding: 0 4px;
    font-family: var(--font-system);
    font-size: 10px;
    color: var(--text-secondary);
    margin: 0 1px;
}

.footer-count { font-size: 11px; color: var(--text-muted); }

.hidden { display: none !important; }

.btn:focus-visible,
.category-pill:focus-visible,
.macro-card:focus-visible {
    outline: 2px solid var(--accent-blue);
    outline-offset: 1px;
}
</style>
</head>
<body>

<div class="header">
    <div class="header-title">Macro Manager</div>
    <div class="search-wrapper">
        <span class="search-icon">&#x2315;</span>
        <input type="text" class="search-input" id="searchInput" placeholder="Search macros..." autocomplete="off" spellcheck="false">
    </div>
    <button class="btn btn-primary" id="newMacroBtn" title="New Macro (Cmd+N)">+ New</button>
    <div class="toggle-wrapper">
        <span class="toggle-label">Auto-expand</span>
        <label class="toggle-switch">
            <input type="checkbox" id="autoExpandToggle">
            <span class="toggle-track"></span>
            <span class="toggle-knob"></span>
        </label>
    </div>
</div>

<div class="category-bar" id="categoryBar">
    <button class="category-pill active" data-category="all">All</button>
</div>

<div class="main-content">
    <div class="macro-list-container" id="macroListContainer">
        <div class="empty-state" id="emptyState">
            <div class="empty-state-icon">{ }</div>
            <div class="empty-state-title">No macros yet</div>
            <div class="empty-state-text">Click "+ New" or press Cmd+N to create your first macro.</div>
        </div>
        <div id="macroList"></div>
    </div>

    <div class="edit-overlay" id="editOverlay"></div>

    <div class="edit-panel" id="editPanel">
        <div class="edit-panel-header">
            <div class="edit-panel-title" id="editPanelTitle">New Macro</div>
            <button class="edit-panel-close" id="editPanelClose" title="Close">&times;</button>
        </div>
        <div class="edit-panel-body">
            <div class="form-group">
                <label class="form-label" for="formName">Name</label>
                <input type="text" class="form-input" id="formName" placeholder="My Macro" autocomplete="off" spellcheck="false">
            </div>
            <div class="form-group">
                <label class="form-label" for="formAbbr">
                    Abbreviation
                    <span class="form-hint">e.g. ;sig</span>
                </label>
                <input type="text" class="form-input mono" id="formAbbr" placeholder=";abbr" autocomplete="off" spellcheck="false">
            </div>
            <div class="form-group">
                <label class="form-label" for="formCategory">Category</label>
                <input type="text" class="form-input" id="formCategory" placeholder="general" list="categorySuggestions" autocomplete="off" spellcheck="false">
                <datalist id="categorySuggestions"></datalist>
            </div>
            <div class="form-group">
                <label class="form-label" for="formText">Text Content</label>
                <textarea class="form-textarea" id="formText" placeholder="The text that will be expanded when the abbreviation is typed..."></textarea>
            </div>
        </div>
        <div class="edit-panel-footer">
            <button class="btn btn-save" id="formSaveBtn">Save</button>
            <button class="btn" id="formCancelBtn">Cancel</button>
            <button class="btn btn-danger hidden" id="formDeleteBtn">Delete</button>
        </div>
    </div>
</div>

<div class="footer">
    <div class="footer-hint">
        <kbd>ESC</kbd> close
        &nbsp;&middot;&nbsp;
        <kbd>Cmd+N</kbd> new
        &nbsp;&middot;&nbsp;
        <kbd>Cmd+S</kbd> save
    </div>
    <div class="footer-count" id="macroCount">0 macros</div>
</div>

<script>
(function() {
    "use strict";

    var macros = [];
    var filteredMacros = [];
    var selectedId = null;
    var editingId = null;
    var activeCategory = "all";
    var searchQuery = "";

    var searchInput = document.getElementById("searchInput");
    var newMacroBtn = document.getElementById("newMacroBtn");
    var autoExpandToggle = document.getElementById("autoExpandToggle");
    var categoryBar = document.getElementById("categoryBar");
    var macroListContainer = document.getElementById("macroListContainer");
    var macroList = document.getElementById("macroList");
    var emptyState = document.getElementById("emptyState");
    var editOverlay = document.getElementById("editOverlay");
    var editPanel = document.getElementById("editPanel");
    var editPanelTitle = document.getElementById("editPanelTitle");
    var editPanelClose = document.getElementById("editPanelClose");
    var formName = document.getElementById("formName");
    var formAbbr = document.getElementById("formAbbr");
    var formCategory = document.getElementById("formCategory");
    var formText = document.getElementById("formText");
    var formSaveBtn = document.getElementById("formSaveBtn");
    var formCancelBtn = document.getElementById("formCancelBtn");
    var formDeleteBtn = document.getElementById("formDeleteBtn");
    var macroCount = document.getElementById("macroCount");
    var categorySuggestions = document.getElementById("categorySuggestions");

    function escapeHtml(str) {
        var div = document.createElement("div");
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function getCategories() {
        var cats = {};
        for (var i = 0; i < macros.length; i++) {
            var c = macros[i].category || "general";
            cats[c] = true;
        }
        return Object.keys(cats).sort();
    }

    function formatPreview(text) {
        if (!text) return "";
        var preview = text.substring(0, 120);
        var escaped = escapeHtml(preview);
        escaped = escaped.replace(/\n/g, " <span class=\"newline-indicator\">\\n</span> ");
        if (text.length > 120) {
            escaped += " ...";
        }
        return escaped;
    }

    function sendMessage(payload) {
        try {
            window.webkit.messageHandlers.macrosHandler.postMessage(payload);
        } catch (e) {
            console.log("Message handler not available:", JSON.stringify(payload));
        }
    }

    function applyFilters() {
        var query = searchQuery.toLowerCase().trim();
        filteredMacros = macros.filter(function(m) {
            if (activeCategory !== "all") {
                var mCat = (m.category || "general").toLowerCase();
                if (mCat !== activeCategory.toLowerCase()) return false;
            }
            if (query) {
                var nameMatch = (m.name || "").toLowerCase().indexOf(query) !== -1;
                var abbrMatch = (m.abbreviation || "").toLowerCase().indexOf(query) !== -1;
                var textMatch = (m.text || "").toLowerCase().indexOf(query) !== -1;
                var catMatch = (m.category || "").toLowerCase().indexOf(query) !== -1;
                if (!nameMatch && !abbrMatch && !textMatch && !catMatch) return false;
            }
            return true;
        });
    }

    function sortMacros() {
        macros.sort(function(a, b) {
            var na = (a.name || "").toLowerCase();
            var nb = (b.name || "").toLowerCase();
            if (na < nb) return -1;
            if (na > nb) return 1;
            return 0;
        });
    }

    function renderCategoryBar() {
        var cats = getCategories();
        var html = "";
        html += "<button class=\"category-pill" + (activeCategory === "all" ? " active" : "") + "\" data-category=\"all\">All</button>";
        for (var i = 0; i < cats.length; i++) {
            var c = cats[i];
            var isActive = activeCategory.toLowerCase() === c.toLowerCase();
            html += "<button class=\"category-pill" + (isActive ? " active" : "") + "\" data-category=\"" + escapeHtml(c) + "\">" + escapeHtml(c) + "</button>";
        }
        categoryBar.innerHTML = html;

        var datalistHtml = "";
        for (var j = 0; j < cats.length; j++) {
            datalistHtml += "<option value=\"" + escapeHtml(cats[j]) + "\">";
        }
        categorySuggestions.innerHTML = datalistHtml;
    }

    function renderMacroList() {
        applyFilters();

        if (macros.length === 0) {
            emptyState.style.display = "";
            emptyState.querySelector(".empty-state-title").textContent = "No macros yet";
            emptyState.querySelector(".empty-state-text").textContent = "Click \"+ New\" or press Cmd+N to create your first macro.";
            macroList.innerHTML = "";
            updateMacroCount();
            return;
        }

        if (filteredMacros.length === 0) {
            emptyState.style.display = "";
            emptyState.querySelector(".empty-state-title").textContent = "No matching macros";
            emptyState.querySelector(".empty-state-text").textContent = "Try a different search term or category filter.";
            macroList.innerHTML = "";
            updateMacroCount();
            return;
        }

        emptyState.style.display = "none";

        var html = "";
        for (var i = 0; i < filteredMacros.length; i++) {
            var m = filteredMacros[i];
            var isSelected = selectedId === m.id;
            html += "<div class=\"macro-card" + (isSelected ? " selected" : "") + "\" data-id=\"" + escapeHtml(m.id) + "\" tabindex=\"0\">";
            html += "<div class=\"macro-card-header\">";
            html += "<span class=\"macro-name\">" + escapeHtml(m.name || "Untitled") + "</span>";
            if (m.abbreviation) {
                html += "<span class=\"macro-abbr\">" + escapeHtml(m.abbreviation) + "</span>";
            }
            if (m.category) {
                html += "<span class=\"macro-category-badge\">" + escapeHtml(m.category) + "</span>";
            }
            html += "</div>";
            html += "<div class=\"macro-preview\">" + formatPreview(m.text) + "</div>";
            html += "</div>";
        }
        macroList.innerHTML = html;
        updateMacroCount();
    }

    function updateMacroCount() {
        var total = macros.length;
        var shown = filteredMacros.length;
        if (total === 0) {
            macroCount.textContent = "0 macros";
        } else if (shown === total) {
            macroCount.textContent = total + " macro" + (total === 1 ? "" : "s");
        } else {
            macroCount.textContent = shown + " of " + total + " macro" + (total === 1 ? "" : "s");
        }
    }

    function openEditPanel(macro) {
        if (macro) {
            editingId = macro.id;
            editPanelTitle.textContent = "Edit Macro";
            formName.value = macro.name || "";
            formAbbr.value = macro.abbreviation || "";
            formCategory.value = macro.category || "";
            formText.value = macro.text || "";
            formDeleteBtn.classList.remove("hidden");
        } else {
            editingId = null;
            editPanelTitle.textContent = "New Macro";
            formName.value = "";
            formAbbr.value = "";
            formCategory.value = "";
            formText.value = "";
            formDeleteBtn.classList.add("hidden");
        }

        editOverlay.classList.add("visible");
        editPanel.classList.add("visible");

        setTimeout(function() {
            formName.focus();
        }, 280);
    }

    function closeEditPanel() {
        editOverlay.classList.remove("visible");
        editPanel.classList.remove("visible");
        editingId = null;
    }

    function selectMacro(id) {
        selectedId = id;
        renderMacroList();
        var macro = findMacroById(id);
        if (macro) {
            openEditPanel(macro);
        }
    }

    function findMacroById(id) {
        for (var i = 0; i < macros.length; i++) {
            if (macros[i].id === id) return macros[i];
        }
        return null;
    }

    function handleSave() {
        var name = formName.value.trim();
        var abbreviation = formAbbr.value.trim();
        var category = formCategory.value.trim() || "general";
        var text = formText.value;

        if (!name) {
            formName.style.borderColor = "#cc4444";
            formName.focus();
            setTimeout(function() { formName.style.borderColor = ""; }, 2000);
            return;
        }

        sendMessage({
            action: "save",
            data: {
                id: editingId,
                name: name,
                abbreviation: abbreviation,
                text: text,
                category: category
            }
        });
    }

    function handleDelete() {
        if (editingId) {
            sendMessage({
                action: "delete",
                data: { id: editingId }
            });
        }
    }

    // Event listeners
    searchInput.addEventListener("input", function() {
        searchQuery = searchInput.value;
        renderMacroList();
    });

    newMacroBtn.addEventListener("click", function() {
        selectedId = null;
        renderMacroList();
        openEditPanel(null);
    });

    autoExpandToggle.addEventListener("change", function() {
        sendMessage({ action: "toggleAutoExpand" });
    });

    categoryBar.addEventListener("click", function(e) {
        var pill = e.target.closest(".category-pill");
        if (!pill) return;
        activeCategory = pill.getAttribute("data-category") || "all";
        renderCategoryBar();
        renderMacroList();
    });

    macroList.addEventListener("click", function(e) {
        var card = e.target.closest(".macro-card");
        if (!card) return;
        var id = card.getAttribute("data-id");
        if (id) selectMacro(id);
    });

    macroList.addEventListener("keydown", function(e) {
        if (e.key === "Enter") {
            var card = e.target.closest(".macro-card");
            if (card) {
                var id = card.getAttribute("data-id");
                if (id) selectMacro(id);
            }
        }
    });

    editPanelClose.addEventListener("click", closeEditPanel);
    editOverlay.addEventListener("click", closeEditPanel);

    formSaveBtn.addEventListener("click", handleSave);
    formCancelBtn.addEventListener("click", closeEditPanel);
    formDeleteBtn.addEventListener("click", handleDelete);

    document.addEventListener("keydown", function(e) {
        if ((e.metaKey || e.ctrlKey) && e.key === "n") {
            e.preventDefault();
            selectedId = null;
            renderMacroList();
            openEditPanel(null);
            return;
        }

        if ((e.metaKey || e.ctrlKey) && e.key === "s") {
            e.preventDefault();
            if (editPanel.classList.contains("visible")) {
                handleSave();
            }
            return;
        }

        if (e.key === "Escape") {
            if (editPanel.classList.contains("visible")) {
                closeEditPanel();
            }
            return;
        }

        if ((e.metaKey || e.ctrlKey) && e.key === "f") {
            e.preventDefault();
            searchInput.focus();
            searchInput.select();
            return;
        }
    });

    // Public API (called by Lua via evaluateJavaScript)
    window.loadMacros = function(macrosJson) {
        try {
            if (typeof macrosJson === "string") {
                macros = JSON.parse(macrosJson);
            } else {
                macros = macrosJson;
            }
        } catch (e) {
            macros = [];
        }
        sortMacros();
        renderCategoryBar();
        renderMacroList();
    };

    window.setAutoExpand = function(enabled) {
        autoExpandToggle.checked = !!enabled;
    };

    window.onSaveSuccess = function(macroJson) {
        var saved;
        try {
            if (typeof macroJson === "string") {
                saved = JSON.parse(macroJson);
            } else {
                saved = macroJson;
            }
        } catch (e) { return; }

        var found = false;
        for (var i = 0; i < macros.length; i++) {
            if (macros[i].id === saved.id) {
                macros[i] = saved;
                found = true;
                break;
            }
        }
        if (!found) {
            macros.push(saved);
        }

        sortMacros();
        selectedId = saved.id;
        closeEditPanel();
        renderCategoryBar();
        renderMacroList();
    };

    window.onDeleteSuccess = function(id) {
        macros = macros.filter(function(m) {
            return m.id !== id;
        });
        if (selectedId === id) {
            selectedId = null;
        }
        closeEditPanel();
        renderCategoryBar();
        renderMacroList();
    };

    renderCategoryBar();
    renderMacroList();

})();
</script>

</body>
</html>]]

-- ============================================================
-- Configuration
-- ============================================================
local config = {
    dataFile = os.getenv("HOME") .. "/.config/hammerspoon/macros_data.json",
    bufferSize = 40,
    bufferTimeout = 5,
    windowWidthRatio = 0.55,
    windowHeightRatio = 0.75,
}

-- ============================================================
-- State
-- ============================================================
macros.data = {}
macros.webView = nil
macros.chooserObj = nil
macros.expander = nil
macros.autoExpand = true
macros.keyBuffer = ""
macros.bufferTimer = nil
macros.userContent = nil

-- ============================================================
-- Data Persistence
-- ============================================================

local function loadMacros()
    local f = io.open(config.dataFile, "r")
    if not f then
        macros.data = {}
        return macros.data
    end
    local content = f:read("*all")
    f:close()

    if not content or content == "" then
        macros.data = {}
        return macros.data
    end

    local decoded = hs.json.decode(content)
    if decoded then
        macros.data = decoded
    else
        macros.data = {}
    end
    return macros.data
end

local function saveMacros()
    local dir = config.dataFile:match("(.+)/[^/]+$")
    if dir then
        hs.fs.mkdir(dir)
    end

    local encoded = hs.json.encode(macros.data, true)
    local f = io.open(config.dataFile, "w")
    if not f then
        hs.alert.show("Macros: could not write " .. config.dataFile)
        return false
    end
    f:write(encoded)
    f:close()
    return true
end

-- ============================================================
-- CRUD Operations
-- ============================================================

local function generateId()
    return tostring(hs.timer.absoluteTime())
end

local function addMacro(macro)
    macro.id = generateId()
    macro.name = macro.name or ""
    macro.abbreviation = macro.abbreviation or ""
    macro.text = macro.text or ""
    macro.category = macro.category or ""
    macro.createdAt = os.date("%Y-%m-%dT%H:%M:%S")
    macro.updatedAt = macro.createdAt
    table.insert(macros.data, macro)
    saveMacros()
    return macro
end

local function updateMacro(id, updates)
    for i, macro in ipairs(macros.data) do
        if macro.id == id then
            for key, value in pairs(updates) do
                if key ~= "id" and key ~= "createdAt" then
                    macros.data[i][key] = value
                end
            end
            macros.data[i].updatedAt = os.date("%Y-%m-%dT%H:%M:%S")
            saveMacros()
            return macros.data[i]
        end
    end
    return nil
end

local function deleteMacro(id)
    for i, macro in ipairs(macros.data) do
        if macro.id == id then
            table.remove(macros.data, i)
            saveMacros()
            return true
        end
    end
    return false
end

local function getMacro(id)
    for _, macro in ipairs(macros.data) do
        if macro.id == id then
            return macro
        end
    end
    return nil
end

-- ============================================================
-- Text Expansion Engine
-- ============================================================

local function resetBufferTimer()
    if macros.bufferTimer then
        macros.bufferTimer:stop()
        macros.bufferTimer = nil
    end
    macros.bufferTimer = hs.timer.doAfter(config.bufferTimeout, function()
        macros.keyBuffer = ""
    end)
end

local function pasteText(text)
    local oldClipboard = hs.pasteboard.getContents()
    hs.pasteboard.setContents(text)
    hs.eventtap.keyStroke({"cmd"}, "v", 0)
    hs.timer.doAfter(0.3, function()
        hs.pasteboard.setContents(oldClipboard or "")
    end)
end

function macros.startExpander()
    if macros.expander then
        macros.expander:stop()
        macros.expander = nil
    end

    macros.keyBuffer = ""

    macros.expander = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local flags = event:getFlags()
        if flags.cmd or flags.alt or flags.ctrl or flags.fn then
            return false
        end

        local keyCode = event:getKeyCode()
        local char = event:getCharacters()

        if keyCode == hs.keycodes.map["delete"] then
            if #macros.keyBuffer > 0 then
                macros.keyBuffer = macros.keyBuffer:sub(1, -2)
            end
            resetBufferTimer()
            return false
        end

        if not char or #char == 0 then
            return false
        end

        macros.keyBuffer = macros.keyBuffer .. char
        if #macros.keyBuffer > config.bufferSize then
            macros.keyBuffer = macros.keyBuffer:sub(-config.bufferSize)
        end

        resetBufferTimer()

        for _, macro in ipairs(macros.data) do
            local abbr = macro.abbreviation
            if abbr and #abbr > 0 then
                if macros.keyBuffer:sub(-#abbr) == abbr then
                    local abbrLen = #abbr
                    local expansionText = macro.text

                    macros.keyBuffer = ""

                    hs.timer.doAfter(0.01, function()
                        for _ = 1, abbrLen do
                            hs.eventtap.keyStroke({}, "delete", 0)
                        end
                        hs.timer.doAfter(0.05, function()
                            pasteText(expansionText)
                        end)
                    end)

                    return false
                end
            end
        end

        return false
    end)

    macros.expander:start()
end

function macros.stopExpander()
    if macros.expander then
        macros.expander:stop()
        macros.expander = nil
    end
    if macros.bufferTimer then
        macros.bufferTimer:stop()
        macros.bufferTimer = nil
    end
    macros.keyBuffer = ""
end

-- ============================================================
-- Quick Chooser
-- ============================================================

function macros.showChooser()
    loadMacros()

    local choices = {}
    for _, macro in ipairs(macros.data) do
        local subParts = {}
        if macro.abbreviation and #macro.abbreviation > 0 then
            table.insert(subParts, macro.abbreviation)
        end
        if macro.category and #macro.category > 0 then
            table.insert(subParts, macro.category)
        end
        if macro.text and #macro.text > 0 then
            local preview = macro.text:gsub("\n", " "):sub(1, 80)
            if #macro.text > 80 then preview = preview .. "..." end
            table.insert(subParts, preview)
        end

        table.insert(choices, {
            text = macro.name or "(unnamed)",
            subText = table.concat(subParts, " | "),
            macroId = macro.id,
        })
    end

    macros.chooserObj = hs.chooser.new(function(choice)
        if not choice then return end
        local macro = getMacro(choice.macroId)
        if macro and macro.text then
            hs.timer.doAfter(0.1, function()
                pasteText(macro.text)
            end)
        end
    end)

    macros.chooserObj:choices(choices)
    macros.chooserObj:placeholderText("Search macros...")
    macros.chooserObj:show()
end

-- ============================================================
-- Webview GUI Management
-- ============================================================

local function refreshGUI()
    if not macros.webView then return end

    local jsonStr = hs.json.encode(macros.data)
    macros.webView:evaluateJavaScript(string.format("loadMacros(%s)", jsonStr))
    macros.webView:evaluateJavaScript(string.format("setAutoExpand(%s)", tostring(macros.autoExpand)))
end

local function handleMessage(msg)
    local body = msg.body
    if not body or not body.action then return end

    local action = body.action
    local data = body.data or {}

    if action == "save" then
        local result
        if data.id and data.id ~= "" then
            result = updateMacro(data.id, data)
        else
            result = addMacro(data)
        end
        if result and macros.webView then
            local resultJson = hs.json.encode(result)
            macros.webView:evaluateJavaScript(string.format("onSaveSuccess(%s)", resultJson))
        end

    elseif action == "delete" then
        if data.id then
            deleteMacro(data.id)
            if macros.webView then
                macros.webView:evaluateJavaScript(string.format("onDeleteSuccess(%q)", data.id))
            end
        end

    elseif action == "toggleAutoExpand" then
        macros.autoExpand = not macros.autoExpand
        if macros.autoExpand then
            macros.startExpander()
        else
            macros.stopExpander()
        end
        if macros.webView then
            macros.webView:evaluateJavaScript(string.format("setAutoExpand(%s)", tostring(macros.autoExpand)))
        end

    elseif action == "runMacro" then
        if data.id then
            local macro = getMacro(data.id)
            if macro and macro.text then
                hs.timer.doAfter(0.1, function()
                    pasteText(macro.text)
                end)
            end
        end

    elseif action == "close" then
        macros.hide()
    end
end

local function createWebView()
    if macros.webView then return end

    macros.userContent = hs.webview.usercontent.new("macrosHandler")
    macros.userContent:setCallback(function(msg)
        handleMessage(msg)
    end)

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local w = frame.w * config.windowWidthRatio
    local h = frame.h * config.windowHeightRatio
    local x = frame.x + (frame.w - w) / 2
    local y = frame.y + (frame.h - h) / 2

    macros.webView = hs.webview.new(
        { x = x, y = y, w = w, h = h },
        {},
        macros.userContent
    )

    macros.webView:windowTitle("Macro Manager")
    macros.webView:windowStyle({"utility", "titled", "closable"})
    macros.webView:allowGestures(true)
    macros.webView:allowNewWindows(false)
    macros.webView:closeOnEscape(true)
    macros.webView:deleteOnClose(false)
    macros.webView:level(hs.drawing.windowLevels.tornOffMenu)
end

-- ============================================================
-- Public API
-- ============================================================

function macros.show()
    createWebView()
    loadMacros()

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local w = frame.w * config.windowWidthRatio
    local h = frame.h * config.windowHeightRatio
    local x = frame.x + (frame.w - w) / 2
    local y = frame.y + (frame.h - h) / 2
    macros.webView:frame({ x = x, y = y, w = w, h = h })

    macros.webView:html(GUI_HTML)

    hs.timer.doAfter(0.2, function()
        refreshGUI()
    end)

    macros.webView:show()
end

function macros.hide()
    if macros.webView then
        macros.webView:hide()
    end
end

function macros.toggle()
    if macros.webView and macros.webView:hswindow() and macros.webView:hswindow():isVisible() then
        macros.hide()
    else
        macros.show()
    end
end

function macros.init()
    loadMacros()
    if macros.autoExpand then
        macros.startExpander()
    end
end

-- ============================================================
-- Module initialization and return
-- ============================================================
macros.init()

return macros
