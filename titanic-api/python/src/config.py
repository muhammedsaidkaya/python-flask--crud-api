"""
Module containing environment configurations
"""
import os


class Development:
    """
    Development environment configuration
    """
    DEBUG = True
    TESTING = False
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
    DB_NAME = os.getenv('POSTGRES_DB')
    DB_USER = os.getenv('POSTGRES_USER')
    DB_PASSWORD = os.getenv('POSTGRES_PASSWORD')
    DB_HOST = os.getenv('POSTGRES_HOST')
    DB_URL = "postgresql+psycopg2://{}:{}@{}:5432/{}".format(DB_USER, DB_PASSWORD, DB_HOST, DB_NAME)
    SQLALCHEMY_DATABASE_URI = DB_URL


class Production:
    """
    Production environment configuration
    """
    DEBUG = False
    TESTING = False
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
    DB_NAME = os.getenv('POSTGRES_DB')
    DB_USER = os.getenv('POSTGRES_USER')
    DB_PASSWORD = os.getenv('POSTGRES_PASSWORD')
    DB_HOST = os.getenv('POSTGRES_HOST')
    DB_URL = "postgresql+psycopg2://{}:{}@{}:5432/{}".format(DB_USER, DB_PASSWORD, DB_HOST, DB_NAME)
    SQLALCHEMY_DATABASE_URI = DB_URL


app_config = {
    'development': Development,
    'production': Production,
}
