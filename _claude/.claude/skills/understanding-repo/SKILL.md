---
name: understanding-repo
description: Use when the user types /understanding-repo, or opens an unfamiliar repository and wants to know what it is for, what it is built with, how to run it, which outside services it uses, where and how it is deployed and monitored, who owns it, and what they are missing to change and deploy it themselves.
argument-hint: "[path or area] [code map] [risks]"
allowed-tools: [Bash, Read, Glob, Grep, Agent, Write, AskUserQuestion]
---

# /understanding-repo — what is this repo and can I ship it

Study the repository in the current folder (or `$ARGUMENTS`) and report back in the fixed
structure below, then save it to `docs.md` at the repo root. Apart from that one file this is
read-only: change no other files, deploy nothing, log in to nothing.

## How to look

- Start with the README, docs folder, `CLAUDE.md`/`AGENTS.md`, package manifests, and the
  top-level folder layout. Then follow the deployment trail: `*.tf`/`*.tfvars`, CDK/Pulumi/
  Serverless/SAM, `Dockerfile`/compose, Helm/k8s manifests, `vercel.json`, `netlify.toml`,
  `fly.toml`, `wrangler.toml`, `app.yaml`, `Procfile`, `.github/workflows`, `.gitlab-ci.yml`,
  `Makefile`/`justfile`, deploy scripts, `.env.example`.
- For a large repo, send `Explore` agents in parallel (one for code/stack, one for
  infra/deploy) and keep only their conclusions.
- Live checks are allowed only if a CLI is already logged in, and only read-only calls
  (`aws sts get-caller-identity`, `aws ec2 describe-instances`, `vercel project ls`,
  `gcloud config list`, `terraform state list`, `gh secret list`). Never `apply`, `deploy`,
  `push`, or anything that writes. Say which facts came from code and which from a live check.
- **Never print secret values.** Name secrets and env vars, never show what they contain.
- Every claim about infra or deployment cites where it came from (`path:line`). If something
  is guessed rather than found, mark it **(inferred)**. If it was not found, say "not found".

## Report

Use exactly these headings, in this order. Keep sections 1 and 2 short; spend the depth on
Deployment.

### 1. What it is

Three to six sentences: the idea behind the repo, who uses it and for what, why it exists.
Then two short lists: **Can do** and **Cannot do / out of scope**.

### 2. Stack

A table with one row per layer: Infrastructure as code, Backend, Frontend, Data stores,
CI/CD, Other (queues, auth). Name the language/framework and main version. Skip layers the
repo does not have. One line that sums up what kind of repo it is ("Next.js app on Vercel
with a Supabase database", "Terraform monorepo for three AWS accounts").

### 3. Run it locally

The commands to install, configure, start, test and seed data, taken from the README,
manifests, `Makefile`, compose files and CI. Note what each needs (a local database, Docker,
a cloud login). Say whether it would work on this machine today and what fails if not. Do not
run installs or start services; `--version` checks are fine.

### 4. Outside services

A table of third-party services the code talks to (payments, auth, email, analytics, AI
APIs, storage, maps): service | used for | env var / config that holds its key | source.

### 5. Deployment

- **Where:** each platform and account found — AWS account IDs and regions, GCP projects,
  Vercel team/project, Cloudflare account, Kubernetes clusters, domains. A table:
  platform | account / project | environment | source.
- **Environments:** dev / staging / prod, and how they differ.
- **What runs there:** go deep. For every deployed piece: the resource type and size
  (instance type, Lambda memory, container CPU/RAM, DB engine and class, replicas, autoscaling),
  networking (VPC, load balancer, DNS, CDN), storage, and how the pieces connect. Add a small
  text diagram when there are more than three pieces.
- **How it gets there:** the exact path from a commit to production — which workflow or
  command, what triggers it, which branch, approvals, where Terraform state lives, how
  rollbacks work if visible.

### 6. Monitoring

Where logs go, error tracking (Sentry, Datadog, CloudWatch...), metrics and dashboards,
alerts and who receives them, health-check endpoints. Say "none found" plainly if so.

### 7. Health and owners

- Tests: what kinds exist and roughly how much. CI: the status of the latest runs on the main
  branch (`gh run list --branch <main> --limit 5` if `gh` is logged in).
- Activity: date of the last commit, and how active the last three months were.
- Owners: main contributors by recent commits (`git shortlog -sn --since=1.year`),
  `CODEOWNERS` if present.

### 8. What you are missing to change and deploy

Check this machine against what the repo needs and list only the gaps:

- CLIs and runtimes not installed or at the wrong version (`command -v`, `--version`).
- Logins and access: which accounts or roles are needed and whether you are logged in.
- Env vars and secrets: names in `.env.example` / code / CI that are not set locally.
- CI secrets or permissions the workflows rely on that you would need to own.
- Anything else blocking a first local run or a first deploy.

End with a numbered list: the steps to go from here to "I can make a change and deploy it".

### Only on request: Code map, Risks

Leave these out unless `$ARGUMENTS` or the user asks for them. When asked, add them after
section 8 (and to `docs.md`):

- **Code map:** the main entry points, the important folders and one line on each, and how a
  typical request or job flows through the code.
- **Risks:** hard-coded values and IDs, infra changed outside the IaC (if a live check shows
  drift), deprecated or unmaintained dependencies, TODO/FIXME on critical paths, the most
  expensive resources, single points of failure.

When the Code map was not asked for, end the chat reply with one line offering it.

## Save it

Write the full report to `docs.md` at the repo root so later sessions can read it instead of
redoing the research. Start the file with:

```
# Repo overview
_Generated by /understanding-repo on YYYY-MM-DD at commit <short sha>._
```

- If `docs.md` already exists and starts with that header, replace it.
- If it exists with other content, ask with `AskUserQuestion` whether to overwrite, append the
  report as a section, or write to `docs/repo-overview.md` instead.
- Do not commit it. In the chat, give the short version (one line per section plus the
  numbered steps) and the path to the file.
- On a later run, read the existing `docs.md` first, check what changed since its commit
  (`git log <sha>..HEAD --stat`), and update only what is out of date.
