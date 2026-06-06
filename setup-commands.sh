#!/bin/bash
# ============================================================
# AWS EC2 Linux Instance — SSH Setup Guide
# Run these commands on your LOCAL machine (not inside EC2)
# ============================================================

# ── STEP 1: Create a Key Pair (AWS CLI) ─────────────────────
# Replace "my-key-pair" with your preferred key name
aws ec2 create-key-pair \
    --key-name my-key-pair \
    --query 'KeyMaterial' \
    --output text > my-key-pair.pem

echo "[✓] Key pair created: my-key-pair.pem"

# ── STEP 2: Set correct permissions on the .pem file ─────────
chmod 400 my-key-pair.pem
echo "[✓] Permissions set to 400 (owner read-only)"

# ── STEP 3: Create a Security Group ─────────────────────────
# Replace YOUR_VPC_ID with your actual VPC ID
VPC_ID="vpc-xxxxxxxxxxxxxxxxx"

SG_ID=$(aws ec2 create-security-group \
    --group-name "ec2-ssh-sg" \
    --description "Allow SSH access" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)

echo "[✓] Security Group created: $SG_ID"

# ── STEP 4: Allow SSH (port 22) from YOUR IP only ────────────
MY_IP=$(curl -s https://checkip.amazonaws.com)

aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 22 \
    --cidr "$MY_IP/32"

echo "[✓] SSH access allowed from your IP: $MY_IP"

# ── STEP 5: Launch EC2 Instance ──────────────────────────────
# Replace AMI_ID and SUBNET_ID with your values
# Amazon Linux 2023: ami-0c02fb55956c7d316 (us-east-1)
AMI_ID="ami-0c02fb55956c7d316"
SUBNET_ID="subnet-xxxxxxxxxxxxxxxxx"

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t2.micro \
    --key-name my-key-pair \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --associate-public-ip-address \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=my-ec2-instance}]' \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "[✓] EC2 Instance launched: $INSTANCE_ID"

# ── STEP 6: Wait for instance to be running ──────────────────
echo "[...] Waiting for instance to be in running state..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID
echo "[✓] Instance is running!"

# ── STEP 7: Get the Public IP ────────────────────────────────
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "[✓] Public IP: $PUBLIC_IP"

# ── STEP 8: SSH into the instance ────────────────────────────
echo ""
echo "=== Connect to your EC2 instance with: ==="
echo "ssh -i my-key-pair.pem ec2-user@$PUBLIC_IP"
echo ""
echo "=== Or run it now: ==="
# ssh -i my-key-pair.pem ec2-user@$PUBLIC_IP

# ── STEP 9: Terminate instance when done (optional) ──────────
# aws ec2 terminate-instances --instance-ids $INSTANCE_ID
# echo "[✓] Instance terminated."
