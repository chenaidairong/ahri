#!/usr/bin/env bash

goVersion=`go version`

echo "Your go version is '$goVersion', We suggest using 'go1.12.1 +'"
echo ""

cd $GOPATH/src/github.com/KevinZonda/ahri/
rm -rf releases
mkdir releases

cd ./product/version
version=`go run version.go`
cd $GOPATH/src/github.com/KevinZonda/ahri/

# $1 os, $2 arch
function build() {
  echo "[Building] OS: $1 , ARCH: $2"
  cd ./product/client
  CGO_ENABLED=0 GOOS=$1 GOARCH=$2 go build -o ahri-client
  sleep 0.01
  mkdir ../../releases/client
  mv ./ahri-client ../../releases/client
  cp ./ahri.hosts ../../releases/client
  cp ./ahri.hosts ../../releases/client
  cp ./start.sh ../../releases/client
  cp ./stop.sh ../../releases/client
  cd $GOPATH/src/github.com/KevinZonda/ahri/

  cd ./product/server
  CGO_ENABLED=0 GOOS=$1 GOARCH=$2 go build -o ahri-server
  sleep 0.01
  mkdir ../../releases/server
  mv ./ahri-server ../../releases/server
  cp ./gen_rsa_keys.sh ../../releases/server
  cp ./start.sh ../../releases/server
  cp ./stop.sh ../../releases/server
  cd $GOPATH/src/github.com/KevinZonda/ahri/

  cd ./releases
  tar zcf "ahri_"$version"_"$1"_"$2".tgz" ./client ./server
  rm -rf ./client ./server
  cd $GOPATH/src/github.com/KevinZonda/ahri/
  echo "[OK] OS: $1 , ARCH: $2"
  echo "----------------------------"
  echo
}

echo "Ahri Version: $version"
echo ""

sleep 1

build windows 386
build windows amd64

build linux 386
build linux amd64
build linux arm
build linux arm64

build darwin 386
build darwin amd64

build freebsd 386
build freebsd amd64
build netbsd 386
build netbsd amd64
build openbsd 386
build openbsd amd64

tar zcf ./releases/"ahri_"$version"_src.tgz" ./core ./product ./test ./cross_compile.sh LICENSE

echo "[Finished]"

exit 0
