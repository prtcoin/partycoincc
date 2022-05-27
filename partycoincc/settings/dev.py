from .base import *  # noqa

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'o760y3hm3!v#s$f&h&g0_rbd0=hq65^wvt(1_32lt3v@@s*ln7'

ALLOWED_HOSTS = ['*']

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

WAGTAIL_CACHE = False

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
        'LOCATION': 'cache_table',  # noqa
        'KEY_PREFIX': 'coderedcms',
        'TIMEOUT': 14400,  # in seconds
    }
}

try:
    from .local_settings import *  # noqa
except ImportError:
    pass
