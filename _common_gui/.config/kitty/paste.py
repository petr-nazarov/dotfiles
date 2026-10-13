# ctrl+shift+v that also pastes images into Claude Code.
#
# kitty only ever pastes text, so with an image in the clipboard (a
# screenshot, a picture copied from Telegram) ctrl+shift+v did nothing.
# Claude Code reads an image from the clipboard itself, on ctrl+v. So when
# the clipboard holds an image and no text, send ctrl+v instead; otherwise
# paste as usual.

from kittens.tui.handler import result_handler


def main(args: list[str]) -> None:
    pass


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: None, target_window_id: int, boss) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return
    types = boss.clipboard.get_available_mime_types_for_paste()
    has_text = any(t.startswith('text/plain') for t in types)
    if not has_text and any(t.startswith('image/') for t in types):
        w.send_key('ctrl+v')
    else:
        boss.paste_from_clipboard()
