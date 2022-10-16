from brownie import AdvancedCollectible, config, network
import scripts.functions as func

def main():
    account = func.get_account()
    contract = AdvancedCollectible[-1]
    if(network.show_active() in func.LOCAL_BLOCKCHAIN_ENVIRONMENTS):
        vrf_contract = func.get_contract('vrf_coordinator')
        sub_id_txn = vrf_contract.createSubscription({"from": account})
        sub_id_txn.wait(1)
        sub_id = sub_id_txn.events["SubscriptionCreated"]["subId"]
        fund_amount_link = 300000000000000000000
        fund_vrf_txn = vrf_contract.fundSubscription(sub_id, fund_amount_link, {"from": account})
        fund_vrf_txn.wait(1)
    tx = contract.createCollectible(sub_id, {"from": account})
    tx.wait(1)
    request_id = tx.events["requestedRandomWords"]["requestId"]
    fulfill_txn = vrf_contract.fulfillRandomWords(request_id, contract.address, {"from": account})
    fulfill_txn.wait(1)