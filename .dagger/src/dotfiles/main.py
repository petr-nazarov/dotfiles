
import dagger
import anyio
from dagger import dag, function, object_type, Directory

@object_type
class Dotfiles:
    @function
    async def scan_repo(self, source: Directory):
        async with anyio.create_task_group() as tg:
            tg.start_soon(self.git_leaks_scan, source)
            tg.start_soon(self.trufflehog_scan, source)

    @function
    async def git_leaks_scan(self, source: Directory) -> str:
        clean_source = source.without_directory(".git")
        gitleaks = (
            dag.container()
            .from_("zricethezav/gitleaks:latest")
            .with_mounted_directory("/src", clean_source)
            .with_workdir("/src")
            # We use 'gitleaks' explicitly here as the command
            .with_exec(["gitleaks", "detect", "--verbose", "--source", "."])
        )

        # Execute
        output = await gitleaks.stdout()
        
        return output

    @function
    async def trufflehog_scan(self, source: Directory) -> str:
        clean_source = source.without_directory(".git")
        trufflehog = (
            dag.container()
            .from_("trufflesecurity/trufflehog:latest")
            .with_mounted_directory("/src", clean_source)
            .with_workdir("/src")
            .with_exec(["trufflehog", "filesystem", ".", "--fail"])
        )

        output = await trufflehog.stdout()
        return output
