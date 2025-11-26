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
GO_VERSION="1.25.1"
# renovate: datasource=github-releases depName=golangci/golangci-lint
GOLANGCI_LINT_VERSION="2.6.2"

# renovate: datasource=github-releases depName=kubernetes/kubectl
KUBECTL_VERSION="1.34.1"
# renovate: datasource=github-releases depName=helm/helm
HELM_VERSION="4.0.0"
# renovate: datasource=github-releases depName=kubernetes-sigs/kind
KIND_VERSION="0.30.0"
# renovate: datasource=github-releases depName=derailed/k9s
K9S_VERSION="0.50.16"

# renovate: datasource=github-releases depName=hashicorp/terraform
TERRAFORM_VERSION="1.14.0"

# renovate: datasource=github-releases depName=loft-sh/vcluster
VCLUSTER_VERSION="0.31.0-alpha.0"
# renovate: datasource=github-releases depName=devspace-sh/devspace
DEVSPACE_VERSION="6.3.18"
# renovate: datasource=github-releases depName=casey/just
JUST_VERSION="1.43.0"

# renovate: datasource=github-releases depName=nodejs/node
NODE_VERSION="25.2.0"
# renovate: datasource=github-releases depName=argoproj/argo-cd
ARGOCD_VERSION="3.2.0"
# renovate: datasource=github-releases depName=kubeovn/kube-ovn
KUBEOVN_VERSION="1.14.10"
# renovate: datasource=github-releases depName=cilium/cilium-cli
CILIUM_VERSION="0.18.7"
# renovate: datasource=github-releases depName=kube-burner/kube-burner
KUBE_BURNER_VERSION="1.17.7"
# renovate: datasource=github-releases depName=lework/skopeo-binary
SKOPEO_VERSION="1.20.0"

