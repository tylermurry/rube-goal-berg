# Important Decisions
### Mono Repo
The use of a mono repo was chosen strictly out of code convenience and organization.
Due to the highly mixed nature of module frameworks, there is very little synergy between build systems so frameworks like Lerna, etc.
While heterogeneous tooling like Bazel, Buck or others might introduce more build rigor and solve dependency management concerns, ultimately it's just overkill - even for a project designed to overkill.

One benefit of this mono repo is that all Helm charts are centralized allowing for easy deployment through an umbrella chart.
This helps simplify both local development and testing. 

