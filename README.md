# Energy-Production-IoT-HF
Hyperledger Fabric Network files to deploy a simple case study of Energy Production Origin Verification.

## Componentes
- Hyperledger Fabric Network
- Node-RED

## Actors

### Production
- Non Renewable Energy
- Renewable Energy

### Transmission
- ElectricNetwork

### Distribution
- Distributor1
- Distributor2

### Regulators
- IndependentRegulator


## Deployment steps

### Deploy Hyperledger Fabric Network

```bash
./clean.sh && ./generate && ./start.sh
```

### Node-RED NOT IMPLETED YET!!:warning::triangular_flag_on_post:

```bash
docker build -t hf-energy-iot/nodered ./node_red_data/
docker run -d -p 1880:1880 -e FLOWS=./node_red_data/flows.json --name node-red hf-energy-iot/nodered 
```