install_go() {
    local version="${1:-$GO_VERSION}"
    local dest="/usr/local/bin/go"
    if ! [ -d "${dest}-${version}" ]; then
        echo "# Installing Go $version"
        install_from_archive.sh "https://go.dev/dl/go${version}.${GOOS}-${GOARCH}.tar.gz" "go" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_golangci_lint() {
    local version="${1:-$GOLANGCI_LINT_VERSION}"
    local dest="/usr/local/bin/golangci-lint"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing golangci-lint $version"
        local archive_dir="golangci-lint-${version}-${GOOS}-${GOARCH}"
        install_from_archive.sh "https://github.com/golangci/golangci-lint/releases/download/v${version}/${archive_dir}.tar.gz" "${archive_dir}/golangci-lint" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_kubectl() {
    local version="${1:-$KUBECTL_VERSION}"
    local dest="/usr/local/bin/kubectl"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing kubectl $version"
        install_from_url "https://dl.k8s.io/release/v${version}/bin/${GOOS}/${GOARCH}/kubectl" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_helm() {
    local version="${1:-$HELM_VERSION}"
    local dest="/usr/local/bin/helm"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing Helm $version"
        install_from_archive.sh "https://get.helm.sh/helm-v${version}-${GOOS}-${GOARCH}.tar.gz" "${GOOS}-${GOARCH}/helm" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_kind() {
    local version="${1:-$KIND_VERSION}"
    local dest="/usr/local/bin/kind"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing Kind $version"
        install_from_url "https://kind.sigs.k8s.io/dl/v${version}/kind-${GOOS}-${GOARCH}" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_vcluster() {
    local version="${1:-$VCLUSTER_VERSION}"
    local dest="/usr/local/bin/vcluster"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing VCluster $version"
        install_from_url "https://github.com/loft-sh/vcluster/releases/download/v${version}/vcluster-${GOOS}-${GOARCH}" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_devspace() {
    local version="${1:-$DEVSPACE_VERSION}"
    local dest="/usr/local/bin/devspace"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing DevSpace $version"
        install_from_url "https://github.com/loft-sh/devspace/releases/download/v${version}/devspace-${GOOS}-${GOARCH}" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_just() {
    local version="${1:-$JUST_VERSION}"
    local dest="/usr/local/bin/just"
    if ! [ -f "${dest}-${version}" ]; then
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
        install_from_archive.sh "https://github.com/casey/just/releases/download/${version}/just-${version}-${just_arch}-${just_os}.tar.gz" just "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_k9s() {
    local version="${1:-$K9S_VERSION}"
    local dest="/usr/local/bin/k9s"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing k9s $version"
        install_from_archive.sh "https://github.com/derailed/k9s/releases/download/v${version}/k9s_$(uname -s)_$(uname -m).tar.gz" "k9s" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_terraform() {
    local version="${1:-$TERRAFORM_VERSION}"
    local dest="/usr/local/bin/terraform"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing Terraform $version"
        local archive_name="terraform_${version}_${GOOS}_${GOARCH}.zip"
        install_from_archive.sh "https://releases.hashicorp.com/terraform/${version}/${archive_name}" "terraform" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_node() {
    local version="${1:-$NODE_VERSION}"
    local dest="/usr/local/bin/node"
    if ! [ -f "${dest}-${version}" ]; then
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
        install_from_archive.sh "https://nodejs.org/dist/v${version}/${archive_dir}.tar.gz" "${archive_dir}/bin/node" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_npm() {
    local node_version="${1:-$NODE_VERSION}"
    local dest="/usr/local/bin/npm"
    if ! [ -f "${dest}-${node_version}" ]; then
        echo "# Installing npm for Node.js $node_version"
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
        local archive_dir="node-v${node_version}-${node_os}-${node_arch}"
        install_from_archive.sh "https://nodejs.org/dist/v${node_version}/${archive_dir}.tar.gz" "${archive_dir}/bin/npm" "${dest}-${node_version}"
        chmod +x "${dest}-${node_version}"
    fi
    ln -sfn "${dest}-${node_version}" "$dest"
}

install_argocd() {
    local version="${1:-$ARGOCD_VERSION}"
    local dest="/usr/local/bin/argocd"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing Argo CD CLI $version"
        install_from_url "https://github.com/argoproj/argo-cd/releases/download/v${version}/argocd-${GOOS}-${GOARCH}" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_ko() {
    local version="${1:-$KUBEOVN_VERSION}"
    local dest="/usr/local/bin/kubectl-ko"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing Kube-OVN kubectl plugin (ko) $version"
        install_from_url "https://github.com/kubeovn/kube-ovn/releases/download/v${version}/kubectl-ko" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_cilium() {
    local version="${1:-$CILIUM_VERSION}"
    local dest="/usr/local/bin/cilium"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing Cilium CLI $version"
        install_from_archive.sh "https://github.com/cilium/cilium-cli/releases/download/v${version}/cilium-${GOOS}-${GOARCH}.tar.gz" "cilium" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_kube_burner() {
    local version="${1:-$KUBE_BURNER_VERSION}"
    local dest="/usr/local/bin/kube-burner"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing kube-burner $version"
        install_from_archive.sh "https://github.com/kube-burner/kube-burner/releases/download/v${version}/kube-burner-V${version}-${GOOS}-${GOARCH}.tar.gz" "kube-burner" "${dest}-${version}"
        chmod +x "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
}

install_skopeo() {
    local version="${1:-$SKOPEO_VERSION}"
    local dest="/usr/local/bin/skopeo"
    if ! [ -f "${dest}-${version}" ]; then
        echo "# Installing skopeo $version"
        install_from_url "https://github.com/lework/skopeo-binary/releases/download/v${version}/skopeo-${GOOS}-${GOARCH}" "${dest}-${version}"
    fi
    ln -sfn "${dest}-${version}" "$dest"
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
    install_terraform
    install_node
    install_argocd
    install_ko
    install_cilium
    install_kube_burner
    install_skopeo
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
        "terraform") install_terraform "$2" ;;
        "node") install_node "$2" ;;
        "argocd") install_argocd "$2" ;;
        "ko") install_ko "$2" ;;
        "cilium") install_cilium "$2" ;;
        "kube-burner") install_kube_burner "$2" ;;
        "skopeo") install_skopeo "$2" ;;
        *) echo "Unknown tool: $1" >&2; exit 1 ;;
    esac
else
    echo "Usage: $0 [tool] [version]" >&2
    echo "If no arguments are provided, all tools will be installed with default versions." >&2
    exit 1
fi
