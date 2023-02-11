# Development on local

To use as `autify` command

```bash
autify https://autify.com/pricing https://www.google.com https://stackoverflow.com http://10.255.255.1 https://github.com https://wkerbgwebrgtkuwerbytewrt.com
```

To run as ruby script

```bash
ruby autify.rb https://autify.com/pricing https://www.google.com https://stackoverflow.com http://10.255.255.1 https://github.com https://wkerbgwebrgtkuwerbytewrt.com
```

You might find `rm *.html && rm -rf *.com` very helpful in getting rid of all generated folders & files

# Development on Docker

```bash
docker build -t autify .

docker run -it autify
```

# BONUS tech plan:
- [ ] store assets in "domain" namespaced folder (already created where the last_crawled.txt is located, subfolders named css/images etc
- [ ] Before saving page as HTML
  - [ ] replace the domain portion of the asset links to relative paths to these subfolders
  - [ ] prepend subfolder paths to the asset links if they are already using relative path
- [ ] use docker volumes if need persist assets

# TODO:
- [ ] Handle various argument edge cases (no argument, --unknown-option etc)
- [ ] Command help function
- [ ] improve validation of url, maybe https://github.com/amogil/url_regex
- [ ] use docker volumes if need persist last_crawled date
- [ ] Handle assets loaded via infinite scrolling pages, use selenium
