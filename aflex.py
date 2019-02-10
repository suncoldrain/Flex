
# coding: utf-8

# In[56]:


import web3
import json
import array
import math
import random
import time
import csv
import threading

from web3 import Web3, IPCProvider, HTTPProvider

# Use this function to import the data flexibility table from prosumers to pycharm.
def csv_import(filename):

    columns = []
    with open(filename, 'rU') as f:
        reader = csv.reader(f, delimiter=';')
        for row in reader:
            if columns:
                for i, value in enumerate(row):
                    columns[i].append(value)
            else:
                # first row
                columns = [[value] for value in row]
    # you now have a column-major 2D array of your file.
    as_dict = {c[0]: c[1:] for c in columns}
    return as_dict

data1= csv_import('flextable1.csv')
data2= csv_import('flextable2.csv')
data3= csv_import('flextable3.csv')
#Use print(data1) to check the data.



web3 = Web3(HTTPProvider("HTTP://127.0.0.1:8501", request_kwargs = {'timeout':600}))
print(web3)

#Unlock the account to make transaction. In practice, the three prosumers and the DSO should each have an account to perform the corresponding operations.
#Only one account is used here to do all the operations.
web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')

#Returns the smart contract instance sc that allows to call this contract's functions
contract_address = web3.toChecksumAddress(0x8c4f8895184555d5fe2c89c8b5d02b73d72b3d79)
abi_str = '[{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_PosPower","type":"uint16"},{"name":"_PosEnergy","type":"uint16"},{"name":"_PosPrice","type":"uint16"}],"name":"SetPosoffers1","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"RemoveOffers","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_scheduledPower","type":"uint16"},{"name":"_NegPower","type":"uint16"},{"name":"_NegEnergy","type":"uint16"},{"name":"_NegPrice","type":"uint16"}],"name":"SetNegoffers2","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"showNeeds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ShowFlexId","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_scheduledPower","type":"uint16"},{"name":"_NegPower","type":"uint16"},{"name":"_NegEnergy","type":"uint16"},{"name":"_NegPrice","type":"uint16"}],"name":"SetNegoffers3","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"Checkoffers1","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"StartFlexMatching","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"Checkoffers2","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"Totalprice1","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"Totalprice2","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"FindCheapestoffer","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"i","type":"uint16"}],"name":"ShowOffers1","outputs":[{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"FlexunittoOwner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_EICcode","type":"string"},{"name":"_capacity","type":"uint256"}],"name":"Register","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"i","type":"uint16"}],"name":"ShowOffers3","outputs":[{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_PosPower","type":"uint16"},{"name":"_PosEnergy","type":"uint16"},{"name":"_PosPrice","type":"uint16"}],"name":"SetPosoffers3","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_scheduledPower","type":"uint16"},{"name":"_NegPower","type":"uint16"},{"name":"_PosPower","type":"uint16"},{"name":"_NegEnergy","type":"uint16"},{"name":"_PosEnergy","type":"uint16"},{"name":"_NegPrice","type":"uint16"},{"name":"_PosPrice","type":"uint16"}],"name":"SetFlexoffer1","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_PosPower","type":"uint16"},{"name":"_PosEnergy","type":"uint16"},{"name":"_PosPrice","type":"uint16"}],"name":"SetPosoffers2","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"}],"name":"SetZerooffers3","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"},{"name":"_scheduledPower","type":"uint16"},{"name":"_NegPower","type":"uint16"},{"name":"_NegEnergy","type":"uint16"},{"name":"_NegPrice","type":"uint16"}],"name":"SetNegoffers1","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"Totalprice3","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"i","type":"uint16"}],"name":"ShowOffers2","outputs":[{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"},{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"Checkoffers3","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"calculateNeeds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"Flexunits","outputs":[{"name":"EICcode","type":"string"},{"name":"capacity","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"}],"name":"SetZerooffers1","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_timepoint","type":"uint16"}],"name":"SetZerooffers2","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_kind","type":"string"},{"name":"_timepoint","type":"uint16"},{"name":"_Power","type":"uint16"},{"name":"_duration","type":"uint8"}],"name":"SetFlexdemand","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"FlexunitId","type":"uint256"},{"indexed":false,"name":"EICcode","type":"string"},{"indexed":false,"name":"capacity","type":"uint256"}],"name":"NewFlexunit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"}]'
contract_abi = json.loads(abi_str)
contract = web3.eth.contract(abi=contract_abi, address=contract_address)
contract


