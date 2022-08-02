#!/bin/bash -e

apt-get -y install libwxgtk3.0-gtk3-dev libwxgtk-media3.0-gtk3-dev libboost-dev meson cmake make git

git clone https://github.com/wxFormBuilder/wxFormBuilder
cd wxFormBuilder
git checkout 2d20e717ac918a5f8f4728146c29a3d83a6a3afd  # Nov 1, 2021
git submodule update --recursive

meson _build --prefix $PWD/_install --buildtype=release
ninja -C _build -j 8 install

cd _install

mv bin/* /usr/local/bin/
mv share/* /usr/local/share/
mv lib/arm*-linux-*/* /usr/local/lib/

cd ..

cd ..
rm -rf wxFormBuilder


bash -c 'cat << EOF > /usr/local/share/applications/wxformbuilder.desktop
[Desktop Entry]
Type=Application
Name=WxFormBuilder
GenericName=WxFormBuilder
Comment=WxFormBuilder
Exec=onlyone wxformbuilder
Terminal=false
Icon=document
Categories=Utility;
EOF'
