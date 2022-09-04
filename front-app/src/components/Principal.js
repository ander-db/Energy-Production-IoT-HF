import '../styles/Principal.css';

function Principal(props) {
  return (
    <div className="principal-element Box">
      <h2 id="principal-title">{props.principalTitle} OFF</h2>
      <div id="principal-row-2">{props.children[0]}</div>
      <img id="principal-image" src={props.image} />
      {(props.row5) ? 
        <div className="principal-buttons">
          {props.children[1]}
          {props.children[2]}
        </div> : props.children[1]}

    </div>
  );
}

export default Principal;
