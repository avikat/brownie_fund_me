
from brownie import FundMe , accounts,config,network,MockV3Aggregator
from scripts.helpful_scripts import get_account,deploy_mocks,LOCAL_BLOCKCHAIN_ENVIROMENTS
from web3 import Web3

def deply_fund_me():
    account = get_account()
    if (network.show_active() not in LOCAL_BLOCKCHAIN_ENVIROMENTS):
        price_feed = config["networks"][network.show_active()]["eth_usd_price_feed "]
    else:
        deploy_mocks()
        price_feed = MockV3Aggregator[-1].address

        
    fund_me = FundMe.deploy(price_feed,{"from" : account}, publish_source=config["networks"][network.show_active()]["verify"])
    print(f"Contract deploy to {fund_me.address}")

def main():
    deply_fund_me()