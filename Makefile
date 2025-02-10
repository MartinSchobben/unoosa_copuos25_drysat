.ONESHELL:
SHELL = /bin/bash

BASENAME = un_spider_20250212
CONDA_ENV_DIR = $(shell conda info --base)/envs/un_spider_20250212
CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate
KERNEL_DIR != jupyter --data-dir
KERNEL_DIR := $(KERNEL_DIR)/kernels/un_spider_20250212

all: beamer pptx revealjs

revealjs: $(BASENAME).qmd environment
	$(CONDA_ACTIVATE) un_spider_20250212
	quarto render $^ --output-dir public

beamer: $(BASENAME).qmd environment
	$(CONDA_ACTIVATE) un_spider_20250212
	quarto add --no-prompt kapsner/authors-block
	quarto render $^ --metadata-file _authors.yml --to beamer

pptx: $(BASENAME).qmd environment
	$(CONDA_ACTIVATE) un_spider_20250212
	quarto add --no-prompt kapsner/authors-block
	quarto render $^ --metadata-file _authors.yml --to pptx

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

$(CONDA_ENV_DIR):
	@echo "creating new base un_spider_20250212 conda environment..."
	conda create -y -c conda-forge -n un_spider_20250212 python=3.9 pip mamba jupyter
	$(CONDA_ACTIVATE) un_spider_20250212
	mamba install -y -c conda-forge matplotlib numpy xarray pandas dask
	@echo "... finished."

environment: $(CONDA_ENV_DIR)
	@echo -e "conda environment is ready. To activate use:\n\tconda activate un_spider_20250212"

$(KERNEL_DIR):
	$(CONDA_ACTIVATE) un_spider_20250212
	python -m ipykernel install --user --name un_spider_20250212 --display-name un_spider_20250212 
	conda deactivate

kernel: $(CONDA_ENV_DIR) $(KERNEL_DIR)
	@echo -e "jupyter kernels are ready."

.PHONY: help clean environment 