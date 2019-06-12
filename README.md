# chartpress (modified fork)

Automate building and publishing helm charts and associated images.

This is used as part of the JupyterHub and Binder projects.

Chartpress will:

- build docker images and tag them with the latest git commit
- publish those images to DockerHub
- rerender a chart to include the tagged images
- publish the chart and index to gh-pages

A `chartpress.yaml` file contains a specification of charts and images to build.

For example:

```yaml
charts:
  # list of charts by name
  # each name should be a directory containing a helm chart
  - name: binderhub
    # the prefix to use for built images
    imagePrefix: jupyterhub/k8s-
    # tag to use when resetting the chart values
    # with --reset command-line option (defaults to "set-by-chartpress")
    resetTag: latest
    # Optional image tag prefix
    imageTagPrefix: ''
    # Optional prefix for git tags if enabled, if you have multiple separately versioned
    # charts you should set this for each chart
    gitTagPrefix: ''
    # the git repo whose gh-pages contains the charts
    repo:
      git: jupyterhub/helm-chart
      published: https://jupyterhub.github.io/helm-chart
    # additional paths (if any) relevant to the chart version
    # outside the chart directory itself
    paths:
      - ../setup.py
      - ../binderhub
    # images to build for this chart (optional)
    images:
      binderhub:
        # Context to send to docker build for use by the Dockerfile
        # (if different from the current directory)
        contextPath: ..
        # Dockerfile path, if different from the default
        # (may be needed if contextPath is set)
        dockerfilePath: images/binderhub/Dockerfile
        # path in values.yaml to be updated with image name and tag
        valuesPath: image
        # additional paths (if any) relevant to the image
        # outside the image directory itself
        paths:
          - ../setup.py
          - ../binderhub
```

## Requirements

The following binaries must be in your `PATH`:
- git
- helm

If you are publishing a chart to GitHub Pages create a `gh-pages` branch in the destination repository.

## Usage

In a directory containing a `chartpress.yaml`, run:

    chartpress

to build your chart(s) and image(s). Add `--push` to publish images to docker hub and `--publish-chart` to publish the chart and index to gh-pages.

```
usage: chartpress [-h] [--commit-range COMMIT_RANGE] [--push]
                  [--publish-chart] [--tag TAG]
                  [--extra-message EXTRA_MESSAGE]

Automate building and publishing helm charts and associated images. This is
used as part of the JupyterHub and Binder projects.

optional arguments:
  -h, --help            show this help message and exit
  --commit-range COMMIT_RANGE
                        Range of commits to consider when building images
  --push                push built images to docker hub
  --publish-chart       publish updated chart to gh-pages
  --tag TAG             Use this tag for images & charts
  --extra-message EXTRA_MESSAGE
                        extra message to add to the commit message when
                        publishing charts
```

### Example of releasing images and charts

Chartpress includes flags to help in the release process.
```
chartpress --git-release --tag-latest --push --publish-chart --git-push
```
This will process each Helm chart independently.
If a git tag matching the chart version exists nothing will be done with the chart.
Otherwise:
- Any images in the chart will be built, tagged with the chart version and `latest`, and pushed to the Docker registry.
- The chart will be built and pushed to the configured GitHub Pages repository
- The repository will be git tagged with the chart version, and the tagged will be pushed.
  The commit containing the changes for the tag will be a detached commit for the tag(s) only, it will not be included in your current branch

If you have multiple independently versioned charts you must define `gitTagPrefix` in `chartpress.yaml` to ensure git tags for the two charts can be distinguished.

### GitHub Action

A Dockerfile is included that can be used as a [GitHub Action](https://github.com/features/actions).

### Caveats

#### Shallow clones

Chartpress detects the latest commit which changed a directory or file when determining the tag to use for charts and images.
This means that shallow clones should not be used because if the last commit that changed a relevant file is outside the shallow commit range, the wrong tag will be assigned.

Travis uses a clone depth of 50 by default, which can result in incorrect image tagging.
You can [disable this shallow clone behavior](https://docs.travis-ci.com/user/customizing-the-build/#Git-Clone-Depth) in your `.travis.yml`:

```yaml
git:
  depth: false
```
