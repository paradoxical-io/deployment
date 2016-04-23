# deployment
Deployment Submodule for paradoxical repos

# Setting up a repo

```
git submodule -b master https://github.com/paradoxical-io/deployment.git .deployment
```

# Setup `.travis.yml`
Add the following to your travis configuration
```
git:
  submodules: false
before_install:
  # https://git-scm.com/docs/git-submodule#_options:
  # --remote
  # Instead of using the superproject’s recorded SHA-1 to update the submodule,
  # use the status of the submodule’s remote-tracking (branch.<name>.remote) branch (submodule.<name>.branch).
  # --recursive
  # https://github.com/travis-ci/travis-ci/issues/4099
  - git submodule update --init --remote --recursive
after_success:
- ./.deployment/deploy.sh
```

# Enabling maven caching
```
sudo: false
cache:
  directories:
  - $HOME/.m2
```

# More guidance
- [Someone elses settings](https://gist.github.com/m3t/df29ec4e0aae167f99c8)
- [Helpful Stackoverflow](http://stackoverflow.com/questions/9189575/git-submodule-tracking-latest/9189815#9189815)
- [Another SO](http://stackoverflow.com/questions/1777854/git-submodules-specify-a-branch-tag/18799234#18799234)
- [Submodules (docs)](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
