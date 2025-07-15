# Multi-stage build for smaller production image
FROM ruby:3.3.5-slim AS builder

# Build arguments
ARG RAILS_ENV=production
ARG UID=1000
ARG GID=1000
ARG MAXMINDDB_LINK
ARG MAXMINDDB_LICENSE_KEY=
ARG KAIGARA_VERSION=0.1.34

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    ca-certificates \
    git \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create group and user
RUN groupadd -r --gid ${GID} app \
    && useradd --system --create-home --home /home/app --shell /sbin/nologin --no-log-init \
    --gid ${GID} --uid ${UID} app

# Set working directory
WORKDIR /home/app

# Copy Gemfile and Gemfile.lock first for better layer caching
COPY --chown=app:app Gemfile Gemfile.lock ./

# Switch to app user for gem installation
USER app

# Install gems
RUN gem update bundler --silent \
    && bundle config set --local deployment true \
    && bundle config set --local without 'development test' \
    && bundle config set --local jobs $(nproc) \
    && bundle install --quiet

# Copy application code
COPY --chown=app:app . .

# Runtime stage
FROM ruby:3.3.5-slim AS runtime

# Build arguments (needed in runtime)
ARG RAILS_ENV=production
ARG UID=1000
ARG GID=1000
ARG MAXMINDDB_LINK
ARG MAXMINDDB_LICENSE_KEY=
ARG KAIGARA_VERSION=0.1.34

# Environment variables
ENV RAILS_ENV=${RAILS_ENV} \
    APP_HOME=/home/app \
    TZ=UTC \
    LANG=C.UTF-8 \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_WITHOUT=development:test

# Set MaxMind link with proper escaping
ENV MAXMINDDB_LINK=${MAXMINDDB_LINK:-https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&suffix=tar.gz&license_key=${MAXMINDDB_LICENSE_KEY}}

# Install runtime dependencies only
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    libpq5 \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create group and user (same as builder stage)
RUN groupadd -r --gid ${GID} app \
    && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
    --gid ${GID} --uid ${UID} app

# Install Kaigara
RUN curl -Lo /usr/bin/kaigara https://github.com/openware/kaigara/releases/download/${KAIGARA_VERSION}/kaigara \
    && chmod +x /usr/bin/kaigara

WORKDIR $APP_HOME

# Copy gems from builder stage
COPY --from=builder --chown=app:app /usr/local/bundle /usr/local/bundle

# Copy application from builder stage
COPY --from=builder --chown=app:app /home/app /home/app

# Switch to app user
USER app

# Download MaxMind Country DB with better error handling
RUN if [ -n "${MAXMINDDB_LICENSE_KEY}" ]; then \
        wget -O ${APP_HOME}/geolite.tar.gz "${MAXMINDDB_LINK}" \
        && mkdir -p ${APP_HOME}/geolite \
        && tar xzf ${APP_HOME}/geolite.tar.gz -C ${APP_HOME}/geolite --strip-components 1 \
        && rm ${APP_HOME}/geolite.tar.gz; \
    else \
        echo "Warning: MAXMINDDB_LICENSE_KEY not provided, skipping MaxMind DB download"; \
        mkdir -p ${APP_HOME}/geolite; \
    fi

# Set MaxMind DB path
ENV BARONG_MAXMINDDB_PATH=${APP_HOME}/geolite/GeoLite2-Country.mmdb

# Download Cloudflare IP ranges with better error handling
RUN mkdir -p ${APP_HOME}/config \
    && (curl -s https://www.cloudflare.com/ips-v4 > ${APP_HOME}/config/cloudflare_ips.yml || echo "# Cloudflare IPs not available" > ${APP_HOME}/config/cloudflare_ips.yml) \
    && echo >> ${APP_HOME}/config/cloudflare_ips.yml \
    && (curl -s https://www.cloudflare.com/ips-v6 >> ${APP_HOME}/config/cloudflare_ips.yml || echo "# IPv6 ranges not available" >> ${APP_HOME}/config/cloudflare_ips.yml)

# Initialize application configuration & assets
RUN ./bin/init_config \
    && bundle exec rake tmp:create

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Expose port
EXPOSE 8080

# Use exec form for better signal handling
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]