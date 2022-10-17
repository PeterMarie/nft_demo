from brownie import AdvancedCollectible

def main():
    contract = AdvancedCollectible[-1]
    number_of_collectibles = contract.tokenCounter()
    print(f"You have created {number_of_collectibles} collectibles")