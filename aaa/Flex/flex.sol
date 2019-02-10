pragma solidity ^0.4.25;

import "./ownable.sol";

contract flex is Ownable {
    
event NewFlexunit(uint FlexunitId, string EICcode, uint capacity);


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
    uint8 timepoint;//We can devide one day into 96 time points and use 0~95 to mark every time point.
    uint16 scheduledPower;
    uint16 NegPower;
    uint16 PosPower;
    uint16 NegEnergy;
    uint16 PosEnergy;
    uint16 NegPrice;
    uint16 PosPrice;
}

struct Flexdemand{
    string kind;//Pos means positive demand,Neg means negative demands;
    uint8 timepoint;
    uint16 Power;
    uint8 duration;//1 stands for 15minutes, 2 stands for 30 minutes and so on. 
}

Flexdemand[] Flexdemands;



/*uint totalneed = realdemand.NegPower*realdemand.duration/4;
uint tp;// calculate the total price during the flexdemand period.
bool check1;
bool check2;
bool check3;
uint8 theflexId;
uint8 UesdTimepoint;*/
uint[] totalneeds;


function calculateNeeds() public {
    for (uint8 m=0;m<Flexdemands.length;m++){
        totalneeds[m] =Flexdemands[m].Power*Flexdemands[m].duration/4;//calcaulate the total required energy.1 in duration means 1/4 hours.
    }    
}

Flexoffer[96] offers1;
Flexoffer[96] offers2;
Flexoffer[96] offers3;


function Register(string _EICcode, uint _capacity) external onlyOwner{
    uint id = Flexunits.push(Flexunit(_EICcode, _capacity)) -1;
    FlexunittoOwner[id] = msg.sender;
    emit NewFlexunit(id, _EICcode, _capacity);
}

/*
function SetFlexoffer(uint8 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _PosPower, uint16 _NegEnergy, uint16 _PosEnergy, uint16 _NegPrice, uint16 _PosPrice)external onlyOwner {
    
    offers[_timepoint] = Flexoffer( _timepoint, _scheduledPower,  _NegPower, _PosPower, _NegEnergy, _PosEnergy, _NegPrice, _PosPrice);
}

function SetZerooffers(uint8 _timepoint) external onlyOwner{
    offers[_timepoint].timepoint = _timepoint;
}

function SetPosoffers(uint8 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external onlyOwner {
    offers[_timepoint].PosPower = _PosPower;
    offers[_timepoint].PosEnergy = _PosEnergy;
    offers[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers(uint8 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external onlyOwner {
    offers[_timepoint].scheduledPower = _scheduledPower;
    offers[_timepoint].NegPower = _NegPower;
    offers[_timepoint].NegEnergy = _NegEnergy;
    offers[_timepoint].NegPrice = _NegPrice;
}

function Show(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers1[i].scheduledPower,offers1[i].NegPower,offers1[i].PosPower,offers1[i].NegEnergy,offers1[i].PosEnergy,offers1[i].NegPrice,offers1[i].PosPrice);
}*/


function Setflexdemands(string _kind, uint8 _timepoint, uint16 _NegPower, uint8 _duration) external OwnerDSO  {
    Flexdemands.push(Flexdemand(_kind, _timepoint, _NegPower, _duration));
}

function Showdemands() public view returns(uint){
    return (Flexdemands.length);
}


function SetFlexoffer1(uint8 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _PosPower, uint16 _NegEnergy, uint16 _PosEnergy, uint16 _NegPrice, uint16 _PosPrice)external onlyOwner {
    
    offers1[_timepoint] = Flexoffer( _timepoint, _scheduledPower,  _NegPower, _PosPower, _NegEnergy, _PosEnergy, _NegPrice, _PosPrice);
}

function SetZerooffers1(uint8 _timepoint) external Owner1{
    offers1[_timepoint].timepoint = _timepoint;
}

