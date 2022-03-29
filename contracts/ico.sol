// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/ICO_interface.sol";

contract USDT is ERC20{
    constructor() ERC20("usdc","usdc"){
        _mint(msg.sender,(10000000000000000000000 * (10 ** 6)));
    }

    function mint(uint256 token) public {
        _mint(msg.sender,(token * (10 ** 6)));
    }
}

contract BOIT is ERC20{
    constructor() ERC20("BOIT","BOIT"){
        _mint(msg.sender,(10000000000000000000000 * (10 ** 18)));
    }

    function mint(uint256 token) public {
        _mint(msg.sender,(token * (10 ** 18)));
        
    }
}


contract ICO is Ownable{
    IERC20 public usdc;
    IERC20 public toib;
    ICONFT public NFT;
    address payable public ownersAddress;
    mapping(uint256 => uint256) public slotId; // to be as public
    mapping(uint256 => uint256) public slotPriceInUSDC; // to be as public
    mapping(uint256 => uint256) public slotPriceInETH; // to be as public


    constructor(IERC20 _usdc, IERC20 _toib, address payable _ownersAddress,ICONFT nft){
        NFT = nft;
        usdc = _usdc;
        toib = _toib;
        ownersAddress = _ownersAddress;
        slotId[1] = 40;
        slotId[2] = 25; 
        slotId[3] = 15;
        slotId[4] = 10;
        slotId[5] = 10;
        slotPriceInUSDC[1] = 10 * (10 ** 18);
        slotPriceInUSDC[2] = 10 * (10 ** 18);
        slotPriceInUSDC[3] = 10 * (10 ** 18);
        slotPriceInUSDC[4] = 10 * (10 ** 18);
        slotPriceInUSDC[5] = 10 * (10 ** 18);
        slotPriceInETH[1] = 10000;
        slotPriceInETH[2] = 10000;
        slotPriceInETH[3] = 10000;
        slotPriceInETH[4] = 10000;
        slotPriceInETH[5] = 10000;
    }

    receive() external payable {}

    function buyWithUSDC(uint256 _slotId) public {
        require(slotId[_slotId] > 0,"No more slot are available");
        require(_slotId > 0 && _slotId < 6,"Invalid slot");
        if(_slotId == 1){
            require(IERC20(usdc).allowance(msg.sender,address(this)) >= slotPriceInUSDC[1],"ICO1: Need more allowance");
            IERC20(usdc).transferFrom(msg.sender,ownersAddress,10);
            IERC20(toib).transfer(msg.sender,(50000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 2){ 
            require(IERC20(usdc).allowance(msg.sender,address(this)) >= slotPriceInUSDC[2],"ICO2: Need more allowance");
            IERC20(usdc).transferFrom(msg.sender,ownersAddress,20);
            IERC20(toib).transfer(msg.sender,(120000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 3){ 
            require(IERC20(usdc).allowance(msg.sender,address(this)) > slotPriceInUSDC[3],"ICO3: Need more allowance");
            IERC20(usdc).transferFrom(msg.sender,ownersAddress,30);
            IERC20(toib).transfer(msg.sender,(200000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 4){ 
            require(IERC20(usdc).allowance(msg.sender,address(this)) > slotPriceInUSDC[4],"ICO4: Need more allowance");
            IERC20(usdc).transferFrom(msg.sender,ownersAddress,40);
            IERC20(toib).transfer(msg.sender,(300000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 5){ 
            require(IERC20(usdc).allowance(msg.sender,address(this)) > slotPriceInUSDC[5],"ICO5: Need more allowance");
            IERC20(usdc).transferFrom(msg.sender,ownersAddress,50);
            IERC20(toib).transfer(msg.sender,(900000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        slotId[_slotId]--;
    } 

    function buyWithETH(uint256 _slotId) public payable{
        require(slotId[_slotId] > 0,"No more slot are available");
        require(_slotId > 0 && _slotId < 6,"Invalid slot");
        if(_slotId == 1){
            require(msg.value >= slotPriceInETH[1],"ICOETH: Need more allowance");
            IERC20(toib).transfer(msg.sender,(50000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 2){ 
             require(msg.value >= slotPriceInETH[2],"ICOETH: Need more allowance");
            IERC20(toib).transfer(msg.sender,(120000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 3){ 
             require(msg.value >= slotPriceInETH[3],"ICOETH: Need more allowance");
            IERC20(toib).transfer(msg.sender,(200000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 4){ 
             require(msg.value >= slotPriceInETH[4],"ICOETH: Need more allowance");
            IERC20(toib).transfer(msg.sender,(300000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        if(_slotId == 5){ 
            require(msg.value >= slotPriceInETH[5],"ICOETH: Need more allowance");
            IERC20(toib).transfer(msg.sender,(900000 * (10 ** 18)));
            ICONFT(NFT).NftMint(msg.sender,_slotId);
        }
        slotId[_slotId]--;
    } 

    function setslotPriceInUSDC( uint256[] memory price) public onlyOwner{
        slotPriceInUSDC[1] = price[0];
        slotPriceInUSDC[2] = price[1];
        slotPriceInUSDC[3] = price[2];
        slotPriceInUSDC[4] = price[3];
        slotPriceInUSDC[5] = price[4];
    }

    function setslotPriceInETH( uint256[] memory price) public onlyOwner{
        slotPriceInETH[1] = price[0];
        slotPriceInETH[2] = price[1];
        slotPriceInETH[3] = price[2];
        slotPriceInETH[4] = price[3];
        slotPriceInETH[5] = price[4];
    }

    function withdrawBOIT() public onlyOwner {
        uint256 balanceAmount = IERC20(toib).balanceOf(address(this));
        IERC20(toib).transfer(msg.sender,balanceAmount);
    }

    function withdrawETH() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}