FILES=index.md
OUTPUT=index

html:
	pandoc -s $(FILES) -o $(OUTPUT).html --template template/template.html --css template/template.css --self-contained --toc --toc-depth 2

pdf:
	pandoc $(FILES) -o $(OUTPUT).pdf
