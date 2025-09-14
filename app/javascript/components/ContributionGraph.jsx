import React from "react";
import PropTypes from "prop-types";

function ContributionGraph({ data }) {
  const colorScale = (value) => {
    if (value === 0) return "var(--bg-half-light)";
    if (value < 60) return "hsl(120, 20%, 30%)";
    if (value < 120) return "hsl(120, 50%, 30%)";
    if (value < 240) return "hsl(120, 75%, 30%)";
    return "hsl(120, 100%, 30%)";
  };

  // Parse dates
  const gridData = data.map((d) => ({ ...d, dateObj: new Date(d.date) }));

  return (
    <div
      style={{
        display: "grid",
        gridTemplateRows: "repeat(7, 1fr)",
        gridAutoFlow: "column",
        gridAutoColumns: "1fr",
        maxWidth: "100%",
        gap: "3px",
      }}
    >
      {gridData.map((entry) => (
        <div
          key={entry.date}
          style={{
            aspectRatio: "1 / 1",
            backgroundColor: entry.date ? colorScale(entry.value) : "transparent",
            borderRadius: "2px",
            border: entry.exams && entry.exams.length > 0 ? "2px solid hsl(210, 2%, 25%)" : "1px solid var(--bg-half-light)",
          }}
          title={`${entry.value} minutes on ${entry.date}${entry.exams && entry.exams.length > 0 ? ` (Exams: ${entry.exams.join(", ")})` : ""}`}
        />
      ))}
    </div>
  );
}

ContributionGraph.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      date: PropTypes.string.isRequired,
      value: PropTypes.number.isRequired,
    })
  ),
};

export default ContributionGraph;
