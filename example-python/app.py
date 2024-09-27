from SPARQLWrapper import SPARQLWrapper, JSON
from session import getCookie
from acmidm import getToken
import os

# get a token from acmidm
client_id = os.environ.get('CLIENT_ID')
client_secret= os.environ.get('CLIENT_SECRET')
resp = getToken(client_id, client_secret)
access_token = resp['access_token']
print("token will expire in", int(resp["expires_in"]), "seconds")

# get a session 
session_cookie = getCookie('http://localhost/m2msessions', access_token)

# execute query, from there you no longer need to get a token
sparql_endpoint = 'http://localhost/sparql'

sparql = SPARQLWrapper(sparql_endpoint)
sparql.setReturnFormat(JSON)
sparql.addCustomHttpHeader('Cookie', session_cookie) 


sparql.setQuery("""
    select distinct ?s where {
      ?s a <http://bittich.be/AppDataProtected>
    }
""")


try:
    results = sparql.query().convert()
    for result in results['results']['bindings']:
        print(result['s']['value'])
except Exception as e:
    print(f"An error occurred: {e}")
