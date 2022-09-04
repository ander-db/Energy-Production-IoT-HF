import '../styles/Information.css';

function Information(props) {
  return (
    <div class="information-element Box">
      <h2>Energy Unit Information</h2>

      <select id="information-select-element">
        <option>EnergyUnit1</option>
        <option>EnergyUnit2</option>
        <option>EnergyUnit3</option>
      </select>

      <div className="information-display-element">
        <div className="information-display-row">
          <strong className="information-display-type">Id: </strong>
          <p className="information-display-type">EnergyUnit1</p>
        </div>
        <div className="information-display-row">
          <strong className="information-display-type">Id: </strong>
          <p className="information-display-type">EnergyUnit1</p>
        </div>
        <div className="information-display-row">
          <strong className="information-display-type">Id: </strong>
          <p className="information-display-type">EnergyUnit1</p>
        </div>
        <div className="information-display-row">
          <strong className="information-display-type">Id: </strong>
          <p className="information-display-type">EnergyUnit1</p>
        </div>
      
      </div>

    </div>
  );
}

export default Information;
