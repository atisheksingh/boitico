// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ICONFT is ERC721, ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    address public ICO;

    uint256 private _tokenIdSlot1 = 0;
    uint256 private _tokenIdSlot2 = 40;
    uint256 private _tokenIdSlot3 = 65;
    uint256 private _tokenIdSlot4 = 80;
    uint256 private _tokenIdSlot5 = 90;

    constructor() ERC721("MyToken", "MTK") {}

    function NftMint(address to, uint256 slot) public {
        require(msg.sender == ICO,"ICO_NFT: ONLY ICO CAN CALL THIS FUNCTION ");
        if (slot == 1) {
            require(_tokenIdSlot1 <= 39,"ICO_NFT1: First SLOT is full");
            uint256 tokenId = _tokenIdSlot1;
            _tokenIdSlot1 = _tokenIdSlot1.add(1);
            _safeMint(to, tokenId);
        }
        if (slot == 2) {
            require(_tokenIdSlot2 <= 64,"ICO_NFT2: Secand SLOT is full");
             uint256 tokenId = _tokenIdSlot2;
            _tokenIdSlot2 = _tokenIdSlot2.add(1) ;
            _safeMint(to, tokenId);
        }
        if (slot == 3) {
            require(_tokenIdSlot3 <= 79,"ICO_NFT3: Third SLOT is full");
             uint256 tokenId = _tokenIdSlot3;
            _tokenIdSlot3 = _tokenIdSlot3.add(1);
            _safeMint(to, tokenId);
        }
        if (slot == 4) {
            require(_tokenIdSlot4 <= 89,"ICO_NFT4: Third SLOT is full");
             uint256 tokenId = _tokenIdSlot4;
            _tokenIdSlot4 = _tokenIdSlot4.add(1);
            _safeMint(to, tokenId);
        }
        if (slot == 5) {
            require(_tokenIdSlot5 <= 99,"ICO_NFT5: Third SLOT is full");
             uint256 tokenId = _tokenIdSlot5;
            _tokenIdSlot5 = _tokenIdSlot5.add(1);
            _safeMint(to, tokenId);
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "Hello";
    }

    function setICO(address ico) public onlyOwner {
        ICO = ico;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        // if(REVEAL_TIMESTAMP <= block.timestamp){
        //     return string(abi.encodePacked(baseURI, toString(tokenId), ".json"));
        // }
        return string(abi.encodePacked(baseURI, "fuckOff.json"));
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}