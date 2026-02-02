import React, { useEffect, useMemo, useRef, useState } from "react";

// A lightweight combobox for Quicklog.
// Renders a hidden input named `module_code` so Rails receives the selected code.
export default function ModuleSelect({ data = [] }) {
  const items = useMemo(() => {
    // Accept either an array of UniModule JSON or ActiveRecord-ish objects.
    return (data || []).map((m) => ({
      id: m.id,
      code: (m.code || "").toString(),
      name: (m.name || "").toString(),
    }));
  }, [data]);

  const containerRef = useRef(null);
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState(null);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return items;
    return items.filter((m) => (
      m.code.toLowerCase().includes(q) || m.name.toLowerCase().includes(q)
    ));
  }, [items, query]);

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
            if (open && filtered.length > 0) {
              e.preventDefault();
              selectModule(filtered[0]);
            }
          }
        }}
        autoComplete="off"
      />

      {open && (
        <div className="module-select__menu">
          {filtered.length === 0 ? (
            <div className="module-select__empty">No matches</div>
          ) : (
            <ul className="module-select__list">
              {filtered.slice(0, 20).map((m) => (
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
          )}
        </div>
      )}
    </div>
  );
}
