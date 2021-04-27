
JEKYLL=bundle exec jekyll


all:
	LANG="en_US.UTF-8" $(JEKYLL) build

drafts: tags
	LANG="en_US.UTF-8" $(JEKYLL) serve --drafts --incremental

run: tags
	rm -rf _site && $(JEKYLL) serve --drafts --future --watch --incremental --limit-posts 40

tags:
	./generate-tags

publish: tags
	find files -iname "*.png" -type f -exec pngcrush -ow -noforce -reduce {} \;
	$(JEKYLL) build

.PHONY: all drafts tags publish microblog

microblog:
	_scripts/new-microblog && \
		git add _microblog tweets && git commit --no-gpg-sign -m "tweet"
