from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse
import os, hashlib, time
from .ddb import put_mapping, get_mapping

app = FastAPI()


@app.get("/", response_class=HTMLResponse)
def homepage():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Simple URL Shortener</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
                background: #f4f4f4;
            }
            .container {
                background: white;
                padding: 20px;
                border-radius: 8px;
                max-width: 500px;
                margin: auto;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            input[type="text"] {
                width: 100%;
                padding: 8px;
                margin-bottom: 10px;
            }
            button {
                padding: 8px 16px;
                background: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
            }
            button:hover {
                background: #45a049;
            }
            #result {
                margin-top: 15px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>URL Shortener</h2>
            <input id="urlInput" type="text" placeholder="Enter URL here" />
            <button onclick="shorten()">Shorten</button>
            <div id="result"></div>
        </div>

        <script>
            async function shorten() {
                const url = document.getElementById("urlInput").value;
                const response = await fetch("/shorten", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({url})
                });

                const data = await response.json();

                if (response.ok) {
                    document.getElementById("result").innerHTML =
                        "Short URL: <a href='/" + data.short + "'>" +
                        window.location.origin + "/" + data.short + "</a>";
                } else {
                    document.getElementById("result").innerText = data.detail;
                }
            }
        </script>
    </body>
    </html>
    """


@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}


@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")

    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}


@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    return RedirectResponse(item["url"])
