#AUTHOR Lukas Becker
# miniconda - NCBI BLAST+ 2.11.0+ - edirect - Dockerfile
#

#base image; maybe choose another image
FROM ubuntu:focal

# Download and install required software
RUN apt-get update -y && apt-get upgrade -y && apt-get install curl -y && apt-get install wget bzip2 -y && apt-get install libgl1-mesa-glx -y && apt-get install libglib2.0-0 -y
# Software and packages for the E-Direct Tool
RUN apt-get -y -m update && DEBIAN_FRONTEND="noninteractive" apt-get install -y cpanminus libxml-simple-perl libwww-perl libnet-perl build-essential
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# set working directory
WORKDIR /blast

# Download and install anaconda; version: 4.9.2
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh
#-b Batch mode with no PATH modifications to ~/.bashrc
RUN bash Miniconda3-py38_4.9.2-Linux-x86_64.sh -b -p /blast/miniconda3
RUN rm Miniconda3-py38_4.9.2-Linux-x86_64.sh

# Download & install BLAST
RUN curl ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.11.0/ncbi-blast-2.11.0+-x64-linux.tar.gz | tar -zxvpf-

# Download & install NCBI EDIRECT
RUN sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
RUN mv $HOME/edirect .

# Update path environment variable
ENV PATH="/blast/edirect:$PATH"

# Update path environment variable
ENV PATH /blast/ncbi-blast-2.11.0+/bin:$PATH

# Update path environment variable
ENV PATH /blast/miniconda3/bin:$PATH

# Update miniconda
RUN conda update conda
RUN conda update --all

# Add bioconda as channel
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda install -c conda-forge notebook
# Download wget and pandas
COPY requirements.txt /blast/
RUN pip install -r requirements.txt

RUN mkdir /blast/applications
COPY . /blast/applications


#set appropriate working directory in order to allow development with docker
WORKDIR /blast/applications

# Delete not required packages etc..
RUN apt-get autoremove --purge --yes && apt-get clean && rm -rf /var/lib/apt/lists/*
# Optional commands e.g. initiating scripts

#open port for jupyter notebook
EXPOSE 8888

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
