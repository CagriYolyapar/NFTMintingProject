//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC721Metadata.sol";
import "./ERC165.sol";

//this contract will contain our metadata

contract ERC721Metadata is IERC721Metadata, ERC165 {
    string private _name;
    string private _symbol;

    //When you write strings in constructors remember they need to be stored in memory...They are temporarily stored in memory...Because strings are variables that have memory locations...
    constructor(string memory named, string memory symbolified) {
        _name = named;
        _symbol = symbolified;
        _registerInterface(
            bytes4(keccak256("name()") ^ keccak256("symbol(uint256)"))
        );
    }

    function name() external view override returns (string memory result) {
        result = _name;
    }

    function symbol() external view override returns (string memory result) {
        result = _symbol;
    }
}
