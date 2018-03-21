#!/bin/bash

set -e 

function init_settings(){
    books_path=$(python3 manage.py sopds_util getconf SOPDS_ROOT_LIB)
    echo "books path ${books_path}"
    #if [[ "${books_path}" == "/books" ]]; then
    #    echo "database exist, exit"
    #    return 1
    #fi
    python3 manage.py migrate
    python3 manage.py sopds_util clear
    #python3 manage.py sopds_util load_mygenres
    #python3 manage.py sopds_util pg_optimize
    #python3 manage.py loaddata genre.json --app opds_catalog
    #python3 manage.py createsuperuser
    python3 -c "
import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'sopds.settings'
import django
django.setup()
from django.contrib.auth.management.commands.createsuperuser import get_user_model
if get_user_model().objects.filter(username='${SOPDS_USER}'): 
    print('Super user already exists. SKIPPING...')
else:
    print('Creating super user...')
    get_user_model()._default_manager.db_manager('default').create_superuser(username='${SOPDS_USER}', email='${SOPDS_EMAIL}', password='${SOPDS_PASSWORD}')
    print('Super user created...')"
    python3 manage.py sopds_util setconf SOPDS_ROOT_LIB '/books'
    python3 manage.py sopds_util setconf SOPDS_LANGUAGE ${SOPDS_LANG}
    #python3 manage.py sopds_util setconf SOPDS_SCAN_START_DIRECTLY False
    touch ${SOPDS_DATA}/inited.flag
    return 0
}

case "$1" in
server)
    if [ ! -f ${SOPDS_DATA}/inited.flag ]; then
        echo 'wait mysql init'
        #wait database
        sleep 10
        echo 'first init ...'
        init_settings
    fi
    python3 manage.py sopds_server start
    ;;
scanner)
    # wait migrate
    sleep 20
    echo "start scanner"
    python3 manage.py sopds_scanner start --verbose
    ;;
log)
    tail -f \
        $(python3 manage.py sopds_util getconf SOPDS_SERVER_LOG) \
        $(python3 manage.py sopds_util getconf SOPDS_SCANNER_LOG)
    ;;
*)
    "$@"
    ;;
esac