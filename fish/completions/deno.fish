complete -c deno -n "__fish_use_subcommand" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_use_subcommand" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_use_subcommand" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_use_subcommand" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_use_subcommand" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_use_subcommand" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_use_subcommand" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_use_subcommand" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_use_subcommand" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_use_subcommand" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_use_subcommand" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_use_subcommand" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_use_subcommand" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_use_subcommand" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_use_subcommand" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_use_subcommand" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_use_subcommand" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_use_subcommand" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c deno -n "__fish_use_subcommand" -f -a "run" -d 'Run a JavaScript or TypeScript program'
complete -c deno -n "__fish_use_subcommand" -f -a "serve" -d 'Run a server'
complete -c deno -n "__fish_use_subcommand" -f -a "add" -d 'Add dependencies'
complete -c deno -n "__fish_use_subcommand" -f -a "bench" -d 'Run benchmarks'
complete -c deno -n "__fish_use_subcommand" -f -a "bundle" -d 'Bundle module and dependencies into single file'
complete -c deno -n "__fish_use_subcommand" -f -a "cache" -d 'Cache the dependencies'
complete -c deno -n "__fish_use_subcommand" -f -a "check" -d 'Type-check the dependencies'
complete -c deno -n "__fish_use_subcommand" -f -a "compile" -d 'Compile the script into a self contained executable'
complete -c deno -n "__fish_use_subcommand" -f -a "completions" -d 'Generate shell completions'
complete -c deno -n "__fish_use_subcommand" -f -a "coverage" -d 'Print coverage reports'
complete -c deno -n "__fish_use_subcommand" -f -a "doc" -d 'Show documentation for a module'
complete -c deno -n "__fish_use_subcommand" -f -a "eval" -d 'Eval script'
complete -c deno -n "__fish_use_subcommand" -f -a "fmt" -d 'Format source files'
complete -c deno -n "__fish_use_subcommand" -f -a "init" -d 'Initialize a new project'
complete -c deno -n "__fish_use_subcommand" -f -a "info" -d 'Show info about cache or info related to source file'
complete -c deno -n "__fish_use_subcommand" -f -a "install" -d 'Install script as an executable'
complete -c deno -n "__fish_use_subcommand" -f -a "jupyter" -d 'Deno kernel for Jupyter notebooks'
complete -c deno -n "__fish_use_subcommand" -f -a "uninstall" -d 'Uninstall a script previously installed with deno install'
complete -c deno -n "__fish_use_subcommand" -f -a "lsp" -d 'Start the language server'
complete -c deno -n "__fish_use_subcommand" -f -a "lint" -d 'Lint source files'
complete -c deno -n "__fish_use_subcommand" -f -a "publish" -d 'Unstable preview feature: Publish the current working directory\'s package or workspace'
complete -c deno -n "__fish_use_subcommand" -f -a "repl" -d 'Read Eval Print Loop'
complete -c deno -n "__fish_use_subcommand" -f -a "task" -d 'Run a task defined in the configuration file'
complete -c deno -n "__fish_use_subcommand" -f -a "test" -d 'Run tests'
complete -c deno -n "__fish_use_subcommand" -f -a "types" -d 'Print runtime TypeScript declarations'
complete -c deno -n "__fish_use_subcommand" -f -a "upgrade" -d 'Upgrade deno executable to given version'
complete -c deno -n "__fish_use_subcommand" -f -a "vendor" -d 'Vendor remote modules into a local directory'
complete -c deno -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from run" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from run" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l inspect -d 'Activate inspector on host:port (default: 127.0.0.1:9229)' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from run" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from run" -l watch -d 'Watch for file changes and restart automatically' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-hmr -d 'UNSTABLE: Watch for file changes and hot replace modules' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts	'',tsx	'',js	'',jsx	''}"
complete -c deno -n "__fish_seen_subcommand_from run" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from run" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from run" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from run" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from run" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from run" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from run" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from run" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from run" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from run" -l no-code-cache -d 'Disable V8 code cache feature'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from run" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from run" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from serve" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from serve" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l inspect -d 'Activate inspector on host:port (default: 127.0.0.1:9229)' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from serve" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l port -d 'The TCP port to serve on, defaulting to 8000.' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l host -d 'The TCP address to serve on, defaulting to 0.0.0.0 (all interfaces).' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from serve" -l watch -d 'Watch for file changes and restart automatically' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-hmr -d 'UNSTABLE: Watch for file changes and hot replace modules' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts	'',tsx	'',js	'',jsx	''}"
complete -c deno -n "__fish_seen_subcommand_from serve" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from serve" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from serve" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from serve" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from serve" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from serve" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from serve" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from serve" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from serve" -l no-code-cache -d 'Disable V8 code cache feature'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from serve" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from serve" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from serve" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from add" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from add" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from add" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from bench" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from bench" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from bench" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from bench" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l ignore -d 'Ignore files' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l filter -d 'Run benchmarks with this string or pattern in the bench name' -r
complete -c deno -n "__fish_seen_subcommand_from bench" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from bench" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from bench" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from bench" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from bench" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from bench" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from bench" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from bench" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from bench" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from bench" -l json -d 'UNSTABLE: Output benchmark result in JSON format'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-run -d 'Cache bench modules, but don\'t run benchmarks'
complete -c deno -n "__fish_seen_subcommand_from bench" -l watch -d 'Watch for file changes and restart automatically'
complete -c deno -n "__fish_seen_subcommand_from bench" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from bench" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from bundle" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from bundle" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from bundle" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bundle" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from bundle" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from bundle" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bundle" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from bundle" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from bundle" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from bundle" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from bundle" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from bundle" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts	'',tsx	'',js	'',jsx	''}"
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from bundle" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l watch -d 'Watch for file changes and restart automatically'
complete -c deno -n "__fish_seen_subcommand_from bundle" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from bundle" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from cache" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from cache" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from cache" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from cache" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from cache" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from cache" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from cache" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from cache" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from cache" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from cache" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from cache" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from cache" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from cache" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from cache" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from cache" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from cache" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from cache" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from cache" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from check" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from check" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from check" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from check" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from check" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from check" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from check" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from check" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from check" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from check" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from check" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from check" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from check" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from check" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from check" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from check" -l all -d 'Type-check all code, including remote modules and npm packages'
complete -c deno -n "__fish_seen_subcommand_from check" -l remote -d 'Type-check all modules, including remote'
complete -c deno -n "__fish_seen_subcommand_from check" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from compile" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from compile" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from compile" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from compile" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from compile" -l include -d 'Additional module to include in the module graph' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -s o -l output -d 'Output file (defaults to $PWD/<inferred-name>)' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l target -d 'Target OS architecture' -r -f -a "{x86_64-unknown-linux-gnu	'',aarch64-unknown-linux-gnu	'',x86_64-pc-windows-msvc	'',x86_64-apple-darwin	'',aarch64-apple-darwin	''}"
complete -c deno -n "__fish_seen_subcommand_from compile" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts	'',tsx	'',js	'',jsx	''}"
complete -c deno -n "__fish_seen_subcommand_from compile" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from compile" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from compile" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from compile" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from compile" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from compile" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from compile" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from compile" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from compile" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from compile" -l no-terminal -d 'Hide terminal on Windows'
complete -c deno -n "__fish_seen_subcommand_from compile" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from completions" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from completions" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from completions" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from coverage" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from coverage" -l ignore -d 'Ignore coverage files' -r -F
complete -c deno -n "__fish_seen_subcommand_from coverage" -l include -d 'Include source files in the report' -r
complete -c deno -n "__fish_seen_subcommand_from coverage" -l exclude -d 'Exclude source files from the report' -r
complete -c deno -n "__fish_seen_subcommand_from coverage" -l output -d 'Output file (defaults to stdout) for lcov' -r -F
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from coverage" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l lcov -d 'Output coverage report in lcov format'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l html -d 'Output coverage report in HTML format in the given directory'
complete -c deno -n "__fish_seen_subcommand_from coverage" -l detailed -d 'Output coverage report in detailed format in the terminal.'
complete -c deno -n "__fish_seen_subcommand_from coverage" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from doc" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from doc" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from doc" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from doc" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from doc" -l name -d 'The name that will be displayed in the docs' -r
complete -c deno -n "__fish_seen_subcommand_from doc" -l output -d 'Directory for HTML documentation output' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_seen_subcommand_from doc" -l filter -d 'Dot separated path to symbol' -r
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from doc" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from doc" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from doc" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from doc" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from doc" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from doc" -l json -d 'Output documentation in JSON format'
complete -c deno -n "__fish_seen_subcommand_from doc" -l html -d 'Output documentation in HTML format'
complete -c deno -n "__fish_seen_subcommand_from doc" -l private -d 'Output private documentation'
complete -c deno -n "__fish_seen_subcommand_from doc" -l lint -d 'Output documentation diagnostics.'
complete -c deno -n "__fish_seen_subcommand_from doc" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from eval" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from eval" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from eval" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from eval" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from eval" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from eval" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from eval" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from eval" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from eval" -l inspect -d 'Activate inspector on host:port (default: 127.0.0.1:9229)' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from eval" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from eval" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts	'',tsx	'',js	'',jsx	''}"
complete -c deno -n "__fish_seen_subcommand_from eval" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from eval" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from eval" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from eval" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from eval" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from eval" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from eval" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from eval" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from eval" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from eval" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from eval" -s T -l ts -d 'deprecated: Use `--ext=ts` instead. The `--ts` and `-T` flags are deprecated and will be removed in Deno 2.0.'
complete -c deno -n "__fish_seen_subcommand_from eval" -s p -l print -d 'print result to stdout'
complete -c deno -n "__fish_seen_subcommand_from eval" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from fmt" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from fmt" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from fmt" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts	'',tsx	'',js	'',jsx	'',md	'',json	'',jsonc	'',ipynb	''}"
complete -c deno -n "__fish_seen_subcommand_from fmt" -l ignore -d 'Ignore formatting particular source files' -r -F
complete -c deno -n "__fish_seen_subcommand_from fmt" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from fmt" -l use-tabs -d 'Use tabs instead of spaces for indentation. Defaults to false.' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from fmt" -l line-width -d 'Define maximum line width. Defaults to 80.' -r
complete -c deno -n "__fish_seen_subcommand_from fmt" -l indent-width -d 'Define indentation width. Defaults to 2.' -r
complete -c deno -n "__fish_seen_subcommand_from fmt" -l single-quote -d 'Use single quotes. Defaults to false.' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from fmt" -l prose-wrap -d 'Define how prose should be wrapped. Defaults to always.' -r -f -a "{always	'',never	'',preserve	''}"
complete -c deno -n "__fish_seen_subcommand_from fmt" -l no-semicolons -d 'Don\'t use semicolons except where necessary. Defaults to false.' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from fmt" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l check -d 'Check if the source files are formatted'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l watch -d 'Watch for file changes and restart automatically'
complete -c deno -n "__fish_seen_subcommand_from fmt" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from fmt" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from init" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from init" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from init" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from init" -s h -l help -d 'Print help'
complete -c deno -n "__fish_seen_subcommand_from info" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from info" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from info" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from info" -l location -d 'Show files used for origin bound APIs like the Web Storage API when running a script with \'--location=<HREF>\'' -r -f
complete -c deno -n "__fish_seen_subcommand_from info" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from info" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from info" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from info" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from info" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from info" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from info" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from info" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from info" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from info" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from info" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from info" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from info" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from info" -l json -d 'UNSTABLE: Outputs the information in JSON format'
complete -c deno -n "__fish_seen_subcommand_from info" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from install" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from install" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from install" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from install" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l inspect -d 'Activate inspector on host:port (default: 127.0.0.1:9229)' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from install" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from install" -s n -l name -d 'Executable file name' -r
complete -c deno -n "__fish_seen_subcommand_from install" -l root -d 'Installation root' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_seen_subcommand_from install" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from install" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from install" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from install" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from install" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from install" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from install" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from install" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from install" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from install" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from install" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from install" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from install" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from install" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from install" -s f -l force -d 'Forcefully overwrite existing installation'
complete -c deno -n "__fish_seen_subcommand_from install" -s g -l global -d 'Install a package or script as a globally available executable'
complete -c deno -n "__fish_seen_subcommand_from install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l conn -d 'Path to JSON file describing connection parameters, provided by Jupyter' -r -F
complete -c deno -n "__fish_seen_subcommand_from jupyter" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l install -d 'Installs kernelspec, requires \'jupyter\' command to be available.'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l kernel -d 'Start the kernel'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from jupyter" -s h -l help -d 'Print help'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l root -d 'Installation root' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -s g -l global -d 'Remove globally installed package or module'
complete -c deno -n "__fish_seen_subcommand_from uninstall" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from lsp" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from lsp" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from lsp" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from lsp" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from lint" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from lint" -l rules-tags -d 'Use set of rules with a tag' -r
complete -c deno -n "__fish_seen_subcommand_from lint" -l rules-include -d 'Include lint rules' -r
complete -c deno -n "__fish_seen_subcommand_from lint" -l rules-exclude -d 'Exclude lint rules' -r
complete -c deno -n "__fish_seen_subcommand_from lint" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from lint" -l ignore -d 'Ignore linting particular source files' -r -F
complete -c deno -n "__fish_seen_subcommand_from lint" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from lint" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from lint" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from lint" -l fix -d 'Fix any linting errors for rules that support it'
complete -c deno -n "__fish_seen_subcommand_from lint" -l rules -d 'List available rules'
complete -c deno -n "__fish_seen_subcommand_from lint" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from lint" -l json -d 'Output lint result in JSON format'
complete -c deno -n "__fish_seen_subcommand_from lint" -l compact -d 'Output lint result in compact format'
complete -c deno -n "__fish_seen_subcommand_from lint" -l watch -d 'Watch for file changes and restart automatically'
complete -c deno -n "__fish_seen_subcommand_from lint" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from lint" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from publish" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from publish" -l token -d 'The API token to use when publishing. If unset, interactive authentication is be used' -r
complete -c deno -n "__fish_seen_subcommand_from publish" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from publish" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from publish" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from publish" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from publish" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from publish" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from publish" -l dry-run -d 'Prepare the package for publishing performing all checks and validations without uploading'
complete -c deno -n "__fish_seen_subcommand_from publish" -l allow-slow-types -d 'Allow publishing with slow types'
complete -c deno -n "__fish_seen_subcommand_from publish" -l allow-dirty -d 'Allow publishing if the repository has uncommitted changed'
complete -c deno -n "__fish_seen_subcommand_from publish" -l no-provenance -d 'Disable provenance attestation. Enabled by default on Github actions, publicly links the package to where it was built and published from.'
complete -c deno -n "__fish_seen_subcommand_from publish" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from repl" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from repl" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from repl" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from repl" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l inspect -d 'Activate inspector on host:port (default: 127.0.0.1:9229)' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from repl" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l eval-file -d 'Evaluates the provided file(s) as scripts when the REPL starts. Accepts file paths and URLs.' -r -F
complete -c deno -n "__fish_seen_subcommand_from repl" -l eval -d 'Evaluates the provided code when the REPL starts.' -r
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from repl" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from repl" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from repl" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from repl" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from repl" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from repl" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from repl" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from repl" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from repl" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from repl" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from repl" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from repl" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from repl" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from repl" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from task" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from task" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from task" -l cwd -d 'Specify the directory to run the task in' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from task" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from task" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from task" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from test" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from test" -l no-check -d 'Skip type-checking modules' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from test" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from test" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-read -d 'Allow file system read access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-read
  --allow-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-read -d 'Deny file system read access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-read
  --deny-read="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-write -d 'Allow file system write access. Optionally specify allowed paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-write
  --allow-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-write -d 'Deny file system write access. Optionally specify denied paths.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-write
  --deny-write="/etc,/var/log.txt"' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-net
  --allow-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-net
  --deny-net="localhost:8080,deno.land"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-env
  --allow-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-env
  --deny-env="PORT,HOME,PATH"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-sys
  --allow-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-sys
  --deny-sys="systemMemoryInfo,osRelease"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-run
  --allow-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-run
  --deny-run="whoami,ps"' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --allow-ffi
  --allow-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
