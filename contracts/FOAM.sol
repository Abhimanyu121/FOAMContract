pragma solidity >=0.4.21 <0.7.0;

contract FOAM {
    
   // mapping(address => Details) public user_poi_mapping; //one user can add only one set of information
    enum voteStatus {NONE, UP, DOWN}
    mapping(string => mapping(address => uint))  hash_poi;
    mapping(string => Details[]) public detail_array;
    struct Details{
        string opening;
        string closing;
        uint upvotes;
        uint downvotes;
        mapping(address => voteStatus) votes;
    }
    uint detailCounter;
    function addDetails(string memory opening, string memory closing,string memory listingHash) public {
        hash_poi[listingHash][msg.sender]=  detailCounter;
        
        detail_array[listingHash].push(Details({opening:opening, closing:closing ,upvotes:0, downvotes: 0}));
        detailCounter ++;
        
    }
    function upvoteDetail(string memory listingHash, address detailProvider) public {
        uint index =hash_poi[listingHash][detailProvider];
        if(detail_array[listingHash][index].votes[msg.sender] == voteStatus.NONE){
            detail_array[listingHash][index].votes[msg.sender] = voteStatus.UP;
            detail_array[listingHash][index].upvotes++;

        }
        else if(detail_array[listingHash][index].votes[msg.sender] == voteStatus.DOWN){
            
            detail_array[listingHash][index].votes[msg.sender] = voteStatus.UP;
            detail_array[listingHash][index].downvotes--;
            detail_array[listingHash][index].upvotes++;
        }
    }
    function downvoteDetail(string memory listingHash, address detailProvider) public {
        uint index =hash_poi[listingHash][detailProvider];

        if(detail_array[listingHash][index].votes[msg.sender] == voteStatus.NONE){
            detail_array[listingHash][index].votes[msg.sender] = voteStatus.DOWN;
            detail_array[listingHash][index].downvotes++;

        }
        else if(detail_array[listingHash][index].votes[msg.sender] == voteStatus.UP){
            
            detail_array[listingHash][index].votes[msg.sender] = voteStatus.DOWN;
            detail_array[listingHash][index].upvotes--;
            detail_array[listingHash][index].downvotes++;
        }
    }
    
}