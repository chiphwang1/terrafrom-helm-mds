provider "helm" {
  kubernetes {
    config_path = "/tmp/kubeconfig"
  }
}



resource "helm_release" "nginx_ingress" {
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
    value = output.mds_instance_ip
  }

  set {
    name = "externalDatabase.password"
    value = var.admin_password
  }


}