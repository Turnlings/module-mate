import React from "react";

export default function SegmentedBar({ data = []}) {
  let previous = 0;
  const ticks = [40, 50, 60, 70];

  return (
    <div
      style={{
        position: "relative",
        width: "100%",
        height: "1rem",
        background: "var(--bg)",
        borderRadius: 10,
        overflow: "hidden",
        border: "2px solid var(--bg-half-light)",
      }}
    >
      {data && data.map((segment, i) => {
        const width = segment.value - previous;
        const left = previous;
        previous = segment.value;

        return (
          <div
            key={i}
            title={`${segment.name}:  ${Number(segment.value).toFixed(2)}%`}
            style={{
              position: "absolute",
              left: `${left}%`,
              width: `${width}%`,
              height: "100%",
              background: segment.color,
            }}
          />
        );
      })}

      {ticks.map((tick) => (
        <div
          key={tick}
          title={`${tick}%`}
          style={{
            position: "absolute",
            left: `${tick}%`,
            top: 0,
            width: "2px",
            height: "100%",
            background: "var(--bg-half-light)",
            transform: "translateX(-50%)",
          }}
        />
      ))}
    </div>
  );
}