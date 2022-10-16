from brownie import AdvancedCollectible, config, network
import scripts.functions as func

#sample_token_uri = "https://ipfs.io/ipfs/Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"

def deploy():
    account = func.get_account()
    sub_id = config["chainlink"]["subscription_id"]
    keyhash = config["networks"][network.show_active()]["keyhash"]
    vrf_contract = func.get_contract('vrf_coordinator')
    if(len(AdvancedCollectible) == 0):
        contract = AdvancedCollectible.deploy(sub_id, vrf_contract, keyhash, {"from": account}, publish_source=func.get_verify())
    else:
        contract = AdvancedCollectible[-1]
    if(network.show_active() in func.LOCAL_BLOCKCHAIN_ENVIRONMENTS):
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
    breed = fulfill_txn.events["requestedCollectible"]["breed"]
    print(f"New {breed} Collectible created")


def main():
    deploy()