if [[ "$UPDATE" == "true" ]]; then
    if which vcluster &>/dev/null; then
        sudo ln -sfn "$(which vcluster)" "$(dirname "$(which vcluster)")/v"
        vcluster completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_vcluster"
    fi
fi

compdef _vcluster v

build_load_pro () {
	local version=$1
	git co "v${version}"
	just build-snapshot
	docker tag ghcr.io/loft-sh/vcluster-pro:dev-next ghcr.io/loft-sh/vcluster-pro:${version}
	kind load docker-image --name airgapped ghcr.io/loft-sh/vcluster-pro:${version}
}

vendor_vcluster () {
	echo "==> Updating vcluster repository..."
	cd ~loft/vcluster

	if [[ "$(git this)" == "main" ]]; then
		echo "On main branch, running git ffff..."
		git ffff
	else
		echo "Not on main branch, running git fm..."
		git fm
	fi

	local commit_hash=${1:-$(git rev-parse main)}
	echo "==> Using commit: $commit_hash"

	echo "==> Updating vcluster-pro dependencies..."
	cd ~loft/vcluster-pro

	echo "==> Running go get..."
	go get github.com/loft-sh/vcluster@"$commit_hash"

	echo "==> Running go mod vendor..."
	go mod vendor

	echo "==> Done! vcluster-pro now vendors vcluster@$commit_hash"
}
