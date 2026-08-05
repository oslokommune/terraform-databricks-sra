# Security Reference Architectures (SRA) - Terraform Templates

> **Note (oslokommune fork):** This is a partial fork of
> [databricks/terraform-databricks-sra](https://github.com/databricks/terraform-databricks-sra).
> We only maintain the AWS implementation (`aws/`) plus `common/` and `docs/`;
> `azure/`, `gcp/`, and upstream's GitHub Actions workflows have been removed.
> To pull in upstream changes for the paths we keep, run
> `scripts/sync-upstream.sh` — it syncs from the commit recorded in
> `.upstream-ref` and stages the result for review. Do not merge
> `upstream/main` directly; that would resurrect the deleted directories.

<p align="center">
  <img src="https://i.postimg.cc/hP90xPqh/SRA-Screenshot.png" />
</p>

## Project Overview

The [Security Reference Architecture (SRA)](https://databricks.github.io/terraform-databricks-sra/) with Terraform enables deployment of Databricks workspaces and cloud infrastructure configured with security best practices. Using the official Databricks Terraform provider, environments are programmatically set up with hardened configurations modeled after our most security-conscious customers. The included templates are built on [Databricks Security Best Practices](https://www.databricks.com/trust/security-features#best-practices), providing a strong, prescriptive foundation for secure deployments.



- [AWS and AWS GovCloud](https://databricks.github.io/terraform-databricks-sra/docs/usage/AWS/)
- [Azure](https://databricks.github.io/terraform-databricks-sra/docs/usage/Azure/)
- [GCP](https://databricks.github.io/terraform-databricks-sra/docs/usage/GCP/)

## Project Support

The code in this project is provided **for exploration purposes only** and is **not formally supported** by Databricks under any Service Level Agreements (SLAs). It is provided **AS-IS**, without any warranties or guarantees.  

Please **do not submit support tickets** to Databricks for issues related to the use of this project.  

The source code provided is subject to the Databricks [LICENSE](https://github.com/databricks/terraform-databricks-sra/blob/main/LICENSE) . All third-party libraries included or referenced are subject to their respective licenses set forth in the project license.

Any issues or bugs found should be submitted as [GitHub Issues](https://github.com/databricks/terraform-databricks-sra/issues) on the project repository. While these will be reviewed as time permits, there are **no formal SLAs** for support.

## Point-in-Time Solution

The **Security Reference Architecture (SRA)** - Terraform Templates is designed as a point-in-time solution that captures security best practices at the time of each release. 

This project **does not** guarantee backward compatibility between versions; new releases are not drop-in replacements for existing codebases.
