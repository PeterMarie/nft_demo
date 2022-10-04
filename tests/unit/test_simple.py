from brownie import network
import scripts.functions as func
from scripts.simple_collectible.deploy import deploy
import pytest

def test_can_create():
    if(network.show_active in func.LOCAL_BLOCKCHAIN_ENVIRONMENTS):
        pytest.skip()
    contract = deploy()
    assert contract.ownerOf(0) == func.get_account()