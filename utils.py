import logging

def setup_logging(logger_name: str = "gpu-code-gen") -> logging.Logger:
    """
    Set up logging for the project."""
    # Configure basic logging settings
    logging.basicConfig(level=logging.INFO)

    # Create a custom formatter
    formatter = logging.Formatter(
        "%(asctime)s - %(levelname)s - Running function: %(module)s.%(funcName)s"
    )

    # Create handlers and set the formatter
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)

    file_handler = logging.FileHandler("cldrive_runner.log")
    file_handler.setFormatter(formatter)

    # Create the logger and add handlers
    logger = logging.getLogger(logger_name)
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)

    return logger
