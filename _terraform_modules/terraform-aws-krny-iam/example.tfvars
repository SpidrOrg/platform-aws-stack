create_oidc_role              = true
oidc_role_name                = "test-irsa"
provider_urls                 = ["https://oidc.eks.ap-south-1.amazonaws.com/id/ABCD123456789DEFXYZ"]
oidc_fully_qualified_subjects = ["system:serviceaccount:test:test", "system:serviceaccount:lab:lab"]
create_policy                 = false
oidc_role_policy_arns         = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/IAMFullAccess", "arn:aws:iam::aws:policy/AmazonSSMFullAccess"]