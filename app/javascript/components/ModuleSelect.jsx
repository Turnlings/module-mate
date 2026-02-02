import React, { useEffect, useMemo, useRef, useState } from "react";

// A lightweight combobox for Quicklog.
// Renders a hidden input named `module_code` so Rails receives the selected code.
export default function ModuleSelect({ data = [], pinned = [] }) {
  const normalize = (m) => ({
    id: m.id,
    code: (m.code || "").toString(),
    name: (m.name || "").toString(),
  });

  const pinnedItems = useMemo(() => (pinned || []).map(normalize), [pinned]);
  const allItems = useMemo(() => (data || []).map(normalize), [data]);

  // Derive "other" by excluding pinned (by id, fall back to code)
  const pinnedKeys = useMemo(() => {
    const set = new Set();
    pinnedItems.forEach((m) => set.add(m.id ?? m.code));
    return set;
  }, [pinnedItems]);

  const otherItems = useMemo(() => {
    return allItems.filter((m) => !pinnedKeys.has(m.id ?? m.code));
  }, [allItems, pinnedKeys]);

  const containerRef = useRef(null);
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState(null);

  const filterByQuery = (list) => {
    const q = query.trim().toLowerCase();
    if (!q) return list;
    return list.filter((m) => (
      m.code.toLowerCase().includes(q) || m.name.toLowerCase().includes(q)
    ));
  };

  const filteredPinned = useMemo(() => filterByQuery(pinnedItems), [pinnedItems, query]);
  const filteredOther = useMemo(() => filterByQuery(otherItems), [otherItems, query]);

  // Used for Enter-to-select-first behavior
  const flattenedFiltered = useMemo(() => {
    return [...filteredPinned, ...filteredOther];
  }, [filteredPinned, filteredOther]);

  useEffect(() => {
    function onDocClick(e) {
      if (!containerRef.current) return;
      if (!containerRef.current.contains(e.target)) setOpen(false);
    }
    document.addEventListener("click", onDocClick);
    return () => document.removeEventListener("click", onDocClick);
  }, []);

  const selectModule = (mod) => {
    setSelected(mod);
    setQuery(mod.code);
    setOpen(false);
  };

  // Always submit something sensible:
  // - if a module is selected, submit its code
  // - otherwise submit whatever the user typed
  const submittedCode = (selected?.code || query || "").trim();

  const renderSection = (title, items) => {
    if (!items.length) return null;

    return (
      <div className="module-select__section">
        <div className="module-select__section-title">{title}</div>
        <ul className="module-select__list">
          {items.slice(0, 20).map((m) => (
            <li
              key={m.id || m.code}
              className="module-select__item"
              onMouseDown={(e) => {
                // prevent input blur before click
                e.preventDefault();
                selectModule(m);
              }}
            >
              <span className="module-select__code">{m.code}</span>
              {m.name ? (
                <span className="module-select__name">{m.name}</span>
              ) : null}
            </li>
          ))}
        </ul>
      </div>
    );
  };

  return (
    <div ref={containerRef} className="module-select">
      <input type="hidden" name="module_code" value={submittedCode} />

      <input
        type="text"
        className="m-0"
        placeholder="Module Code"
        value={query}
        onFocus={() => setOpen(true)}
        onChange={(e) => {
          setQuery(e.target.value);
          setSelected(null);
          setOpen(true);
        }}
        onKeyDown={(e) => {
          if (e.key === "Enter") {
            // If the dropdown is open and we have a clear top match, choose it.
            // Otherwise allow the form to submit with what the user typed.
            if (open && flattenedFiltered.length > 0) {
              e.preventDefault();
              selectModule(flattenedFiltered[0]);
            }
          }
        }}
        autoComplete="off"
      />

      {open && (
        <div className="module-select__menu">
          {flattenedFiltered.length === 0 ? (
            <div className="module-select__empty">No matches</div>
          ) : (
            <div className="module-select__sections">
              {renderSection("Pinned modules", filteredPinned)}
              {renderSection("Other modules", filteredOther)}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
