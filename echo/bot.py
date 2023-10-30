import asyncio
import os
import json
import logging

from telegram.ext import MessageHandler, ApplicationBuilder, filters
from telegram import Update


logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)


async def echo(update, context):
    await context.bot.send_message(
        chat_id=update.message.chat_id,
        text=f"{update.message.from_user.first_name}: {update.message.text}",
    )


async def async_handler(event, context):
    # print(json.dumps(event), context)
    application = ApplicationBuilder().token(os.environ["TELEGRAM_BOT_TOKEN"]).build()
    await application.initialize()
    application.add_handler(MessageHandler(filters.TEXT, echo))

    await application.process_update(
        Update.de_json(json.loads(event["body"]), application.bot)
    )


def lambda_handler(event, context):
    asyncio.get_event_loop().run_until_complete(async_handler(event, context))
