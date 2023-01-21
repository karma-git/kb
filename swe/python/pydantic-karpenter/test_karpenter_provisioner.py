import typing as t

import pytest

from karpenter import karpenterPayloadProvisioner

# without selected CRI in Provisioner
case1 = ("foo", {}, "dockerd")

# with containerd as a CRI for Provisioner

case2 = ("bar", {"kubeReserved": "testMe", "containerRuntime": "containerd"}, "containerd")

# with typo in CRI for Provisioner
case3 = ("baz", {"kubeReserved": "testMe", "containerRuntime": "qwerty"}, "dockerd")

test_cases = [
    case1,
    case2,
    case3,
]

@pytest.mark.parametrize("name, kubelet_configuration, expected_CRI", test_cases)
def test_cri_provisioner(name: str, kubelet_configuration: t.Optional[dict], expected_CRI: str):

    provisioner = karpenterPayloadProvisioner(name=name, kubelet_configuration=kubelet_configuration)
    assert provisioner.kubelet_configuration["containerRuntime"] == expected_CRI
