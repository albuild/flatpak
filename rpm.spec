Summary: Flatpak for Amazon Linux 2
Name: albuild-flatpak
Version: {{VERSION}}
Release: 1%{?dist}
Group: System Environment/Libraries
License: BSD-3-Clause
Source0: {{SOURCE0}}
Source1: {{SOURCE1}}
URL: https://github.com/albuild/flatpak
BuildArch: x86_64

%define versiondir /opt/albuild-flatpak/%{version}

%description
A set of prebuilt Flatpak binaries for Amazon Linux 2.

%install
mkdir -p `dirname %{buildroot}%{versiondir}`
cp -r %{versiondir} `dirname %{buildroot}%{versiondir}`
# cp -r /dest/* %{buildroot}/
find /dest -maxdepth 1 -print0 | while IFS= read -r -d $'\0' f; do
  if [ ! $f = "/dest" ]; then
    cp -r $f %{buildroot}/
  fi
done

%clean
rm -rf %{buildroot}

%files
