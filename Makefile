html:
	udoc build
	cp out/index.html ./

pdf:
	udoc build -p
	cp out/index.pdf ./

gh-pages:
	git pull origin master
	make html
	git commit -am "build html"
	make pdf
	git commit -am "build pdf"
	git push origin master
	git checkout gh-pages
	git pull origin gh-pages
	git pull origin master
	git push origin gh-pages
	git checkout master
