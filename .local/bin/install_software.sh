#!/usr/bin/env bash

GOOS="$(uname -s | tr '[:upper:]' '[:lower:]')"
GOARCH="$(uname -m)"
case "$GOARCH" in
  x86_64) GOARCH="amd64" ;;
  aarch64 | arm64) GOARCH="arm64" ;;
  *) echo "Unsupported architecture: $GOARCH" >&2; exit 1 ;;
esac

install_from_url() {
    local url="$1"
    local destination="$2"

    curl -sSL "$url" -o "$destination"
    chmod +x "$destination"
}

# renovate: datasource=golang-version
GO_VERSION="1.24.5"
# renovate: datasource=github-releases depName=golangci/golangci-lint
GOLANGCI_LINT_VERSION="2.2.1"

# renovate: datasource=github-releases depName=kubernetes/kubectl
KUBECTL_VERSION="1.33.2"
# renovate: datasource=github-releases depName=helm/helm
HELM_VERSION="3.18.3"
# renovate: datasource=github-releases depName=kubernetes-sigs/kind
KIND_VERSION="0.29.0"
# renovate: datasource=github-releases depName=derailed/k9s
K9S_VERSION="0.50.6"

# renovate: datasource=github-releases depName=loft-sh/vcluster
VCLUSTER_VERSION="0.26.0"
# renovate: datasource=github-releases depName=devspace-sh/devspace
DEVSPACE_VERSION="6.3.15"
# renovate: datasource=github-releases depName=casey/just
JUST_VERSION="1.41.0"

# renovate: datasource=github-releases depName=nodejs/node
NODE_VERSION="24.4.1"

install_go() {
    local version="${1:-$GO_VERSION}"
    local dest="/usr/local/bin/go${version}"
    if ! [ -d "$dest" ]; then
        echo "# Installing Go $version"
        install_from_archive.sh "https://go.dev/dl/go${version}.${GOOS}-${GOARCH}.tar.gz" "go" "$dest"
    fi
    ln -sfn "$dest" "$(dirname "$dest")/go"
}

install_golangci_lint() {
    local version="${1:-$GOLANGCI_LINT_VERSION}"
    local dest="/usr/local/bin/golangci-lint-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing golangci-lint $version"
        local archive_dir="golangci-lint-${version}-${GOOS}-${GOARCH}"
        install_from_archive.sh "https://github.com/golangci/golangci-lint/releases/download/v${version}/${archive_dir}.tar.gz" "${archive_dir}/golangci-lint" "$dest"
        chmod +x "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/golangci-lint"
}

install_kubectl() {
    local version="${1:-$KUBECTL_VERSION}"
    local dest="/usr/local/bin/kubectl-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing kubectl $version"
        install_from_url "https://dl.k8s.io/release/v${version}/bin/${GOOS}/${GOARCH}/kubectl" "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/kubectl"
}

install_helm() {
    local version="${1:-$HELM_VERSION}"
    local dest="/usr/local/bin/helm-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing Helm $version"
        install_from_archive.sh "https://get.helm.sh/helm-v${version}-${GOOS}-${GOARCH}.tar.gz" "${GOOS}-${GOARCH}/helm" "$dest"
        chmod +x "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/helm"
}

install_kind() {
    local version="${1:-$KIND_VERSION}"
    local dest="/usr/local/bin/kind-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing Kind $version"
        install_from_url "https://kind.sigs.k8s.io/dl/v${version}/kind-${GOOS}-${GOARCH}" "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/kind"
}

install_vcluster() {
    local version="${1:-$VCLUSTER_VERSION}"
    local dest="/usr/local/bin/vcluster-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing VCluster $version"
        install_from_url "https://github.com/loft-sh/vcluster/releases/download/v${version}/vcluster-${GOOS}-${GOARCH}" "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/vcluster"
}

install_devspace() {
    local version="${1:-$DEVSPACE_VERSION}"
    local dest="/usr/local/bin/devspace-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing DevSpace $version"
        install_from_url "https://github.com/loft-sh/devspace/releases/download/v${version}/devspace-${GOOS}-${GOARCH}" "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/devspace"
}

install_just() {
    local version="${1:-$JUST_VERSION}"
    local dest="/usr/local/bin/just-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing Just $version"
        local just_os
        case "$(uname -s)" in
          Darwin) just_os="apple-darwin" ;;
          Linux) just_os="linux" ;;
          *) echo "Unsupported OS" >&2; exit 1 ;;
        esac
        local just_arch
        case "$(uname -m)" in
          x86_64) just_arch="x86_64" ;;
          aarch64 | arm64) just_arch="aarch64" ;;
          *) echo "Unsupported architecture" >&2; exit 1 ;;
        esac
        install_from_archive.sh "https://github.com/casey/just/releases/download/${version}/just-${version}-${just_arch}-${just_os}.tar.gz" just "$dest"
        chmod +x "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/just"
}

install_k9s() {
    local version="${1:-$K9S_VERSION}"
    local dest="/usr/local/bin/k9s-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing k9s $version"
        install_from_archive.sh "https://github.com/derailed/k9s/releases/download/v${version}/k9s_$(uname -s)_$(uname -m).tar.gz" "k9s" "$dest"
        chmod +x "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/k9s"
}

install_node() {
    local version="${1:-$NODE_VERSION}"
    local dest="/usr/local/bin/node-${version}"
    if ! [ -f "$dest" ]; then
        echo "# Installing Node.js $version"
        local node_os
        case "$(uname -s)" in
          Darwin) node_os="darwin" ;;
          Linux) node_os="linux" ;;
          *) echo "Unsupported OS" >&2; exit 1 ;;
        esac
        local node_arch
        case "$(uname -m)" in
          x86_64) node_arch="x64" ;;
          aarch64 | arm64) node_arch="arm64" ;;
          *) echo "Unsupported architecture" >&2; exit 1 ;;
        esac
        local archive_dir="node-v${version}-${node_os}-${node_arch}"
        install_from_archive.sh "https://nodejs.org/dist/v${version}/${archive_dir}.tar.gz" "${archive_dir}/bin/node" "$dest"
        chmod +x "$dest"
    fi
    ln -sfn "$dest" "/usr/local/bin/node"
}

if [ $# -eq 0 ]; then
    install_go
    install_golangci_lint
    install_kubectl
    install_helm
    install_kind
    install_vcluster
    install_devspace
    install_just
    install_k9s
    install_node
elif [ $# -le 2 ]; then
    case "$1" in
        "go") install_go "$2" ;;
        "golangci-lint") install_golangci_lint "$2" ;;
        "kubectl") install_kubectl "$2" ;;
        "helm") install_helm "$2" ;;
        "kind") install_kind "$2" ;;
        "vcluster") install_vcluster "$2" ;;
        "devspace") install_devspace "$2" ;;
        "just") install_just "$2" ;;
        "k9s") install_k9s "$2" ;;
        "node") install_node "$2" ;;
        *) echo "Unknown tool: $1" >&2; exit 1 ;;
    esac
else
    echo "Usage: $0 [tool] [version]" >&2
    echo "If no arguments are provided, all tools will be installed with default versions." >&2
    exit 1
fi
