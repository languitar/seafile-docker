#!/bin/bash

# fix seahub symlinks
if [ ! -L ${SEAFILE_PATH}/seahub/media/avatars ]; then
    rm -rf ${SEAFILE_PATH}/seahub/media/avatars
    ln -s /seafile/seahub-data/avatars ${SEAFILE_PATH}/seahub/media/avatars
fi

if [ ! -L ${SEAFILE_PATH}/seahub/media/custom ]; then
    rm -rf ${SEAFILE_PATH}/seahub/media/custom
    ln -s /seafile/seahub-data/custom ${SEAFILE_PATH}/seahub/media/custom
fi

if [ ! -L ${SEAFILE_PATH}/seahub/media/CACHE ]; then
    rm -rf ${SEAFILE_PATH}/seahub/media/CACHE
    ln -s /seafile/seahub-data/CACHE ${SEAFILE_PATH}/seahub/media/CACHE
fi

# fix seafile install path symlinks
for folder in ccnet conf logs seafile-data seahub-data; do
   [ -L /opt/seafile/${folder} ] || ln -s /seafile/${folder} /opt/seafile/${folder}
done
