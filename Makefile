FILES=index.md
OUTPUT=index
TEMPLATE_DIR=theme
CSS_DIR=theme/css

html:
	pandoc -s $(FILES) -o $(OUTPUT).html --template $(TEMPLATE_DIR)/html.template --css $(CSS_DIR)/kultiad.css --self-contained --toc --toc-depth 2

pdf:
	pandoc $(FILES) -o $(OUTPUT).pdf
