aws cloudformation create-stack --stack-name $1 --template-body file://$2 --parameters file://$3 --profile 226915686048_PowerUserAccess --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"