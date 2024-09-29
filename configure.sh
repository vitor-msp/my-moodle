#!/bin/bash

sudo apt update
sudo apt install -y postgresql-16-cron
sudo systemctl restart postgresql
