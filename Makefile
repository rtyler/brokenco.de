
all:
	LANG="en_US.UTF-8" jekyll build

publish:
	find files -iname "*.png" -type f -exec pngcrush -ow -noforce -reduce {} \;
	jekyll build
	rsync -acvz --delete _site/ clam:www.unethicalblogger.com/htdocs/


