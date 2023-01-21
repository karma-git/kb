import string

from pydantic import BaseModel, validator

DEFAULT_CRI = {"containerRuntime": "dockerd"}

class karpenterPayloadProvisioner(BaseModel):
  name: str
  az: str = "b"
  kubelet_configuration: dict = DEFAULT_CRI
  nodes_deprovisiong: str = "ttlSecondsAfterEmpty"
  enable_taint: bool = False
  capacity_types: list = ["spot"]

  @validator('name')
  def name_rfc_1123(cls, v):
    "ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names"
    pass

  @validator('az')
  def aws_az_suffixes(cls, v):
    assert v in string.ascii_lowercase, 'az must be a, b, c, d and etc.'
    return v

  @validator('kubelet_configuration')
  def kubelet_container_runtime(cls, v):
    cri = v.get("containerRuntime")
    # option two - Validation
    # assert cri in ["dockerd", "containerd"], 'dockerd && containerd are only ones allowed runtimes'

    # option two - Mutating
    if cri not in ["dockerd", "containerd"]:
      v.update(DEFAULT_CRI)
    return v

  @validator('nodes_deprovisiong')
  def provisioner_nodes_deprovisioning(cls, v):
    assert v in ["ttlSecondsAfterEmpty", "consolidation"], 'ttlSecondsAfterEmpty and consolidation are only ones nodesDeprovisioning mechanisms'
    return v

  @validator('capacity_types')
  def ec2_capacity_types(cls, v):
    "check if list contains proper values"
    pass
