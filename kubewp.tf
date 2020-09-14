provider "kubernetes" {
    config_context_cluster   = "minikube"
}

resource "kubernetes_deployment" "wp" {
  metadata {
    name = "wp"
    labels = {
      test = "myword"
    }
  }


  spec {
    replicas = 2


    selector {
      match_labels = {
        test = "myword"
      }
    }


    template {
      metadata {
        labels = {
          test = "myword"
        }
      }


     spec {
        container {
          image = "wordpress"
          name  = "wp"
        }
      }
    }
  }
}

resource "kubernetes_service" "wordlb" {
  metadata {
    name = "wordlb"
  }
  spec {
    selector = {
      test = "${kubernetes_deployment.wp.metadata.0.labels.test}"
    }
    port {
      port = 80
      target_port = 80
    }


    type = "NodePort"
  }
}


resource "null_resource" "url" {
 provisioner "local-exec" {
  command = "minikube service list"
 }
 
depends_on = [ kubernetes_service.wordlb ]


}