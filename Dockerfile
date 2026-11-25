# Hermes Agent for Railway
#
# Runs the official Hermes Agent image from Nous Research (MIT), pinned to a
# release, with the web dashboard switched on and served on Railway's $PORT.
# Nothing in the image is modified: the start script only maps this
# template's variables onto Hermes' own settings, then hands over to the
# image's normal entrypoint (s6-overlay supervises the gateway and dashboard).

FROM nousresearch/hermes-agent:v0.23.4

COPY --chmod=755 railway-start.sh /opt/railway/railway-start.sh

# Dashboard on, listening on all interfaces so Railway's proxy can reach it.
# The dashboard refuses to start on a public bind without a sign-in provider,
# which railway-start.sh sets up from ADMIN_USERNAME / ADMIN_PASSWORD.
ENV HERMES_DASHBOARD=1 \
    HERMES_DASHBOARD_HOST=0.0.0.0

EXPOSE 9119
VOLUME ["/opt/data"]

ENTRYPOINT ["/opt/railway/railway-start.sh"]
CMD ["gateway", "run"]
