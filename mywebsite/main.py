"""
Simple static web-site on flask
"""
from flask import (
    Flask,
    render_template,
    request,
)
from flask_bootstrap import Bootstrap
from flask_moment import Moment
from datetime import datetime

app = Flask(__name__)

bootstrap = Bootstrap(app)

moment = Moment(app)


@app.route('/')
def index():
    ip = request.remote_addr
    current_time = datetime.utcnow()
    return render_template('index.html', ip=ip, current_time=current_time)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
