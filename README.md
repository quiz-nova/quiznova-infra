# QuizNova Infrastructure

Platform Infrastructure as Code for the `quiz-nova` GitHub organization, managed
via Terraform, Doppler, and GitHub App automation.

---

## Overview

This repository serves as the single source of truth for the `quiz-nova` GitHub
organization. All organization repositories, configurations, and platform-level
resources are managed declaratively using Terraform without manual changes in
the GitHub dashboard.

Authentication to GitHub is handled by an organization-scoped GitHub App
(`quiznova-terraform-bot`), eliminating dependency on personal access tokens.
Credentials and secrets are managed centrally in Doppler (`quiznova-infra`
project).

---

## Prerequisites

- [Terraform](https://www.terraform.io/) (>= 1.5.0)
- [Doppler CLI](https://docs.doppler.com/docs/cli)
- GitHub organization access to `quiz-nova`

---

## Doppler Configuration

Secrets required for Terraform execution are stored in Doppler under the
`quiznova-infra` project (`prd` config):

| Secret Name                  | Description                                |
| :--------------------------- | :----------------------------------------- |
| `GITHUB_OWNER`               | Target GitHub organization (`quiz-nova`)   |
| `GITHUB_APP_ID`              | GitHub App numeric ID (`5241495`)          |
| `GITHUB_APP_INSTALLATION_ID` | Organization Installation ID (`169355840`) |
| `GITHUB_APP_PEM_FILE`        | Raw RSA private key content (PEM format)   |

---

## Quick Start

### 1. Initialize Terraform

```bash
doppler run --project quiznova-infra --config prd -- \
  terraform -chdir=terraform init
```

### 2. Plan Changes

```bash
doppler run --project quiznova-infra --config prd -- \
  terraform -chdir=terraform plan
```

### 3. Apply Changes

```bash
doppler run --project quiznova-infra --config prd -- \
  terraform -chdir=terraform apply
```

---

## Managed Repositories

| Repository       | Visibility | Description                     |
| :--------------- | :--------- | :------------------------------ |
| `quiznova-web`   | Public     | QuizNova Web Application        |
| `quiznova-api`   | Public     | QuizNova Backend API            |
| `quiznova-infra` | Public     | Platform Infrastructure as Code |
