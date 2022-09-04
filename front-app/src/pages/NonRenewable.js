import Header from '../components/Header.js';
import Principal from '../components/Principal.js';
import Button from '../components/Button.js';


function NonRenewable() {
  return (
    <>
      <Header Organization="Non renewable Energy Production Organization" background="--red"/>
      <div className="content"> 
        <Principal principalTitle="Production status: " image="/nonrenewable.jpg">
          <Button message="Toggle Production" background="--red-transparent" color="black"/>
          <Button message="Generate 1 unit" background="--red" color="white" energyIcon/>
        </Principal>
      </div>
    </>
  );
}

export default NonRenewable;
