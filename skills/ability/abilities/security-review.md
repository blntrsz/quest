---
name: security-review
description: Scan a codebase or path for security vulnerabilities the way a researcher would — trace user input to dangerous sinks, self-verify every finding, and propose patches for human approval. Use for "is my code secure", a security audit, injection or XSS, hardcoded secrets, authentication and access-control bugs, or vulnerable dependencies.
---

# Security review

Reason about the code the way a security researcher does. Understand the context, trace how user input moves through the application, and verify each finding before you report it. Pattern matching misses the vulnerabilities that only show up across files. This review follows the data.

The review reads and reasons. It changes nothing. Every patch is a proposal a human applies.

## Workflow

Follow these steps in order.

1. **Resolve the scope.** Scan the path the user named, or the whole project from its root. Identify the languages and frameworks from the manifests (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `Gemfile`, `composer.json`).
2. **Audit dependencies.** Do this first. The wins are fast. Check the lockfiles (`package-lock.json`, `Gemfile.lock`, `go.sum`, and their equivalents) for packages with known CVEs, deprecated crypto libraries, or pinned versions old enough to matter.
3. **Scan for secrets and exposure.** Read every file, including config, `.env`, CI workflows, Dockerfiles, and infrastructure code. Look for hardcoded API keys, tokens, passwords, and private keys; committed `.env` files; secrets in comments or debug logs; cloud credentials (AWS, GCP, Azure, Stripe, Twilio); and connection strings with credentials inside them. Apply both regex patterns and entropy heuristics.
4. **Deep-scan the source.** Walk the categories below against the diff or the scope. Reason about each site rather than stopping at a pattern match.
5. **Trace data flows across files.** After the per-file pass, take the holistic view. Follow user-controlled input from its entry points (HTTP parameters, headers, body, uploads) all the way to its sinks (database queries, process calls, HTML output, file writes). Look for vulnerabilities that appear only when several files are read together, and check the trust boundaries between services and modules.
6. **Self-verify every finding.** For each one: re-read the code with fresh eyes. Ask whether the vulnerability is truly exploitable, and whether sanitization, middleware, or the framework already handles it upstream. Downgrade or discard anything that is not a genuine vulnerability, then set the final severity.
7. **Write the report**, in the shape below.
8. **Propose patches.** For every CRITICAL and HIGH finding, give a concrete fix.

For a large codebase, fan the deep scan out to parallel sub-agents, one per area or module, and run the self-verification pass yourself over their findings.

## Injection flaws

- **SQL injection.** Raw queries built by string interpolation, ORM raw fragments, and second-order input that is stored now and used in a query later. Safe: parameterized queries and bound parameters.
- **Cross-site scripting (XSS).** Unescaped output, `innerHTML`, `dangerouslySetInnerHTML`, and template injection. Safe: contextual escaping, which most frameworks do by default.
- **Command injection.** `exec`, `spawn`, and `system` calls that receive user input. Safe: pass an argument array, and keep the shell out of the call.
- **LDAP, XPath, header, and log injection.** The same shape as the others: user input reaches an interpreter without escaping.

## Authentication and access control

- **Missing authentication** on a sensitive endpoint.
- **Broken object-level authorization** (IDOR, BOLA): an endpoint trusts an object id the caller supplied.
- **JWT weaknesses**: `alg:none`, a weak signing secret, and missing signature or expiry checks.
- **Session fixation**, and missing CSRF protection on state-changing requests.
- **Privilege escalation**, mass assignment, and parameter pollution.

## Data handling

- Sensitive data in logs, error messages, or API responses.
- Missing encryption at rest or in transit.
- Insecure deserialization of untrusted input.
- Path traversal and directory traversal.
- XML external entity (XXE) processing.
- Server-side request forgery (SSRF), where a server fetches a URL the user chose.

## Cryptography

- MD5, SHA1, and DES used for a security purpose.
- A hardcoded initialization vector or salt.
- Weak randomness for tokens, such as `Math.random()`.
- Missing TLS certificate validation.

## Business logic

- Race conditions, including time-of-check to time-of-use.
- Integer overflow in financial calculations.
- Missing rate limiting on a sensitive endpoint.
- Predictable resource identifiers.

## Severity

| Severity | Meaning | Example |
|----------|---------|---------|
| **CRITICAL** | Immediate exploitation risk, data breach likely | SQL injection, remote code execution, auth bypass |
| **HIGH** | Serious vulnerability, an exploit path exists | XSS, IDOR, hardcoded secret |
| **MEDIUM** | Exploitable under conditions or by chaining | CSRF, open redirect, weak crypto |
| **LOW** | Best-practice violation, low direct risk | Verbose errors, missing headers |
| **INFO** | Worth noting, not a vulnerability | Outdated dependency with no CVE |

## Report shape

- Lead with a findings summary table: counts by severity.
- Group findings by category, not by file.
- For each finding, give the file path, the line, the vulnerable snippet, the risk in plain English (what could an attacker do with this?), a confidence rating of High, Medium, or Low, and the severity.
- When the codebase is clean, say so plainly: "No vulnerabilities found", with what was scanned.

## Propose patches

For every CRITICAL and HIGH finding, show the vulnerable code, show the fixed code, and explain what changed and why. Preserve the original code style, variable names, and structure, and add an inline comment that explains the fix.

Close by stating: **Review each patch before applying. Nothing has been changed yet.**

## Done when

Every category has been scanned, every finding has survived the self-verification pass, and the report and patches are in front of the user. Nothing is applied.
