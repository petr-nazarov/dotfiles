import dagger
from dagger import dag, function, object_type, Directory

@object_type
class Dotfiles:
    @function
    async def scan_secrets(self, source: Directory) -> str:
        clean_source = source.without_directory(".git")
        # 1. Gitleaks Fix: Use the full path or just the subcommand 
        # because the binary is usually the entrypoint.
        gitleaks = (
            dag.container()
            .from_("zricethezav/gitleaks:latest")
            .with_mounted_directory("/src", clean_source)
            .with_workdir("/src")
            # We use 'gitleaks' explicitly here as the command
            .with_exec(["gitleaks", "detect", "--verbose", "--source", "."])
        )

        # 2. TruffleHog Fix: Use the 'trufflehog' binary name explicitly
        trufflehog = (
            dag.container()
            .from_("trufflesecurity/trufflehog:latest")
            .with_mounted_directory("/src", clean_source)
            .with_workdir("/src")
            .with_exec(["trufflehog", "filesystem", ".", "--fail"])
        )

        # Execute
        gitleaks_output = await gitleaks.stdout()
        trufflehog_output = await trufflehog.stdout()
        
        return f"--- Gitleaks ---\n{gitleaks_output}\n\n--- TruffleHog ---\n{trufflehog_output}"
