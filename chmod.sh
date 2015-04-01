#!/usr/bin/env bash

for t in $@
do
	find $t -type d -print0 | xargs -0 chmod 755
	find $t -type f -print0 | xargs -0 chmod 644
done

echo 'Done'
