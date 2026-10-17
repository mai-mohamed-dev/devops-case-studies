resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      name = "frontend"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        name = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          name = "webapp"
        }
      }

      spec {
        container {
          name  = "simple-webapp"
          image = "kodekloud/webapp-color:v1"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "webapp_service" {
  metadata {
    name = "webapp-service"
  }

  spec {
    type = "NodePort"

    selector = {
      name = "webapp"
    }

    port {
      port        = 8080
      target_port = 8080
      node_port   = 30080
    }
  }
}