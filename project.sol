// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExamPrepTips {
    address public owner;

    struct Tip {
        uint256 id;
        string title;
        string description;
        address payable creator;
        uint256 price;
        bool purchased;
    }

    mapping(uint256 => Tip) public tips;
    uint256 public tipCount;

    event TipCreated(
        uint256 id,
        string title,
        string description,
        address creator,
        uint256 price
    );

    event TipPurchased(
        uint256 id,
        address buyer,
        uint256 price
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createTip(
        string memory _title,
        string memory _description,
        uint256 _price
    ) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_price > 0, "Price must be greater than zero");

        tipCount++;
        tips[tipCount] = Tip(
            tipCount,
            _title,
            _description,
            payable(msg.sender),
            _price,
            false
        );

        emit TipCreated(tipCount, _title, _description, msg.sender, _price);
    }

    function purchaseTip(uint256 _id) public payable {
        Tip storage tip = tips[_id];
        require(_id > 0 && _id <= tipCount, "Invalid tip ID");
        require(!tip.purchased, "Tip already purchased");
        require(msg.value == tip.price, "Incorrect payment amount");

        tip.purchased = true;
        tip.creator.transfer(msg.value);

        emit TipPurchased(_id, msg.sender, tip.price);
    }

    function getTip(uint256 _id)
        public
        view
        returns (
            uint256 id,
            string memory title,
            string memory description,
            address creator,
            uint256 price,
            bool purchased
        )
    {
        Tip storage tip = tips[_id];
        return (
            tip.id,
            tip.title,
            tip.description,
            tip.creator,
            tip.price,
            tip.purchased
        );
    }
}
