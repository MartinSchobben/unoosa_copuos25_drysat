.ONESHELL:
SHELL = /bin/bash

BASENAME = un_spider_20250212

all: revealjs

venv/bin/activate:
	python3 -m venv venv
	source venv/bin/activate && \
	pip install --upgrade pip setuptools && \
	pip install -r requirements.txt && \
	python -m ipykernel install --user --name $(BASENAME) --display-name $(BASENAME)

revealjs: venv/bin/activate
	quarto render $(BASENAME).qmd

help:
	@echo "make revealjs"
	@echo " Render revealjs presentation"
	@echo "make environment"
	@echo " create the base environment for the project"

clean: 
	find . -name '*.pyc' -exec rm --force {} +
	find . -name '*.pyo' -exec rm --force {} +
	find . -name '*~' -exec rm --force {} +
	rm --force .coverage
	rm --force --recursive .pytest_cache
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info
	rm --force .install.done
	rm --force .install.test.done

.PHONY: help clean environment 