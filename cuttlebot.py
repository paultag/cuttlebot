from butterfield.utils import at_bot
import asyncio


@at_bot
@asyncio.coroutine
def whosleft(bot, message: "message"):
    text = message.get('text', '').lower()
    yield from bot.post(message['channel'], "")
