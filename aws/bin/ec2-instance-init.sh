#!/bin/bash

sudo yum install ruby -y
sudo yum install ruby-devel -y
sudo yum install python3-pip -y

gem install bundler
gem install irb
gem install pry
gem install google-cloud-storage

pip3 install mitmproxy

cat << EOF > /home/ec2-user/.vimrc
let mapleader=" "
inoremap jk <esc>
nnoremap <leader>rf :!ruby %<cr>
EOF

cat << EOF > /home/ec2-user/federated-workload.rb
require "pry"
require "google/cloud/storage"

storage = Google::Cloud::Storage.new(
  project_id:  "PROJECT_ID",
  credentials: "federated-config.json"
)

binding.pry
EOF
