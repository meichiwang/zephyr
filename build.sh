#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
ROOT=$(cd -- "${SCRIPT_DIR}/.." && pwd)
echo "ROOT: ${ROOT}"
IMAGE_PATH=${ROOT}/image
BUILD_DATE=$(TZ="Asia/Taipei" date +"%y%m%d%H")
export BUILD_DATE

OP_CMD=$1
cd ${ROOT}
mkdir -p image

function showUsage()
{
	printf "build.sh [CMD] \n"
	printf "CMD: \n"
	printf "\tinit\tInitialize zephyr-os\n"
	printf "\tboot\t\tbuild profile\n"
	return 0
}

if [ "${OP_CMD}" = "init" ]; then
    west init -l zephyr
    echo "update zephyr needed modules"
    west update
elif [ "${OP_CMD}" = "boot" ]; then
    west build -p always -b rpi_pico my_app -- -DDTC_OVERLAY_FILE=boards/rpi_pico.overlay
    cp ${ROOT}/build/zephyr/zephyr.bin ${IMAGE_PATH}/zephyr_${BUILD_DATE}.bin
    cp ${ROOT}/build/zephyr/zephyr.uf2 ${IMAGE_PATH}/zephyr_${BUILD_DATE}.uf2

else
    showUsage;
fi