pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // Store Images
  uint public imageCount  = 0;
  mapping(uint => Image) public images;
  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }
  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create Images
  function uploadImage(string memory _imgHash, string memory _description) public {

    // Make Sure Image Hash exists
    require(bytes(_imgHash).length > 0);

    // Make Sure Image Description exists
    require(bytes(_description).length > 0);

    // Make Sure Uploader Address exists
    require(msg.sender != address(0x0));

    // Increament Image Id
    imageCount ++;

    //Add Image to Contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

    // Triger An Event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  //Tip Images
  function tipImageOwner(uint _id) public payable {
    
    // Make Sure the id is valid
    require(_id > 0 && _id <= imageCount);

    // Fetch the Image
    Image memory _image = images[_id];
    
    // Fetch the Author
    address payable _author = _image.author;
    
    //Pay The Author by sending them ether
    address(_author).transfer(msg.value);
    
    // Increament the tip Amount
    _image.tipAmount = _image.tipAmount + msg.value;
    
    // Update the Image
    images[_id] = _image;
    
    // Trigger an Event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }


}