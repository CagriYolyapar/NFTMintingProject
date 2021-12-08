//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Metadata.sol";
//Linear Inheritance'a dikkat et!!! ERC721Enumerable zaten ERC721'den miras alıyor...Bu yüzden ERC721'i hem de ERC721Enumerable'i miras veremeyiz!!!

import "./ERC721Enumerable.sol";

//this contract will connect all other ERC721 contracts in itself...Thus it can be inheritad by out NFT smart contracts...

contract ERC721Connector is ERC721Metadata, ERC721Enumerable {
    //whenever we deploy connector right away we want to carry the metadata info over

    constructor(string memory name, string memory symbol)
        ERC721Metadata(name, symbol)
    {}
}
