# QuizNova Platform Infrastructure - Agent Guidelines

This guide establishes the architectural context, multi-machine workflow,
secrets management, and local emulation rules for agents working on this
codebase.

---

## 1. Repository Ecosystem & Architecture

This repository (`quiznova-infra`) serves as the platform control plane and
single source of truth for the `quiz-nova` organization.

### Repository Links & Roles

1. **`quiznova-infra` (Current Repository)**:
   - Platform Infrastructure as Code managed via Terraform and GitHub App
     automation (`quiznova-terraform-bot`).
   - Provisions organization repositories, environment branch protection rules,
     Doppler service account memberships, and foundational Azure resources
     (resource group `quiznova-rg`, storage account `stquiznova`, and tfstate
     blob containers).
2. **`quiznova-api` (`../quiznova-api`)**:
   - Backend service built with .NET 9 (ASP.NET Core Clean Architecture).
   - Backed by PostgreSQL and MongoDB Atlas.
   - Deployed as Azure Container Apps (`quiznova-api-dev`, `stg`, `prd`) using
     Managed Identities for Azure Key Vault secret access.
3. **`quiznova-web` (`../quiznova-web`)**:
   - Single Page Application built with Angular 19.
   - Production is hosted on **GitHub Pages CDN** for apex domain `quiznova.dev`
     and `www`.
   - Development and staging previews run as Azure Container Apps
     (`quiznova-web-dev`, `stg`) with scale-to-zero enabled.

---

## 2. Multi-Machine Development Protocol

The development team operates across several physical machines.

> [!IMPORTANT] **Always pull before starting work**: Agents must always
> synchronize with the remote repository before making changes, planning tasks,
> or running commands:
>
> ```bash
> git pull origin "$(git branch --show-current)"
> ```
>
> Never assume local branches reflect the latest commits pushed from other
> workstations.

---

## 3. Secret Management via Doppler

All environment variables, API tokens, and provider credentials are centrally
managed in Doppler.

### Operational Rules

- **Doppler is Mandatory**: Terraform plans and applies cannot execute without
  Doppler because credentials (GitHub App PEM, Datadog keys, Azure client IDs)
  are injected dynamically at runtime.
- **Never Hardcode Secrets**: All secrets must be referenced via Doppler
  projects.
- **Execution Pattern**: Always prefix commands with `doppler run`:

  ```bash
  doppler run --project quiznova-infra --config prd -- terraform <command>
  ```

### Doppler Project Mapping

| Project          | Environment Configs | Target Usage                    |
| :--------------- | :------------------ | :------------------------------ |
| `quiznova-infra` | `prd`               | Platform Terraform & GitHub App |
| `quiznova-api`   | `dev`, `stg`, `prd` | Backend DBs, JWT, Key Vault     |
| `quiznova-web`   | `dev`, `stg`, `prd` | Frontend runtime environments   |

---

## 4. LocalStack Azure Emulation & State Isolation

To avoid exhausting Azure for Students credits and prevent remote state locks,
local development and integration testing use LocalStack's Azure emulator.

> [!CAUTION] **Never Run Local Tests Against Real Azure State**: The real Azure
> state file lives in `stquiznova` blob storage. If Terraform queries LocalStack
> while pointing to the real Azure state file, Terraform will assume live cloud
> resources were deleted and will corrupt remote state.

### Local Tooling & Automation Scripts

Use the version-controlled automation scripts in `scripts/`:

#### 1. Terraform against LocalStack (`scripts/localstack-tf.sh`)

Temporarily generates `localstack_override.tf` (ignored by Git), overrides the
`azurerm` endpoint to `azure.localhost.localstack.cloud:4566`, switches backend
state to `localstack.tfstate`, and executes via Doppler. Terraform working data
is isolated in `~/.cache/quiznova-localstack/` (`TF_DATA_DIR`), so the real
`.terraform/` stays bound to the `azurerm` backend, and the override file is
deleted on exit (including failures and Ctrl+C):

```bash
# Plan changes locally
./scripts/localstack-tf.sh plan

# Apply changes locally
./scripts/localstack-tf.sh apply

# Target another module (e.g., API environment)
./scripts/localstack-tf.sh plan ../quiznova-api/terraform/environments/dev
```

> [!WARNING] **Before any real `plan`/`apply`**, confirm no LocalStack override
> is present and the backend is `azurerm`. If either check fails, delete the
> override and run `terraform init -reconfigure` first:
>
> ```bash
> test ! -f terraform/localstack_override.tf || echo "STOP: override"
> jq -r .backend.type \
>   terraform/.terraform/terraform.tfstate # expect azurerm
> ```
>
> The Doppler provider also needs `DOPPLER_TOKEN`, which `doppler run` does not
> inject:
>
> ```bash
> export DOPPLER_TOKEN="$(doppler configure get token --plain)"
> doppler run --project quiznova-infra --config prd -- \
>   terraform -chdir=terraform apply
> ```

#### 2. Cross-Machine State Sync via Cloud Pods (`scripts/snapshot-sync.sh`)

Because the team works across several workstations, LocalStack Pro Cloud Pods
are used to sync local state snapshots without committing state to Git:

```bash
# Save local state to cloud workspace
./scripts/snapshot-sync.sh save

# Restore local state on another machine
./scripts/snapshot-sync.sh load
```

The standard baseline snapshot name is `pod:quiznova-localstack-base`.

---

## 5. Git Safety & Public Repository Rules

- All QuizNova repositories are **public**.
- Terraform state files (`*.tfstate`) contain plaintext secrets (database
  connection strings, private keys, tokens).
- **Rule**: Never remove `.tfstate`, `localstack_*.tf`, or `.lstk/` from
  `.gitignore`. If state files are accidentally generated, ensure they remain
  untracked.
