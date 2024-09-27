import requests

def getCookie(url, accessToken):
    
    payload = {
        "authorizationCode": accessToken
    }
    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    response = requests.post(url, data=payload, headers=headers)

    if response.status_code == 201:
        cookie = response.headers.get('set-cookie')
        if cookie:
            return cookie.split(";")[0]
        else:
            return None
    else:
        response.raise_for_status()
