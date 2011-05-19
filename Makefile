
all:
	echo ">> Building the site"
	jekyll && notify-send "Site rebuilt!"

publish: all
	rsync -acvz --delete _site/ clam:www.unethicalblogger.com/htdocs/
	notify-send "Site deployed!"


