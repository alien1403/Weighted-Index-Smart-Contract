// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WeightedIndex is ERC20 {

    address public tokenA; // address of token A
    uint256 public weightA; // weight of token A
    address public tokenB; // address of token B
    uint256 public weightB; // weight of token B

    uint256 public priceA; // price for tokenA in wei
    uint256 public priceB; // price for tokenB in wei

    // Events for actions
    event Rebalanced(uint256 newWeightA, uint256 newWeightB);
    event UpdatePrice(uint256 newPriceA, uint256 newPriceB);

    /**
     * @dev Initialize two tokens with their respective addresses and weights.
     * @param _tokenA The address of token A
     * @param _weightA The weight of token A
     * @param _tokenB The address of token B
     * @param _weightB The weight of token B
     */
    constructor (address _tokenA, uint256 _weightA, address _tokenB, uint256 _weightB) ERC20("Crypto Index", "CI"){
        require(_weightA + _weightB == 100, "Must to be 100%");
        require(_tokenA != address(0) && _tokenB != address(0),"Invalid token address");
        
        tokenA = _tokenA;
        weightA = _weightA;
        tokenB = _tokenB;
        weightB = _weightB;
        
        // Initialize the prices for the tokens
        priceA = 2 ether;
        priceB = 5 ether;

        _mint(msg.sender, 100);
    }

    /**
     * @dev Set the prices for tokens.
     * @param _priceA The new price of token A
     * @param _priceB The new price of token B
     */
    function setPrice(uint256 _priceA, uint256 _priceB) public {
        require(_priceA > 0 && _priceB > 0, "Prices must be greater than 0");
        priceA = _priceA;
        priceB = _priceB;
        emit UpdatePrice(_priceA, _priceB);
    }

    /**
     * @dev Find the value of the index using the prices and the weights of the tokens
     * @return The calculated index value
     */
    function findIndex() public view returns (uint256){
        // The formula is v = (pA * wA + pB * wB) / (wA + wB)
        // Since the sum of the weights is 100, I can rewrite the formula as:
        // v = (pA * wA + pB * wB) / 100
        uint256 value = (priceA * weightA + priceB * weightB) / 100;
        return value;
    }

    /**
     * @dev Rebalance the index with the new values of the weights
     * @param _newWeightA The new weight for token A
     * @param _newWeightB The new weight for token B
     */
    function rebalance(uint256 _newWeightA, uint256 _newWeightB) public {
        require(_newWeightA + _newWeightB == 100, "Must be 100%");
        weightA = _newWeightA;
        weightB = _newWeightB;
        emit Rebalanced(_newWeightA, _newWeightB);
    }

    /**
     * @dev Mints new index tokens.
     * @param to The address to which the new tokens will be minted
     * @param amount The amount of new tokens to be minted
     */
    function mintIndexTokens(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * @dev Burns a specified amount of index tokens.
     * @param amount The amount of tokens to be burned
     */
    function burnIndexTokens(uint256 amount) public {
        require(amount >= 0 && amount <= totalSupply(), "Must be greater than 0 and lower than the total of tokens");
        _burn(msg.sender, amount);
    }
}