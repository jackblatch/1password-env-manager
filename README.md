## 1Password Environment Variable Manager

Scripts that wrap the 1Password CLI to help manage and interact with your environment variables stored in 1Password for app development.

Once you have your environment variables stored in 1Password, you can use these scripts to easily retrieve and set them in your local environment.

If you're storing the 1Pasword reference values in your `.env` file, prepend your run command with `op run --no-masking --env-file=".env" --`. This will ensure that the 1Password reference values are resolved before the command is run. For example, `op run --no-masking --env-file=".env.local" -- pnpm dev`.

### Requirements

Install the following:

- [1Password CLI](https://1password.com/downloads/command-line/)
- [jq](https://stedolan.github.io/jq/)
