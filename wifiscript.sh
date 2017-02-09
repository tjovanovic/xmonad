#!/bin/bash

nmcli device wifi list | tail -n +2 | grep ^\* | awk -F" " '{ print "<fc=#CCC>" $2 "</fc> <fc=#8cc4ff>" $7"</fc>" }'
