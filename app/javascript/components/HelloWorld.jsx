// app/javascript/components/HelloWorld.jsx
import React from "react";
import PropTypes from "prop-types";

const HelloWorld = ({ name }) => {
  return <div>Hello, {name}!</div>;
};

HelloWorld.defaultProps = {
  name: "World",
};

HelloWorld.propTypes = {
  name: PropTypes.string,
};

export default HelloWorld;