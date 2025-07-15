Here are the recommended Docker build command lines for different scenarios:

## Development Build
```bash
docker build \
  --build-arg RAILS_ENV=development \
  --build-arg MAXMINDDB_LICENSE_KEY=your_license_key_here \
  --tag barong:dev \
  --target builder \
  .
```

## Production Build (Recommended)
```bash
docker build \
  --build-arg RAILS_ENV=production \
  --build-arg MAXMINDDB_LICENSE_KEY=your_license_key_here \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  --tag barong:3.3.5 \
  --tag barong:latest \
  --cache-from barong:latest \
  --pull \
  .
```

## CI/CD Pipeline Build
```bash
docker build \
  --build-arg RAILS_ENV=production \
  --build-arg MAXMINDDB_LICENSE_KEY=${MAXMIND_LICENSE_KEY} \
  --build-arg KAIGARA_VERSION=0.1.34 \
  --tag ${REGISTRY}/barong:${BUILD_NUMBER} \
  --tag ${REGISTRY}/barong:latest \
  --cache-from ${REGISTRY}/barong:latest \
  --pull \
  --progress=plain \
  .
```

## BuildKit Enhanced Build (Recommended for modern Docker)
```bash
DOCKER_BUILDKIT=1 docker build \
  --build-arg RAILS_ENV=production \
  --build-arg MAXMINDDB_LICENSE_KEY=your_license_key_here \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  --tag barong:3.3.5 \
  --tag barong:latest \
  --cache-from type=registry,ref=barong:latest \
  --cache-to type=inline \
  --pull \
  --progress=plain \
  .
```

## Multi-platform Build (for different architectures)
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg RAILS_ENV=production \
  --build-arg MAXMINDDB_LICENSE_KEY=your_license_key_here \
  --tag barong:3.3.5 \
  --tag barong:latest \
  --cache-from type=registry,ref=barong:latest \
  --cache-to type=registry,ref=barong:cache \
  --push \
  .
```

## Key Parameters Explained:

### Essential Arguments:
- `--build-arg MAXMINDDB_LICENSE_KEY=your_key` - **Required** for MaxMind DB download
- `--build-arg RAILS_ENV=production` - Sets Rails environment
- `--build-arg UID=$(id -u) --build-arg GID=$(id -g)` - Matches host user permissions

### Performance Optimizations:
- `--cache-from barong:latest` - Uses existing image layers for caching
- `--pull` - Ensures base image is up-to-date
- `DOCKER_BUILDKIT=1` - Enables faster BuildKit engine
- `--progress=plain` - Shows detailed build progress

### Production Best Practices:
- Use specific version tags: `barong:3.3.5`
- Include build metadata: `--label "build.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"`
- Add git commit: `--label "git.commit=$(git rev-parse HEAD)"`

## Complete Production Example:
```bash
#!/bin/bash
set -e

# Get build metadata
BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
GIT_COMMIT=$(git rev-parse HEAD)
VERSION="3.3.5"

DOCKER_BUILDKIT=1 docker build \
  --build-arg RAILS_ENV=production \
  --build-arg MAXMINDDB_LICENSE_KEY=${MAXMIND_LICENSE_KEY} \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  --label "build.date=${BUILD_DATE}" \
  --label "git.commit=${GIT_COMMIT}" \
  --label "version=${VERSION}" \
  --tag barong:${VERSION} \
  --tag barong:latest \
  --cache-from barong:latest \
  --pull \
  --progress=plain \
  .
```

## Important Notes:
1. **Always set `MAXMINDDB_LICENSE_KEY`** - The build will work without it but MaxMind functionality won't be available
2. **Use BuildKit** (`DOCKER_BUILDKIT=1`) for better performance and caching
3. **Include version tags** for proper versioning
4. **Match UID/GID** to avoid permission issues in development
5. **Use `--pull`** to ensure base images are current

