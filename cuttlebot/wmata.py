from butterfield.utils import at_bot
import asyncio
import aiowmata.rail


@at_bot
@asyncio.coroutine
def wmata(bot, message: "message"):

    def prediction_to_string(prediction):
        eta = prediction['Min'].strip()
        if eta == "BRD":
            eta = "is boarding now"
        elif eta == "ARR":
            eta = "is just arriving"
        else:
            eta = "in " + eta + " minutes"

        return ("{Car} car train to {DestinationName} arrriving to "
                "{LocationName} {eta} (on track {Group})".format(eta=eta, **prediction))

    text = message.get('text', '').lower()
    if 'wmata' not in text:
        return

    predictions = yield from aiowmata.rail.get_predictions("B35")

    yield from bot.post(
        message['channel'],
        "\n".join((prediction_to_string(x) for x in sorted(predictions['Trains'], key=lambda x: x['Group']))),
    )
