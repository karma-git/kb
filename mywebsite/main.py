"""
Simple static web-site on flask
"""
from flask import (
    Flask,
    render_template,
    request,
)
from flask_bootstrap import Bootstrap

app = Flask(__name__)

bootstrap = Bootstrap(app)


@app.route('/')
def index():
    ip = request.remote_addr
    return render_template('index.html', ip=ip)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
