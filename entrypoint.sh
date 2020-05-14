#!/bin/sh
set -e

haml_lint_flags() {
  if [ -n "$1" ]; then
    echo "$1"
  fi
}

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# shellcheck disable=SC2046
# shellcheck disable=SC2086
haml-lint $(haml_lint_flags "$INPUT_HAML_LINT_FLAGS") . | reviewdog -efm="%f:%l [%t] %m" \
      -name="haml-lint" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
