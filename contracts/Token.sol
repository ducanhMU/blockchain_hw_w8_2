//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Token {
    string public name = "My Hardhat Token";
    string public symbol = "MHT";
    uint256 public totalSupply = 1000000;
    address public owner;
    
    // Thêm biến phí giao dịch
    uint256 public feePercent = 10; // 1% mặc định (10 = 1%, 1 = 0.1%)
    uint256 public totalFeesCollected;
    
    mapping(address => uint256) balances;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event FeeCharged(address indexed _from, address indexed _to, uint256 _amount, uint256 _fee);
    event FeeChanged(uint256 _oldFee, uint256 _newFee);

    constructor() {
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    // Thêm modifier chỉ cho phép owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");
        
        uint256 fee = (amount * feePercent) / 1000;
        uint256 amountAfterFee = amount - fee;
        
        // Sửa lại console.log để chỉ hiển thị thông tin cơ bản
        console.log("Transferring tokens with fee:", fee);
        
        balances[msg.sender] -= amount;
        balances[to] += amountAfterFee;
        balances[owner] += fee;
        totalFeesCollected += fee;

        emit Transfer(msg.sender, to, amountAfterFee);
        emit Transfer(msg.sender, owner, fee);
        emit FeeCharged(msg.sender, to, amount, fee);
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
    
    // Hàm thay đổi tỷ lệ phí (chỉ owner)
    function setFeePercent(uint256 newFeePercent) external onlyOwner {
        require(newFeePercent <= 100, "Fee cannot exceed 10%"); // Giới hạn phí tối đa 10%
        
        emit FeeChanged(feePercent, newFeePercent);
        feePercent = newFeePercent;
    }
    
    // Hàm xem tổng phí đã thu
    function getTotalFees() external view returns (uint256) {
        return totalFeesCollected;
    }
    
    // Hàm rút phí (chỉ owner)
    function withdrawFees() external onlyOwner {
        uint256 fees = balances[owner];
        balances[owner] = 0;
        balances[msg.sender] += fees; // Chuyển toàn bộ phí cho người gọi (owner)
        totalFeesCollected = 0;
        
        emit Transfer(owner, msg.sender, fees);
    }
}
