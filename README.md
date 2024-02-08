# Azure DevOps Agent in Docker/K8s

## Introduction

On the below microsoft documentation there is a bug with permissions. The agent tries to access the home folder which is not created yet, so you get a permissions error when running the pipeline.

## Getting Started

Please see the Microsoft documentation [here](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)
