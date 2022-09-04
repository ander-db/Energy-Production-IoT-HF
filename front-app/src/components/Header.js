import '../styles/Header.css';

function Header(props) {
  return (
    <header className="Header" style={{background: `var(${props.background})`}}> 
      <div id="header-title">
        {props.Organization} 
      </div>
    </header>
  );
}

export default Header;

