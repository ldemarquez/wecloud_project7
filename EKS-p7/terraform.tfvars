region          = "us-east-1"
vpc_name        = "EKSP7"
vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
cluster_name    = "Project7"
node_group_1    = "node_group_1"
node_group_2    = "node_group_2"
instance_types  = "t3.small"
node_min_size   = 1
node_max_size   = 2
node_desired_size = 2





