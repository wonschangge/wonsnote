all: $(docs/source/*)
	rm -rf docs/source/html
	cd docs/source/ && python -m sphinx -T -b html -d _build/doctrees -D language=zh_CN . html