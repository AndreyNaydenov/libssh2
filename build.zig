const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libssh2_dep = b.dependency("libssh2", .{
        .target = target,
        .optimize = optimize,
    });

    const mbedtls_dep = b.dependency("mbedtls", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "ssh2",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib.addIncludePath(libssh2_dep.path("include"));
    lib.addIncludePath(libssh2_dep.path("src"));
    lib.linkLibrary(mbedtls_dep.artifact("mbedtls"));
    lib.addCSourceFiles(.{
        .root = libssh2_dep.path("src"),
        .flags = &.{},
        .files = &.{
            "channel.c",
            "comp.c",
            "crypt.c",
            "hostkey.c",
            "kex.c",
            "mac.c",
            "misc.c",
            "packet.c",
            "publickey.c",
            "scp.c",
            "session.c",
            "sftp.c",
            "userauth.c",
            "transport.c",
            "version.c",
            "knownhost.c",
            "agent.c",
            "mbedtls.c",
            "pem.c",
            "keepalive.c",
            "global.c",
            "blowfish.c",
            "bcrypt_pbkdf.c",
            "agent_win.c",
        },
    });
    lib.installHeader(b.path("config/libssh2_config.h"), "libssh2_config.h");
    lib.installHeadersDirectory(libssh2_dep.path("include"), ".", .{});
    lib.root_module.addCMacro("LIBSSH2_MBEDTLS", "");

    if (target.result.os.tag == .windows) {
        lib.root_module.addCMacro("_CRT_SECURE_NO_DEPRECATE", "1");
        lib.root_module.addCMacro("HAVE_LIBCRYPT32", "");
        lib.root_module.addCMacro("HAVE_WINSOCK2_H", "");
        lib.root_module.addCMacro("HAVE_IOCTLSOCKET", "");
        lib.root_module.addCMacro("HAVE_SELECT", "");
        lib.root_module.addCMacro("LIBSSH2_DH_GEX_NEW", "1");

        if (target.result.isGnu()) {
            lib.root_module.addCMacro("HAVE_UNISTD_H", "");
            lib.root_module.addCMacro("HAVE_INTTYPES_H", "");
            lib.root_module.addCMacro("HAVE_SYS_TIME_H", "");
            lib.root_module.addCMacro("HAVE_GETTIMEOFDAY", "");
        }
    } else {
        lib.root_module.addCMacro("HAVE_UNISTD_H", "");
        lib.root_module.addCMacro("HAVE_INTTYPES_H", "");
        lib.root_module.addCMacro("HAVE_STDLIB_H", "");
        lib.root_module.addCMacro("HAVE_SYS_SELECT_H", "");
        lib.root_module.addCMacro("HAVE_SYS_UIO_H", "");
        lib.root_module.addCMacro("HAVE_SYS_SOCKET_H", "");
        lib.root_module.addCMacro("HAVE_SYS_IOCTL_H", "");
        lib.root_module.addCMacro("HAVE_SYS_TIME_H", "");
        lib.root_module.addCMacro("HAVE_SYS_UN_H", "");
        lib.root_module.addCMacro("HAVE_LONGLONG", "");
        lib.root_module.addCMacro("HAVE_GETTIMEOFDAY", "");
        lib.root_module.addCMacro("HAVE_INET_ADDR", "");
        lib.root_module.addCMacro("HAVE_POLL", "");
        lib.root_module.addCMacro("HAVE_SELECT", "");
        lib.root_module.addCMacro("HAVE_SOCKET", "");
        lib.root_module.addCMacro("HAVE_STRTOLL", "");
        lib.root_module.addCMacro("HAVE_SNPRINTF", "");
        lib.root_module.addCMacro("HAVE_O_NONBLOCK", "");
    }

    b.installArtifact(lib);
}
