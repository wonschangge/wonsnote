all: $(docs/source/*)
# if [ ! -d "./.venv" ]; then
# 	python -m venv .venv
# fi
	rm -rf docs/source/html
	cd docs/ && pip install -r requirements.txt
	cd docs/source/ && python -m sphinx -T -b html -d _build/doctrees -D language=zh_CN . html