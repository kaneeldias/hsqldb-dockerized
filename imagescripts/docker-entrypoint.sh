#!/bin/bash -x
set -o errexit

java_vm_parameters="-Dfile.encoding=UTF-8"

if [ -n "${JAVA_VM_PARAMETERS}" ]; then
  java_vm_parameters=${JAVA_VM_PARAMETERS}
fi

hsqldb_user="sa"

if [ -n "${HSQLDB_USER}" ]; then
  hsqldb_user=${HSQLDB_USER}
fi

hsqldb_password=""

if [ -n "${HSQLDB_PASSWORD}" ]; then
  hsqldb_password=${HSQLDB_PASSWORD}
fi

hsqldb_trace="-trace true"

if [ "${HSQLDB_TRACE}" = 'false' ]; then
  hsqldb_trace="-trace false"
fi

hsqldb_silent="-silent false"

if [ "${HSQLDB_SILENT}" = 'true' ]; then
  hsqldb_trace="-silent true"
fi

hsqldb_remote="-remote_open true"

if [ "${HSQLDB_REMOTE}" = 'false' ]; then
  hsqldb_trace="-remote_open false"
fi

hsqldb_database_name="hsqldb"

if [ -n "${HSQLDB_DATABASE_NAME}" ]; then
  hsqldb_database_name=${HSQLDB_DATABASE_NAME}
fi

hsqldb_database_alias="test"

if [ -n "${HSQLDB_DATABASE_ALIAS}" ]; then
  hsqldb_database_alias=${HSQLDB_DATABASE_ALIAS}
fi

if [ "$1" = 'hsqldb' ]; then
  java ${java_vm_parameters} -cp /opt/hsqldb/hsqldb.jar org.hsqldb.Server -database.0 "file:/opt/database/${hsqldb_database_name};user=${hsqldb_user};password=${hsqldb_password}" -dbname.0 ${hsqldb_database_alias} ${hsqldb_trace} ${hsqldb_silent} ${hsqldb_remote}
else
  exec "$@"
fi