#contract.transact({'from':web3.eth.accounts[1]}).SetZerooffers1(2)


#Set flexibility table from 3 prosumers. Here we use the same account.
#In practice, it should be the account corresponding to each prosumer and the password it sets.
web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
for i in range(0,95):
    if(int(data1['Leistung_Plan'][i])==0 and int(data1['Leistung+'][i])==0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetZerooffers1(i)
        
    
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    if(int(data1['Leistung_Plan'][i])==0 and int(data1['Leistung+'][i])!=0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetPosoffers1(i,int(data1['Leistung+'][i]),int(data1['Energie+'][i]),int(data1['Preis+'][i]))
      
        
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    if(int(data1['Leistung_Plan'][i])!=0 and int(data1['Leistung+'][i])==0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetNegoffers1(i,int(data1['Leistung_Plan'][i]),int(data1['Leistung-'][i]),int(data1['Energie-'][i]),int(data1['Preis-'][i]))
        
for i in range(0,95):
    if(int(data2['Leistung_Plan'][i])==0 and int(data2['Leistung+'][i])==0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetZerooffers2(i)
        
    
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    if(int(data2['Leistung_Plan'][i])==0 and int(data2['Leistung+'][i])!=0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetPosoffers2(i,int(data2['Leistung+'][i]),int(data2['Energie+'][i]),int(data2['Preis+'][i]))
      
        
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    if(int(data2['Leistung_Plan'][i])!=0 and int(data2['Leistung+'][i])==0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetNegoffers2(i,int(data2['Leistung_Plan'][i]),int(data2['Leistung-'][i]),int(data2['Energie-'][i]),int(data2['Preis-'][i]))
        
for i in range(0,95):
    if(int(data3['Leistung_Plan'][i])==0 and int(data3['Leistung+'][i])==0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetZerooffers3(i)
        
    
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    if(int(data3['Leistung_Plan'][i])==0 and int(data3['Leistung+'][i])!=0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetPosoffers3(i,int(data3['Leistung+'][i]),int(data3['Energie+'][i]),int(data3['Preis+'][i]))
      
        
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    if(int(data3['Leistung_Plan'][i])!=0 and int(data3['Leistung+'][i])==0):
        web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
        contract.transact({'from':web3.eth.accounts[1]}).SetNegoffers3(i,int(data3['Leistung_Plan'][i]),int(data3['Leistung-'][i]),int(data3['Energie-'][i]),int(data3['Preis-'][i]))

#Set flexdemand, e.g  a negative demand with 19000W in 30 Minutes at 13:15.
#In practice, it should be the account of DSO and the password it sets.
web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
contract.transact({'from':web3.eth.accounts[1]}).SetFlexdemand('Neg',53,19000,2)


#This function will call Flexmatching simulation every 15 minutes.
def Watchdog():
    web3.personal.unlockAccount(web3.eth.accounts[1],'gogogo')
    contract.transact({'from':web3.eth.accounts[1]}).StartFlexMatching()
    global timer
    timer = threading.Timer(900,Watchdog) #Using the timer in the threading library, the function itself is called
    timer.start()                         #again in the watchdog to perform a market simulation every 15 minutes.

if __name__=='__main__':
    timer = threading.Timer(1, Watchdog)  #Watchdog function will start after 1 second.
    timer.start()

    time.sleep(86400) #this operation will stop after 24 hours.
    timer.cancel()
