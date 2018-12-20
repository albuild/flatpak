FROM amazonlinux:2.0.20181114

ARG version

RUN yum update -y
RUN yum install -y wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/glib2-2.56.1-2.el7.x86_64.rpm
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/glib2-devel-2.56.1-2.el7.x86_64.rpm
RUN yum install -y glib2-2.56.1-2.el7.x86_64.rpm glib2-devel-2.56.1-2.el7.x86_64.rpm
RUN yum install -y \
  autoconf \
  automake \
  bison \
  e2fsprogs-devel \
  fuse-devel \
  gettext-devel \
  git \
  gobject-introspection-devel \
  gpgme-devel \
  gtk-doc \
  json-glib-devel \
  libappstream-glib-devel \
  libarchive-devel \
  libcap-devel \
  libseccomp-devel \
  libsoup-devel \
  libtool \
  libXau-devel \
  libxml2-devel \
  make \
  pkgconfig \
  polkit-devel \
  rpm-build \
  which \
  xz-devel \
  zlib-devel

RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/ostreedev/ostree.git
RUN git clone https://github.com/flatpak/flatpak.git

WORKDIR /app/ostree
RUN git checkout -b build v2018.9
RUN git submodule update --init --recursive
RUN env NOCONFIGURE=1 ./autogen.sh
RUN ./configure --prefix=/opt/albuild-flatpak/$version/ostree --enable-man=no
RUN make
RUN make install

ENV PKG_CONFIG_PATH=/opt/albuild-flatpak/$version/ostree/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib64/pkgconfig

WORKDIR /app/flatpak
RUN git checkout -b build 1.1.1
RUN git submodule update --init --recursive
RUN env NOCONFIGURE=1 ./autogen.sh
RUN ./configure --prefix=/usr --sysconfdir=/etc --enable-static
RUN make
RUN make DESTDIR=/dest install

RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS}
WORKDIR /root/rpmbuild
ADD rpm.spec SPECS
RUN find /opt/albuild-flatpak/$version -type f >> SPECS/rpm.spec
RUN find /opt/albuild-flatpak/$version -type l >> SPECS/rpm.spec
RUN find /dest -type f | sed 's,^/dest,,' | sed 's,^\(/usr/share/man/man[15]/.\+\.[15]\)$,\1.gz,' >> SPECS/rpm.spec
RUN find /dest -type l | sed 's,^/dest,,' | sed 's,^\(/usr/share/man/man[15]/.\+\.[15]\)$,\1.gz,' >> SPECS/rpm.spec
RUN rpmbuild -bb SPECS/rpm.spec
