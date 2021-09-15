terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_namespace" "test" {
  metadata {
    name = "fa"
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "fa-deploy"
    namespace = kubernetes_namespace.test.metadata.0.name
    labels = {
      app = "fa"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "fa"
      }
    }
    template {
      metadata {
        labels = {
          app = "fa"
        }
      }
      spec {
        container {
          image = "karmawow/fastapi:v0.20"
          name  = "fa"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = "fa-svc"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 80
      protocol    = "TCP"
      name        = "http"
      target_port = 80
    }
  }
}

resource "kubernetes_ingress" "test" {
  metadata {
    name      = "fa-ingress"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    rule {
      http {
        path {
          backend {
            service_name = "fa-svc"
            service_port = 80
          }

          path = "/"
        }
      }
    }
  }
}
