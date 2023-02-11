FROM ruby:3
RUN mkdir /workspace
WORKDIR /workspace/
RUN apt-get install libxslt-dev liblzma-dev patch && \
    gem install bundler && \
    gem install nokogiri --platform=ruby

COPY ./autify* .
RUN chmod a+x /workspace/autify* && \
    mv /workspace/autify* /usr/local/bin

CMD ["/bin/bash"]
