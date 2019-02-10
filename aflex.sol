pragma solidity ^0.4.25;

import "./ownable.sol";

contract aflex is Ownable {
    
event NewFlexunit(uint FlexunitId, string EICcode, uint capacity);

//In practical applications, you should first determine the address of the prosumers and DSO accounts, and then you can use these modifiers to ensure that only their accounts can be operated accordingly.
address DER1;
address DER2;
address DER3;
address DSO;

modifier Owner1() {
    require(msg.sender == DER1);
    _;
}

modifier Owner2() {
    require(msg.sender == DER2);
    _;
}

modifier Owner3() {
    require(msg.sender == DER3);
    _;
}

modifier OwnerDSO() {
    require(msg.sender == DSO);
    _;
}


struct Flexunit {
    string EICcode;//describe the location of Flexunit.
    uint capacity;
}

Flexunit[] public Flexunits;

mapping(uint => address) public FlexunittoOwner;

struct Flexoffer{
    uint16 timepoint;//We can devide one day into 96 time points and use 0~95 to mark every time point.
    uint16 scheduledPower;
    uint16 NegPower;
    uint16 PosPower;
    uint16 NegEnergy;
    uint16 PosEnergy;
    uint16 NegPrice;
    uint16 PosPrice;
}

Flexoffer[96] offers1;
Flexoffer[96] offers2;
Flexoffer[96] offers3;


struct Flexdemand{
    string kind;//Pos means positive demand, Neg means negative demand;
    uint16 timepoint;
    uint16 Power;
    uint8 duration;//1 stands for 15minutes, 2 stands for 30minutes and so on. 
}

Flexdemand realdemand;

uint totalneed = 0;//calcaulate the total required energy.1 in duration means 1/4 hours.
uint tp;// calculate the total price during the flexdemand period.
uint tp1 = 0;
uint tp2 = 0;
uint tp3 = 0;
bool check1;
bool check2;
bool check3;
uint8 theflexId = 0;
uint16 UesdTimepoint;
uint[] totalneeds;
uint8 num = 0;

function calculateNeeds() public returns(uint) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        return totalneed = realdemand.Power*realdemand.duration/4;  
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        return totalneed = realdemand.Power*realdemand.duration/4;
}

function showNeeds() public view returns(uint) {
    return(totalneed);
}

//Flexdemand[] RealFlexdemands;
//mapping (uint8 => Flexdemand) Reals;


function Register(string _EICcode, uint _capacity) external onlyOwner{
    uint id = Flexunits.push(Flexunit(_EICcode, _capacity)) -1;
    FlexunittoOwner[id] = msg.sender;
    emit NewFlexunit(id, _EICcode, _capacity);
}
/* The following remarks are the basic steps of the "Setoffers" function, because we need to upload the three prosumers separately, so use 1, 2, 3 to represent the corresponding Setoffers function.
function SetFlexoffer(uint16 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _PosPower, uint16 _NegEnergy, uint16 _PosEnergy, uint16 _NegPrice, uint16 _PosPrice)external onlyOwner {
    
    offers[_timepoint] = Flexoffer( _timepoint, _scheduledPower,  _NegPower, _PosPower, _NegEnergy, _PosEnergy, _NegPrice, _PosPrice);
}

function SetZerooffers(uint16 _timepoint) external onlyOwner{
    offers[_timepoint].timepoint = _timepoint;
}

function SetPosoffers(uint16 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external onlyOwner {
    offers[_timepoint].PosPower = _PosPower;
    offers[_timepoint].PosEnergy = _PosEnergy;
    offers[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers(uint16 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external onlyOwner {
    offers[_timepoint].scheduledPower = _scheduledPower;
    offers[_timepoint].NegPower = _NegPower;
    offers[_timepoint].NegEnergy = _NegEnergy;
    offers[_timepoint].NegPrice = _NegPrice;
}

function Show(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers[i].scheduledPower,offers[i].NegPower,offers[i].PosPower,offers[i].NegEnergy,offers[i].PosEnergy,offers[i].NegPrice,offers[i].PosPrice);
}*/

function SetFlexdemand(string _kind, uint16 _timepoint, uint16 _Power, uint8 _duration) public {
   realdemand = Flexdemand(_kind, _timepoint, _Power, _duration);
}

