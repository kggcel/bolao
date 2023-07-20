// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Structures.sol";
interface iPrize{

    function getWinners(Points[] calldata points) external view returns (Points memory top);

    function isTop(Points[] calldata points, Points calldata pointsToAssess, uint8 topQuant) external view returns (bool top);


}

contract HighestScore is iPrize{
    function getWinners( Points[] calldata points) public pure returns (Points memory top){
        
        Points memory largest = Points(0,address(0),0); 
        for(uint i = 0; i < points.length; i++){
            if(points[i].score > largest.score) {
                largest = points[i]; 
            } 
        }   
        
        return largest;
    }

    function isTop(Points[] calldata points, Points calldata pointsToAssess, uint8 topQuant) public pure  returns (bool top){
        
        uint i = points.length-1;
        uint8 attempts = 0;
        while ((i > 0 )&& (attempts < topQuant)){
            if((points[i].score > pointsToAssess.score)) {
                attempts++;
            } 
            i--;
        }
        if (attempts < topQuant){
            return true;
        }
        return false;
    }

}
