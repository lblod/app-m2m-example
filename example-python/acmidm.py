import requests

def getToken(client_id, client_secret):
    url = "https://authenticatie-ti.vlaanderen.be/op/v1/token"

    payload = {
        "scope": "vo_info",
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret
    }

    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    response = requests.post(url, data=payload, headers=headers)

    response_data = response.json()

    return response_data
