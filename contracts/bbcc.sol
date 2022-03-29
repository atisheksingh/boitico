// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SuperCarNFT is ERC721, ERC721URIStorage, Pausable, Ownable {
    using SafeMath for uint256;

    using Counters for Counters.Counter;
    bool public saleIsActive = false;
    bool public saleIsActiveForVIP = true;
    bool public saleIsActiveForPerMint = true;
    bool public saleIsActiveWhiteList = false;
    Counters.Counter private _tokenOwners;

    mapping(address => bool) public whiteListPreMint;
    mapping(address => uint256) public whiteListPreMintLimit;
    bool public whiteListPreMintable = true;
    uint256 public preMintSlot = 30;

    mapping(address => bool) public whiteListVIPMint;
    mapping(address => uint256) public whiteListVIPMintLimit;
    bool public whiteListVIPMintable = true;
    uint256 public VIPMintSlot = 20;

    mapping(address => bool) public normalWhiteListing;
    mapping(address => uint256) public normalWhiteListingLimit;
    bool public normalWhiteListMintable = false;
    uint256 public normalWhiteSlot = 1200;

    uint256 public giveAwaySlot = 200;

    uint256 public constant superCarPrice = 100000000000000000; //0.1 ETH
    uint256 public constant maxSuperCarPurchase = 10;
    uint256 public MAX_SUPER_CARS;
    // uint256 public totalSupply() = 0;
    uint256 public REVEAL_TIMESTAMP;
    uint256 public startingIndexBlock;

    constructor(uint256 maxNftSupply,uint256 time,address dev,address artist) ERC721("Big Block Car Club", "BBCC") {
        MAX_SUPER_CARS = maxNftSupply;
        REVEAL_TIMESTAMP = time;
        /**
        Dev and Artist 400 each
         */
        for (uint256 i = 0; i < 400; i++) {
            uint256 mintIndex = _tokenOwners.current();
            if (totalSupply() < MAX_SUPER_CARS) {
                _safeMint(dev, mintIndex);
                _tokenOwners.increment();
            }
        }
        for (uint256 i = 0; i < 400; i++) {
            uint256 mintIndex = _tokenOwners.current();
            if (totalSupply() < MAX_SUPER_CARS) {
                _safeMint(artist, mintIndex);
                _tokenOwners.increment();
            }
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://gateway.pinata.cloud/ipfs/QmTEgSEAT1T5qa6aCS7yBFq2ZX3WYmQC7Pd1s6cT6jUnpP/";
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenOwners.current();
        _tokenOwners.increment();
        _safeMint(to, tokenId);
    }

    function giveAway(
        address[] memory to,
        uint256[] memory numberOfTokens,
        uint104 n
    ) public onlyOwner {
        require(giveAwaySlot > 0, "GiveAway: 0 Slot is remaning");
        for (uint32 i = 0; i < n; i++) {
            for (uint32 j = 0; j < numberOfTokens[i]; j++) {
                uint256 tokenId = _tokenOwners.current();
                _tokenOwners.increment();
                _safeMint(to[i], tokenId);
            }
            giveAwaySlot.sub(1);
        }
    }

    function setGiveAwaySlot(uint32 totalSlot) public onlyOwner {
        giveAwaySlot = totalSlot;
    }

    function setnormalWhiteSlot(uint32 totalSlot) public onlyOwner {
        normalWhiteSlot = totalSlot;
    }

    function setVIPMintSlot(uint32 totalSlot) public onlyOwner {
        VIPMintSlot = totalSlot;
    }

    function setpreMintSlot(uint32 totalSlot) public onlyOwner {
        preMintSlot = totalSlot;
    }

    function SetREVEAL_TIMESTAMP(uint256 time) public onlyOwner{
        REVEAL_TIMESTAMP = time;
    }
    /*
     * Pause sale if active, make active if paused
     */
    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function flipSaleStateForWhitelist() public onlyOwner {
        saleIsActiveWhiteList = !saleIsActiveWhiteList;
    }

    function flipSaleStateForPerMint() public onlyOwner {
        saleIsActiveForPerMint = !saleIsActiveForPerMint;
    }

    function flipSaleStateForVIP() public onlyOwner {
        saleIsActiveForVIP = !saleIsActiveForVIP;
    }

    /**
     * Mints Bored Apes
     */
    function mintSuperCar(uint256 numberOfTokens) public payable {
        require(
            totalSupply().add(numberOfTokens) <= MAX_SUPER_CARS,
            "Purchase would exceed max supply of Supercar"
        );

        if (normalWhiteListing[msg.sender]) {
            require(
                saleIsActiveWhiteList,
                "Whitelisting Sale must be active to mint the NFT"
            );
            require(
                numberOfTokens <= maxSuperCarPurchase,
                "Can only mint 10 tokens at a time"
            );
            require(
                superCarPrice.mul(numberOfTokens) <= msg.value,
                "Ether value sent is not correct"
            );
            for (uint256 i = 0; i < numberOfTokens; i++) {
                uint256 mintIndex = _tokenOwners.current();
                if (totalSupply() < MAX_SUPER_CARS) {
                    _safeMint(msg.sender, mintIndex);
                    _tokenOwners.increment();
                }
            }
            normalWhiteListingLimit[msg.sender].sub(numberOfTokens);
            if (normalWhiteListingLimit[msg.sender] == 0) {
                normalWhiteListing[msg.sender] = false;
            }
            normalWhiteListingLimit[msg.sender].sub(1);
        }
        /**
        normal user minting
         */
        if (!whiteListVIPMint[msg.sender] && !whiteListPreMint[msg.sender]) {
            require(saleIsActive, "Sale must be active to mint the NFT");
            require(
                numberOfTokens <= maxSuperCarPurchase,
                "Can only mint 10 tokens at a time"
            );
            require(
                superCarPrice.mul(numberOfTokens) <= msg.value,
                "Ether value sent is not correct"
            );
            for (uint256 i = 0; i < numberOfTokens; i++) {
                uint256 mintIndex = _tokenOwners.current();
                if (totalSupply() < MAX_SUPER_CARS) {
                    _safeMint(msg.sender, mintIndex);
                    _tokenOwners.increment();
                }
            }
        } else {
            if (whiteListPreMint[msg.sender]) {
                uint256 discountPrice = 50000000000000000;
                require(
                    saleIsActiveForPerMint,
                    "Per-Mint Sale must be active to mint the NFT"
                );
                require(
                    numberOfTokens <= whiteListPreMintLimit[msg.sender],
                    "You have exceeded your whitelist limit"
                );
                require(
                    discountPrice.mul(numberOfTokens) <= msg.value,
                    "Ether value sent is not correct"
                );
                require(preMintSlot > 0, "PER_MINTER: 0 Slot is remaning");
                for (
                    uint256 i = 0;
                    i < whiteListPreMintLimit[msg.sender];
                    i++
                ) {
                    uint256 mintIndex = _tokenOwners.current();
                    if (totalSupply() < MAX_SUPER_CARS) {
                        _safeMint(msg.sender, mintIndex);
                        _tokenOwners.increment();
                    }
                }
                whiteListPreMintLimit[msg.sender].sub(numberOfTokens);
                if (whiteListPreMintLimit[msg.sender] == 0) {
                    whiteListPreMint[msg.sender] = false;
                }
                preMintSlot.sub(1);
            }
            if (whiteListVIPMint[msg.sender]) {
                uint256 discountPrice = 60000000000000000;
                require(
                    saleIsActiveForVIP,
                    "VIP Sale must be active to mint the NFT"
                );
                require(
                    numberOfTokens <= whiteListVIPMintLimit[msg.sender],
                    "You have exceeded your whitelist limit"
                );
                require(
                    discountPrice.mul(numberOfTokens) <= msg.value,
                    "Ether value sent is not correct"
                );
                require(VIPMintSlot > 0, "VIP_MINTER: 0 Slot is remaning");
                for (
                    uint256 i = 0;
                    i < whiteListVIPMintLimit[msg.sender];
                    i++
                ) {
                    uint256 mintIndex = _tokenOwners.current();
                    if (totalSupply() < MAX_SUPER_CARS) {
                        _safeMint(msg.sender, mintIndex);
                        _tokenOwners.increment();
                    }
                }
                whiteListVIPMintLimit[msg.sender].sub(numberOfTokens);
                if (whiteListVIPMintLimit[msg.sender] == 0) {
                    whiteListVIPMint[msg.sender] = false;
                }
                VIPMintSlot.sub(1);
            }
        }

        // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
        // the end of pre-sale, set the starting index block
        if (
            startingIndexBlock == 0 &&
            (totalSupply() == MAX_SUPER_CARS ||
                block.timestamp >= REVEAL_TIMESTAMP)
        ) {
            startingIndexBlock = block.number;
        }
    }

    function totalSupply() public view returns (uint256) {
        return _tokenOwners.current();
    }

    function addWhiteListVIPMint(
        address[] memory user,
        uint256[] memory num,
        uint32 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            whiteListVIPMint[user[i]] = true;
            whiteListVIPMintLimit[user[i]] = num[i];
        }
    }

    function addnormalWhiteListing(
        address[] memory user,
        uint256[] memory num,
        uint32 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            normalWhiteListing[user[i]] = true;
            normalWhiteListingLimit[user[i]] = num[i];
        }
    }

    function addwhiteListPreMint(
        address[] memory user,
        uint256[] memory num,
        uint32 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            whiteListPreMint[user[i]] = true;
            whiteListPreMintLimit[user[i]] = num[i];
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
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
        if (REVEAL_TIMESTAMP <= block.timestamp) {
            return
                string(abi.encodePacked(baseURI, toString(tokenId), ".json"));
        }
        return string(abi.encodePacked(baseURI, "Test.json"));
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
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