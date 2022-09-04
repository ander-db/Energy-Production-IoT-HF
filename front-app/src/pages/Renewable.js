import Header from '../components/Header.js';
import Principal from '../components/Principal.js';
import Button from '../components/Button.js';
import Information from '../components/Information.js';

import '../styles/Renewable.css';

function Renewable() {
  return (
    <>
      <Header Organization="Renewable Energy Production Organization" background="--green"/>
      <div className="content"> 
        <Principal principalTitle="Production status: " image="/renewable.jpg">
          <Button message="Toggle Production" background="--green-transparent" color="black"/>
          <Button message="Generate 1 unit" background="--green" color="white" energyIcon/>
        </Principal>
        <Information />
      </div>
    </>
  );
}

export default Renewable;
