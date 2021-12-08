//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoBird is ERC721Connector {
    //array to store our NFTs...
    string[] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public {
        require(
            !_kryptoBirdzExists[_kryptoBird],
            "Error -This kryptoBird already exists"
        );

        //this is deprecated
        // uint256 _id = KryptoBirdz.push(_kryptoBird);
        //.push no longer returns the length but a ref to the added element

        kryptoBirdz.push(_kryptoBird);
        uint256 _id = kryptoBirdz.length - 1;
        _mint(msg.sender, _id);

        _kryptoBirdzExists[_kryptoBird] = true;
    }

    constructor() ERC721Connector("KryptoBird", "KBIRD") {}
}
