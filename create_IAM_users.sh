#!/bin/bash
# IAM User Creation Script with Group Assignment from CSV
# Author: Sakshi CloudVerse 2k25

# ===== Configuration =====
INPUT_FILE="users.csv"          # CSV file format: Name,Email
ACCOUNT_TAG="CloudVerse2k25"    # Tag for your output files
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="iam_users_${ACCOUNT_TAG}_${TIMESTAMP}.csv"
GROUP_NAME="TechFusion2k25"

# ===== Prepare Output File =====
echo "Name,Email,Username,Password,AccessKeyID,SecretAccessKey" > "$OUTPUT_FILE"

echo "🔸 Using input file: $INPUT_FILE"
echo "🔸 Output credentials will be saved to: $OUTPUT_FILE"
echo "🔸 IAM Group: $GROUP_NAME"

# ===== Required Policies =====
POLICIES=(
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
    "arn:aws:iam::aws:policy/IAMFullAccess"
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    "arn:aws:iam::aws:policy/AWSCloudShellFullAccess"
)

# Inline policy to allow users to change their own password
SELF_PASSWORD_POLICY='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        }
    ]
}'

# ===== Check if Group Exists =====
if ! aws iam get-group --group-name "$GROUP_NAME" >/dev/null 2>&1; then
    echo "📁 Creating IAM group: $GROUP_NAME"
    aws iam create-group --group-name "$GROUP_NAME"
else
    echo "✅ Group '$GROUP_NAME' already exists."
fi

# ===== Attach Managed Policies =====
echo "🔗 Attaching managed policies to group..."
for POLICY in "${POLICIES[@]}"; do
    aws iam attach-group-policy --group-name "$GROUP_NAME" --policy-arn "$POLICY"
done

# ===== Attach Inline Policy for self password change =====
INLINE_POLICY_NAME="AllowSelfPasswordChange"
aws iam put-group-policy \
    --group-name "$GROUP_NAME" \
    --policy-name "$INLINE_POLICY_NAME" \
    --policy-document "$SELF_PASSWORD_POLICY"

# ===== Create Users =====
COUNT=0
while IFS=',' read -r NAME EMAIL
do
    # Skip header
    if [[ "$NAME" == "Candidate's Name" || -z "$NAME" || -z "$EMAIL" ]]; then
        continue
    fi

    ((COUNT++))
    echo ""
    echo "🧑 Processing user #$COUNT: $NAME <$EMAIL>"

    # Username from email
    EMAIL_PREFIX=$(echo "$EMAIL" | cut -d'@' -f1)
    USERNAME="cv25${EMAIL_PREFIX}"

    # Generate random strong password
    PASSWORD=$(openssl rand -base64 14)

    # Create IAM user
    if aws iam create-user --user-name "$USERNAME" >/dev/null 2>&1; then
        echo "✅ Created IAM user: $USERNAME"
    else
        echo "⚠️ Skipping $USERNAME - already exists or error"
        continue
    fi

    # Create console login profile WITH password reset
    aws iam create-login-profile \
        --user-name "$USERNAME" \
        --password "$PASSWORD" \
        --password-reset-required

    # Add user to group
    aws iam add-user-to-group --user-name "$USERNAME" --group-name "$GROUP_NAME"

    # Create access keys
    KEYS=$(aws iam create-access-key --user-name "$USERNAME")
    ACCESS_KEY_ID=$(echo "$KEYS" | jq -r '.AccessKey.AccessKeyId')
    SECRET_ACCESS_KEY=$(echo "$KEYS" | jq -r '.AccessKey.SecretAccessKey')

    # Save credentials
    echo "$NAME,$EMAIL,$USERNAME,$PASSWORD,$ACCESS_KEY_ID,$SECRET_ACCESS_KEY" >> "$OUTPUT_FILE"

done < "$INPUT_FILE"

echo ""
echo "🎉 All done! Created $COUNT users."
echo "📄 Credentials saved in: $OUTPUT_FILE"
