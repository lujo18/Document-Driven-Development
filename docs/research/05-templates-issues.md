# 05-templates-issues
> **Status:** done

## Purpose

**What:** GitHub issue-template anatomy and skeletons — bug reports, feature requests, and epics — plus label and acceptance-criteria guidance. **When to read:** Standardizing how your team files issues. **Not for:** ADR templates ([04-templates-adr](./04-templates-adr.md)) or roadmap/design/feature templates ([06-templates-roadmap-design-feature](./06-templates-roadmap-design-feature.md)).

## GitHub Issue Anatomy

- **Two template formats coexist:** classic **Markdown templates** (YAML front matter `name`, `about`, `title`, `labels`, `assignees` + freeform body) and **issue forms** (YAML using GitHub's form schema with typed fields: `markdown`, `textarea`, `input`, `dropdown`, `checkboxes`, `upload`). Forms convert answers into a standard markdown issue body (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates; https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).
- **Where they live:** templates in `.github/ISSUE_TEMPLATE` on the default branch; `.md` for markdown templates, `.yml` for forms. The community checklist requires valid `name:` + `about:` (`.md`) or `name:` + `description:` (`.yml`). Ordering is alphanumeric by filename, so prefix numbers (`01-bug.yml`, `02-feature.yml`). A `config.yml` in the same folder controls the chooser (`blank_issues_enabled`, `contact_links` for support/security reporting) (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).
- **Form schema:** forms require top-level `name`, `description`, `body`; optional `title`, `labels`, `assignees`, `projects`, `type` (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms).
- **Good template anatomy:** GitHub's reference form: markdown intro → contact input → "what happened" textarea (required) → version dropdown (required) → browser multi-select dropdown → log output textarea (`render: shell`) → CoC checkbox (required) → screenshot upload (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).
- **Real-org example (VS Code):** adds pre-submission checks in HTML comments (search existing issues, test latest build, disable extensions), "Does this issue occur when all extensions are disabled?", VS Code Version, OS Version, numbered Steps to Reproduce (source: https://raw.githubusercontent.com/microsoft/vscode/main/.github/ISSUE_TEMPLATE/bug_report.md). Real-org collections are small — VS Code ships only `bug_report.md`, `feature_request.md`, `copilot_bug_report.md`, `config.yml` (source: https://api.github.com/repos/microsoft/vscode/contents/.github/ISSUE_TEMPLATE).

## Bug Report Skeleton

**When to use:** GitHub issue form (`.yml`) for structured bug intake — required fields enforced by the form, log output auto-rendered as a code block.

    name: Bug report
    description: File a bug report to help us improve.
    title: "[Bug]: "
    labels: ["bug", "triage"]
    assignees: []

    body:
      - type: markdown
        attributes:
          value: |
            Thanks for taking the time to report a bug. Please search existing
            issues first to avoid duplicates.
      - type: checkboxes
        id: searched
        attributes:
          label: Is there an existing issue for this?
          options:
            - label: I have searched the existing issues
              required: true
      - type: input
        id: version
        attributes:
          label: Version
          description: What version of the software are you running?
          placeholder: e.g. 1.0.3
        validations:
          required: true
      - type: input
        id: environment
        attributes:
          label: Environment
          description: OS, runtime, device or browser
          placeholder: e.g. macOS 14, Node 20, Chrome 128
        validations:
          required: true
      - type: textarea
        id: what-happened
        attributes:
          label: What happened?
          description: What did you expect to happen, and what actually happened?
          placeholder: Tell us what you see!
        validations:
          required: true
      - type: textarea
        id: reproduction
        attributes:
          label: Steps to reproduce
          placeholder: |
            1. Go to '...'
            2. Click on '...'
            3. Scroll to '...'
            4. See error
        validations:
          required: true
      - type: textarea
        id: logs
        attributes:
          label: Relevant log output
          description: Paste log output — it will be rendered as a code block.
          render: shell
        validations:
          required: false
      - type: upload
        id: screenshots
        attributes:
          label: Screenshots / video
          description: If applicable, add screenshots or a screen recording.
        validations:
          required: false

## Feature Request Skeleton

**When to use:** classic Markdown template (`.md`) for lighter-weight asks; front matter auto-fills title and labels, body guides the writer through problem, behavior, and scope.

    ---
    name: Feature request
    about: Suggest an idea for this project
    title: "[Feature]: "
    labels: ["enhancement"]
    assignees: ''
    ---

    <!-- Before submitting: search existing issues and discussions for duplicates. -->

    ### Problem statement
    <!-- What pain point does this solve, and for whom? One or two sentences. -->

    ### Proposed behavior
    <!-- What should the feature do? Describe the happy path and edge cases. -->

    ### Alternatives considered
    <!-- What workarounds exist today, and why are they insufficient? -->

    ### Success criteria
    <!-- How would we know this feature is done and correct? Bullets or Given/When/Then. -->

    ### Out of scope
    <!-- What is deliberately NOT included in this request? -->

## Chore Skeleton

**When to use:** a Markdown planning template for epics/large bodies of work; each scope item becomes a child issue and definition of done prevents silent growth.

    ---
    name: Epic
    about: A large body of work that spans multiple issues
    title: "[Epic]: "
    labels: ["epic"]
    assignees: ''
    ---

    ### Objective
    <!-- One sentence: what outcome does this epic deliver? Should link to an OKR or roadmap item. -->

    ### Context
    <!-- Why now? What decisions are already made? Link the design doc or ADR. -->

    ### Scope
    <!-- Bulleted list of the user-visible capabilities. Each becomes a child issue. -->
    - [ ] <!-- Capability 1 (link issue) -->
    - [ ] <!-- Capability 2 (link issue) -->

    ### Non-goals
    <!-- Explicitly excluded work, so the epic does not silently grow. -->

    ### Definition of done
    <!-- The shippable state: what is true for users/ops when this epic closes?
         e.g. feature shipped behind flag, docs updated, telemetry verified, no open P1s. -->

    ### Dependencies
    <!-- Other epics, ADRs, external vendors, or sequencing constraints. -->

## Labels & Acceptance Criteria

- **Labels guide triage:** templates attach default labels via front matter (`labels: ["bug", "triage"]`) so issues land pre-tagged and filterable; labels are declared per template and enforced by the chooser (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).
- **Ordering by number:** prefix filenames (`01-bug.yml`, `02-feature.yml`) because the chooser orders templates alphanumerically by filename (source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).
- **Acceptance criteria as Given/When/Then:** write criteria as observable outcomes — `Given` initial context → `When` action/event → `Then` expected outcome — so the issue doubles as an executable specification (source: https://cucumber.io/docs/gherkin/reference/).

## Sources

- https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates — GitHub, about issue & PR templates
- https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository — GitHub, configuring issue templates
- https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms — GitHub, issue form schema
- https://raw.githubusercontent.com/microsoft/vscode/main/.github/ISSUE_TEMPLATE/bug_report.md — VS Code bug report template
- https://api.github.com/repos/microsoft/vscode/contents/.github/ISSUE_TEMPLATE — VS Code issue template set
- https://cucumber.io/docs/gherkin/reference/ — Gherkin executable specification reference
