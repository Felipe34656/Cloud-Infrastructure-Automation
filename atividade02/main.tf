module "vpc" {
  source  = "./modules/vpc"
  
}

module "slackoapp" {
    depends_on=[module.vpc]
    source = "./modules/slacko-app"
}