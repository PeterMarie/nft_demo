from brownie import network
import time
import scripts.functions as func
from scripts.advanced_collectible.deploy import deploy
import pytest

def test_can_create_advanced():
    if(network.show_active() not in func.LOCAL_BLOCKCHAIN_ENVIRONMENTS):
        pytest.skip("Only for Local Testing!")
    contract = deploy()
    time.sleep(60)
    assert contract.tokenCounter() == 1