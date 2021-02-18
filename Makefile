
all:
	LANG="en_US.UTF-8" jekyll build

drafts: tags
	LANG="en_US.UTF-8" jekyll serve --drafts --incremental

run: tags
	rm -rf _site && jekyll serve --drafts --future --watch --incremental --limit-posts 20

tags:
	./generate-tags

publish: tags
	find files -iname "*.png" -type f -exec pngcrush -ow -noforce -reduce {} \;
	jekyll build

.PHONY: all drafts tags publish microblog

microblog:
	_scripts/new-microblog && git add _microblog tweets && git commit --no-gpg-sign
