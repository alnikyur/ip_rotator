## AWS infrastructure via terraform for autorotation ip`s

## Prerequisites:

- Terraform ^~ v1.3.9
- Docker Engine ^~ 20.10.21
- AWS

### How to use

Current terraform template provide infrastructure in AWS which allow to run and use multiple openvpn servers in full automation mode.  
OVPN clients configuration files will be stored in S3 bucket and can be easily using. There is also present an entrypoint server which automatticaly bringing-up VPN tunnels to each VPN server.

### Run the next command to create infrastructure
1. Firstly create `key-pair` with name `vpn-test`. This is only one manual step, every other steps will be fully-automated.
2. Run `terraform init` command
3. Run `terraform apply` command
4. After some time you will be able to see output of your infrastructure. The output contain next info:
- Entrypoint instance private/public ip address
- S3 bucket URL
- Target instance private/public ip address
- VPN instance private/public ip address



