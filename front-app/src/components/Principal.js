import '../styles/Principal.css';

function Principal(props) {
  return (
    <div className="principal-element">
      <h2 id="principal-title">{props.principalTitle}: OFF</h2>
      <div id="principal-row-2">{props.children[0]}</div>
      <img id="principal-image" src={props.image} />
      <div id="principal-row-4">{props.children[1]}</div>
      {(props.row5) ? <div id="principal-row-5"></div> : ""}    
    </div>
  );
}

export default Principal;
