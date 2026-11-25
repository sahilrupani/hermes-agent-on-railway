# Hermes Agent on Railway

A small Railway wrapper for [Hermes Agent](https://github.com/NousResearch/hermes-agent), the self-improving AI agent by Nous Research.

It runs the **official, unmodified** `nousresearch/hermes-agent` image, pinned to a release, and adds only a start script that:

- serves the Hermes web dashboard on Railway's `$PORT` (default `9119`);
- turns your `ADMIN_USERNAME` and `ADMIN_PASSWORD` into the dashboard's built-in username and password sign-in;
- derives a stable session secret so you stay signed in across restarts;
- then starts the image through its normal entrypoint, so s6-overlay supervises the gateway and dashboard as usual.

All Hermes state (config, memory, skills, sessions, logs) lives in `/opt/data`. Mount a Railway volume there.

## Variables

| Variable | Required | Purpose |
|---|---|---|
| `PORT` | Yes | Port the dashboard listens on. Point the Railway domain at it (`9119`). |
| `ADMIN_USERNAME` | Yes | Dashboard sign-in username. |
| `ADMIN_PASSWORD` | Yes | Dashboard sign-in password. Use a long random value. |

Any other Hermes setting can be added as a variable too, for example model provider keys or messaging-platform tokens. See the [Hermes Docker guide](https://hermes-agent.nousresearch.com/docs/user-guide/docker).

## Security

The dashboard can store API keys and run tools. Hermes' own documentation describes username/password sign-in as suited to trusted networks, so on a public Railway domain:

- use a long, random `ADMIN_PASSWORD`;
- consider Nous OAuth instead (`HERMES_DASHBOARD_OAUTH_CLIENT_ID`);
- don't enable the OpenAI-compatible API server (`API_SERVER_ENABLED`) without also setting `API_SERVER_KEY`.

## Updating

Change the image tag in the `Dockerfile` to a newer Hermes release and redeploy. Back up the `/opt/data` volume first.

## License

The files in this repository are MIT licensed (see `LICENSE`). Hermes Agent itself is MIT licensed by Nous Research; this repository does not include or modify its source code.
