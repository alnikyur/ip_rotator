## AWS infrastructure via terraform for autorotation ip`s

## Prerequisites:

- Terraform ^~ v1.3.9
- Docker Engine ^~ 20.10.21 (for build backend and frontend parts)
- AWS account with admin access rights

### How to use

Current terraform template provide infrastructure in AWS which allow to run and use multiple openvpn servers in full automation mode.  
OVPN clients configuration files will be stored in S3 bucket and can be easily using. There is also present an entrypoint server which automatticaly bringing-up VPN tunnels to each VPN server.

### Run the next command to create infrastructure
1. Firstly create `key-pair` with name `vpn-test`. This is only one manual step, every other steps will be fully-automated.
2. Run `terraform init` command
3. Run `terraform fmt` command
4. Run `terraform validate` command
3. Run `terraform apply` command and put `yes` or `terraform apply --auto-approve`
4. After some time you will be able to see output of your infrastructure. The output contain next info:
- Entrypoint instance private/public ip address
- S3 bucket URL
- Target instance private/public ip address
- VPN instance private/public ip address

### There is several variables that can be used under the terraform code:

- `vpn_count` - number of VPN servers that can be created in AWS, default value is `2`
- `docker_ecr` - number of ECR repositories, default if `3`
- `region` - specify in which region infrastructure will be run, default `us-east-1`
- `"create_target_instance` - specify whether to create or not target instance (this is applicable only for testing), default `true`
- `create_entrypoint_instance` - specify whether to create or not main server instance, default `true`
- `key_name` - name of the SSH key pairs, default `vpn-test`

#### *You can specify this variables when running `terrafom apply` command, for example:*

`terraform apply --var=ky_name=example-key --var=region=eu-central-1` - means that terraform create infrastructure in `eu-central-1` region and EC2 instances will be used the key with `example-key` name
