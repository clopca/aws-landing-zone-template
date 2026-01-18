#!/usr/bin/env python3
"""
Render Jinja2 templates for Terraform configurations.

Usage:
    python render.py --template providers.tf.j2 --output providers.tf \
        --var account_id=123456789012 \
        --var region=us-east-1 \
        --var role_name=TerraformRole

    python render.py --template backend.tf.j2 --output backend.tf \
        --config config.yaml
"""

import argparse
import sys
from pathlib import Path

try:
    from jinja2 import Environment, FileSystemLoader, StrictUndefined
    import yaml
except ImportError:
    print(
        "Error: Required packages not installed. Run: pip install -r requirements.txt"
    )
    sys.exit(1)


def parse_var(var_string: str) -> tuple[str, str]:
    """Parse a key=value string into a tuple."""
    if "=" not in var_string:
        raise ValueError(f"Invalid variable format: {var_string}. Expected key=value")
    key, value = var_string.split("=", 1)
    return key.strip(), value.strip()


def load_config(config_path: str) -> dict:
    """Load variables from a YAML config file."""
    with open(config_path, "r") as f:
        return yaml.safe_load(f) or {}


def render_template(
    template_name: str, variables: dict, template_dir: str = "."
) -> str:
    """Render a Jinja2 template with the given variables."""
    env = Environment(
        loader=FileSystemLoader(template_dir),
        undefined=StrictUndefined,
        trim_blocks=True,
        lstrip_blocks=True,
    )
    template = env.get_template(template_name)
    return template.render(**variables)


def main():
    parser = argparse.ArgumentParser(
        description="Render Jinja2 templates for Terraform"
    )
    parser.add_argument("--template", "-t", required=True, help="Template file name")
    parser.add_argument("--output", "-o", help="Output file (default: stdout)")
    parser.add_argument(
        "--var", "-v", action="append", default=[], help="Variable in key=value format"
    )
    parser.add_argument("--config", "-c", help="YAML config file with variables")
    parser.add_argument("--template-dir", "-d", default=".", help="Template directory")

    args = parser.parse_args()

    variables = {}
    if args.config:
        variables.update(load_config(args.config))

    for var in args.var:
        key, value = parse_var(var)
        variables[key] = value

    try:
        rendered = render_template(args.template, variables, args.template_dir)
    except Exception as e:
        print(f"Error rendering template: {e}", file=sys.stderr)
        sys.exit(1)

    if args.output:
        Path(args.output).write_text(rendered)
        print(f"Rendered template written to: {args.output}")
    else:
        print(rendered)


if __name__ == "__main__":
    main()
