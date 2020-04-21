# pulumi-test

Experimenting with Pulumi for managing AWS infrastructure.


## Usage

Requirements and gotchas:

-  POSIX (make, bash).
-  Docker.
-  Assumes AWS credentials will be gotten from the environment
   (e.g. using https://github.com/otm/limes).
-  Assumes that a role called `Admin` exists in the current AWS account.
-  Assumes that you have enough AWS privileges to provision *lots of stuff* (tm).
-  Defaults to AWS region `eu-west-1`.

First, Pulumi needs a few things before it can get to work. Create a
CloudFormation stack that sets up two things within your AWS account:

-  An S3 bucket for Pulumi to hold state.
-  A KMS key for Pulumi to use for config secrets.

```
make provision-pulumi-state-stack
```

Then use the scripts in `bin` to manage Pulumi stacks, for example:

```
bin/pulumi-ts
bin/pulumi-ts projects/my-cool-project new
bin/pulumi-ts projects/my-cool-project prod up
bin/pulumi-ts projects/my-cool-project prod destroy
```


## Todo

-  Restrict stacks to specific accounts? Currently, any stack can be
   provisioned in the current AWS account.
-  Reuse same node_modules for all projects? Conflicts?
