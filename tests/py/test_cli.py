import pytest
from abies import cli

def test_clifoo():
    print("Test")
    assert(cli.foo() == 2)
