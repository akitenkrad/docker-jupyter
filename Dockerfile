FROM python:3.8
SHELL ["/bin/bash", "-c"]
WORKDIR /usr/src/app
RUN apt update -y && apt install -y sudo nodejs npm xvfb python-opengl git cmake mecab libmecab-dev mecab-ipadic-utf8
RUN pip install --upgrade pip
RUN pip install -U numpy scipy matplotlib ipython scikit-learn pandas pillow attrdict
RUN pip install -U tqdm beautifulsoup4 janome
RUN pip install -U mecab-python3 gensim nltk seaborn opencv-python plotly
RUN pip install -U torch torchvision torchtext
RUN pip install -U motmetrics pyyaml
RUN pip install -U jupyterlab_widgets ipywidgets

# install latest npm
RUN npm config set unsafe-perm true
RUN apt install -y nodejs npm
RUN npm install -g n
RUN n stable
RUN apt purge -y nodejs npm
RUN exec bash -l

# install mecab
WORKDIR /usr/src/app
RUN git clone https://github.com/neologd/mecab-ipadic-neologd.git
WORKDIR /usr/src/app/mecab-ipadic-neologd
RUN sed -E -i -e 's/^\s*wanna_install\s*//g' bin/install-mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd

RUN pip install 'jupyterlab>=3.0.0,<4.0.0a0'

RUN jupyter serverextension enable --py jupyterlab
RUN pip install jupyterlab_vim
RUN pip install jupyterlab-lsp
RUN pip install python-language-server[all]

