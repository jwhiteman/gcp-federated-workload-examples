#!/bin/bash

# export KEY="path/to/key"
# export PUBLIC_DNS="public-dns-from-terraform-out"

scp -i $KEY ../tmp/federated-config.json ec2-user@$PUBLIC_DNS:/home/ec2-user
scp -i $KEY ./ec2-instance-init.sh ec2-user@$PUBLIC_DNS:/home/ec2-user
ssh -i $KEY ec2-user@$PUBLIC_DNS
