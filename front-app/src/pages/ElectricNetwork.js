import Header from '../components/Header.js';
import Principal from '../components/Principal.js';
import Button from '../components/Button.js';

function ElectricNetwork() {
  return (
    <>
      <Header Organization="Electric Network Energy Organization" background="--blue"/>
      <div className="content"> 
        <Principal principalTitle="Transmission status: " image="/electricNetwork.png" row5>
          <Button message="Toggle Transmission" background="--blue-transparent" color="black"/>
          <Button message="Transmit 1 unit" background="--green" color="white" energyIcon/>
          <Button message="Transmit 1 unit" background="--red" color="white" energyIcon />
        </Principal>
      </div>
    </>
  );
}


export default ElectricNetwork;
