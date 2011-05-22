all:
	jekyll && notify-send "Site rebuilt!"

publish:
	jekyll --lsi && notify-send "Site rebuilt and reindexed!"
	rsync -acvz --delete _site/ clam:www.unethicalblogger.com/htdocs/
	notify-send "Site deployed!"


