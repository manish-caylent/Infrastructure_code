# Module Security Group

 Terraform module that creates a security group inside a VPC.

## Usage Examples

### Creating a Security Group

This example shows how to create a simple security group allowing HTTPS and HTTP connections from the internet.

```bash
module "security-group" {
  source = "../"
  name   = "iiq-test-sg"
  vpc_id = "vpc-11112222333344445"
  ingress = [
    {
      description = "Allow HTTPS connections from the internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP connections from the internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [
    {
      description = "Default rule"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


  tags = {
    Environment  = "Dev"
    Terraform    = true
    CostCenter   = 00000
    OwnedBy      = "iiq"
    Application  = "App"
    DeploymentID = "UniqId"
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_egress"></a> [egress](#input\_egress) | List of maps containing egress rules that will be configured for in the security group. | `any` | n/a | yes |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | List of maps containing ingress rules that will be configured for in the security group. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the security group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(any)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the security group will be created. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The security group description. Defaults to "Managed by Terraform". | `string` | `"Managed by Terraform"` | no |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The security group ARN. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The security group ID. |
<!-- END_TF_DOCS -->