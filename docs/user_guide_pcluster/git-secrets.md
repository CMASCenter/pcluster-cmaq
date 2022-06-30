### Screen code prior to committing to git repo

To prevent committing passwords and other sensitive information to the git repository

<a href="https://github.com/awslabs/git-secrets">git-secrets</a>

after installing run the following command prior to making commits to the git repo

```
git secrets --scan
```

For documentation purposes, it is best practice to set up a profile, and use that in the document.

<a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html">Configure Named Profiles</a>
