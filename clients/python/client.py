#!/usr/bin/env python3

import asyncio
import json

import websockets


async def connect(user, token):
    uri = f"ws://localhost:4000/socket/websocket?token={token}"
    async with websockets.connect(uri) as websocket:
        channel_payload = json.dumps({
            "topic": f"session:{user}",
            "event": "phx_join",
            "payload": {},
            "ref": 1
        })

        await websocket.send(channel_payload)
        print(f"> {channel_payload}")

        server_response = await websocket.recv()
        print(f"< {server_response}")

        if get_payload(server_response)["status"] != "ok":
            print("Exiting")
            exit(1)

        total_payoff = 0

        bandit = input("Choose a bandit: ")
        while bandit:
            bandit_payload = json.dumps({
                "topic": f"session:{user}",
                "event": "bandit",
                "payload": {
                    "bandit_id": bandit
                },
                "ref": 2
            })

            await websocket.send(bandit_payload)
            print(f"> {bandit_payload}")

            server_response = await websocket.recv()
            print(f"< {server_response}")

            payload = get_payload(server_response)
            if payload["status"] == "ok":
                total_payoff += int(payload["response"]["payoff"])

            bandit = input("Choose a bandit: ")

        print(f"Recieved a total payoff of {total_payoff}")


def get_payload(response):
    json_response = json.loads(response)
    return json_response["payload"]


if __name__ == "__main__":
    user = "sample_user"
    token = 12356
    asyncio.get_event_loop().run_until_complete(connect(user, token))
