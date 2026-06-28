import logging
import os
import platform
import sys
from os.path import abspath

import app_manager
import process
import util.log_setup
import version

if __name__ == "__main__":
    print("Application started")
    manager = app_manager.AppManager()
    util.log_setup.setup_logging(manager)
    sys.excepthook = manager.handle_exception

    logger = logging.getLogger("fm_rpc").getChild(__name__)
    logger.info(
        f' -------- fm.rpc version {version.get_version()} {"(debug mode)" if manager.get_debug() else ""} -------- '
    )

    logger.info(f'Current working path: "{abspath(os.curdir)}"')

    if platform.system() == "Darwin" and process.check_process_running(
        "fm_rpc", "fm.rpc"
    ):
        logger.info("fm.rpc is already running, opening settings...")
        manager.open_settings()
        sys.exit(2)

    try:
        manager.start()
    except KeyboardInterrupt:
        manager.close()
        sys.exit()
