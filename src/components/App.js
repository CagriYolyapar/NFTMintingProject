import React,{Component} from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
import {MDBCard,MDBCardBody,MDBCardTitle,MDBCardText,MDBCardImage,MDBBtn} from 'mdb-react-ui-kit';
import './App.css';

class App extends Component{

async componentDidMount(){
    await this.loadWeb3();
    await this.loadBlockchainData();
}



    //First up is to detect ethereum provider
async loadWeb3(){
    const provider = await detectEthereumProvider();

    //modern browsers
    //if there is provider then let's log that it's working and access the window from the doc to set Web3 to the provider

    if(provider){
        console.log("Ethereum wallet is connected");
        window.web3 =new Web3(provider);
    }
    else{
        //if there is no ethereum provider 
        console.log("No ethereum wallet detected");
    }
}

async loadBlockchainData(){
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    this.setState({account:accounts[0]});

    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId];
    if(networkData){
        //we3js library document for the requests...
        const abi = KryptoBird.abi;
        const address = networkData.address;
        const contract = new web3.eth.Contract(abi,address);
        this.setState({contract});
        //console.log(this.state.contract);
        
        //we can call the total supply of our Krypto Birdz
        const totalSupply = await contract.methods.totalSupply().call();
        this.setState({totalSupply});
        //console.log(this.state.totalSupply);

        //set an array to keep track of tokens
        for(var i = 1; i<=totalSupply;i++){
            const KryptoBird = await contract.methods.kryptoBirdz(i-1).call();
            this.setState({
                kryptoBirdz:[...this.state.kryptoBirdz,KryptoBird]
            })
        }

       // console.log(this.state.totalSupply)
    }
    else{
        window.alert('Smart contract was not deployed');
    }
    
}


mint = (kryptoBird) =>  {
   this.state.contract.methods.mint(kryptoBird).send({from:this.state.account}).once('receipt',(receipt) => {
       this.setState({
        kryptoBirdz:[...this.state.kryptoBirdz,KryptoBird]
       })
   })
}


constructor(props){
    super(props);
    this.state = {
        account:'',
        contract : null,
        totalSupply:0,
        kryptoBirdz : []

    }
}

    render() {
        return(
            <div className='container-filled'>
                {console.log(this.state.kryptoBirdz)}
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'> 
                <div  style={{color:'black'}} className='navbar-brand col-sm-3 col-md-3 mr-0'>
                   
                   Krypto Birdz NFT minting
               </div>
               

                <ul className='navbar-nav px-3'>
                    <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                        <small className='text-white'>
                            {this.state.account}
                        </small>

                    </li>
                </ul>


               </nav>

             <div className='container-fluit mt-1'>
        <div className='row'>
                <main role='main' className='col-lg-12 d-flex text-center'>
            <div className='content mr-auto ml-auto' style={{opacity:'0.8'}}>
                    <h1 style={{color:'black'}}>KryptoBirdz Minting Project</h1>


            <form onSubmit={(event)=> {
                           event.preventDefault();
                           const kryptoBird = this.kryptoBird.value;
                    this.mint(kryptoBird)
            }}>
                    <input type='text' placeholder='Add a file location' className='form-control mb-1' ref={(input)=> {this.kryptoBird = input}}/>
                    <input style={{margin:'6px'}} type='submit' value='Mint Crypto!' className='btn btn-primary'/>
             </form>




            </div>
                </main>
             </div>

             <hr/>
             <div className='row text-center'>
                {this.state.kryptoBirdz.map((kryptoBird,key)=> {
                return(<div>
                    
                            <div> 
                                
                                <MDBCard className='token img' style={{maxWidth:'22rem'}}> 
                            <MDBCardImage  src={kryptoBird} position='top' height='250rem' style={{marginLeft:'7px'}} />
                            <MDBCardBody>
                                     <MDBCardTitle> 
                                          KryptoBirdz
                                     </MDBCardTitle>

                                     <MDBCardText>
                                         Uniquely Generated NFTs from a true Cyberpunk Star Wars fan!! Each bird can be only owned by single person on the blockchain
                                     </MDBCardText>

                                     <MDBBtn href = {kryptoBird}> Download </MDBBtn>
                            </MDBCardBody>

                            </MDBCard>
                            </div>
                    </div>
                    )
                })}
             </div>
             </div>
                
            </div>
        )
    }
}

export default App;