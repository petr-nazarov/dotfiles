# ctrl+shift+v that also pastes images into Claude Code.
#
# kitty only ever pastes text, so with an image in the clipboard (a
# screenshot, a picture copied from Telegram) ctrl+shift+v did nothing.
# Claude Code reads an image from the clipboard itself, on ctrl+v. So when
# the clipboard holds an image and no text, send ctrl+v instead; otherwise
# paste as usual.
#
# Over ssh that clipboard is the remote machine's, which never has the
# image. So when the window runs ssh, the image is copied over to where the
# remote Claude can read it (paste-remote.sh: into the devcontainer of the
# active tmux pane, else onto the host) and its path is pasted instead;
# Claude attaches a pasted image path as the image.

import os
import shlex
import subprocess

from kittens.tui.handler import result_handler
from kitty.constants import config_dir

# kitty runs this file without __file__, so find it through the config dir
REMOTE_SCRIPT = os.path.join(config_dir, 'paste-remote.sh')
# ssh options that take a value, from ssh(1)
SSH_ARG_OPTS = set('BbcDEeFIiJLlmOoPpQRSWw')


def main(args: list[str]) -> None:
    pass


def ssh_destination(cmdline: list[str]) -> str | None:
    if not cmdline or os.path.basename(cmdline[0]) != 'ssh':
        return None
    args = iter(cmdline[1:])
    for a in args:
        if a == '--':
            return next(args, None)
        if a.startswith('-') and len(a) > 1:
            # -p22 carries its value; a bare -p takes the next argument
            if a[-1] in SSH_ARG_OPTS and not any(c in SSH_ARG_OPTS for c in a[1:-1]):
                next(args, None)
            continue
        return a
    return None


def window_ssh_destination(w) -> str | None:
    for p in w.child.foreground_processes:
        dest = ssh_destination(p.get('cmdline') or [])
        if dest:
            return dest
    return None


def upload_image(dest: str, png: bytes) -> str:
    with open(REMOTE_SCRIPT) as f:
        script = f.read()
    r = subprocess.run(['ssh', dest, 'sh -c ' + shlex.quote(script)], input=png, capture_output=True, timeout=15)
    if r.returncode != 0 or not r.stdout:
        raise RuntimeError(r.stderr.decode().strip() or f'exit code {r.returncode}')
    return r.stdout.decode()


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: None, target_window_id: int, boss) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return
    types = boss.clipboard.get_available_mime_types_for_paste()
    has_text = any(t.startswith('text/plain') for t in types)
    if has_text or not any(t.startswith('image/') for t in types):
        boss.paste_from_clipboard()
        return
    dest = window_ssh_destination(w)
    png = boss.clipboard.get_mime_data('image/png') if dest else b''
    if not png:
        w.send_key('ctrl+v')
        return
    try:
        path = upload_image(dest, png)
    except Exception as e:
        boss.show_error('Image paste failed', f'Could not copy the image to {dest}: {e}')
        return
    w.paste_text(path)
