"""
How to control logger level via CLI flags
"""
import sys
from loguru import logger
from typing import Union, NoReturn
from argparse import ArgumentParser, RawTextHelpFormatter

# Clear current logger
logger.remove(0)


class LoggerExample:
    def some_method(self):
        logger.trace('Value trace=5 Message !')
        logger.debug('Value debug=10 Message!')
        logger.info('Value info=20 Message!')
        logger.success('Value success=25 Message!')
        logger.warning('Value warning=30 Message!')
        logger.error('Value error=40 Message!')
        logger.critical('Value critical=50 Message!')

    def low_log_level_method(self):
        logger.trace('Trace in obj {}, method {}', self.__class__, self.low_log_level_method.__name__)

    def high_log_level_method(self):
        logger.critical('Critical in obj {}, method {}', self.__class__, self.low_log_level_method.__name__)

    def __call__(self, *args, **kwargs):
        self.some_method()
        self.low_log_level_method()
        self.high_log_level_method()


logger.critical('outside')


def main():
    parser = ArgumentParser(description="A CLI for logging test",
                            formatter_class=RawTextHelpFormatter)
    parser.add_argument('-l', '--level', help='Logging level to show', choices=['trace', 'debug', 'info', 'success',
                                                                                'warning', 'error', 'critical'],
                        default=False)
    parser.add_argument('-v', '--verbose_warn', help='activate warning level', action='store_true')
    parser.add_argument('-vv', '--verbose_info', help='activate info level', action='store_true')
    parser.add_argument('-vvv', '--verbose_trace', help='activate trace level', action='store_true')

    args = parser.parse_args()
    logger.debug("argparse namespace: {}", args)  # no logger for cur module global namespace, this line will be ignored

    verbose_level = {'verbose_warn': 'warning',
                     'verbose_info': 'info',
                     'verbose_trace': 'trace'}

    if args.level:
        logger.add(sys.stderr, level=args.level.upper())
        ll = LoggerExample()
        ll()
    else:
        kv = args.__dict__
        command = list(filter(lambda x: True if kv[x] == True and x != 'level' else False, kv))[0]
        logger.add(sys.stderr, level=verbose_level[command].upper())

        ll = LoggerExample()
        ll()

    logger.info('Logger inside the function {} has been restored', main.__name__)
    logger.debug("argparse namespace: {}", args)


if __name__ == '__main__':
    main()
    logger.critical('outside')
