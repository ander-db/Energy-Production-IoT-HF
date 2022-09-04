import '../styles/Button.css'

function Button(props) {
  return (
      <button  
        className="buttonElement" 
        style={{background: `var(${props.background})`, color:`${props.color}`}}>
        
        {(props.energyIcon) ? <img class="icon" src="Battery-white.svg" /> : ""}

        {props.message}
      </button>
  );
}

export default Button;
