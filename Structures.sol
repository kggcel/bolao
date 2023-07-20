// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./CorrectScore.sol";
import "./Prizes.sol";

contract Structures{
    
    

}

struct Match{
        uint matchId;
        address matchAddr;
        uint8 scoreP1;
        uint8 scoreP2;
}

struct Points{
        uint pointsId;
        address pointsAddr;
        uint8 score;
}
 struct MatchCriterion {
    string name;
    uint8 player1;
	  uint8 player2;
    bool isMatch;
  }
  
  struct Bolao{
    uint idBolao;
    address bowner;
    iCriterion[] criteria;
    iPrize[] prizes;
  }

 struct matchesSet{
   address matchSetOwner;
   uint bolaoId;
   Match[] matchList;
 }

 struct ActualResults{
    uint championshipId;
    string championshipName;
    Match[] matchList;
 }