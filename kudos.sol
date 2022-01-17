pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./base64.sol";

contract Kudos is ERC721 {
    constructor() ERC721("kudos", "KDS") {

    }

    mapping (address => uint[]) allKudos;
    mapping (uint => Kudo) nfts;
    uint nextTokenId = 0;

    function giveKudos(address who, string memory what, string memory comments) public {
        Kudo memory kudo = Kudo(what, msg.sender, comments, nextTokenId);
        _mint(who, nextTokenId);
        nfts[nextTokenId] = kudo;
        allKudos[who].push(nextTokenId);
        nextTokenId = nextTokenId + 1;
    }

    function getKudosLength(address who) public view returns(uint) {
        uint[] memory allKudosForWho = allKudos[who];
        return allKudosForWho.length;
    }

    function getKudosAtIndex(address who, uint idx) public view returns(string memory, address, string memory) {
        Kudo memory kudo = nfts[allKudos[who][idx]];
        return (kudo.what, kudo.giver, kudo.comments);
    }

    function getNftInfo(uint tokenId) public view returns(string memory, address, string memory) {
        Kudo memory kudo = nfts[tokenId];
        return (kudo.what, kudo.giver, kudo.comments);
    }

    function tokenURI(uint tokenId) public view override returns(string memory) {
        Kudo memory kudo = nfts[tokenId];
        string memory kudoJson = Base64.encode(bytes(string(abi.encodePacked('{"giver":"', string(abi.encodePacked(kudo.giver)), '"}'))));
        string memory output = string(abi.encodePacked('data:application/json;base64,', kudoJson)); 
        return output;
    }
}

struct Kudo {
    string what;
    address giver;
    string comments;
    uint nextTokenId;
}
