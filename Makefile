# usage: make new content name=post-name
new-post:
	hugo new content posts/$(name).md

build:
	hugo build

server:
	hugo server