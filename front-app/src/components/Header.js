import '../styles/Header.css';

function Header(props) {
  return (
    <header className="Header" style={{background: `var(${props.background})`}}> 
      <div className="content">
        {props.Organization} 
      </div>
    </header>
  );
}

export default Header;

