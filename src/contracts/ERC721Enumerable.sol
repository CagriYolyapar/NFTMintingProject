//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {
    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply()") ^
                    keccak256("tokenByIndex(uint256)") ^
                    keccak256("tokenOfOwnerByIndex(address,uint256)")
            )
        );
    }

    uint256[] private _allTokens;

    //mapping from tokenId to positions in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from tokens Id  to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        //super is going to allow us to to reach for our ERC721 (for reaching the original function)
        super._mint(to, tokenId);

        // 1. add tokens to the owner
        // 2. add tokens to our totalSupply => to _allTokens
        _addTokensToAllEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    //add tokens to the _allTokens array and set the position of the tokens indexes
    function _addTokensToAllEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        //1.Add address and tokenId to the _ownedTokens
        //2.ownedTokensIndex tokenId set to address of ownedTokens position
        //3.we want to execute this function with minting
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    //two functions - one that returns token by the index and another one that returns tokenOfOwnerByIndex

    function tokenByIndex(uint256 index)
        public
        view
        override
        returns (uint256)
    {
        //make sure that the index is not out of bounds of the total supply
        require(index < totalSupply(), "Global index is out of bounds!");
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        override
        returns (uint256)
    {
        require(index < balanceOf(owner), "Owner index is out of bounds!");
        return _ownedTokens[owner][index];
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address

    //return the total supply of the _allTokens array
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
}
