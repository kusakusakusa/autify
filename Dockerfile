# bash autify.sh https://autify.com/pricing https://www.google.com
# rm *.html

# docker build -t autify .
# docker run -it autify
# ./autify.rb https://autify.com/pricing https://www.google.com
# autify https://autify.com/pricing https://www.google.com

FROM ruby:3.2
RUN mkdir /workspace
WORKDIR /workspace/
COPY ./autify* .
RUN chmod a+x /workspace/autify* && \
    mv /workspace/autify* /usr/local/bin
CMD ["/bin/bash"]
