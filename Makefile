FILES=index.md
OUTPUT=index
TEMPLATE_DIR=pandoc-templates/templates
CSS_DIR=pandoc-templates/marked

html:
	pandoc -s $(FILES) -o $(OUTPUT).html --template $(TEMPLATE_DIR)/html.template --css $(CSS_DIR)/kultiad-serif.css --self-contained --toc --toc-depth 2

pdf:
	pandoc $(FILES) -o $(OUTPUT).pdf
