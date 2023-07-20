// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
pragma experimental ABIEncoderV2;

import "./CorrectScore.sol";
import "./Prizes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract W3Pool is Ownable{

 

  
  uint _bolaoCount = 0;
  uint _championshipCount = 1;
 // uint matchCount = 1;


  mapping (uint => Bolao) boulos;
  mapping (uint => ActualResults) champResults;
  mapping (address => mapping(uint => matchesSet )) matchResults;

 /* function getSizeOfPoolOfBolao() public view returns (uint size){
    return  poolOfBolao.length;
  }
  */

  
  modifier onlyBowner (address bowner) {
    require(msg.sender == bowner, "You're are not the Bowner, Bye.");
    _;
  }

  
  
  function initBolaoDefault() public {
    
    iCriterion[] memory criteria  = new iCriterion[](4);       
    criteria[0] = new CorrectScore();
    criteria[1] = new CorrectWinner();
    criteria[2] = new CorrectEven();    
    criteria[3] = new CorrectBalance();    

    iPrize[] memory prizes = new iPrize[](1);
    prizes[0] = new HighestScore();

    for (uint i=0; i< criteria.length; i++){
        boulos[_bolaoCount].criteria.push(criteria[i]);
    }

    for (uint i=0; i< prizes.length; i++){
        boulos[_bolaoCount].prizes.push(prizes[i]);
    }
    boulos[_bolaoCount].bowner = msg.sender;
   
    _bolaoCount++;   
        
  }

  function setBet(Match[] memory matches, uint8 bolaoId) public returns (uint countmatches){
      //Match[] memory mymatches = matches;
      //matchesSet memory matchesSet = matchesSet(msg.sender, bolaoId, matches);
      for (uint i=0; i< matches.length; i++){
        matchResults[msg.sender][bolaoId].matchList.push(matches[i]);
    }
      return matches.length;
    }

  function setBulkResults(Match[] memory matches, uint8 champId, string memory champName) public onlyOwner returns (uint countmatches){

      //Match[] memory mymatches = matches;
      //ActualResults memory actualResults = ActualResults(champId, champName, matches);

      for (uint i=0; i< matches.length; i++){
        champResults[champId].matchList.push(matches[i]);
        champResults[champId].championshipName = champName;
      }
      return matches.length;
  }

  
  
  function createChampionship(string memory champName, uint8 qttmatches) public onlyOwner{
    
    champResults[_championshipCount].championshipName = champName;
    for (uint i=0; i< qttmatches; i++){
        Match memory m =  Match(0,address(0),0,0); //Creating empty matches to have the size of the championship
        champResults[_championshipCount].matchList.push(m);
      }
    _championshipCount++;
   
  }

  function updateSetMatchResult(uint8 champId, uint8 matchId, uint8 scoreP1, uint8 scoreP2) public onlyOwner{
    champResults[champId].matchList[matchId].scoreP1 = scoreP1;
    champResults[champId].matchList[matchId].scoreP1 = scoreP2;

  }
  
  function setMatchResultIntoChamp(Match memory amatch, uint8 champId) public onlyOwner{
        //Match memory m =  Match(matchCount, address(0),scoreP1,scoreP2);

        champResults[champId].matchList.push(amatch);
    
  }

  function createMatch(uint8 scoreP1, uint8 scoreP2) public onlyOwner view {
    
  }

  function getMyBet(uint8 bolaoId) 
  public 
  view returns (Match[] memory matches){
      return matchResults[msg.sender][bolaoId].matchList;
  }

  
  function getActualResults(uint8 champId) public view returns (Match[] memory matches){
      return champResults[champId].matchList;
  }

  function addCriterion(uint bolaoId, iCriterion ic)
  public onlyBowner(boulos[bolaoId].bowner) returns (uint newSize)
  {
    boulos[bolaoId].criteria.push(ic);
    return boulos[bolaoId].criteria.length;
  }


  function getSizeOfBolao(uint bolaoId) public onlyBowner(boulos[bolaoId].bowner) view returns (uint size){
    return boulos[bolaoId].criteria.length;
  }
  

  function getbolaoCriteria(uint bolaoId, uint criterionIndex) public onlyBowner(boulos[bolaoId].bowner) view returns (iCriterion ic){
    return boulos[bolaoId].criteria[criterionIndex];
  }

  function getBolao(uint bolaoId) public onlyBowner(boulos[bolaoId].bowner) view returns (Bolao memory bolao){
    return boulos[bolaoId];
  }

  
  function getBolaoId(uint bolaoId) public onlyBowner(boulos[bolaoId].bowner) view returns (uint rebolaoId){
    return boulos[bolaoId].idBolao;
  }

 

  function getMatchPoints(uint bolaoId,uint8 actualP1Score, uint8 actualP2Score, uint8 betP1Score, uint8 betP2Score ) public onlyBowner(boulos[bolaoId].bowner) view returns (uint8 points){
    uint8 valor =0;
    Bolao memory bolao = boulos[bolaoId];
    uint poolSize = getSizeOfBolao(bolaoId);
     for (uint i=0; i < poolSize; i++){
      if( bolao.criteria[i].isWin(actualP1Score,actualP2Score,betP1Score,betP2Score)){
        valor++;
      }
    }    
    return valor;
  }

  function getAllmatchesPoints(uint8 champId, uint8 bolaoId) public view returns (uint8 sumPoints){
    // mapping (uint => ActualResults) champResults;
    // mapping (address => mapping(uint => matchesSet )) matchResults;
    uint8 sum = 0;
    Match[] memory matchesSet_loc = getMyBet(bolaoId);
    Match[] memory actRes = getActualResults(champId);
    require (matchesSet_loc.length == actRes.length);
    for (uint i=0; i < matchesSet_loc.length;i++){
        sum = sum + getMatchPoints(bolaoId,actRes[i].scoreP1,actRes[i].scoreP2,matchesSet_loc[i].scoreP1, matchesSet_loc[i].scoreP2);
    }
    return sum;

  }
  


////////// TESTS ///////////////////

  
  iPrize highSc = new HighestScore();

  Match[] tstmatches;

  Points[] pa; 
  
  function initTestsPrize(uint participants) public{
    uint size = pa.length;
    for (uint i =size; i<participants+size;i++){
      pa.push(Points(i,address(uint160((i))),uint8(i)));
    }

  }

  function initTestsMatchSetter(uint qttmatches) public{
      for (uint i =0; i<qttmatches;i++){

        tstmatches.push(Match(i,address(uint160((i))),uint8(i),uint8(i)));
      }

  }
  function testSetBets(uint8 bolaoId) public onlyBowner(boulos[bolaoId].bowner) returns (uint countM){
     uint countmatches = setBet(tstmatches, bolaoId);
     return countmatches;
  }

  function initTestActualResult()public returns (uint countM){
    uint countmatches = setBulkResults(tstmatches, 1, "Fifa Worldcup 2022");
    return countmatches;
  }

  function e2e() public{
    initBolaoDefault();
    initTestsMatchSetter(10);
    testSetBets(0);
    initTestActualResult();
    //getBet(0);
  }    



  function testIsTop(uint8 index, uint8 topWhat) public view returns (bool top) {
    bool istop = highSc.isTop(pa,pa[index],topWhat);
    return istop;

  }
  function testWinner() public view returns (Points memory win){   
    Points memory winner = highSc.getWinners(pa);
    return winner;
  }

  
}