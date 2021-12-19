"""
Basic Auth for CloudFront
"""
import logging
import base64
from http import HTTPStatus
import boto3


USERNAME = "demo-s3-user"
PASSWORD_SECRET_NAME = "demo-s3-password"

# logger configure
logger = logging.getLogger(__name__)
c_handler = logging.StreamHandler()
c_handler.setLevel(logging.DEBUG)
logger.setLevel(logging.DEBUG)
c_format = logging.Formatter(
    "%(asctime)s - %(levelname)s - %(message)s", datefmt="%d-%b-%y %H:%M:%S"
)
c_handler.setFormatter(c_format)
logger.addHandler(c_handler)


def get_secret_from_aws_ssm(name: str) -> str:
    """
    Fetch Secret from System Manager Parametrs Store
    """
    client = boto3.client("ssm", region_name="eu-west-1")
    response = client.get_parameter(Name=name, WithDecryption=True)
    try:
        secret = response.get("Parameter").pop("Value")
        logger.debug(f"SSM secret payload {response}")
    except (AttributeError, KeyError):
        logger.exception("Exception occurred")
    return secret


def basic_auth(login: str, password: str) -> str:
    """generate basic auth header from given lg & pw"""
    auth_user_pw: bytes = f"{login}:{password}".encode("ascii")
    auth = f"Basic {base64.b64encode(auth_user_pw).decode()}"
    return auth


def lambda_handler(event, context) -> dict:
    """Check if the given event paylod has desired basic auth header"""
    logger.debug(f"<event={event}, type={type(event)}")
    logger.debug(f"<context={context}, type={type(context)}")
    password = get_secret_from_aws_ssm(PASSWORD_SECRET_NAME)
    desired_auth = basic_auth(USERNAME, password)
    try:
        request = event["Records"][0]["cf"]["request"]
        headers = request["headers"]
        auth = headers["authorization"][0]["value"]
        assert auth == desired_auth, "Basic auth should match"
    # TODO add some http answer?
    except AssertionError:
        logger.exception("Exception occurred")
        return {"exception": HTTPStatus.UNAUTHORIZED.description}
    except (KeyError, IndexError):
        logger.exception("Exception occurred")
        return {"exception": HTTPStatus.INTERNAL_SERVER_ERROR.description}
    else:
        return request
