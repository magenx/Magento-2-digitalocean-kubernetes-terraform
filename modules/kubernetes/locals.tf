
locals {
  ## environmental variables to pass to containers
  env = {
    php = {
      "PHP_VARIABLE" = "PHP_VARIABLE"
    }
    magento = {
      "MAGENTO_VARIABLE" = "MAGENTO_VARIABLE"
    }
    nginx = {
      "NGINX_ARIABLE" = "NGINX_ARIABLE"
    }
    elasticsearch = {
      "ELK_VARIABLE" = "ELK_VARIABLE"
    }
    varnish = {
      "VARNISH_VARIABLE" = "VARNISH_VARIABLE"
    }
  }
}
