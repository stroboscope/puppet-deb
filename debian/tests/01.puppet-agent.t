#!/bin/sh

test_description="puppet agent"

. ./sharness.sh

lockfile=/var/lib/puppet/state/agent_disabled.lock

test_expect_success "lock file present" "
  test -e ${lockfile}
"
test_expect_success "enable puppet agent" "
  puppet agent --enable
"
test_expect_success "lock file removed" "
  test_must_fail test -e ${lockfile}
"

test_done
