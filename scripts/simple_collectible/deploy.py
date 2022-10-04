from brownie import SimpleCollectible
import scripts.functions as func

sample_token_uri = "https://ipfs.io/ipfs/Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"

def deploy():
    account = func.get_account()
    contract = SimpleCollectible.deploy(sample_token_uri, {"from": account}, publish_source=func.get_verify())
    #contract = SimpleCollectible[-1]
    token_id = contract.tokenCounter({"from": account})
    #print(token_id)
    tx = contract.createCollectible({"from": account})
    tx.wait(1)
    token_uri = contract.tokenURI(token_id, {"from": account})
    #print(token_uri)
    #print(f"Done. View NFT at {func.opensea_url.format(contract.address, token_id)}")
    return contract


def main():
    deploy()