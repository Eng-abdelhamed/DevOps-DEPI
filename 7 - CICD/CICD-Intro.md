# Comprehensive Guide to CI/CD and GitHub Actions

This repository serves as a personal documentation and reference guide for Continuous Integration (CI), Continuous Delivery/Deployment (CD), and automation using GitHub Actions workflow pipelines.

---

## 1. Core Concepts: CI vs. CD

### Continuous Integration (CI)
Continuous Integration is a software development practice where developers regularly merge their code changes into a central shared repository (such as the main branch in Git).
Every merge triggers an automated pipeline to build, check dependencies, scan for security issues, and test the code.

**The Key Principles of CI:**
* **Pull Frequently:** Regularly updating your local environment with the remote repository to avoid merge conflicts and "Merge Hell".
* **Validate Every Commit:** Running compilation and automated tests on every single change.
* **Fail Fast:** Stopping the pipeline execution sequentially the exact moment an issue is found (e.g., stopping tests if the build fails) to minimize wasted time.
* **Automation:** Automating the repetitive processes of compiling, testing, and formatting.
* **Continuous Feedback:** Ensuring developers receive instant reports regarding the stability and safety of their code changes.

### Continuous Delivery vs. Continuous Deployment (CD)
* **Continuous Delivery:** The automated pipeline thoroughly prepares and packages the release artifact, but human approval (a manual button click) is required to deploy it to the live production server.
* **Continuous Deployment:** There is zero human intervention. If the CI pipeline passes all tests, the artifact is instantly and automatically deployed to production.

---

## 2. Automated CI/CD Pipeline Stages

A standard automated pipeline consists of sequential checkpoints:

1. **Dependency Check:** Inspecting third-party package libraries for known security vulnerabilities or licensing issues.
2. **Code Scanning (Static Analysis):** Evaluating the codebase structure without executing it (using tools like SonarQube) to catch code smells, bugs, and enforce quality rules.
3. **Unit Testing & Code Coverage:** Verifying individual software functions and measuring what percentage of the codebase is covered by these automated tests.
4. **Quality Gates:** Strict criteria boundaries (e.g., Code Coverage > 95%). If the code violates the gate rules, the pipeline fails and halts.
5. **Artifact Build:** Compiling the validated code into a tangible, deployable package (e.g., `.hex` / `.bin` files for Embedded Systems, or Docker Images).
6. **Binary Repository Management:** Storing and managing the versioned artifacts inside secure managers (like JFrog Artifactory) where they can be promoted through environment stages.

---

## 3. GitHub Actions Architecture and Triggers

GitHub Actions is an automation platform that allows you to execute workflows directly inside your repository.

### Essential Components
* **Workflow:** The automated process defined in a `.yaml` file inside the `.github/workflows/` directory.
* **Job:** A set of sequential steps executed on a fresh virtual environment runner.
* **Step:** An individual task that can run a command or call an "Action".
* **Action:** Reusable, standalone code blocks (like plugins) that perform common tasks (e.g., checking out code, setting up runtime environments).

### Workflow Triggers & Filters
To prevent workflows from running needlessly on every push, we restrict them using filters:
* **Branches:** Restricting execution to specific branches (e.g., `main`).
* **Tags:** Triggering the pipeline only when a release version tag is created (e.g., `v1.0.0`).
* **SHA (Commit SHA):** A unique cryptographic hash representing the exact commit ID, serving as an identity tag for artifacts and debugging logs.

---

## 4. Practical Hands-on Implementations

### Bash Scripting Automation (`bash.sh`)
This script automates installing a package tool, safely handles package management for scripts, and redirects the terminal output directly into a tracking text file.

```bash
#!/bin/bash
sudo apt-get update
sudo apt-get install -y cowsay

```

```yaml
name: firstAction

# Trigger the workflow only when code is pushed to the repository
on: push

jobs:
  # Job 1: Responsible for building the file and creating the artifact
  first-jop:
    runs-on: ubuntu-latest
    steps:
    # Essential action to clone the source code onto the blank runner machine
    - name: Checkout
      uses: actions/checkout@v4

    # Making the script executable and running it to create the target file
    - name: ExecutingBash
      run: |
        chmod +x bash.sh
        ./bash.sh

    # Uploading the generated file outside the temporary runner environment
    - name: artifact upload
      uses: actions/upload-artifact@v4
      with:
        name: dragon-text-file
        path: dragon.txt

  # Job 2: Responsible for validating the contents of the generated artifact
  test-jop2:
    needs: first-jop # This job will wait and only run if first-jop completes successfully
    runs-on: ubuntu-latest
    steps:
    # Downloading the artifact from the shared GitHub cloud storage
    - name: artifact Download
      uses: actions/download-artifact@v4
      with:
        name: dragon-text-file

    # Running an automated search check to verify specific strings exist inside the file
    - name: dragon file Exists
      run: grep -i "hellodragon" dragon.txt

  # Job 3: Responsible for logging the final result
  test-jop3:
    needs: [first-jop, test-jop2] # Waits for both previous jobs to finish flawlessly
    runs-on: ubuntu-latest
    steps:
    - name: artifact Download
      uses: actions/download-artifact@v4
      with:
        name: dragon-text-file

    # Outputting the complete file text content onto the pipeline console logs
    - name: Read File
      run: cat dragon.txt
```
