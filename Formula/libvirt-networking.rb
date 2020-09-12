class LibvirtNetworking < Formula
    desc "C virtualization API fork"
    homepage "https://www.libvirt.org"
    url "https://libvirt.org/sources/libvirt-6.7.0.tar.xz"
    sha256 "655b9476c797cdd3bb12e2520acc37335e5299b2d56a5bb9ab3f55db40161342"
    license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  
    livecheck do
      url "https://libvirt.org/sources/"
      regex(/href=.*?libvirt[._-]v?([\d.]+)\.t/i)
    end

    head do
      url "https://github.com/libvirt/libvirt.git"
    end
    depends_on "docutils" => :build
    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "perl" => :build
    depends_on "pkg-config" => :build
    depends_on "python@3.8" => :build
    depends_on "rpcgen" => :build
    depends_on "gettext"
    depends_on "glib"
    depends_on "gnutls"
    depends_on "libgcrypt"
    depends_on "libiscsi"
    depends_on "libssh2"
    depends_on "yajl"
  
    def install
      mkdir "build" do
        args = %W[
          --localstatedir=#{var}
          --mandir=#{man}
          --sysconfdir=#{etc}
          -Ddriver_esx=enabled
          -Ddriver_qemu=enabled
          -Ddriver_libvirtd=enabled
          -Ddriver_network=enabled
          -Dinit_script=none
        ]
        system "meson", *std_meson_args, *args, ".."
        system "meson", "compile"
        system "meson", "install"
      end
    end
  
    plist_options manual: "libvirtd"
  
    def plist
      <<~EOS
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>EnvironmentVariables</key>
            <dict>
              <key>PATH</key>
              <string>#{HOMEBREW_PREFIX}/bin</string>
            </dict>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>ProgramArguments</key>
            <array>
              <string>#{sbin}/libvirtd</string>
              <string>-f</string>
              <string>#{etc}/libvirt/libvirtd.conf</string>
            </array>
            <key>KeepAlive</key>
            <true/>
            <key>RunAtLoad</key>
            <true/>
          </dict>
        </plist>
      EOS
    end
  end