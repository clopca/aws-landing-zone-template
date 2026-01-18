"""
Custom Checkov check to enforce required tags on all resources.

This check ensures that all taggable resources have the required tags:
- ManagedBy
- Environment
"""

from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckResult, CheckCategories


class RequiredTagsCheck(BaseResourceCheck):
    def __init__(self):
        name = "Ensure all resources have required tags (ManagedBy, Environment)"
        id = "CKV_CUSTOM_1"
        supported_resources = [
            "aws_vpc",
            "aws_subnet",
            "aws_security_group",
            "aws_instance",
            "aws_s3_bucket",
            "aws_iam_role",
            "aws_lambda_function",
            "aws_rds_cluster",
            "aws_dynamodb_table",
        ]
        categories = [CheckCategories.CONVENTION]
        super().__init__(
            name=name,
            id=id,
            categories=categories,
            supported_resources=supported_resources,
        )

    def scan_resource_conf(self, conf):
        required_tags = ["ManagedBy", "Environment"]

        tags = conf.get("tags", [{}])
        if isinstance(tags, list):
            tags = tags[0] if tags else {}

        if not tags:
            return CheckResult.FAILED

        for tag in required_tags:
            if tag not in tags:
                return CheckResult.FAILED

        return CheckResult.PASSED


check = RequiredTagsCheck()
