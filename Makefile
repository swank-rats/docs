FILES=index.md intro/01_idea.md intro/02_architecture.md intro/03_communication.md image-processing/01_components.md image-processing/02_requirements.md image-processing/03_architecture.md game/01_requirements_technologies.md
OUTPUT=index
TEMPLATE_DIR=theme
CSS_DIR=theme/css

html:
	pandoc -s $(FILES) -o $(OUTPUT).html --template $(TEMPLATE_DIR)/html.template --css $(CSS_DIR)/kultiad.css --self-contained --toc --toc-depth 2

pdf:
	pandoc $(FILES) -o $(OUTPUT).pdf --template $(TEMPLATE_DIR)/latex.template --chapters --toc --toc-depth 2

gh-pages:
	make html
	make pdf
	git commit -am "build html"
	git push origin master
	git checkout gh-pages
	git pull origin gh-pages
	git pull origin master
	git push origin gh-pages
	git checkout master
