resource "aws_eks_cluster" "my-project-eks" {
  name     = "my-project-eks-${var.ENV_NAME}"
  role_arn = aws_iam_role.my-project-eks.arn
  version = var.EKS_CLUSTER_VERSION

  vpc_config {
    subnet_ids = var.PRIVATE_SUBNETS_ID
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.my-project-eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.my-project-eks-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.my-project-eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-project-eks.certificate_authority[0].data
}

resource "aws_eks_node_group" "my-project-eks-node-group" {
  cluster_name    = aws_eks_cluster.my-project-eks.name
  node_group_name = "my-project-eks-node-group-${var.ENV_NAME}"
  node_role_arn   = aws_iam_role.my-project-eks-node-group.arn
  subnet_ids      = var.PRIVATE_SUBNETS_ID
  instance_types = [ var.INSTANCE_NODE_TYPE ]

  scaling_config {
    desired_size = var.DESIRED_SIZE
    max_size     = var.MAX_SIZE
    min_size     = var.MIN_SIZE
  }

  update_config {
    max_unavailable = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEC2ContainerRegistryReadOnly,
  ]
}