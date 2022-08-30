#!/bin/bash

set -e


docker-compose -f docker-compose.yaml kill && docker-compose -f docker-compose.yaml down --volumes --remove-orphans



