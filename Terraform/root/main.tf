module "vpc" {
    source = "../modules/vpc"
    region = var.region
    project_name = var.project_name
    vpc_cidr         = var.vpc_cidr
    pub_sub_1a_cidr = var.pub_sub_1a_cidr
    pub_sub_2b_cidr = var.pub_sub_2b_cidr
    priv_sub_3a_cidr = var.priv_sub_3a_cidr
    priv_sub_4b_cidr = var.priv_sub_4b_cidr
}

module "nat" {
  source = "../modules/nat"

  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  igw_id        = module.vpc.igw_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id
  priv_sub_3a_id = module.vpc.priv_sub_3a_id
  priv_sub_4b_id = module.vpc.priv_sub_4b_id
}

module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "database" {
  source         = "../modules/database"
  mydb_sg_id       = module.security-group.mydb_sg_id
  priv_sub_3a_id = module.vpc.priv_sub_3a_id
  priv_sub_4b_id = module.vpc.priv_sub_4b_id
  mydb_username    = var.mydb_username
  mydb_password    = var.mydb_password
}

module "loadbalancer" {
  source         = "../modules/loadbalancer"
  project_name   = module.vpc.project_name
  alb_sg_id      = module.security-group.alb_sg_id
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id         = module.vpc.vpc_id
}

module "autoscaling-group" {
  source         = "../modules/autoscaling-group"
  project_name   = module.vpc.project_name
  webserver_sg_id   = module.security-group.webserver_sg_id
  priv_sub_3a_id = module.vpc.priv_sub_3a_id
  priv_sub_4b_id = module.vpc.priv_sub_4b_id
  targetgroup_arn = module.loadbalancer.targetgroup_arn
}





