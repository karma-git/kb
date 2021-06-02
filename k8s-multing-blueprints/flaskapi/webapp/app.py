from flask import Flask, render_template, jsonify
from functools import wraps
import subprocess
from time import time

app = Flask(__name__)


def cleaner(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        # from byte string to object str
        string = result.decode('utf-8')
        # clean string from trail symbols
        clean = string.rstrip()
        return clean

    return wrapper


@cleaner
def get_container_hostname() -> str:
    hostname = subprocess.check_output(['cat', '/etc/hostname'])
    return hostname


def get_current_timestamp() -> str:
    t: float = time()
    timestamp = str(t)
    return timestamp


@cleaner
def get_container_uuid() -> str:
    cmd = r"cat /proc/self/cgroup | grep docker | sed s/\\//\\n/g | tail -1"
    ps = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = ps.communicate()[0]
    return output


@app.route("/")
def root():
    return render_template("index.html")


@app.route("/ready")
def container():
    return jsonify(
        hostName=get_container_hostname(),
        timeStamp=get_current_timestamp(),
        uuid=get_container_uuid(),
    )
