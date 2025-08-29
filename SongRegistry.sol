// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4 <0.9.0;

contract SongRegistry {
    struct Song {
        uint256 id;
        string title;
        string ipfsHash;
        address payable artist;
        uint256 price;
    }

    uint256 nextSongId;
    mapping(uint256 => Song) public allSongs;
    mapping(uint256 => mapping(address => bool)) public hasAccess;

    event SongRegistered(uint256 indexed songId, address indexed artist, string title);
    event SongUnlocked(uint256 indexed songId, address indexed listener);

    error MissingSongTitle(string _title);
    error MissingIpfsHash(string _ipfsHash);
    error InsufficientPayment(uint256 _payment, uint256 _price);
    error SongDoesNotExist();
    error SongAlreadyUnlocked(uint256 _songId, address _listener);
    
    function registerSong(string memory _title, string memory _ipfsHash, uint256 _price) external {
        // require
        require(bytes(_title).length > 0, MissingSongTitle(_title));
        require(bytes(_ipfsHash).length > 0, MissingIpfsHash(_ipfsHash));

        // add new song to songs mapping
        allSongs[nextSongId] = Song({
            id: nextSongId,
            title: _title,
            ipfsHash: _ipfsHash,
            artist: payable(msg.sender),
            price: _price
        });

        // emit SongRegistered event
        emit SongRegistered(nextSongId, msg.sender, _title);
        nextSongId++;
    }

    function unlockSong(uint256 _songId) external payable {
        Song storage song = allSongs[_songId];
        require(song.artist != address(0), SongDoesNotExist());
        require(msg.value >= song.price, InsufficientPayment(msg.value, song.price));
        require(!hasAccess[_songId][msg.sender], SongAlreadyUnlocked(_songId, msg.sender));

        // enable access
        hasAccess[_songId][msg.sender] = true;
    
        emit SongUnlocked(_songId, msg.sender);

        // pay artist
        song.artist.transfer(msg.value);
    }

    function userHasAccess(uint256 _songId, address _user) external view returns (bool) {
        return hasAccess[_songId][_user];
    }
}