pragma solidity >=0.4.21 <0.7.0;

contract FOAM {
    
   // mapping(address => Details) public user_poi_mapping; //one user can add only one set of information
// mapping(address => Details) public user_poi_mapping; //one user can add only one set of information
    enum voteStatus {NONE, UP, DOWN}
    mapping(string => mapping(address => uint))  hash_poi;
    mapping(string => Details[]) public detail_array;
    mapping(string => uint) public listing_detail_counter;
    struct Details{
        uint8 opening_min;
        uint8 opening_hour;
        uint8 closing_min;
        uint8 closing_hour;
        uint upvotes;
        uint downvotes;
        mapping(address => voteStatus) votes;
    }

    function addDetails(uint8  opening_min,uint8  opening_hour, uint8  closing_min,uint8  closing_hour,string memory listingHash) public {
        uint counter =listing_detail_counter[listingHash];
        hash_poi[listingHash][msg.sender]= counter;
        
        detail_array[listingHash].push(Details({opening_min:opening_min,opening_hour:opening_hour,closing_min:closing_min, closing_hour:closing_hour ,upvotes:0, downvotes: 0}));
        listing_detail_counter[listingHash] = counter +1;
        
    }
    function getDetaild(string memory hash) public view returns(uint8[] memory , uint8[] memory  ,uint8[] memory ,uint8[] memory, uint[]memory , uint[]memory ){
        // opening = detail_array[hash][index].opening;
        // closing = detail_array[hash][index].closing;
        // upvotes = detail_array[hash][index].upvotes;
        // downvotes = detail_array[hash][index].downvotes;
        uint8[] memory arromin = new uint8[](detail_array[hash].length);
        uint8[] memory arrohour = new uint8[](detail_array[hash].length);
        uint8[] memory arrcmin = new uint8[](detail_array[hash].length);
        uint8[] memory arrchour = new uint8[](detail_array[hash].length);
        uint[] memory upvotes = new uint[](detail_array[hash].length);
        uint[] memory downvotes = new uint[](detail_array[hash].length);

        for(uint i;i<detail_array[hash].length;i++){
            arromin[i]=detail_array[hash][i].opening_min;
            arrohour[i]=detail_array[hash][i].opening_hour;
            arrchour[i]=detail_array[hash][i].closing_hour;
            arrcmin[i]=detail_array[hash][i].closing_min;
            upvotes[i]=detail_array[hash][i].upvotes;
            downvotes[i]=detail_array[hash][i].downvotes;
        }
        return(arrohour,arromin,arrcmin,arrchour,upvotes, downvotes);
        
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
