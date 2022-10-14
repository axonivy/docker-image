#!/bin/bash
set -e

# check if licence file is available
amountOfLicenceFiles=$(ls -1 /etc/axonivy-engine/*.lic 2>/dev/null | wc -l)
if [ $amountOfLicenceFiles -gt 0 ]; then
   bin/EngineConfigCli wait-for-db-server
   bin/EngineConfigCli create-db
fi

exec bin/AxonIvyEngine
