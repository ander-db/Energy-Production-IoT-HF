'use stric'

const { Contract } = require('fabric-contract-api');


class EnergyProduction extends Contract {

  async initLedger(ctx) {
    const assets = [
      {
        ID: energy1,
        Type: "renewable",
        Producer: "Renewable Org",
        State: "Stored",
        Owner: "Renewable Org"
      },
      {
        ID: energy2,
        Type: "renewable",
        Producer: "Non Renewable Org",
        State: "For sale",
        Owner: "Non Renewable Org"
      },
    ];

    for (const asset in assets) {
      asset.docType = 'asset';
      await ctx.stub.putState(asset.ID, Buffer.from(JSON.stringify(asset)));
      console.info(`Asset ${asset.ID} initialized`)
    }
  }
}

module.exports = EnergyProduction;
