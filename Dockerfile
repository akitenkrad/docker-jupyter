FROM python:3.9
SHELL ["/bin/bash", "-c"]
WORKDIR /usr/src/app
RUN apt update -y && \
    apt install -y sudo xvfb git cmake mecab libmecab-dev mecab-ipadic-utf8 wget less vim p7zip unzip

WORKDIR /usr/src/app
RUN pip install --upgrade pip
RUN pip install -U numpy scipy matplotlib ipython scikit-learn pandas pillow attrdict \
                   tqdm beautifulsoup4 janome \
                   mecab-python3 gensim nltk seaborn opencv-python plotly \
                   torch torchvision torchtext \
                   motmetrics pyyaml \
                   jupyterlab_widgets ipywidgets scapy networkx

# install latest npm
RUN apt install -y nodejs npm && \
    npm config set unsafe-perm true && \
    npm install -g n && \
    n stable && \
    apt purge -y nodejs npm && \
    exec bash -l

# install mecab
WORKDIR /usr/src/app
RUN git clone https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd /usr/src/app/mecab-ipadic-neologd && \
    sed -E -i -e 's/^\s*wanna_install\s*//g' bin/install-mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd

# install Utatane
WORKDIR ~/
RUN wget https://github.com/nv-h/Utatane/releases/download/Utatane_v1.0.8/Utatane_v1.0.8.7z && \
    7zr x Utatane_v1.0.8.7z && \
    cp Utatane_v1.0.8/*ttf Utatane_v1.0.8/YasashisaGothicBold-V2/*.ttf /usr/local/share/fonts/

# install jupyterlab
RUN pip install 'jupyterlab>=3.0.0,<4.0.0a0' && \
    jupyter serverextension enable --py jupyterlab && \
    pip install jupyterlab_vim jupyterlab-lsp python-language-server[all] && \
    mkdir -p /usr/local/share/jupyter/lab/settings/
COPY overrides.json /usr/local/share/jupyter/lab/settings/
