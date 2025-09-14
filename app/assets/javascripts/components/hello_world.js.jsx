
function HelloWorld(props) {
  return (
    <React.Fragment>
      Name: {props.name}
    </React.Fragment>
  );
}

HelloWorld.propTypes = {
  name: PropTypes.string
};


