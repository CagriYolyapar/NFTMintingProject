const { isTaggedTemplateExpression } = require('@babel/types');
const {assert} = require('chai');


const KryptoBird = artifacts.require('./KryptoBird');

//check for chai

require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird',(accounts)=> {

    let contract;
    //before tells our tests to run this first before anything else (this seems more professional instead of assigned it in first describe container)
    before( async () => { 
        contract = await KryptoBird.deployed();
    }) 

  

    //testing container - describe

    describe('deployment',async()=> {
            //test samples with writing it

            //we want to avoid for contracts otherwise we might not get them!!!
            it('deploys successfully',async()=> {
                  //  contract = await KryptoBird.deployed(); // this also works because the let variable was defined outside
                    
                    const address = contract.address;

                    //we don't want contract address to be empty
                    assert.notEqual(address,'');
                    assert.notEqual(address,null);
                    assert.notEqual(address,undefined);
                    assert.notEqual(address,0x0);
                   

            });

            it('matches the name',async()=> {
                const name = await contract.name();
                assert.equal(name,'KryptoBird');
            })

            it('has a symbol',async()=> {
                const symbol = await contract.symbol();
                assert.equal(symbol,'KBIRD');
            })
    })


    describe('minting',async() => {
        it('creates a new token',async()=> {
            const result =await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();

            //Success
            assert.equal(totalSupply,1);
            const event = result.logs[0].args;
            //tests to check the address from is 0
            assert.equal(event._from,'0x0000000000000000000000000000000000000000','from is the contract');
            assert.equal(event._to,accounts[0],'to is msg.sender');

            //Failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing',async() => {
        it('lists KyrptoBirdz',async()=> {
            //mint three new tokens
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');

            const totalSupply = await contract.totalSupply();

             //Loop through list and grab KBirdz from list

            let result = [];
            let KryptoBird;

             for(i=1;i<=totalSupply;i++){ 
                
                //be careful of array parantheses!
                KryptoBird = await contract.kryptoBirdz(i-1);
                result.push(KryptoBird);

                //assert that our new array result will equal our exptected result

              
             }

             let expected = ['https...1','https...2','https...3','https...4'];

             assert.equal(result.join(','),expected.join(','));
            
             
        })

       

    })
})