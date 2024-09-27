# M2M-Example

Eexample on how to use m2m on a semtech stack with a python client using sparqlWrapper.

## How to

- create a `docker-compose.override.yml` file at the root of this repo
- override `MU_APPLICATION_AUTH_CLIENT_ID` and `MU_APPLICATION_AUTH_CLIENT_SECRET` with the clientId/secret of the SERVER:

```yml
services:
  m2m:
    environment:
      MU_APPLICATION_AUTH_CLIENT_ID: "myClientID"
      MU_APPLICATION_AUTH_CLIENT_SECRET: "mySecret"
```

- run `docker compose up -d`

- now go to `cd example-python`
- run `pipenv install`
- run the following command, make sure to use the client id/secret of the client APP:
  `CLIENT_ID=<CLIENT_ID> CLIENT_SECRET=<SECRET> pipenv run app`

- You should get the following output:

```
token will expire in 3600 seconds
http://example.org/data1
http://example.org/data2
http://example.org/data3

```

## Important note

The mu auth query being used checks if the token is not expired, as you can see below.

If kept as is, it is the responsibility of the client app to either refresh the token,
or get a new token/session once it expires.

```ex
  defp logged_in_app() do
    %AccessByQuery{
      vars: [],
      query: "PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
      PREFIX session: <http://mu.semte.ch/vocabularies/session/>
      PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
      PREFIX dcterms: <http://purl.org/dc/terms/>
      SELECT DISTINCT ?account WHERE {
      <SESSION_ID> session:account ?account;
                   ext:applicationName \"test-nordine\";
                   ext:exp ?exp.
      values ?epoch { \"1970-01-01T00:00:00\"^^xsd:dateTime }
      BIND(ROUND(NOW() - ?epoch ) AS ?current_time)
      FILTER(?exp > ?current_time)

      }"
    }
  end
```
