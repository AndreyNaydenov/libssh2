# libssh2

libssh2 packaged with Zig

## Usage

1. Install as dependency using ```zig fetch --save git+https://github.com/{repo_name}```
2. Link this library in build.zig
```
    const exe = b.addExecutable(.{
        .name = "test_name",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // import libssh2
    const libssh2 = b.dependency("libssh2", .{
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibrary(libssh2.artifact("ssh2"));

    b.installArtifact(exe);
```
3. Import using `@cImport()`
