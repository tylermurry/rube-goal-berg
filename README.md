# Guiding Principles for This Project

1. A quality local environment is just as important as a quality production environment
2. Artificial complexity is not a license for low quality

# Important Decisions

### Why do this?
Easy. I wanted to get hands-on experience with building, deploying, managing and monitoring a kube-first product.
Additionally, I wanted more direct experience with languages/frameworks outside of my comfort zone.
This seemed as good a way as any to give it a go.  

### Mono Repo
The use of a mono repo was chosen strictly out of code convenience and organization.
Due to the highly mixed nature of module frameworks, there is very little synergy between build systems so frameworks like Lerna, etc.
While heterogeneous tooling like Bazel, Buck or others might introduce more build rigor and solve dependency management concerns, ultimately it's just overkill - even for a project designed to overkill.

One benefit of this mono repo is that all Helm charts are centralized allowing for easy deployment through an umbrella chart.
This helps simplify both local development and testing. 

# Local Development
To ease the burden of local development, this project includes several helper scripts.
To be as DRY as possible, these scripts simply re-use the same underlying logic used in the CI/CD pipelines.

## Deploying Modules to a Local Cluster
Deploying to your local cluster is supported by running the following script: `./.scripts/local/process-and-deploy.sh <module_name>`.

The script accepts a single parameter, `module_name` which can have the following values:
* `changes` - Build and deploy only modules that have changed since the last `deploy` tag
* `all` - Build and deploy all modules
* `<module_name>` - Builds and deploys only the module name specified (e.g. `frontend-web`)

## Verifying the Product Chart Against a Kind Cluster
Verification locally against a King cluster locally is supported by funning the following: `./.scripts/local/process-and-verify.sh <module>`

The script accepts a single parameter, `<module_name>`, which will have the same possilbe values as the `process-and-deploy` script.
One unique difference is that this will startup a local docker registry on `localhost:5000` and wire that into the Kind cluster to allow it to pull images successfully.

NOTE: This registry is stopped at the end of execution.
