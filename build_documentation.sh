#!/bin/bash

npm ci
npx copy-wave-assets ./docs
python -m mkdocs build
