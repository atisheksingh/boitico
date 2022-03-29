
const { expect } = require("chai");
const { keccak256, parseUnits } = require("ethers/lib/utils");
const { ethers } = require("hardhat");



describe("Test contract", function () {
    

    let contract;
    let owner;
    let  boit ;
    let usdc ;
    let ico ;
    let ati , nft;
    let anil

    beforeEach(async () =>{
        // Create the smart contract object to test from

        [owner, ati , anil] = await ethers.getSigners();
        //deploy usdc
        const TestContract = await ethers.getContractFactory("USDT");
        usdc = await TestContract.deploy();
        console.log(' usdc token at ',usdc.address);
        //depoly iconft 
        const test1 = await ethers.getContractFactory("contracts/nft.sol:ICONFT");
        nft =  await test1.deploy();
        console.log("nft contract ", nft.address)
        //deploy boit token 
        const testtoken = await ethers.getContractFactory("BOIT")
        boit = await testtoken.deploy();
        console.log('boit token at ',boit.address);
        //
        const test2 = await ethers.getContractFactory('ICO');
        ico = await test2.deploy(usdc.address, boit.address, owner.address, nft.address)
        console.log("ico contract at ",ico.address)
        //balance of the owner in the both usdc and boit 

        var   bal0 =  await usdc.balanceOf(owner.address)
          console.log ('balanceof  usdc of the owner',bal0.toString())
         
         var bal1=  await boit.balanceOf(owner.address)
          console.log ('balanceof boit of the owner',bal1.toString())
     
      

        console.log('deployment done ______>')

    })
        // send usdc to ati 
        it("usdc distribution", async function () {
            let amount = await usdc.totalSupply();
        await usdc.increaseAllowance(owner.address,amount.toString())
        await usdc.transferFrom (owner.address,ati.address,amount.toString())
      //  await usdc.transferFrom (owner.address,anil.address,'100000000')
       bal2 = await usdc.balanceOf(ati.address)
     //  bal3 = await usdc.balanceOf(anil.address)
      
        console.log('atis balance usdc :',bal2.toString())
    //    console.log('anil balance usdc :',bal3.toString())

        //incresing allowance of the users 

        await usdc.increaseAllowance(ati.address,"100000000" )
        await usdc.increaseAllowance(anil.address,"100000000" )
        await usdc.connect(owner).approve(ico.address,'10000000000000000000')
       
       //checking allowance to usdc
        let ap =  await usdc.allowance(owner.address,ati.address)
        console.log('ati of usdc :',ap.toString())
        let ap1 =  await usdc.allowance(owner.address,anil.address)
        console.log('anil of usdc :',ap1.toString())
            
        let ap2 =  await usdc.allowance(owner.address,ico.address)
        console.log('allowance to get usdt from ati :',ap2.toString())
console.log('distrubiton of boit =========>');
        await boit.increaseAllowance(owner.address,'200000000')
      //  await boit.transferFrom (owner.address,ati.address,'100000000')
        //await boit.transferFrom (owner.address,anil.address,'100000000')
        bal2 = await boit.balanceOf(ati.address)
        bal3 = await boit.balanceOf(anil.address)
        console.log('atis balance boit :',bal2.toString())
        console.log('anil balance boit :',bal3.toString())
          let total = await boit.totalSupply();
        await boit.transfer(ico.address,total.toString());
        bal33 = await boit.balanceOf(ico.address);
        console.log(bal33.toString());

    //set ico for nft
    await nft.setICO(ico.address);


console.log('buying with eth ========>');

        
//   await ico.connect(owner).buyWithUSDC('1');

//   bal44 = await boit.balanceOf(owner.address);
//   console.log(bal44.toString());
console.log('buying with user ===========>');

            await usdc.connect(ati).approve(ico.address,amount.toString())

            await ico.connect(ati).buyWithUSDC('1');

            bal66 = await usdc.balanceOf(ati.address);
            console.log('balance of ati :', bal66.toString());
            bal55 = await boit.balanceOf(ati.address);
            console.log('ati got boit',bal55.toString());

          let nftbal = await nft.balanceOf(ati.address);
            console.log('no of nft',nftbal.toString());


        
    });
          
        
//         let a= await usdc.allowance(owner.address ,ati.address);
//         console.log('allowance of the ati ', a.toString())
   
//         let approval = "1000000000000"
//         await boit.approve(ico.address, approval.toString());
//         await boit.transfer(ico.address,'1000000000000')

       
//         //user to contract usdc 



       
//      // console.log('allowance of ati',ap)
//     
//       bal3 = await boit.balanceOf(ico.address)
//       console.log('ico balance boit1 :',bal3.toString())
     
//       await usdc.connect(owner).approve(ati.address,"1000");
     
//      let ap1 = await boit.allowance(owner.address,ico.address);
//      console.log('allowance of ico from boit', ap1.toString())

//     //giving allowance from the user to contract for transfer of usdc
//   //  (usdc).allowance(msg.sender,address(this))
//     let amount = 1000000
//     await usdc.approve(ico.address,amount.toString());
//     let ap2 =  await usdc.allowance(owner.address,ico.address)
//     console.log('allowance from ati to ico :',ap2.toString())



   
//      await ico.connect(owner).buyWithUSDC('1');
//      bal3 = await boit.balanceOf(ati.address)
//      console.log('ati balance boit : ',bal3.toString());
   
    





});