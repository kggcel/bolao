//SPDX-License-Identifier:  MIT
pragma solidity ^0.8.17;

interface iCriterion{
    
    function isWin(uint8 actualP1Score,uint8 actualP2Score,uint8 betP1Score,uint8 betP2Score) external pure returns (bool isIndeed);
}

contract CorrectScore is iCriterion{
    
    function isWin(uint8 actualP1Score,uint8 actualP2Score,uint8 betP1Score,uint8 betP2Score) public pure returns (bool isIndeed){
        if (actualP1Score == betP1Score && actualP2Score == betP2Score){
            return true;
        }
        return false;
    }
}

contract CorrectWinner is iCriterion{
    
    function isWin(uint8 actualP1Score,uint8 actualP2Score,uint8 betP1Score,uint8 betP2Score) public pure returns (bool isIndeed){
        int8 actualP1Wins = int8(actualP1Score) - int8(actualP2Score);
        int8 betP1Wins = int8(betP1Score) - int8(betP2Score);
        if ((actualP1Wins >0 && betP1Wins > 0) ||  (actualP1Wins <0 && betP1Wins < 0) ){
            return true;
        }
        return false;
    }
}

contract CorrectBalance is iCriterion{
    
    function isWin(uint8 actualP1Score,uint8 actualP2Score,uint8 betP1Score,uint8 betP2Score) public pure returns (bool isIndeed){
        int8 actualBalance = int8(actualP1Score) - int8(actualP2Score);
        int8 betBalance = int8(betP1Score) - int8(betP2Score);
        if (actualBalance == betBalance){
            return true;
        }
        return false;
    }
}

contract CorrectEven is iCriterion{
    
    function isWin(uint8 actualP1Score,uint8 actualP2Score,uint8 betP1Score,uint8 betP2Score) public pure returns (bool isIndeed){
        int8 actualBalance = int8(actualP1Score) - int8(actualP2Score);
        int8 betBalance = int8(betP1Score) - int8(betP2Score);
        if (actualBalance == 0  && betBalance == 0 ){
            return true;
        }
        return false;
    }
}