function SetPosoffers1(uint8 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external Owner1 {
    offers1[_timepoint].PosPower = _PosPower;
    offers1[_timepoint].PosEnergy = _PosEnergy;
    offers1[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers1(uint8 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external Owner1 {
    offers1[_timepoint].scheduledPower = _scheduledPower;
    offers1[_timepoint].NegPower = _NegPower;
    offers1[_timepoint].NegEnergy = _NegEnergy;
    offers1[_timepoint].NegPrice = _NegPrice;
}

function SetZerooffers2(uint8 _timepoint) external Owner2{
    offers2[_timepoint].timepoint = _timepoint;
}

function SetPosoffers2(uint8 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external Owner2 {
    offers2[_timepoint].PosPower = _PosPower;
    offers2[_timepoint].PosEnergy = _PosEnergy;
    offers2[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers2(uint8 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external Owner2 {
    offers2[_timepoint].scheduledPower = _scheduledPower;
    offers2[_timepoint].NegPower = _NegPower;
    offers2[_timepoint].NegEnergy = _NegEnergy;
    offers2[_timepoint].NegPrice = _NegPrice;
}

function SetZerooffers3(uint8 _timepoint) external Owner3{
    offers3[_timepoint].timepoint = _timepoint;
}

function SetPosoffers3(uint8 _timepoint, uint16 _PosPower, uint16 _PosEnergy, uint16 _PosPrice) external Owner3 {
    offers3[_timepoint].PosPower = _PosPower;
    offers3[_timepoint].PosEnergy = _PosEnergy;
    offers3[_timepoint].PosPrice = _PosPrice;
    
}

function SetNegoffers3(uint8 _timepoint, uint16 _scheduledPower, uint16 _NegPower, uint16 _NegEnergy, uint16 _NegPrice) external Owner3 {
    offers3[_timepoint].scheduledPower = _scheduledPower;
    offers3[_timepoint].NegPower = _NegPower;
    offers3[_timepoint].NegEnergy = _NegEnergy;
    offers3[_timepoint].NegPrice = _NegPrice;
}

function ShowOffers1(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers1[i].scheduledPower,offers1[i].NegPower,offers1[i].PosPower,offers1[i].NegEnergy,offers1[i].PosEnergy,offers1[i].NegPrice,offers1[i].PosPrice);
}

function ShowOffers2(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers2[i].scheduledPower,offers2[i].NegPower,offers2[i].PosPower,offers2[i].NegEnergy,offers2[i].PosEnergy,offers2[i].NegPrice,offers2[i].PosPrice);
}

function ShowOffers3(uint16 i) public view returns(uint16,uint16,uint16,uint16,uint16,uint16,uint16){
    return(offers3[i].scheduledPower,offers3[i].NegPower,offers3[i].PosPower,offers3[i].NegEnergy,offers3[i].PosEnergy,offers3[i].NegPrice,offers3[i].PosPrice);
}

bool[] check1s; 
bool[] check2s;
bool[] check3s;

function Checkoffers1() public {
    for (uint8 p=0;p<Flexdemands.length;p++) {
    if (keccak256(Flexdemands[p].kind) == keccak256('Neg'))
        if (Flexdemands[p].Power <= offers1[Flexdemands[p].timepoint].NegPower && totalneeds[p] <= offers1[Flexdemands[p].timepoint].NegEnergy )
            check1s[p]=true;
        check1s[p]=false;
    if (keccak256(Flexdemands[p].kind) == keccak256('Pos'))
        if (Flexdemands[p].Power <= offers1[Flexdemands[p].timepoint].PosPower && totalneeds[p] <= offers1[Flexdemands[p].timepoint].PosEnergy )
            check1s[p]=true;
        check1s[p]=false;
    }
}

function Checkoffers2() public {
    for (uint8 p=0;p<Flexdemands.length;p++) {
    if (keccak256(Flexdemands[p].kind) == keccak256('Neg'))
        if (Flexdemands[p].Power <= offers2[Flexdemands[p].timepoint].NegPower && totalneeds[p] <= offers2[Flexdemands[p].timepoint].NegEnergy )
            check2s[p]=true;
        check2s[p]=false;
    if (keccak256(Flexdemands[p].kind) == keccak256('Pos'))
        if (Flexdemands[p].Power <= offers2[Flexdemands[p].timepoint].PosPower && totalneeds[p] <= offers2[Flexdemands[p].timepoint].PosEnergy )
            check2s[p]=true;
        check2s[p]=false;
    }
}

function Checkoffers3() public {
    for (uint8 p=0;p<Flexdemands.length;p++) {
    if (keccak256(Flexdemands[p].kind) == keccak256('Neg'))
        if (Flexdemands[p].Power <= offers3[Flexdemands[p].timepoint].NegPower && totalneeds[p] <= offers3[Flexdemands[p].timepoint].NegEnergy )
            check3s[p]=true;
        check1s[p]=false;
    if (keccak256(Flexdemands[p].kind) == keccak256('Pos'))
        if (Flexdemands[p].Power <= offers3[Flexdemands[p].timepoint].PosPower && totalneeds[p] <= offers3[Flexdemands[p].timepoint].PosEnergy )
            check3s[p]=true;
        check3s[p]=false;
    }
}

uint[] tp1;
uint[] tp2;
uint[] tp3;

function Totalprice1() public {
    for (uint8 j=0;j<Flexdemands.length;j++){
    if (keccak256(Flexdemands[j].kind) == keccak256('Neg')) 
        for (uint8 i=1;i<=Flexdemands[j].duration;i++) {
            tp1[j] += offers1[Flexdemands[j].timepoint+i-1].NegPrice*offers1[Flexdemands[j].timepoint+i-1].NegPower;
        }
    if (keccak256(Flexdemands[j].kind) == keccak256('Pos')) 
        for (uint8 k=1;k<=Flexdemands[j].duration;k++) {
            tp1[j] += offers1[Flexdemands[j].timepoint+k-1].PosPrice*offers1[Flexdemands[j].timepoint+k-1].PosPower;
        }    
    }
}

function Totalprice2() public {
    for (uint8 j=0;j<Flexdemands.length;j++){
    if (keccak256(Flexdemands[j].kind) == keccak256('Neg')) 
        for (uint8 i=1;i<=Flexdemands[j].duration;i++) {
            tp2[j] += offers2[Flexdemands[j].timepoint+i-1].NegPrice*offers2[Flexdemands[j].timepoint+i-1].NegPower;
        }
    if (keccak256(Flexdemands[j].kind) == keccak256('Pos')) 
        for (uint8 k=1;k<=Flexdemands[j].duration;k++) {
            tp2[j] += offers2[Flexdemands[j].timepoint+k-1].PosPrice*offers2[Flexdemands[j].timepoint+k-1].PosPower;
        }    
    }
}

function Totalprice3() public {
    for (uint8 j=0;j<Flexdemands.length;j++){
    if (keccak256(Flexdemands[j].kind) == keccak256('Neg')) 
        for (uint8 i=1;i<=Flexdemands[j].duration;i++) {
            tp3[j] += offers3[Flexdemands[j].timepoint+i-1].NegPrice*offers3[Flexdemands[j].timepoint+i-1].NegPower;
        }
    if (keccak256(Flexdemands[j].kind) == keccak256('Pos')) 
        for (uint8 k=1;k<=Flexdemands[j].duration;k++) {
            tp3[j] += offers3[Flexdemands[j].timepoint+k-1].PosPrice*offers3[Flexdemands[j].timepoint+k-1].PosPower;
        }    
    }
}

uint8[] UsedFlexIds;
function FindCheapestoffer() public {
    for (uint8 i=0;i<Flexdemands.length;i++) {
    if(check1s[i] && check2s[i] && check3s[i])
        if(tp1[i] <= tp2[i] && tp1[i] <= tp3[i])
            UsedFlexIds[i] = 1;
        if(tp2[i] <= tp1[i] && tp2[i] <= tp3[i])
            UsedFlexIds[i] = 2;
        if(tp3[i] <= tp1[i] && tp3[i] <= tp2[i])
            UsedFlexIds[i] = 3; 
    if(check1s[i] && check2s[i] && !check3s[i])
        if(tp1[i] <= tp2[i])
            UsedFlexIds[i] = 1;
        UsedFlexIds[i] = 2;
    if(check1s[i] && !check2s[i] && check3s[i])
        if(tp1[i] <= tp3[i])
            UsedFlexIds[i] = 1;
        UsedFlexIds[i] = 3;
    if(!check1s[i] && check2s[i] && check3s[i])
        if(tp2[i] <= tp3[i])
            UsedFlexIds[i] = 2;
        UsedFlexIds[i] = 3;
    if(check1s[i] && !check2s[i] && !check3s[i])
        UsedFlexIds[i] = 1;
    if(!check1s[i] && check2s[i] && !check3s[i])
        UsedFlexIds[i] = 2;
    if(!check1s[i] && !check2s[i] && check3s[i])
        UsedFlexIds[i] = 3;
    else UsedFlexIds[i] = 0;
    }
}


function RemoveOffers() public {
    for (uint8 i=0;i<=Flexdemands.length;i++){
    if (keccak256(Flexdemands[j].kind) == keccak256('Neg')) 
        if (UsedFlexIds[i] == 1)
            for (uint8 j=1;j<=Flexdemands[i].duration;j++) {
                offers1[Flexdemands[i].timepoint+j-1].NegPower = 0;
        }
        if (UsedFlexIds[i] == 2)
            for (uint8 k=1;k<=Flexdemands[i].duration;k++) {
                offers2[Flexdemands[i].timepoint+k-1].NegPower = 0;
        }
        if (UsedFlexIds[i] == 3)
            for (uint8 l=1;l<=Flexdemands[i].duration;l++) {
                offers3[Flexdemands[i].timepoint+l-1].NegPower = 0;
        }
    if (keccak256(Flexdemands[j].kind) == keccak256('Pos')) 
        if (UsedFlexIds[i] == 1)
            for (uint8 m=1;m<=Flexdemands[i].duration;m++) {
                offers1[Flexdemands[i].timepoint+m-1].PosPower = 0;
        }
        if (UsedFlexIds[i] == 2)
            for (uint8 n=1;n<=Flexdemands[i].duration;n++) {
                offers2[Flexdemands[i].timepoint+n-1].PosPower = 0;
        }
        if (UsedFlexIds[i] == 3)
            for (uint8 o=1;o<=Flexdemands[i].duration;o++) {
                offers3[Flexdemands[i].timepoint+o-1].PosPower = 0;
        }
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

function ShowFlexIds() public view returns(uint8[]) {
    return (UsedFlexIds);
}
}