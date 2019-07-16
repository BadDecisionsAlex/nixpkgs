{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "6.2.5";
  name = "grafana-${version}";
  goPackagePath = "github.com/grafana/grafana";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "03wign7dkc2a9267mmqicvvzgya0g1i9ygr0dz3jvks2k1yhlv2j";
  };

  srcStatic = fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "19zc9x1gkmdr7ijsrhrlln5cib20iyx0vgk0z79d8qyhq69nxfs8";
  };

  postPatch = ''
    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";

  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $bin/share/grafana
    mv grafana-*/{public,conf,tools} $bin/share/grafana/
    ln -sf ${phantomjs2}/bin/phantomjs $bin/share/grafana/tools/phantomjs/phantomjs
  '';

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = https://grafana.org/;
    maintainers = with maintainers; [ offline fpletz willibutz ];
    platforms = platforms.linux;
  };
}
