#!/bin/sh
# Maps this template's variables onto Hermes Agent's own settings, then
# starts the official image exactly as it normally starts.
set -e

# Dashboard port: Railway's $PORT, falling back to Hermes' default 9119.
export HERMES_DASHBOARD_PORT="${HERMES_DASHBOARD_PORT:-${PORT:-9119}}"

# Dashboard sign-in. Hermes requires a sign-in provider on a public bind,
# so without these the dashboard will not start.
if [ -n "${ADMIN_USERNAME:-}" ] && [ -n "${ADMIN_PASSWORD:-}" ]; then
    export HERMES_DASHBOARD_BASIC_AUTH_USERNAME="${HERMES_DASHBOARD_BASIC_AUTH_USERNAME:-$ADMIN_USERNAME}"
    export HERMES_DASHBOARD_BASIC_AUTH_PASSWORD="${HERMES_DASHBOARD_BASIC_AUTH_PASSWORD:-$ADMIN_PASSWORD}"
    # Keep sessions valid across restarts: derive a stable signing secret
    # from the password unless one is set explicitly.
    if [ -z "${HERMES_DASHBOARD_BASIC_AUTH_SECRET:-}" ]; then
        HERMES_DASHBOARD_BASIC_AUTH_SECRET="$(printf '%s:%s' "$ADMIN_USERNAME" "$ADMIN_PASSWORD" | sha256sum | cut -d' ' -f1)"
        export HERMES_DASHBOARD_BASIC_AUTH_SECRET
    fi
else
    echo "[railway] ADMIN_USERNAME and ADMIN_PASSWORD are not both set." >&2
    echo "[railway] The Hermes dashboard needs a login on a public domain and will not start without one." >&2
fi

# Hand over to the official entrypoint (keeps s6-overlay as PID 1).
exec /opt/hermes/docker/entrypoint-dispatch.sh "$@"
