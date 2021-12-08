//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";

import "./interfaces/IERC721.sol";

//This is our main ERC721 standart contract

/*
    Building out the minting function:
    We want minteds (NFTS) to
    a. NFT to point to an address
    b. keep track of the token ids
    c. keep track of token owner addresses to token ids
    d. keep track of how many tokens an owner address has
    e. create an event that emits a transfer log -- contract address, where it is being minted to, the id
    
    
     */

contract ERC721 is ERC165, IERC721 {
    //mapping in Solidity creates  a hash table of key pair values

    //Mapping from token id to the owner

    mapping(uint256 => address) private _tokenOwner;

    //Mapping from owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;

    //Mapping from token id to approved addresses

    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(address)") ^
                    keccak256("ownerOf(uint256)") ^
                    keccak256("transferFrom(address,address,uint256)")
            )
        );
    }

    //Count all NFTS assigned to owner
    //NFTs assigned to the zero address are considered invalid
    //function throws queries about the zero address
    //param _owner an address for whom to query the balance
    //return the number of NFTs owned by '_owner' , possibly zero

    function balanceOf(address _owner) public view override returns (uint256) {
        //NFTS assigned to the zero address are considered invalid!!!
        require(
            _owner != address(0),
            "Error: Owner query for nonexistent token"
        );
        return _ownedTokensCount[_owner];
    }

    //Find the owner of an NFT
    //NFTs assigned to zero address considered invalid
    //param the identifier for an NFT
    //return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "Error: Owner address is zero ");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        //setting the address of nft owner to check the mapping of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        //return truthiness the address is not zero
        return owner != address(0);
    }

    modifier restricted(address to, uint256 tokenId) {
        require(
            to != address(0) && !(_exists(tokenId)),
            "ERC721: minting to the zero address or the token was already minted"
        );
        _;
    }

    function _mint(address to, uint256 tokenId)
        internal
        virtual
        restricted(to, tokenId)
    {
        //requires that the address isn't zero
        // require(to != address(0), "ERC721: minting to the zero address");

        // //requires that the token does not already exists
        // require(!(_exists(tokenId)), "ERC721: token already minted");

        //we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;

        //keeping track of each address that is minting and adding one to the count
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    ///@notice Transfer ownership of NFT
    ///@dev Throws unless 'msg.sender' is the current owner,an authorized operator, or the approved address for this NFT. Throws if '_from' is not the current owner. Throws if '_to' is the zero address. Throws is '_tokenId' is not a valid NFT.
    ///@param _from The current owner of the NFT
    ///@param _to The new owner
    ///@param _tokenId The NFT to transfer

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "Error - ERC721 Transfer to the zero address"
        );

        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token the address does not have"
        );

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId)); //todo: it is not doing the approval it is just doing the owner!!! If you want to truly finish it go to openzeppelin library  go to token ERC721  and figure out how to write the necessary functions!!!
        _transferFrom(_from, _to, _tokenId);
    }

    //1. require that the person approving is the owner
    //2. we are approving an address to a token (tokenId)
    //3. require that we can't approve sending tokens of the owner to the owner (current caller)
    //4. update the map of the approved addresses
    function approve(address _to, uint256 _tokenId) public override {
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner, "Current caller is not the owner");
        require(_to != owner, "Error - Approval to current owner");
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(tokenId), "Error - Token does not exists");
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }
}
