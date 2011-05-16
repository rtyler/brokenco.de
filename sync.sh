#!/bin/sh

rsync -acvz --delete _site/ clam:www.unethicalblogger.com/htdocs/