Examples:
  --deny-ffi
  --deny-ffi="./libfoo.so"' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l inspect -d 'Activate inspector on host:port (default: 127.0.0.1:9229)' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l location -d 'Value of \'globalThis.location\' used by some web APIs' -r -f
complete -c deno -n "__fish_seen_subcommand_from test" -l v8-flags -d 'Set V8 command line options' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l check -d 'Type-check modules' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l ignore -d 'Ignore files' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l fail-fast -d 'Stop after N errors. Defaults to stopping after first failure.' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l filter -d 'Run tests with this string or pattern in the test name' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l shuffle -d 'Shuffle the order in which the tests are run' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l coverage -d 'Collect coverage profile data into DIR. If DIR is not specified, it uses \'coverage/\'.' -r
complete -c deno -n "__fish_seen_subcommand_from test" -s j -l jobs -d 'deprecated: The `--jobs` flag is deprecated and will be removed in Deno 2.0. Use the `--parallel` flag with possibly the `DENO_JOBS` environment variable instead.' -r
complete -c deno -n "__fish_seen_subcommand_from test" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l junit-path -d 'Write a JUnit XML test report to PATH. Use \'-\' to write to stdout which is the default when PATH is not provided.' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l reporter -d 'Select reporter to use. Default to \'pretty\'.' -r -f -a "{pretty	'',dot	'',junit	'',tap	''}"
complete -c deno -n "__fish_seen_subcommand_from test" -l env -d 'Load .env file' -r -F
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from test" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from test" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from test" -l lock-write -d 'Force overwriting the lock file.'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-lock -d 'Disable auto discovery of the lock file.'
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-hrtime -d 'Allow high-resolution time measurement. Note: this can enable timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from test" -l deny-hrtime -d 'Deny high-resolution time measurement. Note: this can prevent timing attacks and fingerprinting.
Docs: https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from test" -s A -l allow-all -d 'Allow all permissions. Learn more about permissions in Deno:
https://deno.land/manual@v1.43.3/basics/permissions
'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_seen_subcommand_from test" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_seen_subcommand_from test" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-run -d 'Cache test modules, but don\'t run tests'
complete -c deno -n "__fish_seen_subcommand_from test" -l trace-ops -d 'Deprecated alias for --trace-leaks.'
complete -c deno -n "__fish_seen_subcommand_from test" -l trace-leaks -d 'Enable tracing of leaks. Useful when debugging leaking ops in test, but impacts test execution time.'
complete -c deno -n "__fish_seen_subcommand_from test" -l doc -d 'Type-check code blocks in JSDoc and Markdown'
complete -c deno -n "__fish_seen_subcommand_from test" -l allow-none -d 'Don\'t return error code if no test files are found'
complete -c deno -n "__fish_seen_subcommand_from test" -l parallel -d 'Run test modules in parallel. Parallelism defaults to the number of available CPUs or the value in the DENO_JOBS environment variable.'
complete -c deno -n "__fish_seen_subcommand_from test" -l watch -d 'Watch for file changes and restart automatically'
complete -c deno -n "__fish_seen_subcommand_from test" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_seen_subcommand_from test" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from types" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from types" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from types" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from types" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l version -d 'The version to upgrade to' -r
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l output -d 'The path to output the updated version to' -r -F
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l dry-run -d 'Perform all checks without replacing old exe'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -s f -l force -d 'Replace current exe even if not out-of-date'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -l canary -d 'Upgrade to canary builds'
complete -c deno -n "__fish_seen_subcommand_from upgrade" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c deno -n "__fish_seen_subcommand_from vendor" -s L -l log-level -d 'Set log level' -r -f -a "{trace	'',debug	'',info	''}"
complete -c deno -n "__fish_seen_subcommand_from vendor" -l output -d 'The directory to output the vendored modules to' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_seen_subcommand_from vendor" -s c -l config -d 'Specify the configuration file' -r -F
complete -c deno -n "__fish_seen_subcommand_from vendor" -l import-map -d 'Load import map file' -r -F
complete -c deno -n "__fish_seen_subcommand_from vendor" -l lock -d 'Check the specified lock file.

If value is not provided, defaults to "deno.lock" in the current working directory.' -r -F
complete -c deno -n "__fish_seen_subcommand_from vendor" -l node-modules-dir -d 'Enables or disables the use of a local node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from vendor" -l vendor -d 'UNSTABLE: Enables or disables the use of a local vendor folder for remote modules and node_modules folder for npm packages' -r -f -a "{true	'',false	''}"
complete -c deno -n "__fish_seen_subcommand_from vendor" -s r -l reload -d 'Reload source code cache (recompile TypeScript)' -r -F
complete -c deno -n "__fish_seen_subcommand_from vendor" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable -d 'Enable unstable features and APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-byonm -d 'Enable unstable \'bring your own node_modules\' feature'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing.'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-webgpu -d 'Enable unstable `WebGPU` API'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_seen_subcommand_from vendor" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_seen_subcommand_from vendor" -s f -l force -d 'Forcefully overwrite conflicting files in existing output directory'
complete -c deno -n "__fish_seen_subcommand_from vendor" -l no-config -d 'Disable automatic loading of the configuration file.'
complete -c deno -n "__fish_seen_subcommand_from vendor" -s h -l help -d 'Print help (see more with \'--help\')'
