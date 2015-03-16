#!/usr/bin/python3

import sys
import logging
import logging.handlers
import time
from multiprocessing import Process
import configparser

logging.basicConfig(level=logging.DEBUG, format="%(message)s")

syslog_handler=logging.handlers.SysLogHandler(address='/dev/log', facility='daemon')
syslog_handler.setLevel(logging.DEBUG)

def run_logger(logger_class):
    logger_class.run()


class LoggerProcess:
    level_dict={
        'debug': logging.DEBUG,
        'info': logging.INFO,
        'warn': logging.WARNING,
        'error': logging.ERROR,
        'critical': logging.CRITICAL,
    }
    def __init__(self, name, level, program, rate):
        self.name=name
        self.program=program
        if level.lower() not in self.level_dict:
            print("Unknown level: '%s'" % level)
            sys.exit(1)
        self.level=self.level_dict[level.lower()]
        self.level_name=level.upper()
        self.rate=rate

    def run(self):
        logger = logging.getLogger()
        logger.addHandler(syslog_handler)
        print("Running logging thread '%s'" % self.name)
        sleep_time=60.0/int(self.rate)
        counter=0
        while True:
            counter+=1
            logger.log(self.level, "%s: level is: %s Testmessage %s" % (self.program, self.level_name, counter))
            time.sleep(sleep_time)
        print("Ending logging thread '%s'" % self.name)



if __name__ == "__main__":
    config = configparser.ConfigParser()
    config.read('/etc/loggen.conf')
    started_processes=[]
    # for each settings section start a logger
    for i in config.sections():
        log_process = LoggerProcess(
            name=i,
            level=config[i]['level'],
            program=config[i]['program'],
            rate=config[i]['rate'],
        )
        p = Process(target=run_logger, args=(log_process,))
        p.start()
        started_processes.append(p)

    for i in started_processes:
        i.join()




