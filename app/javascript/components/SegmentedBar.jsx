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
      }}
    >
      {data && data.map((segment, i) => {
        const width = segment.value - previous;
        const left = previous;
        previous = segment.value;

        return (
          <div
            key={i}
            title={`${segment.name}: ${segment.value}%`}
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
            width: 2,
            height: "100%",
            background: "var(--bg-dark)",
            transform: "translateX(-50%)",
          }}
        />
      ))}
    </div>
  );
}