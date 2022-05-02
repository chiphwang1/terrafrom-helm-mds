provider "helm" {
  kubernetes {
    config_path = "/tmp/kubeconfig"
  }
}


resource "time_sleep" "wait_1min" {
  depends_on = [
  local_file.KubeConfigFile
  ]
  create_duration = "60s"
}

resource "helm_release" "magento" {
  depends_on = [time_sleep.wait_1min, module.mds-instance]
  name       = "magento"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "magento"

  set {
    name  = "mariadb.enabled"
    value = false
  }

  set {
    name = "externalDatabase.host"
    value = module.mds-instance.mysql_db_system.ip_address
  }

  set {
    name = "externalDatabase.password"
    value = var.admin_password
  }


set {
    name = "externalDatabase.user"
    value = variable.admin_username
  }

}