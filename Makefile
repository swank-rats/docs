FILES=index.md intro/01_idea.md intro/02_architecture.md intro/03_communication.md
OUTPUT=index
TEMPLATE_DIR=theme
CSS_DIR=theme/css

html:
	pandoc -s $(FILES) -o $(OUTPUT).html --template $(TEMPLATE_DIR)/html.template --css $(CSS_DIR)/kultiad.css --self-contained --toc --toc-depth 2

pdf:
	pandoc $(FILES) -o $(OUTPUT).pdf

gh-pages:
	make html
	git commit -am "build html"
	git push origin master
	git checkout gh-pages
	git pull origin master
	git push origin gh-pages
	git checkout master