function SetFlexoffer1(uint16 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _PosPower, uint16 _NegEnergy, uint16 _PosEnergy, uint16 _NegPrice, uint16 _PosPrice)external Owner1 {
    
    offers1[_timepoint] = Flexoffer( _timepoint, _scheduledPower,  _NegPower, _PosPower, _NegEnergy, _PosEnergy, _NegPrice, _PosPrice);
}

function SetZerooffers1(uint16 _timepoint) external Owner1{
    offers1[_timepoint].timepoint = _timepoint;
}

function SetPosoffers1(uint16 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external Owner1 {
    offers1[_timepoint].PosPower = _PosPower;
    offers1[_timepoint].PosEnergy = _PosEnergy;
    offers1[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers1(uint16 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external Owner1 {
    offers1[_timepoint].scheduledPower = _scheduledPower;
    offers1[_timepoint].NegPower = _NegPower;
    offers1[_timepoint].NegEnergy = _NegEnergy;
    offers1[_timepoint].NegPrice = _NegPrice;
}

function SetZerooffers2(uint16 _timepoint) external Owner2{
    offers2[_timepoint].timepoint = _timepoint;
}

function SetPosoffers2(uint16 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external Owner2 {
    offers2[_timepoint].PosPower = _PosPower;
    offers2[_timepoint].PosEnergy = _PosEnergy;
    offers2[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers2(uint16 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external Owner2 {
    offers2[_timepoint].scheduledPower = _scheduledPower;
    offers2[_timepoint].NegPower = _NegPower;
    offers2[_timepoint].NegEnergy = _NegEnergy;
    offers2[_timepoint].NegPrice = _NegPrice;
}

function SetZerooffers3(uint16 _timepoint) external Owner3{
    offers3[_timepoint].timepoint = _timepoint;
}

function SetPosoffers3(uint16 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external Owner3 {
    offers3[_timepoint].PosPower = _PosPower;
    offers3[_timepoint].PosEnergy = _PosEnergy;
    offers3[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers3(uint16 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external Owner3 {
    offers3[_timepoint].scheduledPower = _scheduledPower;
    offers3[_timepoint].NegPower = _NegPower;
    offers3[_timepoint].NegEnergy = _NegEnergy;
    offers3[_timepoint].NegPrice = _NegPrice;
}

//With functions "Showoffers" we can check the uploaded offers on the blockchain.
function ShowOffers1(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers1[i].scheduledPower,offers1[i].NegPower,offers1[i].PosPower,offers1[i].NegEnergy,offers1[i].PosEnergy,offers1[i].NegPrice,offers1[i].PosPrice);
}

function ShowOffers2(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers2[i].scheduledPower,offers2[i].NegPower,offers2[i].PosPower,offers2[i].NegEnergy,offers2[i].PosEnergy,offers2[i].NegPrice,offers2[i].PosPrice);
}

function ShowOffers3(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers3[i].scheduledPower,offers3[i].NegPower,offers3[i].PosPower,offers3[i].NegEnergy,offers3[i].PosEnergy,offers3[i].NegPrice,offers3[i].PosPrice);
}

//The following functions are matching part.
function Checkoffers1() public returns (bool) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        if (realdemand.Power <= offers1[realdemand.timepoint].NegPower && totalneed <= offers1[realdemand.timepoint].NegEnergy)
            return check1=true;
        return check1=false;
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        if (realdemand.Power <= offers1[realdemand.timepoint].PosPower && totalneed <= offers1[realdemand.timepoint].PosEnergy)
            return check1=true;
        return check1=false;
}

function Checkoffers2() public returns (bool) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        if (realdemand.Power <= offers2[realdemand.timepoint].NegPower && totalneed <= offers2[realdemand.timepoint].NegEnergy)
            return check2=true;
        return check2=false;
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        if (realdemand.Power <= offers2[realdemand.timepoint].PosPower && totalneed <= offers2[realdemand.timepoint].PosEnergy)
            return check2=true;
        return check2=false;
}

function Checkoffers3() public returns (bool) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        if (realdemand.Power <= offers3[realdemand.timepoint].NegPower && totalneed <= offers3[realdemand.timepoint].NegEnergy)
            return check3=true;
        return check3=false;
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        if (realdemand.Power <= offers3[realdemand.timepoint].PosPower && totalneed <= offers3[realdemand.timepoint].PosEnergy)
            return check3=true;
        return check1=false;
}

function Totalprice1() public returns(uint) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        for (uint16 i=1;i<=realdemand.duration;i++) {
            tp1 += offers1[realdemand.timepoint+i-1].NegPrice*realdemand.Power/4;
        }
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        for (uint16 j=1;j<=realdemand.duration;j++) {
            tp1 += offers1[realdemand.timepoint+j-1].PosPrice*realdemand.Power/4;
        }    
    return tp1;
}

function Totalprice2() public returns(uint) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        for (uint16 i=1;i<=realdemand.duration;i++) {
            tp2 += offers2[realdemand.timepoint+i-1].NegPrice*realdemand.Power/4;
        }
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        for (uint16 j=1;j<=realdemand.duration;j++) {
            tp2 += offers2[realdemand.timepoint+j-1].PosPrice*realdemand.Power/4;
        }    
    return tp2;
}

function Totalprice3() public returns(uint) {
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        for (uint16 i=1;i<=realdemand.duration;i++) {
            tp3 += offers3[realdemand.timepoint+i-1].NegPrice*realdemand.Power/4;
        }
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        for (uint16 j=1;j<=realdemand.duration;j++) {
            tp3 += offers3[realdemand.timepoint+j-1].PosPrice*realdemand.Power/4;
        }    
    return tp3;
}

function FindCheapestoffer() public returns(uint8) {
    if(check1 && check2 && check3)
        if(tp1 <= tp2 && tp1 <= tp3)
            return theflexId = 1;
        if(tp2 <= tp1 && tp2 <= tp3)
            return theflexId = 2;
        if(tp3 <= tp1 && tp3 <= tp2)
            return theflexId = 3; 
    if(check1 && check2 && !check3)
        if(tp1 <= tp2)
            return theflexId = 1;
        return theflexId = 2;
    if(check1 && !check2 && check3)
        if(tp1 <= tp3)
            return theflexId = 1;
        return theflexId = 3;
    if(!check1 && check2 && check3)
        if(tp2 <= tp3)
            return theflexId = 2;
        return theflexId = 3;
    if(check1 && !check2 && !check3)
        return theflexId = 1;
    if(!check1 && check2 && !check3)
        return theflexId = 2;
    if(!check1 && !check2 && check3)
        return theflexId = 3;
    
}

function RemoveOffers() public {
    require (theflexId == 1 || theflexId == 2 || theflexId == 3 );
    if (keccak256(realdemand.kind) == keccak256('Neg'))
        if (theflexId == 1)
            for (uint16 i=1;i<=realdemand.duration;i++) {
                offers1[UesdTimepoint+i-1].NegPower = 0;
        }
        if (theflexId == 2)
            for (uint16 j=1;j<=realdemand.duration;j++) {
                offers2[UesdTimepoint+j-1].NegPower = 0;
        }
        if (theflexId == 3)
            for (uint16 k=1;k<=realdemand.duration;k++) {
                offers3[UesdTimepoint+k-1].NegPower = 0;
        }
    if (keccak256(realdemand.kind) == keccak256('Pos'))
        if (theflexId == 1)
            for (uint16 l=1;l<=realdemand.duration;l++) {
                offers1[UesdTimepoint+l-1].PosPower = 0;
        }
        if (theflexId == 2)
            for (uint16 m=1;m<=realdemand.duration;m++) {
                offers2[UesdTimepoint+m-1].PosPower = 0;
        }
        if (theflexId == 3)
            for (uint16 n=1;n<=realdemand.duration;n++) {
                offers3[UesdTimepoint+n-1].PosPower = 0;
        }        
}

function StartFlexMatching() public {
    Checkoffers1();
    Checkoffers2();
    Checkoffers3();
    Totalprice1();
    Totalprice2();
    Totalprice3();
    FindCheapestoffer();
    RemoveOffers();
}

function ShowFlexId() public view returns(uint8) {
    return theflexId;
}

}