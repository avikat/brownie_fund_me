from brownie import accounts
from scripts.helpful_scripts import get_account
from scripts.deploy import deply_fund_me

def test_can_fund_withdraw():
    account = get_account()
    fund_me = deply_fund_me()
    entrance_fee = fund_me.getEntranceFee()
    tx=fund_me.fund({"from" :account , "value":entrance_fee})
    tx.wait(1)

    assert fund_me.addresToAmountFunded(account.address) == entrance_fee

    tx2 = fund_me.withdraw({"from":account})
    tx2.wait(1)
    assert fund_me.addressToAmountFunded(account.address) ==0