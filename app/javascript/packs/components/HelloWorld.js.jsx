// app/javascript/components/HelloWorld.jsx
import React from 'react';
import PropTypes from 'prop-types';

const HelloWorld = (props) => {
  return (
    <div>
      Hello, {props.name}!
    </div>
  );
};

// You can define default props here
HelloWorld.defaultProps = {
  name: 'World'
};

// It's good practice to use PropTypes for type-checking props
HelloWorld.propTypes = {
  name: PropTypes.string
};

export default HelloWorld;