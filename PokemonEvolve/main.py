# Code lấy từ đây https://sanic-jwt.readthedocs.io/en/latest/pages/simpleusage.html
import csv
import os

from sanic import Sanic
from sanic.response import json
from sanic_jwt import exceptions
from sanic_jwt import initialize
from sanic_jwt.decorators import protected


def store_refresh_token(*args, **kwargs):
    user_id = kwargs.get("user_id")
    user = userid_table.get(user_id)
    refresh_token = kwargs.get("refresh_token")
    setattr(user, "refresh_token", refresh_token)
    user.refresh_token = refresh_token

    save_users()


def retrieve_user(request, *args, **kwargs):
    if "user_id" in kwargs:
        user_id = kwargs.get("user_id")
    else:
        if "payload" in kwargs:
            payload = kwargs.get("payload")
        else:
            payload = request.app.auth.extract_payload(request)
        user_id = payload.get("user_id")
    user = userid_table.get(user_id)
    return user


def retrieve_refresh_token(request, *args, **kwargs):
    user = request.app.auth.retrieve_user(request, **kwargs)
    return user.refresh_token


async def authenticate(request, *args, **kwargs):
    username = request.json.get("username", None)
    password = request.json.get("password", None)

    if not username or not password:
        raise exceptions.AuthenticationFailed("Missing username or password.")

    user = username_table.get(username, None)
    if user is None:
        raise exceptions.AuthenticationFailed("User not found.")

    if password != user.password:
        raise exceptions.AuthenticationFailed("Password is incorrect.")

    return user

# ----------------------
app = Sanic()
initialize(
    app,
    authenticate=authenticate,
    store_refresh_token=store_refresh_token,
    retrieve_refresh_token=retrieve_refresh_token,
    retrieve_user=retrieve_user,
)
app.config.SANIC_JWT_REFRESH_TOKEN_ENABLED = True
app.config.SANIC_JWT_CLAIM_ISS = "foo:bar"
app.config.SANIC_JWT_CLAIM_IAT = True
app.config.SANIC_JWT_CLAIM_NBF = True
app.config.SANIC_JWT_CLAIM_AUD = "bar:foo"


class User:
    def __init__(self, id, username, password):
        setattr(self, "user_id", id)
        self.username = username
        self.password = password

    def __str__(self):
        return "User(id='%s')" % self.user_id

    def serialized(self):
        output = [
            getattr(self, "user_id"),
            self.username,
            self.password,
            getattr(self, "refresh_token", ""),
        ]
        return output

    def to_dict(self):
        return {"user_id": self.user_id}


users = []
file_path = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "users.csv"
)

with open(file_path, "r") as file:
    reader = csv.reader(file)

    for line in reader:
        user = User(line[0], line[1], line[2])

        try:
            user.refresh_token = line[3]
        except IndexError:
            pass

        users.append(user)

username_table = {u.username: u for u in users}
userid_table = {getattr(u, "user_id"): u for u in users}


def save_users():
    with open(file_path, "w") as file:
        writer = csv.writer(file)
        for user in users:
            writer.writerow(user.serialized())


@app.route("/pokemon")
async def test(request):
    return json([
        {"id": 1, "name": "Bulbasaur", "photo": "bulbasaur.jpg"},
        {"id": 2, "name": "Charmander", "photo": "charmander.jpg"},
        {"id": 3, "name": "Caterpie", "photo": "caterpie.jpg"},
        {"id": 4, "name": "Eevee", "photo": "eevee.jpg"},
        {"id": 5, "name": "Igglybuff", "photo": "igglybuff.jpg"},
        {"id": 6, "name": "Elekid", "photo": "elekid.jpg"},
        {"id": 7, "name": "Horsea", "photo": "horsea.jpg"},
        {"id": 8, "name": "Pikachu", "photo": "pikachu.jpg"},
        {"id": 9, "name": "Squirtle", "photo": "squirtle.jpg"},
        {"id": 10, "name": "Pidgey", "photo": "pidgey.jpg"},
    ])
# https://pokemondb.net/evolution

@app.route("/evolve")
@protected()
async def protected(request):
    return json([
        {"id": 11, "name": "Venusaur", "photo": "venusaur.jpg"},
        {"id": 22, "name": "Charizard", "photo": "charizard.jpg"},
        {"id": 33, "name": "Butterfree", "photo": "butterfree.jpg"},
        {"id": 44, "name": "Flareon", "photo": "flareon.jpg"},
        {"id": 55, "name": "Wigglytuff", "photo": "wigglytuff.jpg"},
        {"id": 66, "name": "Electivire", "photo": "electivire.jpg"},
        {"id": 77, "name": "Kingdra", "photo": "kingdra.jpg"},
        {"id": 88, "name": "Raichu", "photo": "raichu.jpg"},
        {"id": 99, "name": "Blastoise", "photo": "blastoise.jpg"},
        {"id": 1010, "name": "Pidgeot", "photo": "pidgeot.jpg"},
    ])

app.static('/photo', './photo')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

'''
curl -iv -H "Content-Type: application/json" -d '{"username": "user1", "password": "abcxyz"}' http://localhost:8000/auth

curl -iv -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTY2NTExNDB9.vmfQbfx0H8vIR6wILlLqS82bJILdwecfWlFRQuHb3Ck" http://localhost:8000/auth/verify
'''
