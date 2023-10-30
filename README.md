# telegram-serverless-echo

Example [Telegram](https://telegram.org) bot that is deployed to AWS Lambda and is called via [function URL](https://docs.aws.amazon.com/lambda/latest/dg/lambda-urls.html).

## Set up a Telegram bot

Chat to [@botfather](https://t.me/botfather)

## Build and deploy

```bash
./build_lambda.sh # package echo/bot.py and dependencies as lambda.zip
TF_VAR_telegram_token=<token> terraform -chdir=terraform apply
# the bot's function url is returned as an output
```

## Configure the bot's webhook

```bash
curl -F "url=https://...on.aws/" https://api.telegram.org/bot<token>/setWebhook
```
