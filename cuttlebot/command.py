import asyncio
import shlex


class Command:
    def __init__(self):
        self.objects = {}

    def register(self, name, object):
        self.objects[name] = object

    @asyncio.coroutine
    def __call__(self, bot, message: "message"):
        text = message.get('text', '')
        name = "<@{id}>".format(id=bot.id)
        if not text.startswith(name):
            return
        text = text[len(name):].strip()
        if text.startswith(":"):
            text = text[1:].strip()
        command = shlex.split(text)
        if command == []:
            return
        method, *args = command
        if method not in self.objects:
            yield from bot.post(message['channel'],
                                "Unknown command: {}".format(method))
            return
        yield from self.objects[method](bot, message, *args)

    __annotations__ = __call__.__annotations__

commands = Command()
