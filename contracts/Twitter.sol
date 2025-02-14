// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Twitter {

    uint16 TWEET_MAX_LENGTH = 280;

    address public owner;

    constructor () {
        owner = msg.sender;
    }

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint likes;
    }

    mapping ( address => Tweet[] ) public tweets;

    // create twitter event
    event TweetCreatedEvent(address author, uint256 id, string content, uint256 timestamp);

    // tweet liked event
    event TweetLikedEvent(address likedBy, address owner, uint256 id, uint256 count);

    // unlike tweet event
    event TweetUnlikedEvent(address unlikedBy, address owner, uint256 id, uint256 newLikeCount);

    modifier onlyOwner () {
        require( msg.sender == owner, "You're not the owner");
        _;
    }

    function createTweet( string memory _content) public {

        require(bytes(_content).length <= TWEET_MAX_LENGTH, "Tweet cannot be longer than $TWEET_MAX_LENGTH");

        uint256 id = tweets[msg.sender].length;

        Tweet memory tweet = Tweet({
            id: id,
            author: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(tweet);

        emit  TweetCreatedEvent(msg.sender, id, _content, block.timestamp);
    }

    function modifyTweetLength (uint16 length) public onlyOwner {
        TWEET_MAX_LENGTH = length;
    }


    function getTweet (address _owner, uint _i) public view returns (string memory) {
        return tweets[_owner][_i].content;
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");

        Tweet storage tweet = tweets[author][id];

        tweet.likes++; // increment like

        emit TweetLikedEvent(msg.sender, tweet.author, tweet.id, tweet.likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes > 0, "Tweet has no like");

        tweets[author][id].likes--; // decrement like
        emit TweetUnlikedEvent(msg.sender, author, id, tweets[author][id].likes);
    }

    function getAllTweets( address _owner ) public  view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    function getTotalLikes( address _owner, uint256 _id ) public view returns (uint){
        uint total = 0;

        Tweet storage tweet = tweets[_owner][_id];

        for (uint i=0; i<tweet.likes; i++) {
            total += 1;
        }

        return total;
    }
}