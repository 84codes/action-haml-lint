#!/bin/sh
set -e

config() {
  if [ -n "$1" ]; then
    echo "-c $1"
  fi
}

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

haml-lint "$(config $INPUT_HAML_LINT_CONFIG)" . \
  | reviewdog -efm="%f:%l [%t] %m" \
      -name="haml-lint" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
