data "aws_efs_file_system" "source" {
  file_system_id = var.source_efs_id
}

data "aws_efs_file_system" "destanation" {
  file_system_id = var.destanation_efs_id
}

// attachment

resource "aws_efs_mount_target" "destanation" {
  for_each       = toset(var.subnets)
  file_system_id = data.aws_efs_file_system.destanation.id
  subnet_id      = each.value
}

// access points

data "aws_efs_access_points" "source" {
  file_system_id = data.aws_efs_file_system.source.id
}

data "aws_efs_access_point" "source" {
  for_each        = toset(data.aws_efs_access_points.source.ids)
  access_point_id = each.value
}

resource "aws_efs_access_point" "source_root" {
  for_each       = { for k, v in data.aws_efs_access_point.source : k => v if v.root_directory[0]["path"] == "/" }
  file_system_id = data.aws_efs_file_system.destanation.id
  root_directory {
    path = each.value.root_directory[0]["path"]
  }
  tags = each.value.tags
}

resource "aws_efs_access_point" "source_others" {
  for_each = {
  for k, v in data.aws_efs_access_point.source : k => v if v.root_directory[0]["path"] != "/" }

  file_system_id = data.aws_efs_file_system.destanation.id
  root_directory {
    path = each.value.root_directory[0]["path"]
    creation_info {
      owner_gid   = each.value.root_directory[0]["creation_info"][0]["owner_gid"]
      owner_uid   = each.value.root_directory[0]["creation_info"][0]["owner_uid"]
      permissions = each.value.root_directory[0]["creation_info"][0]["permissions"]
    }
  }

  posix_user {
    gid = each.value.posix_user[0]["gid"]
    uid = each.value.posix_user[0]["uid"]
  }
  tags = each.value.tags
}

// templates

data "aws_efs_access_points" "destanation" {
  file_system_id = data.aws_efs_file_system.destanation.id
}

data "aws_efs_access_point" "destanation" {
  for_each        = toset(data.aws_efs_access_points.destanation.ids)
  access_point_id = each.value
}

data "template_file" "k8s" {
  for_each = {
  for k, v in data.aws_efs_access_point.destanation : k => v if v.root_directory[0]["path"] != "/" }
  template = file("${path.module}/pv-pvc.tpl")
  # template = templatefile("${path.module}/pv-pvc.tpl", vars)

  vars = {
    name  = trimprefix(each.value.root_directory[0]["path"], "/")
    fs_id = each.value.file_system_id
    ap_id = each.value.id
  }
}

resource "local_file" "k8s" {
  for_each = toset(data.template_file.k8s[*])

  content  = each.value.rendered
  filename = "./${each.value.vars["name"]}.yml"
}
