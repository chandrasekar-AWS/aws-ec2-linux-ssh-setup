# Linux EC2 Instance Deployment with SSH Access on AWS

## Overview
Launched and secured a Linux EC2 instance on AWS Free Tier, demonstrating
secure remote access configuration and server environment exploration.

## Architecture
Local Machine (Trusted IP) → SSH (Port 22) → EC2 Amazon Linux Instance

## What I Built
* Launched a t2.micro Amazon Linux EC2 instance on AWS Free Tier
* Configured Security Group to allow SSH only from a trusted IP
* Created RSA key pair for secure passwordless authentication
* Connected via SSH and explored the Linux server environment
* Restricted all other inbound access to minimize attack surface

## Services Used
* Amazon EC2
* Security Groups
* Key Pairs (RSA)
* Linux (Amazon Linux 2)
* AWS Management Console

## Key Learnings
* Secure SSH access configuration
* Key-based authentication over password login
* Security Group rules and IP whitelisting
* Linux server environment basics
* AWS Free Tier instance management

## Screenshots

### SSH Connection to EC2 Instance via RSA Key Pair
<img width="1480" height="725" alt="Screenshot 2026-05-24 071330" src="https://github.com/user-attachments/assets/eed8f55a-5fe1-49ee-988f-e6e29928d212" />

