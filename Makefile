
all:
	LANG="en_US.UTF-8" jekyll build

publish:
	jekyll build
	rsync -acvz --delete _site/ clam:www.unethicalblogger.com/htdocs/


