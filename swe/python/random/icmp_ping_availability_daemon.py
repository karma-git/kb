"""
This daemon will ping a node and raise exception if received status code not 0 5 times
"""
import subprocess
import sys
from loguru import logger


# Comment lines 5,6 if you won't receive debug info
logger.remove(0)
logger.add(sys.stderr, level="TRACE")


class NodeInvalid(Exception):
    """exception"""


def file_log(log_file_name: str):
    """creates file"""
    with open(log_file_name, "w"):
        # Need to do something inside context processor
        print("File has been created!")


def main(target_ip: str, log_file_name: str):
    """main payload"""
    failure_counter = []
    while True:
        icmp_ping_return_code = subprocess.run(
            ["ping", "-c", "1", target_ip], stdout=subprocess.DEVNULL
        ).returncode
        logger.debug("ICMP code -> {}", icmp_ping_return_code)
        # code 0 means what ping command has succeed
        if icmp_ping_return_code == 0:
            with open(log_file_name, "r+") as log_file:
                log_file.truncate(0)
            failure_counter.clear()
            logger.trace(
                "Received icmp return code {}, counter and log file has been cleared!",
                icmp_ping_return_code,
            )
        else:
            logger.warning(
                "Received icmp return code {}, processing...", icmp_ping_return_code
            )
            failure_counter.append(icmp_ping_return_code)
            logger.debug("counter content {}", failure_counter)
        if len(failure_counter) >= 5:
            logger.critical(
                "Received 5 failed return codes, daemon will raise exception"
            )
            with open(log_file_name, "a") as log_file:
                log_file.write(f"Node<{target_ip}> is unavailable!")
            raise NodeInvalid


if __name__ == "__main__":
    LOG_FILE = "log_for_agent.txt"
    file_log(LOG_FILE)
    main("33.33.33.33", LOG_FILE)
