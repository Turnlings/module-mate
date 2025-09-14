function ContributionGraph({ data }) {
  const colorScale = (value) => {
    if (value === 0) return "#2d2e2f";
    if (value < 30) return "#c6e48b";
    if (value < 60) return "#7bc96f";
    if (value < 120) return "#239a3b";
    return "#196127";
  };

  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(15, 1fr)", // 7 days per column
        gap: "3px",
      }}
    >
      {data.map((entry, idx) => (
        <div
          key={entry.date}
          style={{
            width: "100%",
            aspectRatio: "1 / 1",
            backgroundColor: colorScale(entry.value),
            borderRadius: "2px",
          }}
          title={`${entry.value} minutes on ${entry.date}`}
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

export default ContributionGraph